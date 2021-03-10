import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:isco_custom_widgets/isco_custom_widgets.dart';
import 'package:markaa/src/change_notifier/my_cart_change_notifier.dart';
import 'package:markaa/src/change_notifier/order_change_notifier.dart';
import 'package:markaa/src/components/markaa_page_loading_kit.dart';
import 'package:markaa/src/config/config.dart';
import 'package:markaa/src/data/mock/mock.dart';
import 'package:markaa/src/data/models/order_entity.dart';
import 'package:markaa/src/pages/checkout/bloc/checkout_bloc.dart';
import 'package:markaa/src/routes/routes.dart';
import 'package:markaa/src/theme/styles.dart';
import 'package:markaa/src/theme/theme.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:markaa/src/utils/flushbar_service.dart';
import 'package:markaa/src/utils/local_storage_repository.dart';
import 'package:markaa/src/utils/progress_service.dart';
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
  PageStyle pageStyle;
  WebViewController webViewController;
  CheckoutBloc checkoutBloc;
  Map<String, dynamic> data = {};
  OrderChangeNotifier orderChangeNotifier;
  ProgressService progressService;
  FlushBarService flushBarService;
  MyCartChangeNotifier myCartChangeNotifier;
  LocalStorageRepository localStorageRepo;
  var orderDetails;
  var reorder;

  @override
  void initState() {
    super.initState();
    print('init state');
    checkoutBloc = context.read<CheckoutBloc>();
    progressService = ProgressService(context: context);
    flushBarService = FlushBarService(context: context);
    orderChangeNotifier = context.read<OrderChangeNotifier>();
    localStorageRepo = context.read<LocalStorageRepository>();
    myCartChangeNotifier = context.read<MyCartChangeNotifier>();
    _initialData();
  }

  void _initialData() {
    orderDetails = widget.params['orderDetails'];
    reorder = widget.params['reorder'];
    final address = jsonDecode(orderDetails['orderAddress']);
    data = {
      "amount": double.parse(orderDetails['orderDetails']['totalPrice']),
      "currency": "KWD",
      "threeDSecure": true,
      "save_card": false,
      "description": "purchase description",
      "statement_descriptor": "",
      "metadata": {},
      "reference": {
        "acquirer": "acquirer",
        "gateway": "gateway",
        "payment": "payment",
        "track": "track",
        "transaction": "trans_910101",
        "order": "order_262625",
      },
      "receipt": {"email": true, "sms": false},
      "customer": {
        "first_name": address['firstname'],
        "middle_name": "",
        "last_name": address['lastname'],
        "email": address['email'],
        "phone": {}
      },
      "merchant": {"id": ""},
      "source": {
        "id":
            orderDetails['paymentMethod'] == 'knet' ? "src_kw.knet" : "src_card"
      },
      "destinations": {"destination": []},
      "post": {"url": "https://tap.company"},
      "redirect": {"url": "https://tap.company"}
    };
    print(data);
    checkoutBloc.add(TapPaymentCheckout(data: data, lang: lang));
  }

  @override
  Widget build(BuildContext context) {
    pageStyle = PageStyle(context, designWidth, designHeight);
    pageStyle.initializePageStyles();
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        backgroundColor: backgroundColor,
        appBar: AppBar(
          backgroundColor: backgroundColor,
          leading: Container(
            width: pageStyle.unitHeight * 40,
            height: pageStyle.unitHeight * 40,
            margin: EdgeInsets.all(pageStyle.unitHeight * 10),
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
              fontSize: pageStyle.unitFontSize * 16,
              color: greyColor,
            ),
          ),
          actions: [
            Padding(
              padding: EdgeInsets.only(right: pageStyle.unitWidth * 8),
              child: Center(
                child: InkWell(
                  onTap: () => Navigator.pop(context),
                  child: Text(
                    'cancel_button_title'.tr(),
                    style: mediumTextStyle.copyWith(
                      fontSize: pageStyle.unitFontSize * 12,
                      color: greyColor,
                    ),
                  ),
                ),
              ),
            ),
          ],
          elevation: 0,
        ),
        body: BlocConsumer<CheckoutBloc, CheckoutState>(
          listener: (context, state) {
            if (state is TapPaymentCheckoutFailure) {
              Navigator.pop(context, 'Something went wrong');
            }
          },
          builder: (context, state) {
            if (state is TapPaymentCheckoutSuccess) {
              return WebView(
                initialUrl: state.url,
                javascriptMode: JavascriptMode.unrestricted,
                onWebViewCreated: (controller) {
                  webViewController = controller;
                },
                onPageFinished: _onPageLoaded,
              );
            } else {
              return Center(child: PulseLoadingSpinner());
            }
          },
        ),
      ),
    );
  }

  void _onPageLoaded(String url) async {
    /// knet result: {
    ///   knet_vpay: Aqp0Cu0FR914pu%2fQnK3p2gDhUPBTDCDk,
    ///   sess: l0Z6AAbK0Yo%3d,
    ///   token: Aqp0Cu0FR914pu%2fQnK3p2suMC1las7Iq
    /// }
    ///
    /// visa/master result: {
    ///   mpgs_pay: HFJQvtL6oUakKO31ZXGNjf4a%2b3tU8emJ,
    ///   sess: qvHbbuJIKx8%3d,
    ///   token: HFJQvtL6oUakKO31ZXGNjR7AfyaOMr7W
    /// }
    final uri = Uri.dataFromString(url);
    final params = uri.queryParameters;
    if (orderDetails['paymentMethod'] == 'knet') {
      if (url.contains('paymentcancel')) {
        Navigator.pop(context);
      }
      if (params.containsKey('knet_vpay')) {
        await orderChangeNotifier.submitOrder(
          orderDetails,
          lang,
          _onProcess,
          _onSuccess,
          _onFailure,
        );
      }
    } else {
      if (params.containsKey('mpgs_pay')) {
        await orderChangeNotifier.submitOrder(
          orderDetails,
          lang,
          _onProcess,
          _onSuccess,
          _onFailure,
        );
      }
    }
    if (url == 'https://www.tap.company/kw/en' ||
        url == 'https://www.tap.company/kw/ar') {
      if (params.isEmpty) {
        Navigator.pop(context);
      }
    }
  }

  void _onProcess() {
    progressService.showProgress();
  }

  void _onSuccess(OrderEntity order) {
    _onOrderSubmittedSuccess(order.orderNo);
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
    progressService.hideProgress();
    Navigator.pushNamedAndRemoveUntil(
      context,
      Routes.checkoutConfirmed,
      (route) => route.settings.name == Routes.home,
      arguments: orderNo,
    );
  }

  void _onFailure(String error) {
    progressService.hideProgress();
    flushBarService.showErrorMessage(pageStyle, error);
  }
}
