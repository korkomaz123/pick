import 'package:ciga/src/theme/styles.dart';
import 'package:ciga/src/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:isco_custom_widgets/isco_custom_widgets.dart';

class CigaCountryInput extends StatelessWidget {
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

  CigaCountryInput({
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
          hintStyle: bookTextStyle.copyWith(
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
              : Container(),
        ),
        validator: (value) => validator(value),
        keyboardType: inputType,
        readOnly: readOnly,
        onTap: onTap,
      ),
    );
  }
}
