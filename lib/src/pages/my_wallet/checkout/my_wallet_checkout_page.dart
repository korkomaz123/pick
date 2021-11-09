import 'dart:convert';

import 'package:adjust_sdk/adjust.dart';
import 'package:adjust_sdk/adjust_event.dart';
import 'package:markaa/preload.dart';
import 'package:markaa/src/change_notifier/markaa_app_change_notifier.dart';
import 'package:markaa/src/change_notifier/wallet_change_notifier.dart';
import 'package:markaa/src/config/config.dart';
import 'package:markaa/src/data/mock/mock.dart';
import 'package:markaa/src/pages/checkout/payment/awesome_loader.dart';
import 'package:markaa/src/pages/checkout/payment/widgets/payment_method_card.dart';
import 'package:markaa/src/routes/routes.dart';
import 'package:markaa/src/theme/styles.dart';
import 'package:markaa/src/theme/theme.dart';
import 'package:markaa/src/utils/repositories/checkout_repository.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:markaa/src/utils/services/flushbar_service.dart';
import 'package:markaa/src/utils/services/progress_service.dart';
import 'package:provider/provider.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:string_validator/string_validator.dart';

class MyWalletCheckoutPage extends StatefulWidget {
  final bool fromCheckout;

  MyWalletCheckoutPage({required this.fromCheckout});

  @override
  _MyWalletCheckoutPageState createState() => _MyWalletCheckoutPageState();
}

class _MyWalletCheckoutPageState extends State<MyWalletCheckoutPage> {
  AwesomeLoaderController loaderController = AwesomeLoaderController();
  TextEditingController noteController = TextEditingController();

  String payment = 'knet';
  String? cardToken;

  late ProgressService progressService;
  late FlushBarService flushBarService;

  late WalletChangeNotifier walletChangeNotifier;

  CheckoutRepository checkoutRepository = CheckoutRepository();

  _loadData() async {
    if (paymentMethods.isEmpty) {
      paymentMethods = await checkoutRepository.getPaymentMethod();
    }
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    progressService = ProgressService(context: context);
    flushBarService = FlushBarService(context: context);

    walletChangeNotifier = context.read<WalletChangeNotifier>();
    _loadData();
  }

  void _onProcess() {
    progressService.showProgress();
  }

  void _onFailure(String error) {
    progressService.hideProgress();
    flushBarService.showErrorDialog(error);
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
            SizedBox(height: 20.h),
            Consumer<MarkaaAppChangeNotifier>(
              builder: (_, __, ___) {
                return Column(
                  children: List.generate(paymentMethods.length, (index) {
                    int idx = paymentMethods.length - index - 1;
                    if (paymentMethods[idx].id == 'tap' ||
                        paymentMethods[idx].id == 'knet') {
                      return PaymentMethodCard(
                        method: paymentMethods[idx],
                        onChangeMethod: (value) {
                          payment = value!;
                          setState(() {});
                        },
                        value: payment,
                      );
                    }
                    return Container();
                  }),
                );
              },
            ),
            SizedBox(height: 30.h),
            _buildPlacePaymentButton(),
          ],
        ),
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
        onPressed: _onChargeWallet,
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

  void _onChargeWallet() async {
    Map<String, dynamic> data = {};
    data['token'] = user?.token;
    data['lang'] = Preload.language;
    data['shipping'] = '';
    data['paymentMethod'] = payment;
    data['cartId'] = walletChangeNotifier.walletCartId;
    data['orderDetails'] = {};
    data['orderDetails']['totalPrice'] = walletChangeNotifier.amount;
    data['price'] = walletChangeNotifier.amount;
    data['orderAddress'] = jsonEncode(emptyAddress);
    if (payment == 'tap') {
      // if the method is tap, check credit card already authorized
      cardToken =
          (await Navigator.pushNamed(context, Routes.creditCard)) as String?;
      if (cardToken == null) return;
      data['tap_token'] = cardToken;
    }
    // submit the order, after call this api, the status will be pending till payment be processed
    await walletChangeNotifier.getPaymentUrl(data, lang,
        onProcess: _onProcess, onSuccess: _onSuccess, onFailure: _onFailure);
  }

  void _onSuccess(String payUrl, dynamic walletResult) async {
    AdjustEvent adjustEvent = new AdjustEvent(AdjustSDKConfig.placePayment);
    Adjust.trackEvent(adjustEvent);
    progressService.hideProgress();

    if (isURL(payUrl)) {
      /// payment method is knet or tap, go to payment webview page
      Navigator.pushNamed(
        context,
        Routes.myWalletPayment,
        arguments: {
          'url': payUrl,
          'walletResult': walletResult,
          'fromCheckout': widget.fromCheckout,
        },
      );
    } else {
      /// if the payurl is invalid redirect to payment failed page
      await walletChangeNotifier.cancelWalletPayment(walletResult,
          onSuccess: _gotoFailedPage, onFailure: _gotoFailedPage);
    }
  }

  void _gotoFailedPage() {
    String destination = widget.fromCheckout ? Routes.checkout : Routes.account;
    Navigator.pushNamedAndRemoveUntil(
      context,
      Routes.myWalletFailed,
      (route) => route.settings.name == destination,
    );
  }
}
