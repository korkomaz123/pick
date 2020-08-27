import 'package:ciga/src/components/ciga_checkout_app_bar.dart';
import 'package:ciga/src/config/config.dart';
import 'package:ciga/src/data/models/index.dart';
import 'package:ciga/src/theme/styles.dart';
import 'package:ciga/src/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:isco_custom_widgets/isco_custom_widgets.dart';

class CheckoutAddressPage extends StatefulWidget {
  @override
  _CheckoutAddressPageState createState() => _CheckoutAddressPageState();
}

class _CheckoutAddressPageState extends State<CheckoutAddressPage> {
  PageStyle pageStyle;
  TextEditingController noteController = TextEditingController();
  PaymentEnum payment;

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
              Text(
                'Thank You',
                style: boldTextStyle.copyWith(
                  color: primaryColor,
                  fontSize: pageStyle.unitFontSize * 34,
                ),
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
                  'It\'s ordered!\nOrder No. #32212',
                  style: bookTextStyle.copyWith(
                    color: greyColor,
                    fontSize: pageStyle.unitFontSize * 14,
                  ),
                ),
              ),
              SizedBox(height: pageStyle.unitHeight * 20),
              Text(
                'You\'ve successfully placed the order',
                style: bookTextStyle.copyWith(
                  color: greyColor,
                  fontSize: pageStyle.unitFontSize * 17,
                ),
              ),
              SizedBox(height: pageStyle.unitHeight * 20),
              Padding(
                padding: EdgeInsets.only(left: pageStyle.unitWidth * 8),
                child: Text(
                  '''You can check status of your order by using our
Delivery status feature. You will receive an order
Confirmation e-mail with details cf your order and 
a link to track its progress.''',
                  style: bookTextStyle.copyWith(
                    color: greyColor,
                    fontSize: pageStyle.unitFontSize * 14,
                  ),
                ),
              ),
              _buildShowAllMyOrderedButton(),
              Text(
                'Your account',
                style: bookTextStyle.copyWith(
                  color: greyColor,
                  fontSize: pageStyle.unitFontSize * 17,
                ),
              ),
              SizedBox(height: pageStyle.unitHeight * 20),
              Padding(
                padding: EdgeInsets.only(left: pageStyle.unitWidth * 8),
                child: Text(
                  '''You can log to your account using e -mail and
Password defined easier. On your account you can
Edit your profile data. Check history of transactions.
Edit subscription to newsletter.''',
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
        title: 'SHOW ALL MY ORDERED',
        titleSize: pageStyle.unitFontSize * 17,
        titleColor: Colors.white,
        buttonColor: primaryColor,
        borderColor: Colors.transparent,
        onPressed: () => null,
        radius: 0,
      ),
    );
  }

  Widget _buildBackToShopButton() {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(vertical: pageStyle.unitHeight * 30),
      child: TextButton(
        title: 'BACK TO SHOP',
        titleSize: pageStyle.unitFontSize * 17,
        titleColor: greyColor,
        buttonColor: Colors.white,
        borderColor: greyColor,
        onPressed: () => null,
        radius: 0,
      ),
    );
  }
}
