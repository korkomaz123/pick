// import 'dart:convert';

// import 'package:adjust_sdk/adjust.dart';
// import 'package:adjust_sdk/adjust_event.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:markaa/src/change_notifier/order_change_notifier.dart';
// import 'package:markaa/src/config/config.dart';
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

class MyWalletPaymentPage extends StatefulWidget {
  final Map<String, dynamic> params;

  MyWalletPaymentPage({this.params});

  @override
  _MyWalletPaymentPageState createState() => _MyWalletPaymentPageState();
}

class _MyWalletPaymentPageState extends State<MyWalletPaymentPage>
    with WidgetsBindingObserver {
  WebViewController webViewController;

  OrderChangeNotifier orderChangeNotifier;

  ProgressService progressService;
  FlushBarService flushBarService;

  LocalStorageRepository localStorageRepo = LocalStorageRepository();

  String url;
  OrderEntity order;
  OrderEntity reorder;

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    progressService = ProgressService(context: context);
    flushBarService = FlushBarService(context: context);

    orderChangeNotifier = context.read<OrderChangeNotifier>();

    url = widget.params['url'];
    order = widget.params['order'];
    reorder = widget.params['reorder'];
  }

  void _onBack() async {
    final result = await flushBarService.showConfirmDialog(
        message: 'payment_abort_dialog_text');
    if (result != null) {
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
      (route) => route.settings.name == Routes.myWallet,
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

          Navigator.pushNamed(
            context,
            Routes.myWalletFailed,
            arguments: false,
          );
        } else if (params['result'] == 'success') {
          _onSuccessPayment();
          if (user?.token != null) {
            order.status = OrderStatusEnum.processing;
            orderChangeNotifier.updateOrder(order);
          }
          Navigator.pushNamed(
            context,
            Routes.myWalletSuccess,
            arguments: order.orderNo,
          );
        }
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> _onSuccessPayment() async {
    // final priceDetails = jsonDecode(orderDetails['orderDetails']);
    // double price = double.parse(priceDetails['totalPrice']);

    // AdjustEvent adjustEvent = AdjustEvent(AdjustSDKConfig.successPayment);
    // Adjust.trackEvent(adjustEvent);

    // adjustEvent = AdjustEvent(AdjustSDKConfig.completePurchase);
    // adjustEvent.setRevenue(price, 'KWD');
    // Adjust.trackEvent(adjustEvent);
  }
}
