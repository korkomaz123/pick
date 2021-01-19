import 'package:markaa/src/theme/styles.dart';
import 'package:markaa/src/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:isco_custom_widgets/isco_custom_widgets.dart';

class MarkaaCountryInput extends StatelessWidget {
  final TextEditingController controller;
  final String countryCode;
  final double width;
  final double padding;
  final double fontSize;
  final String hint;
  final TextInputType inputType;
  final Function validator;
  final bool readOnly;
  final Function onTap;
  final PageStyle pageStyle;

  MarkaaCountryInput({
    @required this.controller,
    @required this.countryCode,
    @required this.width,
    @required this.padding,
    @required this.fontSize,
    @required this.hint,
    @required this.inputType,
    @required this.validator,
    @required this.pageStyle,
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
          prefixIcon: countryCode != null
              ? Padding(
                  padding: EdgeInsets.only(
                    right: pageStyle.unitWidth * 10,
                  ),
                  child: Image.asset(
                    'lib/public/images/flags/${countryCode.toLowerCase()}.png',
                    width: pageStyle.unitWidth * 30,
                  ),
                )
              : Container(
                  width: pageStyle.unitWidth * 30,
                  height: pageStyle.unitHeight * 30,
                  margin: EdgeInsets.only(
                    top: pageStyle.unitHeight * 10,
                    bottom: pageStyle.unitHeight * 10,
                    right: pageStyle.unitWidth * 10,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    color: greyColor.withOpacity(0.8),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    '?',
                    textAlign: TextAlign.center,
                    style: mediumTextStyle.copyWith(
                      fontSize: pageStyle.unitFontSize * 16,
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
