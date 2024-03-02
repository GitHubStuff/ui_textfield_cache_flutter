import 'package:flutter_bloc/flutter_bloc.dart';
import 'bhive_cache_store.dart';

/// A Cubit class that manages the state of a list of strings.
///
/// This class extends `Cubit<List<String>>` to manage a list of strings, providing
/// methods to update the list, add new items, and sort the list based on search criteria.
/// It leverages a `BHiveCacheStore` instance to persist changes to the local storage.
class UITextFieldCubit extends Cubit<List<String>> {
  /// The Hive-based storage used to persist the list of strings.
  final BHiveCacheStore store;

  /// Constructs a `UITextFieldCubit` with a given store.
  ///
  /// Initializes the cubit with a preloaded list of strings from the given `BHiveCacheStore`.
  /// The initial state is set with the strings loaded from the store.
  UITextFieldCubit({required this.store}) : super(store.loadStrings());

  @override
  Future<void> close() async {
    // Persists the current state to the Hive store before closing.
    await store.saveStrings(state);
    // Closes the Hive store to release resources.
    await store.close();
    // Ensures the cubit is properly closed.
    return super.close();
  }

  /// Updates the state with a new list of strings.
  ///
  /// This method directly emits the provided new list as the current state.
  void updateList(List<String> newList) => emit(newList);

  /// Adds a new item to the state if it does not already exist.
  ///
  /// If the item is not already in the list, it is inserted at the beginning.
  /// The updated list is then persisted to the store before updating the state.
  Future<void> addItem(String item) async {
    final bool notEmpty = item.trim().isNotEmpty;
    final List<String> updatedList = List.from(state);
    if (notEmpty) {
      updatedList.remove(item);
      updatedList.insert(0, item);
    }
    await store.saveStrings(updatedList);
    emit(updatedList);
  }

  /// Sorts the list based on a search term, prioritizing matches.
  ///
  /// The list is sorted based on how closely items match the search term,
  /// with various scores assigned for different types of matches.
  /// Items that better match the search criteria are moved to the beginning of the list.
  void newSort(String search) {
    final List<String> updatedList = List.from(state);
    if (search.trim().isEmpty) {
      emit(updatedList); // No search term, so no sorting is needed.
      return;
    }
    final String searchLower = search.toLowerCase();
    final List<String> searchWords = searchLower.split(' ');
    final String firstSearchWord = searchWords.first;

    // Calculates a score for how closely a string matches the search criteria.
    int calculateScore(String text, String fullSearch, List<String> searchWords,
        String firstWord) {
      int score = 0;
      if (text.startsWith(fullSearch)) score += 800;
      if (text.endsWith(fullSearch)) score += 700;
      if (text.contains(fullSearch)) score += 600;
      if (text.startsWith(firstWord)) score += 500;
      if (text.contains(firstWord)) score += 400;
      if (text.endsWith(firstWord)) score += 300;
      // Adds a score for any search word match.
      for (String word in searchWords) {
        if (text.contains(word)) {
          score += 200;
          break;
        }
      }
      return score;
    }

    // Sorts the list based on the calculated scores and alphabetical order as a fallback.
    updatedList.sort((a, b) {
      String lowerA = a.toLowerCase();
      String lowerB = b.toLowerCase();

      int scoreA =
          calculateScore(lowerA, searchLower, searchWords, firstSearchWord);
      int scoreB =
          calculateScore(lowerB, searchLower, searchWords, firstSearchWord);

      if (scoreA != scoreB) {
        return scoreB - scoreA; // Higher score comes first.
      }
      return lowerA.compareTo(lowerB); // Alphabetical order for tie-breakers.
    });

    emit(updatedList); // Updates the state with the sorted list.
  }
}
