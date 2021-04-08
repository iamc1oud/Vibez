import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:vibez/_utils/safe_print.dart';

class ReelsHiveNotifier with ChangeNotifier {
  Box<dynamic>? _box;
  Box<dynamic>? get box => _box;

  int? _length;
  int? get length => _length;

  /// Constructor
  ReelsHiveNotifier() {
    initializeHive();
  }

  /// Initialize hive
  initializeHive() async {
    safePrint("Hive initialized");
    Hive.init((await getExternalStorageDirectory())!.path);
  }

  /// Method to open box of give [name]
  void openBox(String name) async {
    _box = await Hive.openBox(name);
    notifyListeners();
  }

  void getSizeOfData() {
    _length = box?.toMap().keys.length;
    notifyListeners();
  }

  void reset() {}
}
