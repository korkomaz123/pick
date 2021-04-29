import 'package:markaa/src/components/markaa_checkout_app_bar.dart';
import 'package:markaa/src/components/markaa_text_button.dart';
import 'package:markaa/src/data/mock/mock.dart';
import 'package:markaa/src/theme/icons.dart';
import 'package:markaa/src/theme/styles.dart';
import 'package:markaa/src/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:markaa/src/routes/routes.dart';

class CheckoutConfirmedPage extends StatefulWidget {
  final String orderNo;

  CheckoutConfirmedPage({this.orderNo});

  @override
  _CheckoutConfirmedPageState createState() => _CheckoutConfirmedPageState();
}

class _CheckoutConfirmedPageState extends State<CheckoutConfirmedPage> {
  TextEditingController noteController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: MarkaaCheckoutAppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 30.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'checkout_ordered_success_title'.tr(),
                    style: mediumTextStyle.copyWith(
                      color: primaryColor,
                      fontSize: 34.sp,
                    ),
                  ),
                  SvgPicture.asset(orderedSuccessIcon),
                ],
              ),
              Container(
                width: double.infinity,
                margin: EdgeInsets.symmetric(
                  vertical: 10.h,
                ),
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                color: greyLightColor,
                child: Text(
                  'checkout_ordered_success_text'
                      .tr()
                      .replaceFirst('0', widget.orderNo),
                  style: mediumTextStyle.copyWith(
                    color: greyColor,
                    fontSize: 14.sp,
                  ),
                ),
              ),
              SizedBox(height: 20.h),
              Text(
                'checkout_ordered_success_subtitle'.tr(),
                style: mediumTextStyle.copyWith(
                  color: greyColor,
                  fontSize: 17.sp,
                ),
              ),
              SizedBox(height: 20.h),
              Padding(
                padding: EdgeInsets.only(left: 8.w),
                child: Text(
                  'checkout_ordered_success_subtext'.tr(),
                  style: mediumTextStyle.copyWith(
                    color: greyColor,
                    fontSize: 14.sp,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 8.w, right: 8.w, top: 30.h),
                child: Row(
                  children: [
                    SvgPicture.asset(deliveredIcon),
                    SizedBox(width: 1.w),
                    Text(
                      'delivery_time'.tr(),
                      style: mediumTextStyle.copyWith(
                        color: greyDarkColor,
                        fontSize: 15.sp,
                      ),
                    ),
                  ],
                ),
              ),
              if (user?.token != null) ...[_buildShowAllMyOrderedButton()],
              Text(
                'checkout_ordered_success_account_title'.tr(),
                style: mediumTextStyle.copyWith(
                  color: greyColor,
                  fontSize: 17.sp,
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

  Widget _buildShowAllMyOrderedButton() {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(vertical: 30.h),
      child: MarkaaTextButton(
        title: 'checkout_show_all_ordered_button_title'.tr(),
        titleSize: 12.sp,
        titleColor: Colors.white70,
        buttonColor: primaryColor,
        borderColor: Colors.transparent,
        onPressed: () => Navigator.pushReplacementNamed(
          context,
          Routes.orderHistory,
        ),
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
        onPressed: () => Navigator.pushNamedAndRemoveUntil(
          context,
          Routes.home,
          (route) => false,
        ),
        radius: 0,
      ),
    );
  }
}
