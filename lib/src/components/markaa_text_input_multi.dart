import 'package:markaa/src/theme/styles.dart';
import 'package:markaa/src/theme/theme.dart';
import 'package:flutter/material.dart';

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
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      padding: EdgeInsets.symmetric(horizontal: padding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: padding),
          Text(
            hint,
            style: mediumTextStyle.copyWith(
              color: greyColor,
              fontSize: fontSize,
            ),
          ),
          TextFormField(
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
              border: OutlineInputBorder(
                borderSide: BorderSide(color: greyDarkColor),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: greyDarkColor),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: greyDarkColor),
              ),
            ),
            validator: (value) => validator(value),
            keyboardType: TextInputType.multiline,
            textInputAction: TextInputAction.newline,
            readOnly: readOnly,
            onTap: onTap,
            maxLines: maxLine,
          ),
        ],
      ),
    );
  }
}
