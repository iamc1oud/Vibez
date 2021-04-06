import 'package:flutter/material.dart';

/// Customised loading indicator
class StyledLoadSpinner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: 24,
        height: 24,
        child: CircularProgressIndicator(
          backgroundColor: Colors.yellow[700],
          valueColor: AlwaysStoppedAnimation<Color>(Colors.yellow),
        ));
  }
}
