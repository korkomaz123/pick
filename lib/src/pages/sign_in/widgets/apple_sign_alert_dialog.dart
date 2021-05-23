import 'package:markaa/src/theme/styles.dart';
import 'package:markaa/src/theme/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppleSignAlertDialog extends StatelessWidget {
  final String title;
  final String description;

  AppleSignAlertDialog({this.title, this.description});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Material(
        color: Colors.black.withOpacity(0.5),
        child: CupertinoAlertDialog(
          title: Text(
            title,
            textAlign: TextAlign.center,
            style: mediumTextStyle.copyWith(
              fontSize: 26.sp,
              color: Colors.black,
            ),
          ),
          content: Text(
            description,
            textAlign: TextAlign.center,
            style: mediumTextStyle.copyWith(
              fontSize: 15.sp,
              color: Colors.black87,
            ),
          ),
          actions: [
            // ignore: deprecated_member_use
            FlatButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'close'.tr(),
                style: mediumTextStyle.copyWith(
                  fontSize: 18.sp,
                  color: primaryColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
