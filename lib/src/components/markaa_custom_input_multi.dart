import 'package:markaa/src/theme/styles.dart';
import 'package:markaa/src/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MarkaaCustomInputMulti extends StatelessWidget {
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

  MarkaaCustomInputMulti({
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
            horizontal: padding,
            vertical: 5,
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
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(10.sp),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(10.sp),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(10.sp),
          ),
          filled: true,
          fillColor: greyLightColor,
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
