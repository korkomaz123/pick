import 'package:ciga/src/components/ciga_checkout_app_bar.dart';
import 'package:ciga/src/config/config.dart';
import 'package:ciga/src/data/models/index.dart';
import 'package:ciga/src/theme/images.dart';
import 'package:ciga/src/theme/styles.dart';
import 'package:ciga/src/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:isco_custom_widgets/isco_custom_widgets.dart';
import 'package:ciga/src/routes/routes.dart';

class CheckoutPaymentPage extends StatefulWidget {
  @override
  _CheckoutPaymentPageState createState() => _CheckoutPaymentPageState();
}

class _CheckoutPaymentPageState extends State<CheckoutPaymentPage> {
  PageStyle pageStyle;
  TextEditingController noteController = TextEditingController();
  PaymentEnum payment;

  @override
  Widget build(BuildContext context) {
    pageStyle = PageStyle(context, designWidth, designHeight);
    pageStyle.initializePageStyles();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CigaCheckoutAppBar(pageStyle: pageStyle, currentIndex: 3),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: pageStyle.unitWidth * 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildCashOnDelivery(),
              _buildVisa(),
              _buildKnet(),
              SizedBox(height: pageStyle.unitHeight * 50),
              Divider(
                color: greyLightColor,
                height: pageStyle.unitHeight * 10,
                thickness: pageStyle.unitHeight * 1,
              ),
              _buildDetails(),
              SizedBox(height: pageStyle.unitHeight * 30),
              _buildPlacePaymentButton(),
              _buildBackToReviewButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCashOnDelivery() {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(
        vertical: pageStyle.unitHeight * 10,
      ),
      padding: EdgeInsets.all(pageStyle.unitWidth * 10),
      color: greyLightColor,
      child: RadioListTile(
        value: PaymentEnum.cash,
        groupValue: payment,
        onChanged: (value) {
          setState(() {
            payment = value;
          });
        },
        activeColor: darkColor,
        title: Text(
          'checkout_payment_cash_on_delivery'.tr(),
          style: bookTextStyle.copyWith(
            color: greyColor,
            fontSize: pageStyle.unitFontSize * 14,
          ),
        ),
      ),
    );
  }

  Widget _buildVisa() {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(
        vertical: pageStyle.unitHeight * 10,
      ),
      padding: EdgeInsets.all(pageStyle.unitWidth * 10),
      color: greyLightColor,
      child: RadioListTile(
        value: PaymentEnum.visa,
        groupValue: payment,
        onChanged: (value) {
          setState(() {
            payment = value;
          });
        },
        activeColor: darkColor,
        title: Container(
          alignment: Alignment.centerLeft,
          child: Image.asset(
            visaImage,
            width: pageStyle.unitWidth * 128,
            height: pageStyle.unitHeight * 50,
          ),
        ),
      ),
    );
  }

  Widget _buildKnet() {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(
        vertical: pageStyle.unitHeight * 10,
      ),
      padding: EdgeInsets.all(pageStyle.unitWidth * 10),
      color: greyLightColor,
      child: RadioListTile(
        value: PaymentEnum.knet,
        groupValue: payment,
        onChanged: (value) {
          setState(() {
            payment = value;
          });
        },
        activeColor: darkColor,
        title: Container(
          alignment: Alignment.centerLeft,
          child: Image.asset(
            knetImage,
            width: pageStyle.unitWidth * 55,
            height: pageStyle.unitHeight * 40,
          ),
        ),
      ),
    );
  }

  Widget _buildDetails() {
    return Container(
      width: double.infinity,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'checkout_subtotal_title'.tr(),
                style: bookTextStyle.copyWith(
                  color: greyColor,
                  fontSize: pageStyle.unitFontSize * 14,
                ),
              ),
              Text(
                'currency'.tr() + ' 250',
                style: bookTextStyle.copyWith(
                  color: greyColor,
                  fontSize: pageStyle.unitFontSize * 14,
                ),
              )
            ],
          ),
          SizedBox(height: pageStyle.unitHeight * 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'checkout_shipping_cost_title'.tr(),
                style: bookTextStyle.copyWith(
                  color: greyColor,
                  fontSize: pageStyle.unitFontSize * 14,
                ),
              ),
              Text(
                'free'.tr(),
                style: bookTextStyle.copyWith(
                  color: greyColor,
                  fontSize: pageStyle.unitFontSize * 14,
                ),
              )
            ],
          ),
          SizedBox(height: pageStyle.unitHeight * 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'total'.tr(),
                style: bookTextStyle.copyWith(
                  color: greyColor,
                  fontSize: pageStyle.unitFontSize * 14,
                ),
              ),
              Text(
                'currency'.tr() + ' 250',
                style: mediumTextStyle.copyWith(
                  color: greyColor,
                  fontSize: pageStyle.unitFontSize * 17,
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPlacePaymentButton() {
    return Container(
      width: pageStyle.deviceWidth,
      padding: EdgeInsets.symmetric(horizontal: pageStyle.unitWidth * 60),
      child: TextButton(
        title: 'checkout_place_payment_button_title'.tr(),
        titleSize: pageStyle.unitFontSize * 14,
        titleColor: Colors.white,
        buttonColor: primaryColor,
        borderColor: Colors.transparent,
        onPressed: () => Navigator.pushNamed(context, Routes.checkoutConfirmed),
        radius: 30,
      ),
    );
  }

  Widget _buildBackToReviewButton() {
    return Container(
      width: pageStyle.deviceWidth,
      padding: EdgeInsets.symmetric(horizontal: pageStyle.unitWidth * 60),
      child: TextButton(
        title: 'checkout_back_review_button_title'.tr(),
        titleSize: pageStyle.unitFontSize * 14,
        titleColor: greyColor,
        buttonColor: Colors.white,
        borderColor: Colors.transparent,
        onPressed: () => Navigator.pop(context),
        radius: 30,
      ),
    );
  }
}
