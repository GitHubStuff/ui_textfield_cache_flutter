// Imports the Hive package for Flutter, enabling local storage capabilities.
import 'package:hive_flutter/hive_flutter.dart';
// Imports a custom NoSQL database utility package for Dart.
import 'package:nosql_dart/nosql_dart.dart';

// Defines the maximum number of entries to be stored in the cache.
const int _kCacheLimit = 25;
// Specifies the directory name where Hive databases are stored.
const String _kHiveDir = 'hive';
// The name of the Hive box used for caching UI text fields.
const String _kHiveBox = 'ui_textfield_cache';

/// A cache storage class using Hive database for storing key-value pairs on device.
///
/// This class extends [OnDeviceStore] to provide an implementation for storing
/// data locally using Hive. It is specifically tailored for caching strings,
/// with utility methods for saving and retrieving them.
class BHiveCacheStore extends OnDeviceStore {
  /// Initializes the Hive database and opens a box for storage.
  ///
  /// It sets up the Hive database in a specified directory and opens a box
  /// with a given name for caching. Returns an instance of [BHiveCacheStore].
  static Future<BHiveCacheStore> onDeviceSetup({
    String hiveDir = _kHiveDir,
    String hiveBox = _kHiveBox,
  }) async {
    await Hive.initFlutter(hiveDir);
    Box<String> box = await Hive.openBox<String>(hiveBox);
    return BHiveCacheStore._internal(box, hiveDir, hiveBox);
  }

  // Private fields holding the Hive box, directory, and tag for the store.
  final Box<String> box;
  final String dir;
  @override
  final String tag;

  // Private constructor for initializing an instance with a Hive box, directory, and tag.
  BHiveCacheStore._internal(this.box, this.dir, this.tag);

  /// Closes the Hive box when the store is no longer needed.
  @override
  Future<void> close() async => await box.close();

  /// Deletes the Hive box from the disk, removing all stored data.
  @override
  Future<void> deleteFromDisk() async {
    if (box.isOpen) {
      await box.deleteFromDisk();
    }
  }

  /// Retrieves a value from the Hive box by key, with an optional default value.
  @override
  dynamic get(dynamic key, {dynamic defaultValue}) =>
      box.get(key, defaultValue: defaultValue);

  /// Inserts or updates a key-value pair in the Hive box.
  @override
  Future<void> put(dynamic key, dynamic value) async =>
      await box.put(key, value);

  /// Indicates whether the Hive box is closed and thus unavailable for operations.
  @override
  bool get isUnavailable => !box.isOpen;

  /// Retrieves all stored strings from the Hive box.
  ///
  /// If the box is empty, it initializes the box with a predefined list of strings.
  List<String> loadStrings() {
    List<String> items = box.values.toList();
    if (items.isEmpty) {
      items.add('Anniversary');
      items.add('Birthday');
      items.add('Christmas');
      items.add('Retirement');
      items.add('Vacation');
    }
    return items;
  }

  /// Saves a list of strings to the Hive box, respecting the cache limit.
  ///
  /// Clears the box before saving the new list of strings. Only saves up to the cache limit.
  Future<void> saveStrings(List<String> strings) async {
    await box.clear();
    for (int i = 0; i < strings.length && i < _kCacheLimit; i++) {
      await box.put(i.toString(), strings[i]);
    }
  }
}
