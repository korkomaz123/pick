import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:markaa/src/data/models/address_entity.dart';
import 'package:markaa/src/theme/styles.dart';
import 'package:markaa/src/theme/theme.dart';

class OrderAddressBar extends StatelessWidget {
  final AddressEntity address;

  OrderAddressBar({required this.address});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 375.w,
      margin: EdgeInsets.symmetric(horizontal: 10.w, vertical: 30.h),
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(2),
        color: Colors.grey.shade300,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            address.street,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            style: mediumTextStyle.copyWith(
              color: primaryColor,
              fontSize: 16.sp,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 6.h),
          Text(
            'Block No.${address.company}, ' + address.city + ', ' + address.country,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            style: mediumTextStyle.copyWith(color: greyDarkColor, fontSize: 14.sp),
          ),
          SizedBox(height: 6.h),
          Text(
            'phone_number_hint'.tr() + ': ' + address.phoneNumber!,
            style: mediumTextStyle.copyWith(color: greyDarkColor, fontSize: 14.sp),
          ),
        ],
      ),
    );
  }
}
