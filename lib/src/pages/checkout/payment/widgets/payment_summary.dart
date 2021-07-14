import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:markaa/src/theme/styles.dart';
import 'package:markaa/src/theme/theme.dart';

class PaymentSummary extends StatefulWidget {
  final dynamic details;

  PaymentSummary({@required this.details});

  @override
  _PaymentSummaryState createState() => _PaymentSummaryState();
}

class _PaymentSummaryState extends State<PaymentSummary> {
  bool isExpanded = false;

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
          SizedBox(height: 5.h),
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
            decoration: BoxDecoration(
              color: greyLightColor,
              borderRadius: BorderRadius.circular(10.sp),
            ),
            child: Column(
              children: [
                if (isExpanded) ...[
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
                        'currency'.tr() + ' ${widget.details['subTotalPrice']}',
                        style: mediumTextStyle.copyWith(
                          color: greyColor,
                          fontSize: 14.sp,
                        ),
                      )
                    ],
                  ),
                  if (double.parse(widget.details['discount']) > 0) ...[
                    SizedBox(height: 5.h),
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
                          'currency'.tr() + ' ${widget.details['discount']}',
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
                        double.parse(widget.details['fees']) == .0
                            ? 'free'.tr()
                            : 'currency'.tr() + ' ${widget.details['fees']}',
                        style: mediumTextStyle.copyWith(
                          color: greyColor,
                          fontSize: 14.sp,
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 10.h),
                  Divider(color: greyColor, height: 5.h),
                ],
                InkWell(
                  onTap: () {
                    isExpanded = !isExpanded;
                    setState(() {});
                  },
                  child: Row(
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
                      Row(
                        children: [
                          Text(
                            'currency'.tr() +
                                ' ${widget.details['totalPrice']}',
                            style: mediumTextStyle.copyWith(
                              color: greyColor,
                              fontSize: 18.sp,
                            ),
                          ),
                          Icon(
                            isExpanded
                                ? Icons.keyboard_arrow_up
                                : Icons.keyboard_arrow_down,
                            color: primaryColor,
                            size: 30.sp,
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
