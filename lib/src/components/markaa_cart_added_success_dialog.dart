import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:markaa/src/components/markaa_text_button.dart';
import 'package:markaa/src/routes/routes.dart';
import 'package:markaa/src/theme/icons.dart';
import 'package:markaa/src/utils/services/numeric_service.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:markaa/src/change_notifier/my_cart_change_notifier.dart';
import 'package:markaa/src/config/config.dart';
import 'package:markaa/src/data/models/index.dart';
import 'package:markaa/src/theme/styles.dart';
import 'package:markaa/src/theme/theme.dart';

class MarkaaCartAddedSuccessDialog extends StatefulWidget {
  final ProductModel product;

  MarkaaCartAddedSuccessDialog({required this.product});

  @override
  _MarkaaCartAddedSuccessDialogState createState() =>
      _MarkaaCartAddedSuccessDialogState();
}

class _MarkaaCartAddedSuccessDialogState
    extends State<MarkaaCartAddedSuccessDialog> {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        width: designWidth.w,
        color: Colors.white,
        padding: EdgeInsets.only(
          left: 15.w,
          right: 15.w,
          top: 40.h,
          bottom: 20.h,
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      SvgPicture.asset(
                        orderedSuccessIcon,
                        width: 20.w,
                        height: 20.h,
                      ),
                      SizedBox(width: 5.w),
                      Expanded(
                        child: Text(
                          widget.product.name,
                          style: mediumTextStyle.copyWith(
                            color: greyDarkColor,
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 5.w),
                Consumer<MyCartChangeNotifier>(
                  builder: (_, model, ___) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'cart_total'.tr(),
                          style: mediumTextStyle.copyWith(
                            color: darkColor,
                            fontSize: 13.sp,
                          ),
                        ),
                        Text(
                          '${'currency'.tr()} ${NumericService.roundString(model.cartTotalPrice, 3)}',
                          style: mediumTextStyle.copyWith(
                            color: darkColor,
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
            SizedBox(height: 20.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 160.w,
                  height: 35.h,
                  child: MarkaaTextButton(
                    title: 'continue_shopping_button_title'.tr(),
                    titleSize: 12.sp,
                    titleColor: primaryColor,
                    buttonColor: Colors.white,
                    borderColor: primaryColor,
                    onPressed: () => Navigator.pop(context),
                    isBold: true,
                    radius: 4.sp,
                  ),
                ),
                Container(
                  width: 160.w,
                  height: 35.h,
                  child: MarkaaTextButton(
                    title: 'visit_cart_button_title'.tr(),
                    titleSize: 12.sp,
                    titleColor: Colors.white,
                    buttonColor: primaryColor,
                    borderColor: Colors.transparent,
                    onPressed: () =>
                        Navigator.popAndPushNamed(context, Routes.myCart),
                    isBold: true,
                    radius: 4.sp,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
