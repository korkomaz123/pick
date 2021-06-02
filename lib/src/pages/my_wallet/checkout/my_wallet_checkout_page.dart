import 'dart:convert';

import 'package:adjust_sdk/adjust.dart';
import 'package:adjust_sdk/adjust_event.dart';
import 'package:markaa/preload.dart';
import 'package:markaa/src/change_notifier/address_change_notifier.dart';
import 'package:markaa/src/change_notifier/markaa_app_change_notifier.dart';
import 'package:markaa/src/change_notifier/order_change_notifier.dart';
import 'package:markaa/src/change_notifier/wallet_change_notifier.dart';
import 'package:markaa/src/config/config.dart';
import 'package:markaa/src/data/mock/mock.dart';
import 'package:markaa/src/data/models/order_entity.dart';
import 'package:markaa/src/data/models/payment_method_entity.dart';
import 'package:markaa/src/pages/checkout/payment/awesome_loader.dart';
import 'package:markaa/src/pages/checkout/payment/payment_card_form.dart';
import 'package:markaa/src/routes/routes.dart';
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

class MyWalletCheckoutPage extends StatefulWidget {
  final OrderEntity reorder;

  MyWalletCheckoutPage({this.reorder});

  @override
  _MyWalletCheckoutPageState createState() => _MyWalletCheckoutPageState();
}

class _MyWalletCheckoutPageState extends State<MyWalletCheckoutPage> {
  AwesomeLoaderController loaderController = AwesomeLoaderController();
  TextEditingController noteController = TextEditingController();

  String payment;
  String cardToken;

  ProgressService progressService;
  FlushBarService flushBarService;

  LocalStorageRepository localStorageRepo = LocalStorageRepository();
  CheckoutRepository checkoutRepo = CheckoutRepository();

  WalletChangeNotifier walletChangeNotifier;
  MyCartChangeNotifier myCartChangeNotifier;
  MarkaaAppChangeNotifier markaaAppChangeNotifier;
  OrderChangeNotifier orderChangeNotifier;
  AddressChangeNotifier addressChangeNotifier;

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
    walletChangeNotifier = context.read<WalletChangeNotifier>();
    addressChangeNotifier = context.read<AddressChangeNotifier>();

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
    return Material(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: Preload.language == 'en'
                  ? Alignment.topRight
                  : Alignment.topLeft,
              child: IconButton(
                icon: Icon(Icons.close, color: greyDarkColor, size: 25.sp),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            Center(
              child: Text(
                'add_amount'.tr(),
                textAlign: TextAlign.center,
                style: mediumTextStyle.copyWith(
                  color: primaryColor,
                  fontSize: 26.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            Center(
              child: Text(
                'choose_payment_method'.tr(),
                textAlign: TextAlign.center,
                style: mediumTextStyle.copyWith(
                  color: greyDarkColor,
                  fontSize: 16.sp,
                ),
              ),
            ),
            Consumer<MarkaaAppChangeNotifier>(builder: (_, __, ___) {
              return Column(
                children: List.generate(paymentMethods.length, (index) {
                  int idx = paymentMethods.length - index - 1;
                  if (paymentMethods[idx].id == 'tap' ||
                      paymentMethods[idx].id == 'knet') {
                    return _buildPaymentCard(paymentMethods[idx]);
                  }
                  return Container();
                }),
              );
            }),
            SizedBox(height: 10.h),
            Divider(
              color: greyLightColor,
              height: 10.h,
              thickness: 1.h,
            ),
            Consumer<MarkaaAppChangeNotifier>(
              builder: (_, __, ___) {
                if (payment == 'tap') return Container();
                return _buildPlacePaymentButton();
              },
            ),
          ],
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
                if (method.id == 'knet') ...[
                  SvgPicture.asset(
                    'lib/public/icons/knet.svg',
                    height: 46.h,
                    width: 61.w,
                  ),
                ] else if (method.id == 'tap') ...[
                  Image.asset(
                    'lib/public/images/visa-card.png',
                    height: 35.h,
                    width: 95.w,
                  ),
                  SizedBox(
                    width: 10.w,
                  ),
                  SvgPicture.asset(
                    'lib/public/icons/line.svg',
                    height: 41.h,
                    width: 10.w,
                  ),
                  SizedBox(
                    width: 15.w,
                  ),
                  SvgPicture.asset(
                    'lib/public/icons/master-card.svg',
                    height: 42.h,
                    width: 54.w,
                  ),
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
    Map<String, dynamic> data = {};
    data['token'] = user.token;
    data['lang'] = Preload.language;
    data['shipping'] = shippingMethods[0].id;
    data['paymentMethod'] = payment;
    data['cartId'] = walletChangeNotifier.walletCartId;
    data['orderDetails'] = {};
    data['orderDetails']['totalPrice'] = walletChangeNotifier.amount;
    data['orderAddress'] =
        jsonEncode(addressChangeNotifier.defaultAddress.toJson());
    if (payment == 'tap') {
      /// if the method is tap, check credit card already authorized
      if (cardToken == null) {
        flushBarService.showErrorMessage('fill_card_details_error'.tr());
        return;
      }
      data['tap_token'] = cardToken;
    }

    AdjustEvent adjustEvent = new AdjustEvent(AdjustSDKConfig.placePayment);
    Adjust.trackEvent(adjustEvent);

    /// submit the order, after call this api, the status will be pending till payment be processed
    await orderChangeNotifier.submitOrder(data, lang,
        onProcess: _onProcess,
        onSuccess: _onOrderSubmittedSuccess,
        onFailure: _onFailure,
        isWallet: true);
  }

  void _onOrderSubmittedSuccess(String payUrl, OrderEntity order) async {
    progressService.hideProgress();

    if (isURL(payUrl)) {
      /// payment method is knet or tap, go to payment webview page
      Navigator.pushNamed(
        context,
        Routes.myWalletPayment,
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
      (route) => route.settings.name == Routes.myWallet,
    );
  }
}
