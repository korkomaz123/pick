import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PaymentCardForm extends StatefulWidget {
  @override
  _PaymentCardFormState createState() => _PaymentCardFormState();
}

class _PaymentCardFormState extends State<PaymentCardForm> {
  WebViewController webViewController;
  final url = 'https://cigaon.com/gatewayform.php';

  @override
  Widget build(BuildContext context) {
    return WebView(
      initialUrl: url,
      javascriptMode: JavascriptMode.unrestricted,
      onWebViewCreated: (controller) {
        webViewController = controller;
      },
      onPageStarted: _onPageLoaded,
    );
  }

  void _onPageLoaded(String url) async {
    final uri = Uri.dataFromString(url);
    final params = uri.queryParameters;
    print('Params: $params');
  }
}
