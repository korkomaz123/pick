import 'package:adjust_sdk/adjust.dart';
import 'package:adjust_sdk/adjust_event.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:markaa/src/change_notifier/my_cart_change_notifier.dart';
import 'package:markaa/src/change_notifier/order_change_notifier.dart';
import 'package:markaa/src/components/markaa_page_loading_kit.dart';
import 'package:markaa/src/config/config.dart';
import 'package:markaa/src/data/mock/mock.dart';
import 'package:markaa/src/data/models/index.dart';
import 'package:markaa/src/routes/routes.dart';
import 'package:markaa/src/theme/styles.dart';
import 'package:markaa/src/theme/theme.dart';

import 'package:markaa/src/utils/repositories/local_storage_repository.dart';
import 'package:markaa/src/utils/services/flushbar_service.dart';
import 'package:markaa/src/utils/services/progress_service.dart';
import 'package:webview_flutter/webview_flutter.dart';

class CheckoutPaymentPage extends StatefulWidget {
  final Map<String, dynamic> params;

  CheckoutPaymentPage({required this.params});

  @override
  _CheckoutPaymentPageState createState() => _CheckoutPaymentPageState();
}

class _CheckoutPaymentPageState extends State<CheckoutPaymentPage> with WidgetsBindingObserver {
  WebViewController? webViewController;

  late OrderChangeNotifier orderChangeNotifier;
  late MyCartChangeNotifier myCartChangeNotifier;
  late ProgressService progressService;
  late FlushBarService flushBarService;
  LocalStorageRepository localStorageRepo = LocalStorageRepository();
  String? url;
  OrderEntity? order;
  OrderEntity? reorder;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addObserver(this);
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
    WidgetsBinding.instance!.removeObserver(this);
    super.dispose();
  }

  void _onBack() async {
    final result = await flushBarService.showConfirmDialog(message: 'payment_abort_dialog_text');
    if (result != null) {
      await myCartChangeNotifier.activateCart();
      await orderChangeNotifier.cancelFullOrder(
        order!,
        onProcess: _onCancelProcess,
        onSuccess: _onCanceledSuccess,
        onFailure: _onCanceledFailure,
      );
    }
  }

  void _onCancelProcess() {
    progressService.showProgress();
  }

  void _onCanceledSuccess() {
    progressService.hideProgress();
    Navigator.pop(context);
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
            icon: Icon(Icons.arrow_back_ios, size: 25.sp, color: greyColor),
            onPressed: _onBack,
          ),
          title: Text(
            'payment_title'.tr(),
            style: mediumTextStyle.copyWith(color: greyDarkColor, fontSize: 23.sp),
          ),
        ),
        body: Stack(
          children: [
            WebView(
              initialUrl: url,
              javascriptMode: JavascriptMode.unrestricted,
              onWebViewCreated: (controller) {
                webViewController = controller;
              },
              navigationDelegate: (action) {
                _onPageLoaded(action.url);
                return NavigationDecision.navigate;
              },
              onPageFinished: (_) {
                if (isLoading) {
                  isLoading = false;
                  setState(() {});
                }
              },
            ),
            if (isLoading) ...[Center(child: PulseLoadingSpinner())],
          ],
        ),
      ),
    );
  }

  void _onPageLoaded(String loadingUrl) async {
    try {
      Uri uri = Uri.parse(loadingUrl);
      Map<String, dynamic> params = uri.queryParameters;
      if (params.containsKey('flag')) {
        if (params['flag'] == 'failed') {
          if (user != null) orderChangeNotifier.removeOrder(order!);
          orderChangeNotifier.submitPaymentFailedOrderResult(order!, params);
          if (reorder != null) {
            Navigator.popAndPushNamed(context, Routes.paymentFailed, arguments: true);
          } else {
            Navigator.popAndPushNamed(context, Routes.paymentFailed, arguments: false);
          }
        } else if (params['flag'] == 'success') {
          _onSuccessPayment();
          if (user != null) {
            order!.status = OrderStatusEnum.processing;
            orderChangeNotifier.updateOrder(order!);
          }
          orderChangeNotifier.submitPaymentSuccessOrderResult(order!, params);
          Navigator.pushNamedAndRemoveUntil(
            context,
            Routes.checkoutConfirmed,
            (route) => route.settings.name == Routes.home,
            arguments: order,
          );
        } else if (params['flag'] == 'canceled') {
          await myCartChangeNotifier.activateCart();
          await orderChangeNotifier.cancelFullOrder(
            order!,
            onProcess: _onCancelProcess,
            onSuccess: _onCanceledSuccess,
            onFailure: _onCanceledFailure,
            params: params,
          );
        }
      }
    } catch (e) {
      print('REDIRECTING ON ORDER PAYMENT PAGE CATCH ERROR: $e');
    }
  }

  Future<void> _onSuccessPayment() async {
    if (reorder != null) {
      myCartChangeNotifier.initializeReorderCart();
    } else {
      myCartChangeNotifier.initialize();
      if (user == null) await localStorageRepo.removeItem('cartId');
      await myCartChangeNotifier.getCartId();
    }
    final priceDetails = orderDetails['orderDetails'];
    double price = double.parse(priceDetails['totalPrice']);

    AdjustEvent adjustEvent = AdjustEvent(AdjustSDKConfig.successPayment);
    Adjust.trackEvent(adjustEvent);

    adjustEvent = AdjustEvent(AdjustSDKConfig.completePurchase);
    adjustEvent.setRevenue(price, 'KWD');
    Adjust.trackEvent(adjustEvent);
  }
}
