import 'package:ciga/src/theme/styles.dart';
import 'package:ciga/src/theme/theme.dart';
import 'package:flutter/material.dart';

class CigaTextInput extends StatelessWidget {
  final TextEditingController controller;
  final double width;
  final double padding;
  final double fontSize;
  final String hint;
  final TextInputType inputType;
  final Function validator;

  CigaTextInput({
    @required this.controller,
    @required this.width,
    @required this.padding,
    @required this.fontSize,
    @required this.hint,
    @required this.inputType,
    @required this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      padding: EdgeInsets.symmetric(horizontal: padding),
      child: TextFormField(
        controller: controller,
        style: bookTextStyle.copyWith(
          color: greyColor,
          fontSize: fontSize,
        ),
        decoration: InputDecoration(
          hintText: hint,
        ),
        validator: (value) => validator(value),
        keyboardType: inputType,
      ),
    );
  }
}
