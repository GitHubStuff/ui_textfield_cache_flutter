import 'package:flutter_bloc/flutter_bloc.dart';

import 'bhive_cache_store.dart';

class UITextFieldCubit extends Cubit<List<String>> {
  final BHiveCacheStore store;

  UITextFieldCubit({required this.store}) : super(store.loadStrings());

  @override
  Future<void> close() async {
    await store.saveStrings(state);
    await store.close();
    return super.close();
  }

  void updateList(List<String> newList) => emit(newList);

  Future<void> addItem(String item) async {
    final List<String> updatedList = List.from(state);
    if (!updatedList.contains(item)) {
      updatedList.insert(0, item);
    }
    await store.saveStrings(updatedList);
    emit(updatedList);
  }

  void newSort(String search) {
    final List<String> updatedList = List.from(state);
    final String searchLower = search.toLowerCase();

    updatedList.sort(
      (a, b) {
        // Convert strings to lower case for case-insensitive comparison
        String lowerA = a.toLowerCase();
        String lowerB = b.toLowerCase();

        // Update conditions to use lower case strings
        bool startsWithSearchA = lowerA.startsWith(searchLower);
        bool startsWithSearchB = lowerB.startsWith(searchLower);
        bool endsWithSearchA = lowerA.endsWith(searchLower);
        bool endsWithSearchB = lowerB.endsWith(searchLower);
        bool containsSearchA = lowerA.contains(searchLower);
        bool containsSearchB = lowerB.contains(searchLower);

        if (startsWithSearchA && !startsWithSearchB) return -1;
        if (!startsWithSearchA && startsWithSearchB) return 1;

        if (endsWithSearchA && !endsWithSearchB) return -1;
        if (!endsWithSearchA && endsWithSearchB) return 1;

        if (containsSearchA && !containsSearchB) return -1;
        if (!containsSearchA && containsSearchB) return 1;

        return lowerA.compareTo(lowerB);
      },
    );
    emit(updatedList);
  }
}
