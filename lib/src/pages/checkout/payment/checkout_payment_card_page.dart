import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:markaa/src/change_notifier/my_cart_change_notifier.dart';
import 'package:markaa/src/change_notifier/order_change_notifier.dart';
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

  @override
  void initState() {
    super.initState();
    progressService = ProgressService(context: context);
    flushBarService = FlushBarService(context: context);

    orderChangeNotifier = context.read<OrderChangeNotifier>();
    myCartChangeNotifier = context.read<MyCartChangeNotifier>();

    url = widget.params['url'];
    order = widget.params['order'];
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
    print(url);
    if (url == 'https://cigaon.com/checkout/cart/') {
      if (user?.token != null) {
        order.status = OrderStatusEnum.canceled;
        orderChangeNotifier.updateOrder(order);
      }
      Navigator.pushNamed(context, Routes.paymentFailed);
    } else if (url == 'https://cigaon.com/checkout/onepage/success/') {
      if (user?.token != null) {
        order.status = OrderStatusEnum.processing;
        orderChangeNotifier.updateOrder(order);
      }
      Navigator.pushNamed(
        context,
        Routes.checkoutConfirmed,
        arguments: order.orderNo,
      );
    }
    print(uri.data);
    print(params);
  }
}
