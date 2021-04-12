import 'package:flutter/material.dart';
import 'package:vibez/_utils/utils.dart';

class VTextFormField extends StatelessWidget {
  final String? title;
  final TextInputType? inputType;
  final VoidCallback? onTapSuffixIcon;
  final bool isObscureText;
  final TextEditingController? controller;
  final Widget? suffixIcon;
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
      this.prefixIcon,
      this.suffixIcon});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(kRadius),
        child: TextFormField(
          autovalidateMode: AutovalidateMode.onUserInteraction,
          obscureText: isObscureText,
          controller: controller,
          cursorColor: Colors.white,
          style: Theme.of(context)
              .textTheme
              .bodyText1!
              .copyWith(color: Colors.white),
          keyboardType: inputType,
          validator: (val) {
            if (validator != null) {
              validator!(val);
            }
          },
          decoration: InputDecoration(
              floatingLabelBehavior: FloatingLabelBehavior.auto,
              labelText: title,
              suffixIconConstraints: BoxConstraints(minWidth: 40),
              suffixIcon: GestureDetector(
                  onTap: onTapSuffixIcon, child: this.suffixIcon),
              hintText: hintText,
              hintStyle: Theme.of(context)
                  .textTheme
                  .bodyText1!
                  .copyWith(color: Colors.white),
              prefixIcon: prefixIcon,
              alignLabelWithHint: true,
              labelStyle: Theme.of(context)
                  .textTheme
                  .bodyText1!
                  .copyWith(color: Colors.white),
              filled: true,
              fillColor: Colors.black54,
              border: OutlineInputBorder(
                borderSide: BorderSide.none,
              )),
        ),
      ),
    );
  }
}
