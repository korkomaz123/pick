import 'package:markaa/src/components/markaa_checkout_app_bar.dart';
import 'package:markaa/src/components/markaa_text_button.dart';
import 'package:markaa/src/config/config.dart';
import 'package:markaa/src/data/mock/mock.dart';
import 'package:markaa/src/data/models/order_entity.dart';
import 'package:markaa/src/data/models/shipping_method_entity.dart';
import 'package:markaa/src/pages/my_cart/bloc/my_cart_repository.dart';
import 'package:markaa/src/routes/routes.dart';
import 'package:markaa/src/theme/icons.dart';
import 'package:markaa/src/theme/styles.dart';
import 'package:markaa/src/theme/theme.dart';
import 'package:markaa/src/utils/local_storage_repository.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:isco_custom_widgets/isco_custom_widgets.dart';
import 'package:isco_custom_widgets/styles/page_style.dart';

class CheckoutShippingPage extends StatefulWidget {
  final OrderEntity reorder;

  CheckoutShippingPage({this.reorder});

  @override
  _CheckoutShippingPageState createState() => _CheckoutShippingPageState();
}

class _CheckoutShippingPageState extends State<CheckoutShippingPage> {
  PageStyle pageStyle;
  String shippingMethodId;
  int serviceFees;
  LocalStorageRepository localRepo;
  MyCartRepository cartRepo;

  @override
  void initState() {
    super.initState();
    if (widget.reorder != null) {
      shippingMethodId = widget.reorder.shippingMethod.id;
      serviceFees = widget.reorder.shippingMethod.serviceFees;
    } else {
      shippingMethodId = shippingMethods[0].id;
      serviceFees = shippingMethods[0].serviceFees;
    }
    localRepo = context.read<LocalStorageRepository>();
    cartRepo = context.read<MyCartRepository>();
  }

  @override
  Widget build(BuildContext context) {
    pageStyle = PageStyle(context, designWidth, designHeight);
    pageStyle.initializePageStyles();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: MarkaaCheckoutAppBar(pageStyle: pageStyle, currentIndex: 1),
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
                'checkout_shipping_method_title'.tr(),
                style: mediumTextStyle.copyWith(
                  color: greyDarkColor,
                  fontSize: pageStyle.unitFontSize * 14,
                ),
              ),
            ),
            Column(
              children: shippingMethods.map((method) {
                return _buildShippingMethodCard(method);
              }).toList(),
            ),
            _buildContinueReviewButton(),
            _buildBackToAddressButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildShippingMethodCard(ShippingMethodEntity method) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(
        vertical: pageStyle.unitHeight * 10,
      ),
      padding: EdgeInsets.all(pageStyle.unitWidth * 10),
      color: greyLightColor,
      child: RadioListTile(
        value: method.id,
        groupValue: shippingMethodId,
        onChanged: (value) {
          shippingMethodId = value;
          serviceFees = method.serviceFees;
          setState(() {});
        },
        activeColor: primaryColor,
        title: Text(
          method.title + ' ${method.serviceFees} ' + 'currency'.tr(),
          style: mediumTextStyle.copyWith(
            color: greyColor,
            fontSize: pageStyle.unitFontSize * 14,
          ),
        ),
        secondary: SvgPicture.asset(
          method.serviceFees > 0 ? deliveredIcon : freeShippingIcon,
        ),
      ),
    );
  }

  Widget _buildContinueReviewButton() {
    return Container(
      width: pageStyle.deviceWidth,
      padding: EdgeInsets.symmetric(horizontal: pageStyle.unitWidth * 60),
      child: MarkaaTextButton(
        title: 'checkout_continue_review_button_title'.tr(),
        titleSize: pageStyle.unitFontSize * 12,
        titleColor: Colors.white,
        buttonColor: primaryColor,
        borderColor: Colors.transparent,
        onPressed: () => _onContinue(),
        radius: 30,
      ),
    );
  }

  Widget _buildBackToAddressButton() {
    return Container(
      width: pageStyle.deviceWidth,
      padding: EdgeInsets.symmetric(horizontal: pageStyle.unitWidth * 60),
      child: MarkaaTextButton(
        title: 'checkout_back_address_button_title'.tr(),
        titleSize: pageStyle.unitFontSize * 12,
        titleColor: greyColor,
        buttonColor: Colors.white,
        borderColor: Colors.transparent,
        onPressed: () => _onBack(),
        radius: 30,
      ),
    );
  }

  void _onBack() {
    orderDetails['shipping'] = '';
    Navigator.pop(context);
  }

  void _onContinue() async {
    String cartId;
    if (widget.reorder != null) {
      cartId = await localRepo.getItem('reorderCartId');
    } else {
      final result = await cartRepo.getCartId(user.token);
      if (result['code'] == 'SUCCESS') {
        cartId = result['cartId'];
      }
    }
    orderDetails['shipping'] = shippingMethodId;
    orderDetails['cartId'] = cartId;
    double totalPrice = 0;
    double subtotalPrice = 0;
    if (widget.reorder != null) {
      for (int i = 0; i < reorderCartItems.length; i++) {
        subtotalPrice += reorderCartItems[i].rowPrice;
      }
    } else {
      for (int i = 0; i < myCartItems.length; i++) {
        subtotalPrice += myCartItems[i].rowPrice;
      }
    }

    totalPrice = subtotalPrice + serviceFees;
    orderDetails['orderDetails'] = {};
    orderDetails['orderDetails']['totalPrice'] = totalPrice.toString();
    orderDetails['orderDetails']['subTotalPrice'] = subtotalPrice.toString();
    orderDetails['orderDetails']['fees'] = serviceFees.toString();
    Navigator.pushNamed(
      context,
      Routes.checkoutReview,
      arguments: widget.reorder,
    );
  }
}
