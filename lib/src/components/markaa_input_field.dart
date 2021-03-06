import 'package:markaa/src/theme/styles.dart';
import 'package:flutter/material.dart';

class MarkaaInputField extends StatelessWidget {
  /// textediting controller
  final TextEditingController controller;

  /// input max width
  final double width;

  /// border color
  final Color borderColor;

  /// border radius
  final double radius;

  /// font size of input
  final double fontSize;

  /// font color of input
  final Color fontColor;

  /// hint text string
  final String hint;

  /// hint text color
  final Color hintColor;

  /// hint text size
  final double hintSize;

  /// label text string
  final String label;

  /// label text color
  final Color labelColor;

  /// label text size
  final double labelSize;

  /// read-only
  final bool readOnly;

  /// ontap function on input
  final void Function()? onTap;

  /// the trigger event on complete the editing
  final void Function()? onEditingComplete;

  /// the tirgger event on submitted the field value
  final void Function(String)? onFieldSubmitted;

  /// text input action
  final TextInputAction textInputAction;

  /// keyboard type of input field
  final TextInputType keyboardType;

  /// Focus Node
  final FocusNode? focusNode;

  /// space
  final double space;

  /// obsecure text for password
  final bool obsecureText;

  /// validator function
  final String? Function(String?)? validator;

  /// maxLines
  final int? maxLines;

  final int? maxLength;

  final Color? focusedColor;

  final bool bordered;

  final Color fillColor;

  MarkaaInputField({
    required this.width,
    required this.controller,
    this.borderColor = Colors.transparent,
    required this.radius,
    required this.fontSize,
    required this.fontColor,
    this.hint = '',
    this.hintColor = Colors.grey,
    this.hintSize = 0,
    required this.label,
    required this.labelColor,
    required this.labelSize,
    this.readOnly = false,
    this.onTap,
    this.onEditingComplete,
    this.onFieldSubmitted,
    this.textInputAction = TextInputAction.done,
    this.keyboardType = TextInputType.text,
    this.focusNode,
    this.space = 0,
    this.obsecureText = false,
    this.validator,
    this.maxLines,
    this.maxLength,
    this.focusedColor,
    this.bordered = true,
    this.fillColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            label,
            style: mediumTextStyle.copyWith(
              color: labelColor,
              fontSize: labelSize,
            ),
          ),
          SizedBox(height: space),
          obsecureText
              ? TextFormField(
                  controller: controller,
                  style: mediumTextStyle.copyWith(
                    color: fontColor,
                    fontSize: fontSize,
                  ),
                  focusNode: focusNode,
                  onTap: onTap,
                  onEditingComplete: onEditingComplete,
                  onFieldSubmitted: onFieldSubmitted,
                  textInputAction: textInputAction,
                  keyboardType: keyboardType,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 10,
                    ),
                    border: bordered
                        ? OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(radius),
                            ),
                            borderSide: BorderSide(
                              color: borderColor,
                              width: 0.8,
                              style: BorderStyle.solid,
                            ),
                          )
                        : UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: borderColor,
                              width: 0.8,
                              style: BorderStyle.solid,
                            ),
                          ),
                    enabledBorder: bordered
                        ? OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(radius),
                            ),
                            borderSide: BorderSide(
                              color: borderColor,
                              width: 0.8,
                              style: BorderStyle.solid,
                            ),
                          )
                        : UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: borderColor,
                              width: 0.8,
                              style: BorderStyle.solid,
                            ),
                          ),
                    focusedBorder: bordered
                        ? OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(radius),
                            ),
                            borderSide: BorderSide(
                              color: focusedColor != null
                                  ? focusedColor!
                                  : Color(0xFF82B1FF),
                              width: 0.8,
                              style: BorderStyle.solid,
                            ),
                          )
                        : UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: borderColor,
                              width: 0.8,
                              style: BorderStyle.solid,
                            ),
                          ),
                    hintText: hint,
                    hintStyle: mediumTextStyle.copyWith(
                      color: hintColor,
                      fontSize: hintSize,
                    ),
                    errorStyle: mediumTextStyle.copyWith(
                      color: Colors.red,
                      fontSize: hintSize,
                    ),
                    fillColor: fillColor,
                    filled: true,
                  ),
                  readOnly: readOnly,
                  obscureText: obsecureText,
                  autovalidateMode: AutovalidateMode.disabled,
                  validator: validator,
                )
              : TextFormField(
                  controller: controller,
                  style: TextStyle(color: fontColor, fontSize: fontSize),
                  focusNode: focusNode,
                  onTap: onTap,
                  onEditingComplete: onEditingComplete,
                  onFieldSubmitted: onFieldSubmitted,
                  textInputAction: textInputAction,
                  keyboardType: keyboardType,
                  maxLength: maxLength,
                  buildCounter: (
                    BuildContext context, {
                    int? currentLength,
                    int? maxLength,
                    bool? isFocused,
                  }) =>
                      null,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 10,
                    ),
                    border: bordered
                        ? OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(radius),
                            ),
                            borderSide: BorderSide(
                              color: borderColor,
                              width: 0.8,
                              style: BorderStyle.solid,
                            ),
                          )
                        : UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: borderColor,
                              width: 0.8,
                              style: BorderStyle.solid,
                            ),
                          ),
                    enabledBorder: bordered
                        ? OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(radius),
                            ),
                            borderSide: BorderSide(
                              color: borderColor,
                              width: 0.8,
                              style: BorderStyle.solid,
                            ),
                          )
                        : UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: borderColor,
                              width: 0.8,
                              style: BorderStyle.solid,
                            ),
                          ),
                    focusedBorder: bordered
                        ? OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(radius),
                            ),
                            borderSide: BorderSide(
                              color: focusedColor != null
                                  ? focusedColor!
                                  : Color(0xFF82B1FF),
                              width: 0.8,
                              style: BorderStyle.solid,
                            ),
                          )
                        : UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: borderColor,
                              width: 0.8,
                              style: BorderStyle.solid,
                            ),
                          ),
                    hintText: hint,
                    hintStyle: mediumTextStyle.copyWith(
                      color: hintColor,
                      fontSize: hintSize,
                    ),
                    errorStyle: mediumTextStyle.copyWith(
                      color: Colors.red,
                      fontSize: hintSize,
                    ),
                    fillColor: fillColor,
                    filled: true,
                  ),
                  readOnly: readOnly,
                  autovalidateMode: AutovalidateMode.disabled,
                  validator: validator,
                  maxLines: maxLines,
                ),
        ],
      ),
    );
  }
}
