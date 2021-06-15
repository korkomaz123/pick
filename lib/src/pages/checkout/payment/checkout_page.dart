import 'dart:convert';

import 'package:adjust_sdk/adjust.dart';
import 'package:adjust_sdk/adjust_event.dart';
import 'package:markaa/preload.dart';
import 'package:markaa/src/change_notifier/address_change_notifier.dart';
import 'package:markaa/src/change_notifier/markaa_app_change_notifier.dart';
import 'package:markaa/src/change_notifier/order_change_notifier.dart';
import 'package:markaa/src/components/markaa_checkout_app_bar.dart';
import 'package:markaa/src/components/markaa_page_loading_kit.dart';
import 'package:markaa/src/components/markaa_text_input_multi.dart';
import 'package:markaa/src/config/config.dart';
import 'package:markaa/src/data/mock/mock.dart';
import 'package:markaa/src/data/models/order_entity.dart';
import 'package:markaa/src/pages/checkout/payment/awesome_loader.dart';
import 'package:markaa/src/routes/routes.dart';
import 'package:markaa/src/theme/theme.dart';
import 'package:markaa/src/change_notifier/my_cart_change_notifier.dart';
import 'package:markaa/src/utils/repositories/checkout_repository.dart';
import 'package:markaa/src/utils/repositories/local_storage_repository.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:markaa/src/utils/services/flushbar_service.dart';
import 'package:markaa/src/utils/services/numeric_service.dart';
import 'package:markaa/src/utils/services/progress_service.dart';
import 'package:provider/provider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:string_validator/string_validator.dart';

import 'widgets/payment_address.dart';
import 'widgets/payment_method_card.dart';
import 'widgets/payment_summary.dart';

class CheckoutPage extends StatefulWidget {
  final OrderEntity reorder;

  CheckoutPage({this.reorder});

  @override
  _CheckoutPageState createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  AwesomeLoaderController loaderController = AwesomeLoaderController();
  TextEditingController noteController = TextEditingController();

  String payment = 'knet';
  String cardToken;
  var details;

  ProgressService progressService;
  FlushBarService flushBarService;

  LocalStorageRepository localStorageRepo = LocalStorageRepository();
  CheckoutRepository checkoutRepo = CheckoutRepository();

  MyCartChangeNotifier myCartChangeNotifier;
  MarkaaAppChangeNotifier markaaAppChangeNotifier;
  OrderChangeNotifier orderChangeNotifier;
  AddressChangeNotifier addressChangeNotifier;

  bool get outOfBalance =>
      double.parse(details['subTotalPrice']) > user.balance;

  bool get requireAddress =>
      user?.token != null && addressChangeNotifier.defaultAddress == null ||
      user?.token == null && addressChangeNotifier.guestAddress == null;

  _loadData() async {
    user = await Preload.currentUser;

    print(paymentMethods.length);
    if (paymentMethods.isEmpty) {
      paymentMethods = await checkoutRepo.getPaymentMethod();
    }
    if (widget.reorder != null) {
      payment = widget.reorder.paymentMethod.id;
    }
    setState(() {});
  }

