import 'package:flutter/material.dart';
import 'package:markaa/src/apis/endpoints.dart';
import 'package:markaa/src/components/markaa_page_loading_kit.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PaymentCardForm extends StatefulWidget {
  final Function onAuthorizedSuccess;

  PaymentCardForm({required this.onAuthorizedSuccess});

  @override
  _PaymentCardFormState createState() => _PaymentCardFormState();
}

class _PaymentCardFormState extends State<PaymentCardForm> {
  WebViewController? webViewController;
  String url = EndPoints.gatewayform;
  bool isLoading = true;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        WebView(
          initialUrl: url,
          javascriptMode: JavascriptMode.unrestricted,
          onWebViewCreated: (controller) {
            webViewController = controller;
          },
          onPageStarted: _onPageLoading,
          onPageFinished: _onPageLoaded,
        ),
        if (isLoading) ...[Center(child: PulseLoadingSpinner())],
      ],
    );
  }

  void _onPageLoading(String pageUrl) async {
    final uri = Uri.dataFromString(pageUrl);
    final params = uri.queryParameters;
    if (params.containsKey('token')) {
      widget.onAuthorizedSuccess(params['token']);
    }
  }

  void _onPageLoaded(String pageUrl) async {
    if (isLoading) isLoading = false;
    setState(() {});
  }
}
