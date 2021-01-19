import 'package:markaa/src/theme/styles.dart';
import 'package:flutter/material.dart';
import 'package:isco_custom_widgets/isco_custom_widgets.dart';

class CigaTextIconButton extends StatelessWidget {
  final String title;
  final double titleSize;
  final Color titleColor;
  final Color buttonColor;
  final Color borderColor;
  final Widget icon;
  final Function onPressed;
  final double radius;
  final double elevation;
  final double borderWidth;
  final PageStyle pageStyle;

  CigaTextIconButton({
    @required this.title,
    @required this.titleSize,
    @required this.titleColor,
    @required this.buttonColor,
    @required this.borderColor,
    @required this.icon,
    @required this.onPressed,
    this.elevation = 0,
    this.radius = 10,
    this.borderWidth = 1,
    this.pageStyle,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: onPressed,
      color: buttonColor,
      shape: RoundedRectangleBorder(
        side: BorderSide(color: borderColor, width: borderWidth),
        borderRadius: BorderRadius.all(Radius.circular(radius)),
      ),
      elevation: elevation,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          icon,
          SizedBox(width: pageStyle.unitWidth * 6),
          Text(
            title,
            style: mediumTextStyle.copyWith(
              color: titleColor,
              fontSize: titleSize,
            ),
          ),
        ],
      ),
    );
  }
}
