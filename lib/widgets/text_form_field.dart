import 'package:flutter/material.dart';
import 'package:vibez/_utils/utils.dart';

class VTextFormField extends StatelessWidget {
  final String? title;
  final TextInputType? inputType;
  final VoidCallback? onTapSuffixIcon;
  final bool isObscureText;
  final TextEditingController? controller;

  final Widget? prefixIcon;
  final Function? validator;
  final String? hintText;

  VTextFormField(
      {this.title,
      this.inputType,
      this.onTapSuffixIcon,
      this.isObscureText = false,
      this.controller,
      this.validator,
      this.hintText,
      this.prefixIcon});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(kRadius),
        child: TextFormField(
          autovalidateMode: AutovalidateMode.onUserInteraction,
          obscureText: isObscureText,
          controller: controller,
          keyboardType: inputType,
          validator: (val) => validator!(val),
          decoration: InputDecoration(
              labelText: title,
              hintText: hintText,
              prefixIcon: prefixIcon,
              labelStyle: Theme.of(context).textTheme.bodyText1,
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderSide: BorderSide.none,
              )),
        ),
      ),
    );
  }
}
