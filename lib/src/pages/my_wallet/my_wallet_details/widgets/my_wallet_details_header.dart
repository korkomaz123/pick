import 'package:flutter/material.dart';
import 'package:markaa/src/data/mock/mock.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:markaa/src/routes/routes.dart';
import 'package:markaa/src/theme/styles.dart';
import 'package:markaa/src/theme/theme.dart';
import 'package:markaa/src/utils/services/numeric_service.dart';

class MyWalletDetailsHeader extends StatelessWidget
    implements PreferredSizeWidget {
  final bool fromCheckout;

  MyWalletDetailsHeader({required this.fromCheckout});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: IconButton(
        icon: Icon(Icons.arrow_back_ios, size: 20.sp, color: greyColor),
        onPressed: () {
          String router = fromCheckout ? Routes.checkout : Routes.account;
          Navigator.popUntil(context, (route) => route.settings.name == router);
        },
      ),
      centerTitle: true,
      title: Text(
        'wallet_details'.tr(),
        style: mediumTextStyle.copyWith(fontSize: 21.sp),
      ),
      bottom: PreferredSize(
        preferredSize: Size.fromHeight(60.h),
        child: Column(
          children: [
            Text(
              '${NumericService.roundString(user!.balance, 3)} (${'kwd'.tr()})',
              style: mediumTextStyle.copyWith(
                color: primaryColor,
                fontSize: 23.sp,
                fontWeight: FontWeight.w900,
              ),
            ),
            Text(
              'wallet_balance'.tr(),
              style: mediumTextStyle.copyWith(
                color: greyColor,
                fontSize: 10.sp,
              ),
            ),
            SizedBox(height: 5.h),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(100.h);
}
