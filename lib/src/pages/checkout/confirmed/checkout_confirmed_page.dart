import 'package:ciga/src/components/ciga_checkout_app_bar.dart';
import 'package:ciga/src/config/config.dart';
import 'package:ciga/src/theme/icons.dart';
import 'package:ciga/src/theme/styles.dart';
import 'package:ciga/src/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:isco_custom_widgets/isco_custom_widgets.dart';
import 'package:ciga/src/routes/routes.dart';

class CheckoutConfirmedPage extends StatefulWidget {
  @override
  _CheckoutConfirmedPageState createState() => _CheckoutConfirmedPageState();
}

class _CheckoutConfirmedPageState extends State<CheckoutConfirmedPage> {
  PageStyle pageStyle;
  TextEditingController noteController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    pageStyle = PageStyle(context, designWidth, designHeight);
    pageStyle.initializePageStyles();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CigaCheckoutAppBar(pageStyle: pageStyle),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: pageStyle.unitWidth * 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: pageStyle.unitHeight * 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'checkout_ordered_success_title'.tr(),
                    style: boldTextStyle.copyWith(
                      color: primaryColor,
                      fontSize: pageStyle.unitFontSize * 34,
                    ),
                  ),
                  SvgPicture.asset(orderedSuccessIcon),
                ],
              ),
              Container(
                width: double.infinity,
                margin: EdgeInsets.symmetric(
                  vertical: pageStyle.unitHeight * 10,
                ),
                padding: EdgeInsets.symmetric(
                  horizontal: pageStyle.unitWidth * 20,
                  vertical: pageStyle.unitWidth * 10,
                ),
                color: greyLightColor,
                child: Text(
                  'checkout_ordered_success_text'.tr(),
                  style: bookTextStyle.copyWith(
                    color: greyColor,
                    fontSize: pageStyle.unitFontSize * 14,
                  ),
                ),
              ),
              SizedBox(height: pageStyle.unitHeight * 20),
              Text(
                'checkout_ordered_success_subtitle'.tr(),
                style: bookTextStyle.copyWith(
                  color: greyColor,
                  fontSize: pageStyle.unitFontSize * 17,
                ),
              ),
              SizedBox(height: pageStyle.unitHeight * 20),
              Padding(
                padding: EdgeInsets.only(left: pageStyle.unitWidth * 8),
                child: Text(
                  'checkout_ordered_success_subtext'.tr(),
                  style: bookTextStyle.copyWith(
                    color: greyColor,
                    fontSize: pageStyle.unitFontSize * 14,
                  ),
                ),
              ),
              _buildShowAllMyOrderedButton(),
              Text(
                'checkout_ordered_success_account_title'.tr(),
                style: bookTextStyle.copyWith(
                  color: greyColor,
                  fontSize: pageStyle.unitFontSize * 17,
                ),
              ),
              SizedBox(height: pageStyle.unitHeight * 20),
              Padding(
                padding: EdgeInsets.only(left: pageStyle.unitWidth * 8),
                child: Text(
                  'checkout_ordered_success_account_text'.tr(),
                  style: bookTextStyle.copyWith(
                    color: greyColor,
                    fontSize: pageStyle.unitFontSize * 14,
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
      margin: EdgeInsets.symmetric(vertical: pageStyle.unitHeight * 30),
      child: TextButton(
        title: 'checkout_show_all_ordered_button_title'.tr(),
        titleSize: pageStyle.unitFontSize * 12,
        titleColor: Colors.white70,
        buttonColor: primaryColor,
        borderColor: Colors.transparent,
        onPressed: () => Navigator.pushNamed(context, Routes.orderHistory),
        radius: 30,
      ),
    );
  }

  Widget _buildBackToShopButton() {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(vertical: pageStyle.unitHeight * 30),
      child: TextButton(
        title: 'checkout_back_shop_button_title'.tr(),
        titleSize: pageStyle.unitFontSize * 12,
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
