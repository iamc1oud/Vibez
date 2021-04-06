import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

void safePrint(String val) {
  if (kDebugMode) {
    print(val);
  }
}
