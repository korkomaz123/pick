import 'package:markaa/src/theme/styles.dart';
import 'package:markaa/src/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MarkaaTextInputMulti extends StatelessWidget {
  final TextEditingController controller;
  final double width;
  final double padding;
  final double fontSize;
  final String hint;
  final TextInputType inputType;
  final Function validator;
  final bool readOnly;
  final Function onTap;
  final int maxLine;
  final Color borderColor;
  final double borderRadius;
  final Color fillColor;

  MarkaaTextInputMulti({
    @required this.controller,
    @required this.width,
    @required this.padding,
    @required this.fontSize,
    @required this.hint,
    @required this.inputType,
    @required this.validator,
    this.readOnly = false,
    this.onTap,
    this.maxLine,
    this.borderColor = greyDarkColor,
    this.borderRadius = 10,
    this.fillColor = Colors.white,
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
          contentPadding: EdgeInsets.symmetric(
            horizontal: 10.w,
            vertical: 5.h,
          ),
          errorStyle: mediumTextStyle.copyWith(
            color: Colors.red,
            fontSize: fontSize,
          ),
          hintStyle: mediumTextStyle.copyWith(
            color: greyColor,
            fontSize: fontSize,
          ),
          hintText: hint,
          border: OutlineInputBorder(
            borderSide: BorderSide(color: borderColor),
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: borderColor),
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: borderColor),
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          filled: true,
          fillColor: fillColor,
        ),
        validator: (value) => validator(value),
        keyboardType: TextInputType.multiline,
        textInputAction: TextInputAction.newline,
        readOnly: readOnly,
        onTap: onTap,
        maxLines: maxLine,
      ),
    );
  }
}
