import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:isco_custom_widgets/isco_custom_widgets.dart';
import 'package:markaa/src/components/markaa_page_loading_kit.dart';
import 'package:markaa/src/config/config.dart';
import 'package:markaa/src/data/mock/mock.dart';
import 'package:markaa/src/pages/checkout/bloc/checkout_bloc.dart';
import 'package:markaa/src/theme/styles.dart';
import 'package:markaa/src/theme/theme.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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

  @override
  void initState() {
    super.initState();
    print('init state');
    checkoutBloc = context.read<CheckoutBloc>();
    _initialData();
  }

  void _initialData() {
    final address = jsonDecode(widget.params['orderAddress']);
    print(address);
    data = {
      "amount": double.parse(widget.params['orderDetails']['totalPrice']),
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
        "id": widget.params['paymentMethod'] == 'knet'
            ? "src_kw.knet"
            : "src_card"
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

  void _onPageLoaded(String url) {
    final uri = Uri.dataFromString(url);
    final params = uri.queryParameters;
    if (widget.params['paymentMethod'] == 'knet') {
      if (url.contains('paymentcancel')) {
        Navigator.pop(context);
      }
    }
    print(url);
    print(params);
    if (params.containsKey('tap_id')) {
      Navigator.pop(context, 'success');
    }
  }
}
