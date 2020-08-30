import 'package:ciga/src/components/ciga_checkout_app_bar.dart';
import 'package:ciga/src/config/config.dart';
import 'package:ciga/src/data/models/index.dart';
import 'package:ciga/src/routes/routes.dart';
import 'package:ciga/src/theme/styles.dart';
import 'package:ciga/src/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:isco_custom_widgets/isco_custom_widgets.dart';
import 'package:isco_custom_widgets/styles/page_style.dart';

class CheckoutShippingPage extends StatefulWidget {
  @override
  _CheckoutShippingPageState createState() => _CheckoutShippingPageState();
}

class _CheckoutShippingPageState extends State<CheckoutShippingPage> {
  PageStyle pageStyle;
  ShippingEnum shipping;

  @override
  Widget build(BuildContext context) {
    pageStyle = PageStyle(context, designWidth, designHeight);
    pageStyle.initializePageStyles();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CigaCheckoutAppBar(pageStyle: pageStyle, currentIndex: 1),
      body: Container(
        width: pageStyle.deviceWidth,
        padding: EdgeInsets.symmetric(horizontal: pageStyle.unitWidth * 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                vertical: pageStyle.unitHeight * 20,
              ),
              child: Text(
                'Shipping Method',
                style: bookTextStyle.copyWith(
                  color: greyDarkColor,
                  fontSize: pageStyle.unitFontSize * 14,
                ),
              ),
            ),
            _buildFreeShipping(),
            _buildFlatRateShipping(),
            _buildContinueReviewButton(),
            _buildBackToAddressButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildFreeShipping() {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(
        vertical: pageStyle.unitHeight * 10,
      ),
      padding: EdgeInsets.all(pageStyle.unitWidth * 10),
      color: greyLightColor,
      child: RadioListTile(
        value: ShippingEnum.free,
        groupValue: shipping,
        onChanged: (value) {
          setState(() {
            shipping = value;
          });
        },
        activeColor: darkColor,
        title: Text(
          'Free Shipping',
          style: bookTextStyle.copyWith(
            color: greyColor,
            fontSize: pageStyle.unitFontSize * 14,
          ),
        ),
        subtitle: Text(
          'Average time 2 Days to delivery',
          style: bookTextStyle.copyWith(
            color: greyColor,
            fontSize: pageStyle.unitFontSize * 11,
          ),
        ),
      ),
    );
  }

  Widget _buildFlatRateShipping() {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(
        vertical: pageStyle.unitHeight * 10,
      ),
      padding: EdgeInsets.all(pageStyle.unitWidth * 10),
      color: greyLightColor,
      child: RadioListTile(
        value: ShippingEnum.rate,
        groupValue: shipping,
        onChanged: (value) {
          setState(() {
            shipping = value;
          });
        },
        activeColor: darkColor,
        title: Text(
          'Flat Rate',
          style: bookTextStyle.copyWith(
            color: greyColor,
            fontSize: pageStyle.unitFontSize * 14,
          ),
        ),
        subtitle: Text(
          'Same Day delivery',
          style: bookTextStyle.copyWith(
            color: greyColor,
            fontSize: pageStyle.unitFontSize * 11,
          ),
        ),
      ),
    );
  }

  Widget _buildContinueReviewButton() {
    return Container(
      width: pageStyle.deviceWidth,
      padding: EdgeInsets.symmetric(horizontal: pageStyle.unitWidth * 60),
      child: TextButton(
        title: 'CONTINUE TO REVIEW',
        titleSize: pageStyle.unitFontSize * 14,
        titleColor: Colors.white,
        buttonColor: primaryColor,
        borderColor: Colors.transparent,
        onPressed: () => Navigator.pushNamed(context, Routes.checkoutReview),
        radius: 30,
      ),
    );
  }

  Widget _buildBackToAddressButton() {
    return Container(
      width: pageStyle.deviceWidth,
      padding: EdgeInsets.symmetric(horizontal: pageStyle.unitWidth * 60),
      child: TextButton(
        title: 'BACK TO ADDRESS',
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
