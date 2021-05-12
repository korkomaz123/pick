import 'package:adjust_sdk/adjust.dart';
import 'package:adjust_sdk/adjust_event.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:markaa/src/change_notifier/my_cart_change_notifier.dart';
import 'package:markaa/src/change_notifier/order_change_notifier.dart';
import 'package:markaa/src/config/config.dart';
import 'package:markaa/src/data/mock/mock.dart';
import 'package:markaa/src/routes/routes.dart';
import 'package:markaa/src/theme/styles.dart';
import 'package:markaa/src/theme/theme.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:markaa/src/utils/repositories/local_storage_repository.dart';
import 'package:markaa/src/utils/services/flushbar_service.dart';
import 'package:markaa/src/utils/services/progress_service.dart';
import 'package:webview_flutter/webview_flutter.dart';

class CheckoutPaymentCardPage extends StatefulWidget {
  final Map<String, dynamic> params;

  CheckoutPaymentCardPage({this.params});

  @override
  _CheckoutPaymentCardPageState createState() =>
      _CheckoutPaymentCardPageState();
}

class _CheckoutPaymentCardPageState extends State<CheckoutPaymentCardPage>
    with WidgetsBindingObserver {
  WebViewController webViewController;
  Map<String, dynamic> data = {};
  OrderChangeNotifier orderChangeNotifier;
  ProgressService progressService;
  FlushBarService flushBarService;
  MyCartChangeNotifier myCartChangeNotifier;
  final LocalStorageRepository localStorageRepo = LocalStorageRepository();
  var orderDetails;
  var reorder;
  var url;
  var chargeId;

  @override
  void initState() {
    super.initState();
    progressService = ProgressService(context: context);
    flushBarService = FlushBarService(context: context);
    orderChangeNotifier = context.read<OrderChangeNotifier>();
    myCartChangeNotifier = context.read<MyCartChangeNotifier>();
    _initialData();
  }

  void _initialData() {
    orderDetails = widget.params['orderDetails'];
    reorder = widget.params['reorder'];
    url = widget.params['url'];
    chargeId = widget.params['chargeId'];
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        backgroundColor: backgroundColor,
        appBar: AppBar(
          backgroundColor: backgroundColor,
          leading: Container(
            width: 40.h,
            height: 40.h,
            margin: EdgeInsets.all(10.h),
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                  'lib/public/launcher/ios-app-launcher-icon.png',
                ),
              ),
              shape: BoxShape.circle,
            ),
          ),
          title: Text(
            'Markaa',
            style: mediumTextStyle.copyWith(
              fontSize: 16.sp,
              color: greyColor,
            ),
          ),
          actions: [
            Padding(
              padding: EdgeInsets.only(right: 8.w),
              child: Center(
                child: InkWell(
                  onTap: () => Navigator.pop(context, 'cancel'),
                  child: Text(
                    'cancel_button_title'.tr(),
                    style: mediumTextStyle.copyWith(
                      fontSize: 12.sp,
                      color: greyColor,
                    ),
                  ),
                ),
              ),
            ),
          ],
          elevation: 0,
        ),
        body: WebView(
          initialUrl: url,
          javascriptMode: JavascriptMode.unrestricted,
          onWebViewCreated: (controller) {
            webViewController = controller;
          },
          onPageStarted: _onPageLoaded,
        ),
      ),
    );
  }

  void _onPageLoaded(String url) async {
    final uri = Uri.dataFromString(url);
    final params = uri.queryParameters;
    if (params.containsKey('tap_id')) {
      await myCartChangeNotifier.checkChargeStatus(
          chargeId, _onProcess, _onPaymentSuccess, _onPaymentFailure);
    }
  }

  void _onProcess() {
    progressService.showProgress(1);
  }

  void _onPaymentSuccess() async {
    await orderChangeNotifier.submitOrder(orderDetails, lang, _onProcess,
        _onOrderSubmittedSuccess, _onOrderSubmittedFailure);
  }

  void _onPaymentFailure(String error) {
    progressService.hideProgress();
    Navigator.pushReplacementNamed(context, Routes.paymentFailed);
  }

  void _onOrderSubmittedSuccess(String orderNo) async {
    if (reorder != null) {
      myCartChangeNotifier.initializeReorderCart();
    } else {
      myCartChangeNotifier.initialize();
      if (user?.token == null) {
        await localStorageRepo.removeItem('cartId');
      }
      await myCartChangeNotifier.getCartId();
    }
    AdjustEvent adjustEvent =
        new AdjustEvent(AdjustSDKConfig.completePurchaseToken);
    adjustEvent.setRevenue(double.parse(orderDetails['totalPrice']), 'KWD');
    Adjust.trackEvent(adjustEvent);
    progressService.hideProgress();
    Navigator.pushNamedAndRemoveUntil(
      context,
      Routes.checkoutConfirmed,
      (route) => route.settings.name == Routes.home,
      arguments: orderNo,
    );
  }

  void _onOrderSubmittedFailure(String error) async {
    final refundData = {
      "charge_id": chargeId,
      "amount": double.parse(orderDetails['orderDetails']['totalPrice']),
      "currency": "KWD",
      "description":
          "We need to refund this amount to our customer because this order can not be processed",
      "reason": "requested_by_customer",
      "reference": {"merchant": "6008426"},
      "metadata": {"udf1": "r live1", "udf2": "r live2"},
      "post": {"url": "https://www.google.com"}
    };
    await myCartChangeNotifier.refundPayment(
        refundData, _onRefundedSuccess, _onRefundedFailure);
  }

  void _onRefundedSuccess() {
    progressService.hideProgress();
    Navigator.pushReplacementNamed(context, Routes.paymentFailed);
  }

  void _onRefundedFailure(String error) {
    progressService.hideProgress();
    Navigator.pop(context, error);
  }
}
