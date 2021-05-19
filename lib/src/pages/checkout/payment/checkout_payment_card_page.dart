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

  OrderChangeNotifier orderChangeNotifier;
  MyCartChangeNotifier myCartChangeNotifier;

  ProgressService progressService;
  FlushBarService flushBarService;

  LocalStorageRepository localStorageRepo = LocalStorageRepository();

  String url;
  OrderEntity order;
  OrderEntity reorder;

  @override
  void initState() {
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
            onPressed: () => Navigator.pop(context),
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
          },
          onPageStarted: _onPageLoaded,
        ),
      ),
    );
  }

  void _onPageLoaded(String url) async {
    print('redirect URL>>> $url');
    // if (url == PaymentStatusUrls.failure) {
    //   if (user?.token != null) {
    //     order.status = OrderStatusEnum.canceled;
    //     orderChangeNotifier.updateOrder(order);
    //   }
    //   Navigator.pushNamed(context, Routes.paymentFailed);
    // } else if (url == PaymentStatusUrls.success) {
    //   await _onSuccessPayment();
    //   if (user?.token != null) {
    //     order.status = OrderStatusEnum.processing;
    //     orderChangeNotifier.updateOrder(order);
    //   }
    //   Navigator.pushNamed(
    //     context,
    //     Routes.checkoutConfirmed,
    //     arguments: order.orderNo,
    //   );
    // }
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

    AdjustEvent adjustEvent =
        AdjustEvent(AdjustSDKConfig.completePurchaseToken);
    adjustEvent.setRevenue(price, 'KWD');
    Adjust.trackEvent(adjustEvent);
  }
}
