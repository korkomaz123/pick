import 'package:markaa/preload.dart';
import 'package:markaa/src/data/mock/mock.dart';
import 'package:markaa/src/routes/routes.dart';
import 'package:markaa/src/theme/icons.dart';
import 'package:markaa/src/theme/styles.dart';
import 'package:markaa/src/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:markaa/src/utils/services/numeric_service.dart';

class MyWalletItem extends StatefulWidget {
  @override
  _MyWalletItemState createState() => _MyWalletItemState();
}

class _MyWalletItemState extends State<MyWalletItem> {
  @override
  void initState() {
    super.initState();
    _onLoadUser();
  }

  _onLoadUser() async {
    user = await Preload.currentUser;
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.pushNamed(context, Routes.myWallet),
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
                  child: SvgPicture.asset(walletCustomIcon),
                ),
                SizedBox(width: 10.w),
                Text(
                  'my_wallet'.tr(),
                  style: mediumTextStyle.copyWith(
                    fontSize: 16.sp,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Text(
                  NumericService.roundString(user.balance, 3),
                  style: mediumTextStyle.copyWith(
                    fontSize: 20.sp,
                    color: primaryColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(width: 2.w),
                Text(
                  'currency'.tr(),
                  style: mediumTextStyle.copyWith(
                    fontSize: 12.sp,
                    color: primaryColor,
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 20.sp,
                  color: greyDarkColor,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
