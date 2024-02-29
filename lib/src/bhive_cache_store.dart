import 'package:hive_flutter/hive_flutter.dart';
import 'package:nosql_dart/nosql_dart.dart';

const int _kCacheLimit = 25;
const String _kHiveDir = 'hive';
const String _kHiveBox = 'ui_textfield_cache';

class BHiveCacheStore extends OnDeviceStore {
  static Future<BHiveCacheStore> onDeviceSetup({
    String hiveDir = _kHiveDir,
    String hiveBox = _kHiveBox,
  }) async {
    await Hive.initFlutter(hiveDir);
    Box<String> box = await Hive.openBox<String>(hiveBox);
    return BHiveCacheStore._internal(box, hiveDir, hiveBox);
  }

  final Box<String> box;
  final String dir;
  @override
  final String tag;

  BHiveCacheStore._internal(this.box, this.dir, this.tag);

  @override
  Future<void> close() async => await box.close();

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

  /// Alias for `unAvailable` to match naming conventions.
  @override
  bool get isUnavailable => !box.isOpen;

  /// Get All stored strings
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

  Future<void> saveStrings(List<String> strings) async {
    await box.clear();
    for (int i = 0; i < strings.length && i < _kCacheLimit; i++) {
      await box.put(i.toString(), strings[i]);
    }
  }
}
