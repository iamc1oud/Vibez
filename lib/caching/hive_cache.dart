import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:vibez/_utils/safe_print.dart';

class ReelsHiveNotifier with ChangeNotifier {
  Box<dynamic>? _box;
  Box<dynamic>? get box => _box;

  int? _length;
  int? get length => _length;

  /// Method to open box of give [name]
  void openBox(String name) async {
    _box = await Hive.openBox(
      name,
      keyComparator: _reverseOrder,
    );
    notifyListeners();
  }

  void getSizeOfData() {
    _length = box?.toMap().keys.length;
    notifyListeners();
  }

  int _reverseOrder(k1, k2) {
    if (k1 is int) {
      if (k2 is int) {
        if (k1 > k2) {
          return 1;
        } else if (k1 < k2) {
          return -1;
        } else {
          return 0;
        }
      } else {
        return 1;
      }
    }
    return 0;
  }

  void reset() {}
}
