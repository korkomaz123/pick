import 'dart:convert';

import 'package:adjust_sdk/adjust.dart';
import 'package:adjust_sdk/adjust_event.dart';
import 'package:markaa/src/change_notifier/markaa_app_change_notifier.dart';
import 'package:markaa/src/change_notifier/order_change_notifier.dart';
import 'package:markaa/src/components/markaa_checkout_app_bar.dart';
import 'package:markaa/src/config/config.dart';
import 'package:markaa/src/data/mock/mock.dart';
import 'package:markaa/src/data/models/order_entity.dart';
import 'package:markaa/src/data/models/payment_method_entity.dart';
import 'package:markaa/src/pages/checkout/payment/awesome_loader.dart';
import 'package:markaa/src/routes/routes.dart';
import 'package:markaa/src/theme/icons.dart';
import 'package:markaa/src/theme/styles.dart';
import 'package:markaa/src/theme/theme.dart';
import 'package:markaa/src/change_notifier/my_cart_change_notifier.dart';
import 'package:markaa/src/utils/repositories/checkout_repository.dart';
import 'package:markaa/src/utils/repositories/local_storage_repository.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:markaa/src/utils/services/flushbar_service.dart';
import 'package:markaa/src/utils/services/progress_service.dart';
import 'package:provider/provider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:string_validator/string_validator.dart';

import 'payment_card_form.dart';

class CheckoutPaymentPage extends StatefulWidget {
  final OrderEntity reorder;

  CheckoutPaymentPage({this.reorder});

  @override
  _CheckoutPaymentPageState createState() => _CheckoutPaymentPageState();
}

