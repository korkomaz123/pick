import 'package:markaa/src/components/markaa_checkout_app_bar.dart';
import 'package:markaa/src/components/markaa_text_button.dart';
import 'package:markaa/src/config/config.dart';
import 'package:markaa/src/theme/icons.dart';
import 'package:markaa/src/theme/styles.dart';
import 'package:markaa/src/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:isco_custom_widgets/isco_custom_widgets.dart';
import 'package:markaa/src/routes/routes.dart';

class PaymentFailedPage extends StatefulWidget {
  @override
  _PaymentFailedPageState createState() => _PaymentFailedPageState();
}

class _PaymentFailedPageState extends State<PaymentFailedPage> {
  PageStyle pageStyle;
  TextEditingController noteController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    pageStyle = PageStyle(context, designWidth, designHeight);
    pageStyle.initializePageStyles();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: MarkaaCheckoutAppBar(pageStyle: pageStyle),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: pageStyle.unitWidth * 10),
          child: Column(
            children: [
              SizedBox(height: pageStyle.unitHeight * 30),
              SvgPicture.asset(errorIcon),
              SizedBox(height: pageStyle.unitHeight * 15),
              Text(
                'sorry'.tr(),
                style: mediumTextStyle.copyWith(
                  color: primaryColor,
                  fontSize: pageStyle.unitFontSize * 60,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  top: pageStyle.unitWidth * 10,
                  bottom: pageStyle.unitWidth * 10,
                ),
                child: Text(
                  'transation_failed'.tr(),
                  style: mediumTextStyle.copyWith(
                    color: greyColor,
                    fontSize: pageStyle.unitFontSize * 14,
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
                    fontSize: pageStyle.unitFontSize * 17,
                  ),
                ),
              ),
              SizedBox(height: pageStyle.unitHeight * 20),
              Padding(
                padding: EdgeInsets.only(left: pageStyle.unitWidth * 8),
                child: Text(
                  'checkout_ordered_success_account_text'.tr(),
                  style: mediumTextStyle.copyWith(
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

  Widget _buildGoToShoppingCartButton() {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(vertical: pageStyle.unitHeight * 30),
      child: MarkaaTextButton(
        title: 'go_shopping_cart_button_title'.tr(),
        titleSize: pageStyle.unitFontSize * 14,
        titleColor: Colors.white,
        buttonColor: primaryColor,
        borderColor: Colors.transparent,
        onPressed: () => Navigator.popUntil(
          context,
          (route) => route.settings.name == Routes.myCart,
        ),
        radius: 30,
      ),
    );
  }

  Widget _buildBackToShopButton() {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(vertical: pageStyle.unitHeight * 30),
      child: MarkaaTextButton(
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
