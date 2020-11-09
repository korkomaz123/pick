import 'package:ciga/src/components/ciga_checkout_app_bar.dart';
import 'package:ciga/src/config/config.dart';
import 'package:ciga/src/data/mock/mock.dart';
import 'package:ciga/src/data/models/payment_method_entity.dart';
import 'package:ciga/src/pages/checkout/bloc/checkout_bloc.dart';
import 'package:ciga/src/theme/styles.dart';
import 'package:ciga/src/theme/theme.dart';
import 'package:ciga/src/utils/flushbar_service.dart';
import 'package:ciga/src/utils/progress_service.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isco_custom_widgets/isco_custom_widgets.dart';
import 'package:ciga/src/routes/routes.dart';

class CheckoutPaymentPage extends StatefulWidget {
  @override
  _CheckoutPaymentPageState createState() => _CheckoutPaymentPageState();
}

class _CheckoutPaymentPageState extends State<CheckoutPaymentPage> {
  TextEditingController noteController = TextEditingController();
  String payment;
  PageStyle pageStyle;
  ProgressService progressService;
  FlushBarService flushBarService;
  CheckoutBloc checkoutBloc;

  @override
  void initState() {
    super.initState();
    payment = paymentMethods[0].id;
    progressService = ProgressService(context: context);
    flushBarService = FlushBarService(context: context);
    checkoutBloc = context.bloc<CheckoutBloc>();
  }

  @override
  Widget build(BuildContext context) {
    pageStyle = PageStyle(context, designWidth, designHeight);
    pageStyle.initializePageStyles();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CigaCheckoutAppBar(pageStyle: pageStyle, currentIndex: 3),
      body: BlocConsumer<CheckoutBloc, CheckoutState>(
        listener: (context, state) {
          if (state is OrderSubmittedInProcess) {
            progressService.showProgress();
          }
          if (state is OrderSubmittedSuccess) {
            progressService.hideProgress();
            Navigator.pushNamed(context, Routes.checkoutConfirmed);
          }
          if (state is OrderSubmittedFailure) {
            progressService.hideProgress();
            flushBarService.showErrorMessage(pageStyle, state.message);
          }
        },
        builder: (context, state) {
          return SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: pageStyle.unitWidth * 10,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    children: paymentMethods.map((method) {
                      return _buildPaymentCard(method);
                    }).toList(),
                  ),
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
          );
        },
      ),
    );
  }

  Widget _buildPaymentCard(PaymentMethodEntity method) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(
        vertical: pageStyle.unitHeight * 10,
      ),
      padding: EdgeInsets.all(pageStyle.unitWidth * 10),
      color: greyLightColor,
      child: RadioListTile(
        value: method.id,
        groupValue: payment,
        onChanged: (value) {
          payment = value;
          setState(() {});
        },
        activeColor: primaryColor,
        title: Text(
          method.title,
          style: mediumTextStyle.copyWith(
            color: greyColor,
            fontSize: pageStyle.unitFontSize * 14,
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
                'currency'.tr() +
                    ' ${orderDetails['orderDetails']['subTotalPrice']}',
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
                int.parse(orderDetails['orderDetails']['fees']) == 0
                    ? 'free'.tr()
                    : 'currency'.tr() +
                        ' ${orderDetails['orderDetails']['fees']}',
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
                'currency'.tr() +
                    ' ${orderDetails['orderDetails']['totalPrice']}',
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
        titleSize: pageStyle.unitFontSize * 12,
        titleColor: Colors.white,
        buttonColor: primaryColor,
        borderColor: Colors.transparent,
        onPressed: () => _onPlaceOrder(),
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
        titleSize: pageStyle.unitFontSize * 12,
        titleColor: greyColor,
        buttonColor: Colors.white,
        borderColor: Colors.transparent,
        onPressed: () => Navigator.pop(context),
        radius: 30,
      ),
    );
  }

  void _onPlaceOrder() {
    orderDetails['paymentMethod'] = payment;
    checkoutBloc.add(OrderSubmitted(
      orderDetails: orderDetails,
      lang: lang,
    ));
  }
}
