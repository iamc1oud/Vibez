import 'package:flutter/cupertino.dart';

class AppSize {
  final BuildContext context;

  AppSize(this.context);

  double get height => MediaQuery.of(context).size.height;
  double get width => MediaQuery.of(context).size.width;
}
