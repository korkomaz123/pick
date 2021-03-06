import 'package:markaa/src/theme/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MarkaaTextIconButton extends StatelessWidget {
  final String title;
  final double titleSize;
  final Color titleColor;
  final Color buttonColor;
  final Color borderColor;
  final Widget icon;
  final void Function()? onPressed;
  final double radius;
  final double elevation;
  final double borderWidth;
  final bool leading;

  MarkaaTextIconButton({
    required this.title,
    required this.titleSize,
    required this.titleColor,
    required this.buttonColor,
    required this.borderColor,
    required this.icon,
    required this.onPressed,
    this.leading = true,
    this.elevation = 0,
    this.radius = 10,
    this.borderWidth = 1,
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
          if (leading) ...[
            icon,
            SizedBox(width: 6.w),
          ],
          Text(
            title,
            style: mediumTextStyle.copyWith(
              color: titleColor,
              fontSize: titleSize,
              fontWeight: FontWeight.w500,
            ),
          ),
          if (!leading) ...[
            SizedBox(width: 6.w),
            icon,
          ],
        ],
      ),
    );
  }
}
