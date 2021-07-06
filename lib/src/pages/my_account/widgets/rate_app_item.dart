import 'package:markaa/src/theme/icons.dart';
import 'package:markaa/src/theme/styles.dart';
import 'package:markaa/src/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RateAppItem extends StatefulWidget {
  @override
  _RateAppItemState createState() => _RateAppItemState();
}

class _RateAppItemState extends State<RateAppItem> {
  final InAppReview inAppReview = InAppReview.instance;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => _onRateApp(),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 5.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  width: 22.w,
                  height: 22.h,
                  child: SvgPicture.asset(starCustomIcon),
                ),
                SizedBox(width: 10.w),
                Text(
                  'account_rate_app_title'.tr(),
                  style: mediumTextStyle.copyWith(
                    fontSize: 16.sp,
                  ),
                ),
              ],
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 20.sp,
              color: greyDarkColor,
            ),
          ],
        ),
      ),
    );
  }

  void _onRateApp() async {
    // if (await inAppReview.isAvailable()) {
    //   inAppReview.requestReview();
    // }
    inAppReview.openStoreListing(
      appStoreId: '1549591755',
      microsoftStoreId: '',
    );
  }
}
