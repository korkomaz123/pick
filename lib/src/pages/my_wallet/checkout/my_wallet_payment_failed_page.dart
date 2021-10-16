import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:markaa/src/change_notifier/wallet_change_notifier.dart';
import 'package:markaa/src/config/config.dart';
import 'package:markaa/src/routes/routes.dart';
import 'package:markaa/src/theme/icons.dart';
import 'package:markaa/src/theme/styles.dart';
import 'package:markaa/src/theme/theme.dart';

class MyWalletPaymentFailedPage extends StatefulWidget {
  @override
  _MyWalletPaymentFailedPageState createState() =>
      _MyWalletPaymentFailedPageState();
}

class _MyWalletPaymentFailedPageState extends State<MyWalletPaymentFailedPage>
    with WidgetsBindingObserver {
  WalletChangeNotifier? _walletChangeNotifier;

  @override
  void initState() {
    super.initState();
    _walletChangeNotifier = context.read<WalletChangeNotifier>();
    _walletChangeNotifier!.init();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.popUntil(
          context,
          (route) => route.settings.name == Routes.myWallet,
        );
        Navigator.pop(context);
        return true;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              size: 25.sp,
              color: greyColor,
            ),
            onPressed: () {
              Navigator.popUntil(
                context,
                (route) => route.settings.name == Routes.myWallet,
              );
              Navigator.pop(context);
            },
          ),
        ),
        body: Container(
          width: designWidth.w,
          child: Column(
            children: [
              SizedBox(height: 100.h),
              SvgPicture.asset(walletFailedIcon),
              Text(
                'sorry'.tr(),
                style: mediumTextStyle.copyWith(
                  fontSize: 52.sp,
                  fontWeight: FontWeight.w700,
                  color: primaryColor,
                ),
              ),
              SizedBox(height: 10.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 80.w),
                child: Text(
                  'wallet_added_failure_message'.tr(),
                  textAlign: TextAlign.center,
                  style: mediumTextStyle.copyWith(fontSize: 23.sp),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
