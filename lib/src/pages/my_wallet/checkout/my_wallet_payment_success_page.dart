import 'package:flutter/material.dart';
import 'package:markaa/src/change_notifier/auth_change_notifier.dart';
import 'package:markaa/src/data/mock/mock.dart';
import 'package:markaa/src/routes/routes.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:markaa/src/change_notifier/wallet_change_notifier.dart';
import 'package:markaa/src/config/config.dart';
import 'package:markaa/src/theme/icons.dart';
import 'package:markaa/src/theme/styles.dart';
import 'package:markaa/src/theme/theme.dart';

class MyWalletPaymentSuccessPage extends StatefulWidget {
  @override
  _MyWalletPaymentSuccessPageState createState() =>
      _MyWalletPaymentSuccessPageState();
}

class _MyWalletPaymentSuccessPageState extends State<MyWalletPaymentSuccessPage>
    with WidgetsBindingObserver {
  AuthChangeNotifier? _authChangeNotifier;
  WalletChangeNotifier? _walletChangeNotifier;
  String? amount;

  @override
  void initState() {
    super.initState();
    _authChangeNotifier = context.read<AuthChangeNotifier>();
    _walletChangeNotifier = context.read<WalletChangeNotifier>();

    user!.balance += double.parse(_walletChangeNotifier!.amount!);
    amount = _walletChangeNotifier!.amount;
    _walletChangeNotifier!.init();
    _authChangeNotifier!.updateUserEntity(user);

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.popUntil(
          context,
          (route) => route.settings.name == Routes.home,
        );
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
                (route) => route.settings.name == Routes.home,
              );
            },
          ),
        ),
        body: Container(
          width: designWidth.w,
          padding: EdgeInsets.symmetric(horizontal: 60.w),
          child: Column(
            children: [
              SizedBox(height: 40.h),
              SvgPicture.asset(walletSuccessIcon),
              Text(
                'checkout_ordered_success_title'.tr(),
                style: mediumTextStyle.copyWith(
                  fontSize: 52.sp,
                  fontWeight: FontWeight.w700,
                  color: primaryColor,
                ),
              ),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: amount ?? '',
                      style: mediumTextStyle.copyWith(
                        fontSize: 55.sp,
                        fontWeight: FontWeight.w700,
                        color: primaryColor,
                      ),
                    ),
                    TextSpan(
                      text: 'kwd'.tr(),
                      style: mediumTextStyle.copyWith(
                        fontSize: 22.sp,
                        color: primaryColor,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10.h),
              Text(
                'wallet_added_success_message'.tr(),
                textAlign: TextAlign.center,
                style: mediumTextStyle.copyWith(fontSize: 23.sp),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
