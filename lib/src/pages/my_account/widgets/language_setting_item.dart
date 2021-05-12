import 'package:markaa/src/components/toggle_language.dart';
import 'package:markaa/src/theme/icons.dart';
import 'package:markaa/src/theme/styles.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LanguageSettingItem extends StatefulWidget {
  @override
  _LanguageSettingItemState createState() => _LanguageSettingItemState();
}

class _LanguageSettingItemState extends State<LanguageSettingItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
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
                child: SvgPicture.asset(languageIcon),
              ),
              SizedBox(width: 10.w),
              Text(
                'account_language_title'.tr(),
                style: mediumTextStyle.copyWith(
                  fontSize: 16.sp,
                ),
              ),
            ],
          ),
          ToggleLanguageWidget()
        ],
      ),
    );
  }
}
