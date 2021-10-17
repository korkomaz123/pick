import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:markaa/src/theme/styles.dart';
import 'package:flutter/material.dart';

class MarkaaTextButton extends StatelessWidget {
  final String title;
  final String? image;
  final double titleSize;
  final Color titleColor;
  final Color buttonColor;
  final Color borderColor;
  final void Function()? onPressed;
  final double radius;
  final double elevation;
  final double borderWidth;
  final bool isBold;

  MarkaaTextButton({
    required this.title,
    this.image,
    required this.titleSize,
    required this.titleColor,
    required this.buttonColor,
    required this.borderColor,
    this.onPressed,
    this.elevation = 0,
    this.radius = 10,
    this.borderWidth = 1,
    this.isBold = false,
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
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (image != null) ...[
            Padding(
              padding: EdgeInsets.all(8.w),
              child: SvgPicture.asset(
                'lib/public/icons/$image.svg',
                color: titleColor,
                height: 35.h,
              ),
            ),
            SizedBox(
              width: 10.w,
            )
          ],
          Text(
            title,
            style: mediumTextStyle.copyWith(
              color: titleColor,
              fontSize: titleSize,
              fontWeight: isBold ? FontWeight.w700 : FontWeight.w600,
            ),
          )
        ],
      ),
    );
  }
}
