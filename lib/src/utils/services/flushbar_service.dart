import 'package:markaa/src/theme/styles.dart';
import 'package:markaa/src/theme/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FlushBarService {
  final BuildContext context;

  FlushBarService({required this.context});

  Future showConfirmDialog({
    String title = 'are_you_sure',
    String? message,
    String yesButtonText = 'yes_button_title',
    String noButtonText = 'no_button_title',
  }) {
    return showCupertinoDialog(
      context: context,
      builder: (_) {
        return CupertinoAlertDialog(
          title: Text(
            title.tr(),
            textAlign: TextAlign.center,
            style: mediumTextStyle.copyWith(
              fontSize: 26.sp,
              color: Colors.black,
            ),
          ),
          content: Text(
            message!.tr(),
            textAlign: TextAlign.center,
            style: mediumTextStyle.copyWith(
              fontSize: 15.sp,
              color: Colors.black87,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, 'yes'),
              child: Text(
                yesButtonText.tr(),
                style: mediumTextStyle.copyWith(
                  fontSize: 18.sp,
                  color: primaryColor,
                ),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                noButtonText.tr(),
                style: mediumTextStyle.copyWith(
                  fontSize: 18.sp,
                  color: primaryColor,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  showErrorCustomDialog(String title, String message) {
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        content: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: Text(
                  title,
                  style: mediumTextStyle.copyWith(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            SizedBox(width: 10.w),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: Text(
                  message.tr(),
                  style: mediumTextStyle.copyWith(fontSize: 14.sp),
                ),
              ),
            ),
          ],
        ),
        actions: [
          CupertinoDialogAction(
            onPressed: () => Navigator.pop(context),
            child: Text(
              "close".tr(),
              style: mediumTextStyle.copyWith(
                color: primaryColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  showErrorDialog(String message, [String? image]) {
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        content: Column(
          children: [
            if (image != null) ...[
              SvgPicture.asset("lib/public/images/$image"),
              SizedBox(width: 10.w),
            ],
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: Text(
                  message.tr(),
                  style: mediumTextStyle.copyWith(fontSize: 14.sp),
                ),
              ),
            ),
          ],
        ),
        actions: [
          CupertinoDialogAction(
            onPressed: () => Navigator.pop(context),
            child: Text(
              "close".tr(),
              style: mediumTextStyle.copyWith(
                color: primaryColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
