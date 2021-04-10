import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

/// Customised loading indicator
class StyledLoadSpinner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: SpinKitWave(
        color: Colors.pink,
        size: 18,
      ),
    );
  }
}
