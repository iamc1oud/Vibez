import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

class ReelsHiveNotifier with ChangeNotifier {
  Box? _box;

  Box get box => _box!;

  /// Constructor
  ReelsHiveNotifier() {
    initializeHive();
  }

  /// Initialize hive
  initializeHive() async {
    Hive.init((await getExternalStorageDirectory())!.path);
  }

  /// Boxes
  void openBox(String name) async {
    _box = await Hive.openBox(name);
  }
}
