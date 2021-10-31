import 'package:markaa/src/theme/styles.dart';
import 'package:markaa/src/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MarkaaCountryInput extends StatelessWidget {
  final TextEditingController controller;
  final String? countryCode;
  final double width;
  final double padding;
  final double fontSize;
  final String hint;
  final TextInputType inputType;
  final Function validator;
  final bool readOnly;
  final void Function()? onTap;

  MarkaaCountryInput({
    required this.controller,
    this.countryCode,
    required this.width,
    required this.padding,
    required this.fontSize,
    required this.hint,
    required this.inputType,
    required this.validator,
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
          errorStyle: mediumTextStyle.copyWith(
            color: Colors.red,
            fontSize: fontSize,
          ),
          hintStyle: mediumTextStyle.copyWith(
            color: greyColor,
            fontSize: fontSize,
          ),
          hintText: hint,
          prefixIcon: countryCode != null
              ? Padding(
                  padding: EdgeInsets.only(right: 10.w),
                  child: Image.asset(
                    'lib/public/images/flags/${countryCode!.toLowerCase()}.png',
                    width: 30.w,
                  ),
                )
              : Container(
                  width: 30.w,
                  height: 30.h,
                  margin: EdgeInsets.only(top: 10.h, bottom: 10.h, right: 10.w),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    color: greyColor.withOpacity(0.8),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    '?',
                    textAlign: TextAlign.center,
                    style: mediumTextStyle.copyWith(
                      fontSize: 16.sp,
                      color: Colors.white,
                    ),
                  ),
                ),
        ),
        validator: (value) => validator(value),
        keyboardType: inputType,
        readOnly: readOnly,
        onTap: onTap,
      ),
    );
  }
}
