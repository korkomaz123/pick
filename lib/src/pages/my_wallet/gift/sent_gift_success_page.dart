import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:markaa/src/config/config.dart';
import 'package:markaa/src/theme/icons.dart';
import 'package:markaa/src/theme/styles.dart';
import 'package:markaa/src/theme/theme.dart';

class SentGiftSuccessPage extends StatefulWidget {
  final String amount;

  SentGiftSuccessPage({this.amount});

  @override
  _SentGiftSuccessPageState createState() => _SentGiftSuccessPageState();
}

class _SentGiftSuccessPageState extends State<SentGiftSuccessPage> {
  String amount;

  @override
  void initState() {
    super.initState();

    amount = widget.amount;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            size: 25.sp,
            color: greyColor,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Container(
        width: designWidth.w,
        padding: EdgeInsets.symmetric(horizontal: 60.w),
        child: Column(
          children: [
            SizedBox(height: 40.h),
            SvgPicture.asset(walletSuccessIcon),
            Text(
              'checkout_ordered_success_title'.tr(),
              style: mediumTextStyle.copyWith(
                fontSize: 52.sp,
                fontWeight: FontWeight.w700,
                color: primaryColor,
              ),
            ),
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: amount ?? '',
                    style: mediumTextStyle.copyWith(
                      fontSize: 55.sp,
                      fontWeight: FontWeight.w700,
                      color: primaryColor,
                    ),
                  ),
                  TextSpan(
                    text: 'kwd'.tr(),
                    style: mediumTextStyle.copyWith(
                      fontSize: 22.sp,
                      color: primaryColor,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10.h),
            Text(
              'wallet_sent_success_message'.tr(),
              textAlign: TextAlign.center,
              style: mediumTextStyle.copyWith(fontSize: 23.sp),
            ),
          ],
        ),
      ),
    );
  }
}
