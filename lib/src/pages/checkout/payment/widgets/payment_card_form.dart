import 'package:flutter/material.dart';
import 'package:markaa/src/theme/images.dart';
import 'package:markaa/src/theme/theme.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:markaa/src/apis/endpoints.dart';
import 'package:markaa/src/components/markaa_page_loading_kit.dart';

class PaymentCardForm extends StatefulWidget {
  final Function? onAuthorizedSuccess;

  PaymentCardForm({this.onAuthorizedSuccess});

  @override
  _PaymentCardFormState createState() => _PaymentCardFormState();
}

class _PaymentCardFormState extends State<PaymentCardForm> {
  WebViewController? webViewController;
  String url = EndPoints.gatewayform;
  bool isLoading = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: greyColor, size: 26.sp),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: Container(
          width: 50.w,
          height: 50.w,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(image: AssetImage(launcherImage)),
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 20.h),
        child: Stack(
          alignment: Alignment.center,
          children: [
            WebView(
              initialUrl: url,
              javascriptMode: JavascriptMode.unrestricted,
              onWebViewCreated: (controller) {
                webViewController = controller;
              },
              onPageStarted: _onPageLoad,
              onPageFinished: _onPageLoaded,
            ),
            if (isLoading) ...[PulseLoadingSpinner()],
          ],
        ),
      ),
    );
  }

  void _onPageLoad(String pageUrl) async {
    final uri = Uri.dataFromString(pageUrl);
    final params = uri.queryParameters;
    if (params.containsKey('token')) {
      if (widget.onAuthorizedSuccess != null) {
        widget.onAuthorizedSuccess!(params['token']);
      } else {
        Navigator.pop(context, params['token']);
      }
    }
  }

  void _onPageLoaded(String pageUrl) async {
    if (isLoading) isLoading = false;
    setState(() {});
  }
}
