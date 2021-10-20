import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:markaa/src/change_notifier/auth_change_notifier.dart';
import 'package:markaa/src/data/mock/mock.dart';
import 'package:markaa/src/data/models/index.dart';
import 'package:markaa/src/theme/icons.dart';
import 'package:markaa/src/theme/styles.dart';
import 'package:markaa/src/theme/theme.dart';
import 'package:markaa/src/utils/services/numeric_service.dart';

class PaymentMethodCard extends StatelessWidget {
  final PaymentMethodEntity method;
  final String value;
  final void Function(String?)? onChangeMethod;

  PaymentMethodCard({
    required this.method,
    required this.value,
    this.onChangeMethod,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          margin: EdgeInsets.only(bottom: 5.h),
          padding: EdgeInsets.symmetric(horizontal: 10.w),
          decoration: BoxDecoration(
            color: greyLightColor,
            borderRadius: BorderRadius.circular(10.sp),
          ),
          child: RadioListTile(
            value: method.id,
            groupValue: value,
            onChanged: onChangeMethod,
            activeColor: primaryColor,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (method.id == 'cashondelivery') ...[
                  Row(
                    children: [
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
                    ],
                  ),
                ] else if (method.id == 'knet') ...[
                  SvgPicture.asset(
                    'lib/public/icons/knet.svg',
                    height: 30.h,
                    width: 45.w,
                  ),
                ] else if (method.id == 'tap') ...[
                  Row(
                    children: [
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
                    ],
                  ),
                ] else ...[
                  Row(
                    children: [
                      SvgPicture.asset(walletIcon, width: 40.w, height: 30.h),
                      SizedBox(width: 10.w),
                      SvgPicture.asset(walletTitle, height: 25.h, width: 50.w),
                    ],
                  ),
                  if (user != null) ...[
                    Consumer<AuthChangeNotifier>(builder: (_, model, __) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            'your_amount'.tr(),
                            style: mediumTextStyle.copyWith(
                              fontSize: 10.sp,
                              color: primaryColor,
                            ),
                          ),
                          Text(
                            '${NumericService.roundString(model.currentUser!.balance, 3)} ${'currency'.tr()}',
                            style: mediumTextStyle.copyWith(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      );
                    }),
                  ],
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }
}
