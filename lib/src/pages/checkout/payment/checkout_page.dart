import 'dart:core';
import 'dart:convert';

import 'package:adjust_sdk/adjust.dart';
import 'package:adjust_sdk/adjust_event.dart';
import 'package:flutter/cupertino.dart';
import 'package:markaa/src/change_notifier/address_change_notifier.dart';
import 'package:markaa/src/change_notifier/auth_change_notifier.dart';
import 'package:markaa/src/change_notifier/markaa_app_change_notifier.dart';
import 'package:markaa/src/change_notifier/order_change_notifier.dart';
import 'package:markaa/src/components/markaa_checkout_app_bar.dart';
import 'package:markaa/src/components/markaa_page_loading_kit.dart';
import 'package:markaa/src/components/markaa_text_button.dart';
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
import 'package:markaa/src/utils/services/progress_service.dart';
import 'package:provider/provider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sliding_sheet/sliding_sheet.dart';
import 'package:string_validator/string_validator.dart';

import 'widgets/payment_address.dart';
import 'widgets/payment_method_list.dart';
import 'widgets/payment_summary.dart';

class CheckoutPage extends StatefulWidget {
  final OrderEntity? reorder;

  CheckoutPage({required this.reorder});

  @override
  _CheckoutPageState createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  AwesomeLoaderController loaderController = AwesomeLoaderController();
  TextEditingController noteController = TextEditingController();
  SheetController sheetController = SheetController();

  String payment = 'knet';
  String? cardToken;
  var details;

  late ProgressService progressService;
  late FlushBarService flushBarService;

  late AuthChangeNotifier authChangeNotifier;
  late MyCartChangeNotifier myCartChangeNotifier;
  late MarkaaAppChangeNotifier markaaAppChangeNotifier;
  late OrderChangeNotifier orderChangeNotifier;
  late AddressChangeNotifier addressChangeNotifier;

  LocalStorageRepository localStorageRepo = LocalStorageRepository();
  CheckoutRepository checkoutRepo = CheckoutRepository();

  bool get emptyAddress =>
      user != null && addressChangeNotifier.defaultAddress == null ||
      user == null && addressChangeNotifier.guestAddress == null;

  void _loadAssetData() async {
    try {
      if (paymentMethods.isEmpty) {
        paymentMethods = await checkoutRepo.getPaymentMethod();
      }
      if (widget.reorder != null) {
        payment = widget.reorder!.paymentMethod.id;
        if (payment == 'wallet' && outOfBalance) payment = 'knet';
      }
      setState(() {});
    } catch (e) {
      print('CHECKOUT PAGE LOAD ASSET DATA ERROR: $e');
    }
  }

  @override
  void initState() {
    super.initState();

    progressService = ProgressService(context: context);
    flushBarService = FlushBarService(context: context);

    authChangeNotifier = context.read<AuthChangeNotifier>();
    orderChangeNotifier = context.read<OrderChangeNotifier>();
    markaaAppChangeNotifier = context.read<MarkaaAppChangeNotifier>();
    myCartChangeNotifier = context.read<MyCartChangeNotifier>();
    addressChangeNotifier = context.read<AddressChangeNotifier>();

    details = orderDetails['orderDetails'];
    orderDetails['deliver_as_gift'] = {
      'deliver_as_gift': '0',
      'sender': '',
      'receiver': '',
      'message': '',
    };

    _loadAssetData();
  }

  void _onProcess() {
    progressService.showProgress();
  }

  void _onFailure(String error) {
    progressService.hideProgress();
    flushBarService.showErrorDialog(error);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      appBar: MarkaaCheckoutAppBar(),
      body: Consumer<MarkaaAppChangeNotifier>(
        builder: (_, __, ___) {
          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 10.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                PaymentAddress(),
                if (paymentMethods.isEmpty) ...[
                  Center(child: PulseLoadingSpinner()),
                ] else ...[
                  PaymentMethodList(
                    value: payment,
                    onChangeMethod: _onChangeMethod,
                  ),
                ],
                PaymentSummary(details: details),
                SizedBox(height: 20.h),
                _buildNote(),
                SizedBox(height: 100.h),
              ],
            ),
          );
        },
      ),
      bottomSheet: _buildPlacePaymentButton(),
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
    return Container(
      width: designWidth.w,
      height: 50.h,
      margin: EdgeInsets.only(bottom: 20.h),
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: MarkaaTextButton(
        title: 'checkout_place_payment_button_title'.tr(),
        titleColor: Colors.white,
        titleSize: 18.sp,
        buttonColor: primaryColor,
        borderColor: primaryColor,
        onPressed: () => _onPlaceOrder(),
        radius: 6.sp,
      ),
    );
  }

  bool get outOfBalance => double.parse(details['totalPrice']) > user!.balance;
  void _onChangeMethod(String? val) async {
    if (val != null) {
      if (val == 'wallet' && outOfBalance) {
        final result = await flushBarService.showConfirmDialog(
          title: 'sorry',
          message: 'not_enough_balance',
          yesButtonText: 'add_button_title',
          noButtonText: 'cancel_button_title',
        );
        if (result != null) {
          var amount = double.parse(details['totalPrice']) - user!.balance;
          double value = amount.ceilToDouble() + 1;
          await Navigator.pushNamed(context, Routes.myWallet, arguments: value);
          if (!outOfBalance) {
            payment = val;
          }
        }
      } else {
        payment = val;
        markaaAppChangeNotifier.rebuild();
      }
    }
  }

  _onPlaceOrder() async {
    orderDetails['paymentMethod'] = payment;
    if (payment == 'tap') {
      /// if the method is tap, check credit card already authorized
      cardToken =
          (await Navigator.pushNamed(context, Routes.creditCard) as String?);
      if (cardToken == null) return;
      orderDetails['tap_token'] = cardToken;
    }
    if (emptyAddress) {
      flushBarService.showErrorDialog('checkout_address_error'.tr());
      return;
    }

    var address;
    if (user != null) {
      address = addressChangeNotifier.defaultAddress!.toJson();
    } else {
      address = addressChangeNotifier.guestAddress!.toJson();
    }
    address['postcode'] = address['post_code'];
    address['save_in_address_book'] = '0';
    address['region'] = address['region_id'];
    orderDetails['orderAddress'] = jsonEncode(address);

    /// submit the order, after call this api, the status will be pending till payment be processed
    await orderChangeNotifier.submitOrder(orderDetails, lang,
        onProcess: _onProcess,
        onSuccess: _onOrderSubmittedSuccess,
        onFailure: _onFailure);
  }

  _onOrderSubmittedSuccess(String payUrl, OrderEntity order) async {
    AdjustEvent adjustEvent = new AdjustEvent(AdjustSDKConfig.placePayment);
    Adjust.trackEvent(adjustEvent);
    progressService.hideProgress();

    if (payment == 'cashondelivery' || payment == 'wallet') {
      _onSuccessOrder(order);
      if (payment == 'wallet') {
        user!.balance -= double.parse(order.totalPrice);
        authChangeNotifier.updateUserEntity(user);
      }
      Navigator.pushNamedAndRemoveUntil(
        context,
        Routes.checkoutConfirmed,
        (route) => route.settings.name == Routes.home,
        arguments: order,
      );
    } else if (isURL(payUrl)) {
      Navigator.pushNamed(
        context,
        Routes.checkoutPayment,
        arguments: {'url': payUrl, 'order': order, 'reorder': widget.reorder},
      );
    } else {
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
      if (user == null) {
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
