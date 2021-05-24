import 'package:markaa/src/theme/styles.dart';
import 'package:markaa/src/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MarkaaCustomSuffixInput extends StatelessWidget {
  final TextEditingController controller;
  final double width;
  final double padding;
  final double fontSize;
  final String hint;
  final TextInputType inputType;
  final Function validator;
  final Widget suffixIcon;
  final bool readOnly;
  final Function onTap;

  MarkaaCustomSuffixInput({
    @required this.controller,
    @required this.width,
    @required this.padding,
    @required this.fontSize,
    @required this.hint,
    @required this.inputType,
    @required this.validator,
    @required this.suffixIcon,
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
          contentPadding: EdgeInsets.symmetric(horizontal: 10.w),
          hintStyle: mediumTextStyle.copyWith(
            color: greyColor,
            fontSize: fontSize,
          ),
          hintText: hint,
          filled: true,
          fillColor: greyLightColor,
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
          suffixIcon: suffixIcon,
        ),
        enableInteractiveSelection: true,
        validator: (value) => validator(value),
        keyboardType: inputType,
        readOnly: readOnly,
        onTap: onTap,
      ),
    );
  }
}
