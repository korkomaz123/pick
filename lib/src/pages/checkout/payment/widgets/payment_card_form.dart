import 'package:flutter/material.dart';
import 'package:markaa/src/apis/endpoints.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PaymentCardForm extends StatefulWidget {
  final Function onAuthorizedSuccess;

  PaymentCardForm({@required this.onAuthorizedSuccess});

  @override
  _PaymentCardFormState createState() => _PaymentCardFormState();
}

class _PaymentCardFormState extends State<PaymentCardForm> {
  WebViewController webViewController;
  final url = EndPoints.gatewayform;

  @override
  void dispose() {
    super.dispose();
  }

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
    if (params.containsKey('token')) {
      widget.onAuthorizedSuccess(params['token']);
    }
  }
}
