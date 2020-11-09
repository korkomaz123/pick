import 'package:ciga/src/components/ciga_checkout_app_bar.dart';
import 'package:ciga/src/components/product_h_card.dart';
import 'package:ciga/src/config/config.dart';
import 'package:ciga/src/data/mock/mock.dart';
import 'package:ciga/src/routes/routes.dart';
import 'package:ciga/src/theme/styles.dart';
import 'package:ciga/src/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:isco_custom_widgets/isco_custom_widgets.dart';

class CheckoutReviewPage extends StatefulWidget {
  @override
  _CheckoutReviewPageState createState() => _CheckoutReviewPageState();
}

class _CheckoutReviewPageState extends State<CheckoutReviewPage> {
  PageStyle pageStyle;
  TextEditingController noteController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    pageStyle = PageStyle(context, designWidth, designHeight);
    pageStyle.initializePageStyles();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CigaCheckoutAppBar(pageStyle: pageStyle, currentIndex: 2),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: pageStyle.unitWidth * 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                  vertical: pageStyle.unitHeight * 20,
                ),
                child: Text(
                  'checkout_review_title'.tr(),
                  style: bookTextStyle.copyWith(
                    color: greyDarkColor,
                    fontSize: pageStyle.unitFontSize * 14,
                  ),
                ),
              ),
              Column(
                children: List.generate(
                  myCartItems.length,
                  (index) {
                    return Column(
                      children: [
                        ProductHCard(
                          pageStyle: pageStyle,
                          cardWidth: pageStyle.unitWidth * 340,
                          cardHeight: pageStyle.unitHeight * 150,
                          product: myCartItems[index].product,
                        ),
                        index < (myCartItems.length - 1)
                            ? Divider(
                                color: greyColor.withOpacity(0.3),
                                thickness: 0.5,
                              )
                            : SizedBox.shrink(),
                      ],
                    );
                  },
                ),
              ),
              _buildNote(),
              SizedBox(height: pageStyle.unitHeight * 30),
              _buildContinuePaymentButton(),
              _buildBackToShippingButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNote() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'checkout_note_title'.tr(),
          style: mediumTextStyle.copyWith(
            color: greyDarkColor,
            fontSize: pageStyle.unitFontSize * 17,
          ),
        ),
        Container(
          width: double.infinity,
          child: TextFormField(
            controller: noteController,
            style: bookTextStyle.copyWith(
              color: greyColor,
              fontSize: pageStyle.unitFontSize * 14,
            ),
            decoration: InputDecoration(
              hintText: 'checkout_note_hint'.tr(),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: greyColor),
              ),
            ),
            validator: (value) => null,
            keyboardType: TextInputType.text,
            maxLines: 6,
          ),
        ),
      ],
    );
  }

  Widget _buildContinuePaymentButton() {
    return Container(
      width: pageStyle.deviceWidth,
      padding: EdgeInsets.symmetric(horizontal: pageStyle.unitWidth * 60),
      child: TextButton(
        title: 'checkout_continue_payment_button_title'.tr(),
        titleSize: pageStyle.unitFontSize * 12,
        titleColor: Colors.white,
        buttonColor: primaryColor,
        borderColor: Colors.transparent,
        onPressed: () => _onContinue(),
        radius: 30,
      ),
    );
  }

  Widget _buildBackToShippingButton() {
    return Container(
      width: pageStyle.deviceWidth,
      padding: EdgeInsets.symmetric(horizontal: pageStyle.unitWidth * 60),
      child: TextButton(
        title: 'checkout_back_shipping_button_title'.tr(),
        titleSize: pageStyle.unitFontSize * 12,
        titleColor: greyColor,
        buttonColor: Colors.white,
        borderColor: Colors.transparent,
        onPressed: () => Navigator.pop(context),
        radius: 30,
      ),
    );
  }

  void _onContinue() {
    Navigator.pushNamed(context, Routes.checkoutPayment);
  }
}
