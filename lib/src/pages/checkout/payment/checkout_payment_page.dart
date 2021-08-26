import 'dart:convert';

import 'package:adjust_sdk/adjust.dart';
import 'package:adjust_sdk/adjust_event.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:markaa/src/change_notifier/my_cart_change_notifier.dart';
import 'package:markaa/src/change_notifier/order_change_notifier.dart';
import 'package:markaa/src/config/config.dart';
import 'package:markaa/src/data/mock/mock.dart';
import 'package:markaa/src/data/models/index.dart';
import 'package:markaa/src/routes/routes.dart';
import 'package:markaa/src/theme/styles.dart';
import 'package:markaa/src/theme/theme.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:markaa/src/utils/repositories/local_storage_repository.dart';
import 'package:markaa/src/utils/services/flushbar_service.dart';
import 'package:markaa/src/utils/services/progress_service.dart';
import 'package:webview_flutter/webview_flutter.dart';

class CheckoutPaymentPage extends StatefulWidget {
  final Map<String, dynamic> params;

  CheckoutPaymentPage({this.params});

  @override
  _CheckoutPaymentPageState createState() => _CheckoutPaymentPageState();
}

class _CheckoutPaymentPageState extends State<CheckoutPaymentPage>
    with WidgetsBindingObserver {
  WebViewController webViewController;

  OrderChangeNotifier orderChangeNotifier;
  MyCartChangeNotifier myCartChangeNotifier;

  ProgressService progressService;
  FlushBarService flushBarService;

  LocalStorageRepository localStorageRepo = LocalStorageRepository();

  String url;
  OrderEntity order;
  OrderEntity reorder;

  bool isLoading = true;

  @override
  void initState() {
    // SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.top]);

    super.initState();
    progressService = ProgressService(context: context);
    flushBarService = FlushBarService(context: context);

    orderChangeNotifier = context.read<OrderChangeNotifier>();
    myCartChangeNotifier = context.read<MyCartChangeNotifier>();

    url = widget.params['url'];
    order = widget.params['order'];
    reorder = widget.params['reorder'];
  }

  @override
  void dispose() {
    // SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);

    super.dispose();
  }

  void _onBack() async {
    final result = await flushBarService.showConfirmDialog(
        message: 'payment_abort_dialog_text');
    if (result != null) {
      /// activate the current shopping cart
      await myCartChangeNotifier.activateCart();

      /// cancel the order
      await orderChangeNotifier.cancelFullOrder(order,
          onProcess: _onCancelProcess,
          onSuccess: _onCanceledSuccess,
          onFailure: _onCanceledFailure);
    }
  }

  void _onCancelProcess() {
    progressService.showProgress();
  }

  void _onCanceledSuccess() {
    progressService.hideProgress();
    Navigator.popUntil(
      context,
      (route) => route.settings.name == Routes.myCart,
    );
  }

  void _onCanceledFailure(String message) {
    progressService.hideProgress();
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
          backgroundColor: Colors.white,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              size: 25.sp,
              color: greyColor,
            ),
            onPressed: _onBack,
          ),
          title: Text(
            'payment_title'.tr(),
            style: mediumTextStyle.copyWith(
              color: greyDarkColor,
              fontSize: 23.sp,
            ),
          ),
        ),
        body: WebView(
          initialUrl: url,
          javascriptMode: JavascriptMode.unrestricted,
          onWebViewCreated: (controller) {
            webViewController = controller;
            progressService.showProgress();
          },
          navigationDelegate: (action) {
            _onPageLoaded(action.url);
            return NavigationDecision.navigate;
          },
          onPageFinished: (_) {
            if (isLoading) {
              progressService.hideProgress();
              isLoading = false;
              setState(() {});
            }
          },
        ),
      ),
    );
  }

  void _onPageLoaded(String loadingUrl) async {
    try {
      Uri uri = Uri.parse(loadingUrl);
      Map<String, dynamic> params = uri.queryParameters;

      print('LOADING URL>>> $loadingUrl');
      print('PARAMS>>> $params');

      if (params.containsKey('result')) {
        if (params['result'] == 'failed') {
          if (user?.token != null) {
            orderChangeNotifier.removeOrder(order);
          }

          if (reorder != null) {
            Navigator.pushNamedAndRemoveUntil(
              context,
              Routes.paymentFailed,
              (route) => route.settings.name == Routes.home,
              arguments: true,
            );
          } else {
            Navigator.pushNamedAndRemoveUntil(
              context,
              Routes.paymentFailed,
              (route) => route.settings.name == Routes.myCart,
              arguments: false,
            );
          }
        } else if (params['result'] == 'success') {
          _onSuccessPayment();
          if (user?.token != null) {
            order.status = OrderStatusEnum.processing;
            orderChangeNotifier.updateOrder(order);
          }
          Navigator.pushNamedAndRemoveUntil(
            context,
            Routes.checkoutConfirmed,
            (route) => route.settings.name == Routes.home,
            arguments: order.orderNo,
          );
        }
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> _onSuccessPayment() async {
    if (reorder != null) {
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

    AdjustEvent adjustEvent = AdjustEvent(AdjustSDKConfig.successPayment);
    Adjust.trackEvent(adjustEvent);

    adjustEvent = AdjustEvent(AdjustSDKConfig.completePurchase);
    adjustEvent.setRevenue(price, 'KWD');
    Adjust.trackEvent(adjustEvent);
  }
}
