import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:markaa/src/data/models/index.dart';
import 'package:markaa/src/theme/icons.dart';
import 'package:markaa/src/theme/styles.dart';
import 'package:markaa/src/theme/theme.dart';

import 'payment_card_form.dart';

class PaymentMethodCard extends StatelessWidget {
  final PaymentMethodEntity method;
  final Function onChange;
  final String value;
  final String cardToken;
  final Function onAuthorizedSuccess;

  PaymentMethodCard({
    @required this.method,
    @required this.onChange,
    @required this.value,
    @required this.cardToken,
    @required this.onAuthorizedSuccess,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          margin: EdgeInsets.symmetric(vertical: 5.h),
          padding: EdgeInsets.symmetric(horizontal: 10.w),
          decoration: BoxDecoration(
            color: greyLightColor,
            borderRadius: BorderRadius.circular(10.sp),
          ),
          child: RadioListTile(
            value: method.id,
            groupValue: value,
            onChanged: onChange,
            activeColor: primaryColor,
            title: Row(
              children: [
                if (method.id == 'cashondelivery') ...[
                  SvgPicture.asset(
                    'lib/public/icons/cashondelivery.svg',
                    height: 20.h,
                    width: 30.w,
                  ),
                  Text(
                    "    " + method.title,
                    style: mediumTextStyle.copyWith(
                      color: greyColor,
                      fontSize: 14.sp,
                    ),
                  ),
                ] else if (method.id == 'knet') ...[
                  SvgPicture.asset(
                    'lib/public/icons/knet.svg',
                    height: 30.h,
                    width: 45.w,
                  ),
                ] else if (method.id == 'tap') ...[
                  Image.asset(
                    'lib/public/images/visa-card.png',
                    height: 25.h,
                    width: 75.w,
                  ),
                  SizedBox(
                    width: 6.w,
                  ),
                  SvgPicture.asset(
                    'lib/public/icons/line.svg',
                    height: 25.h,
                    width: 10.w,
                  ),
                  SizedBox(
                    width: 10.w,
                  ),
                  SvgPicture.asset(
                    'lib/public/icons/master-card.svg',
                    height: 25.h,
                    width: 45.w,
                  ),
                ] else ...[
                  SvgPicture.asset(walletIcon, width: 40.w, height: 30.h),
                  SizedBox(width: 10.w),
                  SvgPicture.asset(walletTitle, height: 25.h, width: 50.w),
                ],
              ],
            ),
          ),
        ),
        if (method.id == 'tap' && value == 'tap' && cardToken == null) ...[
          Container(
            width: double.infinity,
            height: 280.h,
            child: PaymentCardForm(
              onAuthorizedSuccess: onAuthorizedSuccess,
            ),
          ),
        ]
      ],
    );
  }
}