  @override
  void initState() {
    super.initState();

    print('init state');

    progressService = ProgressService(context: context);
    flushBarService = FlushBarService(context: context);

    orderChangeNotifier = context.read<OrderChangeNotifier>();
    markaaAppChangeNotifier = context.read<MarkaaAppChangeNotifier>();
    myCartChangeNotifier = context.read<MyCartChangeNotifier>();
    addressChangeNotifier = context.read<AddressChangeNotifier>();

    details = orderDetails['orderDetails'];

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
    return SafeArea(
      top: false,
      left: false,
      right: false,
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.white,
        appBar: MarkaaCheckoutAppBar(),
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 10.w),
          child: Consumer<MarkaaAppChangeNotifier>(
            builder: (_, __, ___) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (paymentMethods.isEmpty) ...[
                    Center(
                      child: PulseLoadingSpinner(),
                    ),
                  ] else ...[
                    Column(
                      children: List.generate(paymentMethods.length, (index) {
                        int idx = paymentMethods.length - index - 1;
                        if ((user?.token == null ||
                                user?.token != null && user.balance <= 0) &&
                            paymentMethods[idx].id == 'wallet') {
                          return Container();
                        }
                        return PaymentMethodCard(
                          method: paymentMethods[idx],
                          onChange: _onChangeMethod,
                          value: payment,
                          cardToken: cardToken,
                          onAuthorizedSuccess: _onCardAuthorizedSuccess,
                        );
                      }),
                    )
                  ],
                  SizedBox(height: 5.h),
                  PaymentAddress(),
                  PaymentSummary(details: details),
                  _buildNote(),
                  SizedBox(height: 100.h),
                ],
              );
            },
          ),
        ),
        bottomSheet: Consumer<MarkaaAppChangeNotifier>(
          builder: (_, __, ___) {
            if (payment == 'tap' || payment == 'wallet' && outOfBalance) {
              return Container(height: 0);
            }
            return _buildPlacePaymentButton();
          },
        ),
      ),
    );
  }

  Widget _buildNote() {
    return Padding(
      padding: EdgeInsets.only(top: 10.h),
      child: MarkaaTextInputMulti(
        controller: noteController,
        width: double.infinity,
        padding: 10.w,
        fontSize: 12.sp,
        hint: 'checkout_note_hint'.tr(),
        inputType: TextInputType.multiline,
        validator: null,
        maxLine: 5,
        borderColor: Colors.grey,
      ),
    );
  }

  Widget _buildPlacePaymentButton() {
    return SizedBox(
      height: 45,
      width: designWidth.w,
      // ignore: deprecated_member_use
      child: RaisedButton(
        color: primaryColor,
        onPressed: _onPlaceOrder,
        child: Text(
          'checkout_place_payment_button_title'.tr(),
          style: TextStyle(color: Colors.white, fontSize: 16.0),
        ),
      ),
    );
  }

  _onChangeMethod(String value) async {
    if (value == 'wallet' && outOfBalance) {
      final result = await flushBarService.showConfirmDialog(
        title: 'sorry',
        message: 'not_enough_balance',
        yesButtonText: 'add_button_title',
        noButtonText: 'cancel_button_title',
      );
      if (result != null) {
        double amount = double.parse(details['subTotalPrice']) - user.balance;
        double value = NumericService.roundDouble(amount, 3);
        await Navigator.pushNamed(context, Routes.myWallet, arguments: value);
        setState(() {});
      }
    } else {
      payment = value;
      markaaAppChangeNotifier.rebuild();
    }
  }

  _onCardAuthorizedSuccess(String token) {
    cardToken = token;
    setState(() {});
    Future.delayed(Duration(milliseconds: 300), _onPlaceOrder);
  }

  _onPlaceOrder() async {
    orderDetails['paymentMethod'] = payment;
    if (payment == 'tap') {
      /// if the method is tap, check credit card already authorized
      if (cardToken == null) {
        flushBarService.showErrorDialog('fill_card_details_error'.tr());
        return;
      }
      orderDetails['tap_token'] = cardToken;
    }
    if (requireAddress) {
      flushBarService.showErrorDialog('checkout_address_error'.tr());
      return;
    }

    var address;
    if (user?.token != null)
      address = addressChangeNotifier.defaultAddress.toJson();
    else
      address = addressChangeNotifier.guestAddress.toJson();
    address['postcode'] = address['post_code'];
    address['save_in_address_book'] = '0';
    address['region'] = address['region_id'];
    orderDetails['orderAddress'] = jsonEncode(address);

    AdjustEvent adjustEvent = new AdjustEvent(AdjustSDKConfig.placePayment);
    Adjust.trackEvent(adjustEvent);

    /// submit the order, after call this api, the status will be pending till payment be processed
    await orderChangeNotifier.submitOrder(orderDetails, lang,
        onProcess: _onProcess,
        onSuccess: _onOrderSubmittedSuccess,
        onFailure: _onFailure);
  }

  _onOrderSubmittedSuccess(String payUrl, OrderEntity order) async {
    progressService.hideProgress();

    if (payment == 'cashondelivery' || payment == 'wallet') {
      _onSuccessOrder(order);
      if (payment == 'wallet') {
        user.balance -= double.parse(order.totalPrice);
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
        Routes.checkoutPayment,
        arguments: {'url': payUrl, 'order': order, 'reorder': widget.reorder},
      );
    } else {
      /// if the payurl is invalid redirect to payment failed page
      await orderChangeNotifier.cancelFullOrder(order,
          onSuccess: _gotoFailedPage, onFailure: _gotoFailedPage);
    }
  }

  _gotoFailedPage() {
    Navigator.pushNamedAndRemoveUntil(
      context,
      Routes.paymentFailed,
      (route) => route.settings.name == Routes.myCart,
    );
  }

  Future _onSuccessOrder(OrderEntity order) async {
    if (widget.reorder != null) {
      myCartChangeNotifier.initializeReorderCart();
    } else {
      myCartChangeNotifier.initialize();
      if (user?.token == null) {
        await localStorageRepo.removeItem('cartId');
      }
      await myCartChangeNotifier.getCartId();
    }
    double price = double.parse(order.totalPrice);

    AdjustEvent adjustEvent = AdjustEvent(AdjustSDKConfig.completePurchase);
    adjustEvent.setRevenue(price, 'KWD');
    Adjust.trackEvent(adjustEvent);
  }
}
