import 'package:markaa/src/theme/styles.dart';
import 'package:markaa/src/theme/theme.dart';
import 'package:flutter/material.dart';

class MarkaaTextInput extends StatelessWidget {
  final TextEditingController controller;
  final double width;
  final double padding;
  final double fontSize;
  final String hint;
  final TextInputType inputType;
  final Function validator;
  final bool readOnly;
  final Function onTap;

  MarkaaTextInput({
    @required this.controller,
    @required this.width,
    @required this.padding,
    @required this.fontSize,
    @required this.hint,
    @required this.inputType,
    @required this.validator,
    this.readOnly = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      padding: EdgeInsets.symmetric(horizontal: padding),
      child: TextFormField(
        controller: controller,
        style: mediumTextStyle.copyWith(
          color: greyDarkColor,
          fontSize: fontSize,
        ),
        decoration: InputDecoration(
          hintStyle: mediumTextStyle.copyWith(
            color: greyColor,
            fontSize: fontSize,
          ),
          hintText: hint,
        ),
        validator: (value) => validator(value),
        keyboardType: inputType,
        readOnly: readOnly,
        onTap: onTap,
      ),
    );
  }
}
