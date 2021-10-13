import 'package:adjust_sdk/adjust.dart';
import 'package:adjust_sdk/adjust_event.dart';
import 'package:markaa/src/change_notifier/my_cart_change_notifier.dart';
import 'package:markaa/src/components/markaa_checkout_app_bar.dart';
import 'package:markaa/src/components/markaa_text_button.dart';
import 'package:markaa/src/config/config.dart';
import 'package:markaa/src/theme/icons.dart';
import 'package:markaa/src/theme/styles.dart';
import 'package:markaa/src/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:markaa/src/routes/routes.dart';

class PaymentFailedPage extends StatefulWidget {
  final bool isReorder;

  PaymentFailedPage({@required this.isReorder});

  @override
  _PaymentFailedPageState createState() => _PaymentFailedPageState();
}

class _PaymentFailedPageState extends State<PaymentFailedPage> {
  TextEditingController noteController = TextEditingController();

  MyCartChangeNotifier _cartProvider;

  @override
  void initState() {
    super.initState();
    AdjustEvent adjustEvent = AdjustEvent(AdjustSDKConfig.failedPayment);
    Adjust.trackEvent(adjustEvent);

    if (!widget.isReorder) {
      _cartProvider = context.read<MyCartChangeNotifier>();
      _cartProvider.activateCart().then((value) {
        print('CART ACTIVATED: $value');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: MarkaaCheckoutAppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.w),
          child: Column(
            children: [
              SizedBox(height: 30.h),
              SvgPicture.asset(errorIcon),
              SizedBox(height: 15.h),
              Text(
                'sorry'.tr(),
                style: mediumTextStyle.copyWith(
                  color: primaryColor,
                  fontSize: 60.sp,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 10.h, bottom: 10.h),
                child: Text(
                  'transation_failed'.tr(),
                  style: mediumTextStyle.copyWith(
                    color: greyColor,
                    fontSize: 14.sp,
                  ),
                ),
              ),
              _buildGoToShoppingCartButton(),
              Container(
                width: double.infinity,
                child: Text(
                  'checkout_ordered_success_account_title'.tr(),
                  style: mediumTextStyle.copyWith(
                    color: greyColor,
                    fontSize: 17.sp,
                  ),
                ),
              ),
              SizedBox(height: 20.h),
              Padding(
                padding: EdgeInsets.only(left: 8.w),
                child: Text(
                  'checkout_ordered_success_account_text'.tr(),
                  style: mediumTextStyle.copyWith(
                    color: greyColor,
                    fontSize: 14.sp,
                  ),
                ),
              ),
              _buildBackToShopButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGoToShoppingCartButton() {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(vertical: 30.h),
      child: MarkaaTextButton(
        title: 'go_shopping_cart_button_title'.tr(),
        titleSize: 14.sp,
        titleColor: Colors.white,
        buttonColor: primaryColor,
        borderColor: Colors.transparent,
        onPressed: () {
          Navigator.popUntil(
            context,
            (route) => route.settings.name == Routes.myCart,
          );
        },
        radius: 30,
      ),
    );
  }

  Widget _buildBackToShopButton() {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(vertical: 30.h),
      child: MarkaaTextButton(
        title: 'checkout_back_shop_button_title'.tr(),
        titleSize: 12.sp,
        titleColor: greyColor,
        buttonColor: Colors.white,
        borderColor: greyColor,
        onPressed: () => Navigator.popUntil(
          context,
          (route) => route.settings.name == Routes.home,
        ),
        radius: 0,
      ),
    );
  }
}