class _CheckoutPaymentPageState extends State<CheckoutPaymentPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  AwesomeLoaderController loaderController = AwesomeLoaderController();
  TextEditingController noteController = TextEditingController();

  String payment;
  String cardToken;

  ProgressService progressService;
  FlushBarService flushBarService;

  LocalStorageRepository localStorageRepo = LocalStorageRepository();
  CheckoutRepository checkoutRepo = CheckoutRepository();

  MyCartChangeNotifier myCartChangeNotifier;
  MarkaaAppChangeNotifier markaaAppChangeNotifier;
  OrderChangeNotifier orderChangeNotifier;

  bool get outOfBalance =>
      double.parse(orderDetails['orderDetails']['subTotalPrice']) >
      user.balance;

  _loadData() async {
    if (paymentMethods.isEmpty)
      paymentMethods = await checkoutRepo.getPaymentMethod();
    if (widget.reorder != null) {
      payment = widget.reorder.paymentMethod.id;
    } else {
      payment = paymentMethods[2].id;
    }
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    if (widget.reorder != null) {
      payment = widget.reorder.paymentMethod.id;
    }
    progressService = ProgressService(context: context);
    flushBarService = FlushBarService(context: context);

    orderChangeNotifier = context.read<OrderChangeNotifier>();
    markaaAppChangeNotifier = context.read<MarkaaAppChangeNotifier>();
    myCartChangeNotifier = context.read<MyCartChangeNotifier>();

    _loadData();
  }

  void _onProcess() {
    progressService.showProgress();
  }

  void _onFailure(String error) {
    progressService.hideProgress();
    flushBarService.showErrorMessage(error);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      appBar: MarkaaCheckoutAppBar(currentIndex: 3),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 10.w),
        child: Consumer<MarkaaAppChangeNotifier>(
          builder: (_, __, ___) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: List.generate(paymentMethods.length, (index) {
                    int idx = paymentMethods.length - index - 1;
                    return _buildPaymentCard(paymentMethods[idx]);
                  }),
                ),
                SizedBox(height: 10.h),
                if (payment == 'mpwalletsystem' && outOfBalance) ...[
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.only(bottom: 10.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'not_enough_wallet'.tr(),
                          style: mediumTextStyle.copyWith(
                            fontSize: 14.sp,
                            color: dangerColor,
                          ),
                        ),
                        InkWell(
                          onTap: () async {
                            await Navigator.pushNamed(context, Routes.myWallet);
                            setState(() {});
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                'add_money_to_wallet'.tr(),
                                style: mediumTextStyle.copyWith(
                                  fontSize: 14.sp,
                                  color: primaryColor,
                                ),
                              ),
                              Icon(
                                Icons.arrow_forward_ios,
                                size: 20.sp,
                                color: primaryColor,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                Divider(
                  color: greyLightColor,
                  height: 10.h,
                  thickness: 1.h,
                ),
                _buildDetails(),
                SizedBox(height: 30.h),
                if (payment == 'tap' ||
                    payment == 'mpwalletsystem' && outOfBalance) ...[
                  Container()
                ] else ...[
                  _buildPlacePaymentButton()
                ],
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildPaymentCard(PaymentMethodEntity method) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          margin: EdgeInsets.symmetric(vertical: 10.h),
          padding: EdgeInsets.all(10.w),
          color: greyLightColor,
          child: RadioListTile(
            value: method.id,
            groupValue: payment,
            onChanged: (value) {
              payment = value;
              markaaAppChangeNotifier.rebuild();
            },
            activeColor: primaryColor,
            title: Row(
              children: [
                if (method.id == 'cashondelivery') ...[
                  SvgPicture.asset(
                    'lib/public/icons/cashondelivery.svg',
                    height: 19,
                    width: 39,
                  ),
                  Text(
                    "    " + method.title,
                    style: mediumTextStyle.copyWith(
                      color: greyColor,
                      fontSize: 14.sp,
                    ),
                  ),
                ] else if (method.id == 'knet') ...[
                  SvgPicture.asset(
                    'lib/public/icons/knet.svg',
                    height: 46,
                    width: 61,
                  ),
                ] else if (method.id == 'tap') ...[
                  Image.asset(
                    'lib/public/images/visa-card.png',
                    height: 35,
                    width: 95,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  SvgPicture.asset(
                    'lib/public/icons/line.svg',
                    height: 41,
                    width: 10,
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  SvgPicture.asset(
                    'lib/public/icons/master-card.svg',
                    height: 42,
                    width: 54,
                  ),
                ] else ...[
                  SvgPicture.asset(walletIcon),
                  SizedBox(width: 10.w),
                  SvgPicture.asset(walletTitle),
                ],
              ],
            ),
          ),
        ),
        if (method.id == 'tap' && payment == 'tap' && cardToken == null) ...[
          SizedBox(height: 5.h),
          Container(
            width: double.infinity,
            height: 280.h,
            child: PaymentCardForm(
              onAuthorizedSuccess: _onCardAuthorizedSuccess,
            ),
          ),
        ]
      ],
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
                style: mediumTextStyle.copyWith(
                  color: greyColor,
                  fontSize: 14.sp,
                ),
              ),
              Text(
                'currency'.tr() +
                    ' ${double.parse(orderDetails['orderDetails']['subTotalPrice']).toStringAsFixed(3)}',
                style: mediumTextStyle.copyWith(
                  color: greyColor,
                  fontSize: 14.sp,
                ),
              )
            ],
          ),
          if (double.parse(orderDetails['orderDetails']['discount']) > 0) ...[
            SizedBox(height: 10.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'discount'.tr(),
                  style: mediumTextStyle.copyWith(
                    color: darkColor,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  'currency'.tr() +
                      ' ${orderDetails['orderDetails']['discount']}',
                  style: mediumTextStyle.copyWith(
                    color: darkColor,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w700,
                  ),
                )
              ],
            ),
          ],
          SizedBox(height: 10.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'checkout_shipping_cost_title'.tr(),
                style: mediumTextStyle.copyWith(
                  color: greyColor,
                  fontSize: 14.sp,
                ),
              ),
              Text(
                double.parse(orderDetails['orderDetails']['fees']) == .0
                    ? 'free'.tr()
                    : 'currency'.tr() +
                        ' ${orderDetails['orderDetails']['fees']}',
                style: mediumTextStyle.copyWith(
                  color: greyColor,
                  fontSize: 14.sp,
                ),
              )
            ],
          ),
          SizedBox(height: 10.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'total'.tr(),
                style: mediumTextStyle.copyWith(
                  color: greyColor,
                  fontSize: 14.sp,
                ),
              ),
              Text(
                'currency'.tr() +
                    ' ${orderDetails['orderDetails']['totalPrice']}',
                style: mediumTextStyle.copyWith(
                  color: greyColor,
                  fontSize: 17.sp,
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPlacePaymentButton() {
    return SizedBox(
      height: 45,
      // ignore: deprecated_member_use
      child: RaisedButton(
        color: primaryColor,
        clipBehavior: Clip.hardEdge,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadiusDirectional.all(Radius.circular(30)),
        ),
        onPressed: _onPlaceOrder,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 25,
              height: 25,
              child: AwesomeLoader(
                outerColor: Colors.white,
                innerColor: Colors.white,
                strokeWidth: 3.0,
                controller: loaderController,
              ),
            ),
            Spacer(),
            Text(
              'checkout_place_payment_button_title'.tr(),
              style: TextStyle(color: Colors.white, fontSize: 16.0),
            ),
            Spacer(),
            Icon(Icons.lock_outline, color: Colors.white),
          ],
        ),
      ),
    );
  }

  void _onCardAuthorizedSuccess(String token) {
    cardToken = token;
    setState(() {});
    Future.delayed(Duration(milliseconds: 300), _onPlaceOrder);
  }

  void _onPlaceOrder() async {
    orderDetails['paymentMethod'] = payment;
    if (payment == 'tap') {
      /// if the method is tap, check credit card already authorized
      if (cardToken == null) {
        flushBarService.showErrorMessage('fill_card_details_error'.tr());
        return;
      }
      orderDetails['tap_token'] = cardToken;
    }

    AdjustEvent adjustEvent = new AdjustEvent(AdjustSDKConfig.placePayment);
    Adjust.trackEvent(adjustEvent);

    /// submit the order, after call this api, the status will be pending till payment be processed
    await orderChangeNotifier.submitOrder(orderDetails, lang,
        onProcess: _onProcess,
        onSuccess: _onOrderSubmittedSuccess,
        onFailure: _onFailure);
  }

  void _onOrderSubmittedSuccess(String payUrl, OrderEntity order) async {
    progressService.hideProgress();

    if (payment == 'cashondelivery' || payment == 'mpwalletsystem') {
      _onSuccessOrder();
      if (payment == 'mpwalletsystem') {
        user.balance -= double.parse(orderDetails['totalPrice']);
      }

      /// payment method is equal to cod, go to success page directly
      Navigator.pushNamedAndRemoveUntil(
        context,
        Routes.checkoutConfirmed,
        (route) => route.settings.name == Routes.home,
        arguments: order.orderNo,
      );
    } else if (isURL(payUrl)) {
      /// payment method is knet or tap, go to payment webview page
      Navigator.pushNamed(
        context,
        Routes.checkoutPaymentCard,
        arguments: {'url': payUrl, 'order': order, 'reorder': widget.reorder},
      );
    } else {
      /// if the payurl is invalid redirect to payment failed page
      await orderChangeNotifier.cancelFullOrder(order,
          onSuccess: _gotoFailedPage, onFailure: _gotoFailedPage);
    }
  }

  void _gotoFailedPage() {
    Navigator.pushNamedAndRemoveUntil(
      context,
      Routes.paymentFailed,
      (route) => route.settings.name == Routes.myCart,
    );
  }

  Future<void> _onSuccessOrder() async {
    if (widget.reorder != null) {
      myCartChangeNotifier.initializeReorderCart();
    } else {
      myCartChangeNotifier.initialize();
      if (user?.token == null) {
        await localStorageRepo.removeItem('cartId');
      }
      await myCartChangeNotifier.getCartId();
    }
    final priceDetails = jsonDecode(orderDetails['orderDetails']);
    double price = double.parse(priceDetails['totalPrice']);

    AdjustEvent adjustEvent = AdjustEvent(AdjustSDKConfig.completePurchase);
    adjustEvent.setRevenue(price, 'KWD');
    Adjust.trackEvent(adjustEvent);
  }
}
