import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:markaa/src/components/markaa_text_button.dart';
import 'package:markaa/src/theme/icons.dart';
import 'package:markaa/src/theme/styles.dart';
import 'package:markaa/src/theme/theme.dart';

class NoNetworkAccessPage extends StatefulWidget {
  @override
  _NoNetworkAccessPageState createState() => _NoNetworkAccessPageState();
}

class _NoNetworkAccessPageState extends State<NoNetworkAccessPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primarySwatchColor,
      body: Container(
        width: 375.w,
        height: 812.h,
        child: Column(
          children: [
            Container(
              width: 245.w,
              height: 150.h,
              margin: EdgeInsets.only(top: 200.h, bottom: 60.h),
              child: SvgPicture.asset(noNetworkIcon),
            ),
            Text(
              'sorry'.tr(),
              style: mediumTextStyle.copyWith(fontSize: 28.sp, color: Colors.white60),
            ),
            Text(
              'no_network_access'.tr(),
              style: mediumTextStyle.copyWith(fontSize: 20.sp, color: Colors.white),
            ),
            SizedBox(height: 42.h),
            Container(
              width: 166.w,
              height: 40.h,
              child: MarkaaTextButton(
                title: 'retry_button_title'.tr(),
                titleSize: 19.sp,
                titleColor: Colors.white,
                buttonColor: primarySwatchColor,
                borderColor: Colors.white70,
                onPressed: () => _onRetry(),
                radius: 30,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onRetry() {}
}
