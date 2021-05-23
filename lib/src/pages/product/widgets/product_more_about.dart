import 'package:markaa/src/data/models/index.dart';
import 'package:markaa/src/theme/styles.dart';
import 'package:markaa/src/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProductMoreAbout extends StatelessWidget {
  final ProductEntity productEntity;

  ProductMoreAbout({this.productEntity});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 375.w,
      padding: EdgeInsets.symmetric(
        horizontal: 20.w,
        vertical: 30.h,
      ),
      margin: EdgeInsets.only(top: 10.h),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'product_more_about'.tr(),
            style: mediumTextStyle.copyWith(
              color: greyDarkColor,
              fontSize: 19.sp,
            ),
          ),
          SizedBox(height: 4.sp),
          Text(
            productEntity.description,
            style: mediumTextStyle.copyWith(
              color: greyColor,
              fontSize: 12.sp,
            ),
          ),
        ],
      ),
    );
  }
}
