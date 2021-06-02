import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:markaa/src/data/mock/mock.dart';
import 'package:markaa/src/theme/styles.dart';
import 'package:markaa/src/theme/theme.dart';

class PaymentSummary extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'order_summary'.tr(),
            style: mediumTextStyle.copyWith(
              color: greyDarkColor,
              fontSize: 16.sp,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 10.h),
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
            decoration: BoxDecoration(
              color: greyLightColor,
              borderRadius: BorderRadius.circular(10.sp),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'checkout_subtotal_title'.tr(),
                      style: mediumTextStyle.copyWith(
                        color: greyColor,
                        fontSize: 14.sp,
                      ),
                    ),
                    Text(
                      'currency'.tr() +
                          ' ${double.parse(orderDetails['orderDetails']['subTotalPrice']).toStringAsFixed(3)}',
                      style: mediumTextStyle.copyWith(
                        color: greyColor,
                        fontSize: 14.sp,
                      ),
                    )
                  ],
                ),
                if (double.parse(orderDetails['orderDetails']['discount']) >
                    0) ...[
                  SizedBox(height: 10.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'discount'.tr(),
                        style: mediumTextStyle.copyWith(
                          color: darkColor,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        'currency'.tr() +
                            ' ${orderDetails['orderDetails']['discount']}',
                        style: mediumTextStyle.copyWith(
                          color: darkColor,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      )
                    ],
                  ),
                ],
                SizedBox(height: 10.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'checkout_shipping_cost_title'.tr(),
                      style: mediumTextStyle.copyWith(
                        color: greyColor,
                        fontSize: 14.sp,
                      ),
                    ),
                    Text(
                      double.parse(orderDetails['orderDetails']['fees']) == .0
                          ? 'free'.tr()
                          : 'currency'.tr() +
                              ' ${orderDetails['orderDetails']['fees']}',
                      style: mediumTextStyle.copyWith(
                        color: greyColor,
                        fontSize: 14.sp,
                      ),
                    )
                  ],
                ),
                SizedBox(height: 10.h),
                Divider(color: greyColor),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'total'.tr(),
                      style: mediumTextStyle.copyWith(
                        color: primaryColor,
                        fontWeight: FontWeight.w700,
                        fontSize: 18.sp,
                      ),
                    ),
                    Text(
                      'currency'.tr() +
                          ' ${orderDetails['orderDetails']['totalPrice']}',
                      style: mediumTextStyle.copyWith(
                        color: greyColor,
                        fontSize: 18.sp,
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
