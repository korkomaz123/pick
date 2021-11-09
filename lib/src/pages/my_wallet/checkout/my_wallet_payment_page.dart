import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:markaa/src/change_notifier/wallet_change_notifier.dart';
import 'package:markaa/src/components/markaa_page_loading_kit.dart';
import 'package:markaa/src/routes/routes.dart';
import 'package:markaa/src/theme/styles.dart';
import 'package:markaa/src/theme/theme.dart';
import 'package:provider/provider.dart';
import 'package:markaa/src/utils/services/flushbar_service.dart';
import 'package:markaa/src/utils/services/progress_service.dart';
import 'package:webview_flutter/webview_flutter.dart';

class MyWalletPaymentPage extends StatefulWidget {
  final Map<String, dynamic> params;

  MyWalletPaymentPage({required this.params});

  @override
  _MyWalletPaymentPageState createState() => _MyWalletPaymentPageState();
}

class _MyWalletPaymentPageState extends State<MyWalletPaymentPage>
    with WidgetsBindingObserver {
  WebViewController? webViewController;

  late WalletChangeNotifier walletChangeNotifier;

  late ProgressService progressService;
  late FlushBarService flushBarService;

  String? url;
  dynamic walletResult;
  bool? fromCheckout;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addObserver(this);
    progressService = ProgressService(context: context);
    flushBarService = FlushBarService(context: context);

    walletChangeNotifier = context.read<WalletChangeNotifier>();

    url = widget.params['url'];
    walletResult = widget.params['walletResult'];
    fromCheckout = widget.params['fromCheckout'];
  }

  @override
  void dispose() {
    WidgetsBinding.instance!.removeObserver(this);
    super.dispose();
  }

  void _onBack() async {
    final result = await flushBarService.showConfirmDialog(
        message: 'payment_abort_dialog_text');
    if (result != null) {
      /// cancel the order
      await walletChangeNotifier.cancelWalletPayment(walletResult,
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

      print('LOADING URL>>> $loadingUrl');
      print('PARAMS>>> $params');

      if (params.containsKey('result')) {
        String destination = fromCheckout! ? Routes.checkout : Routes.account;
        if (params['result'] == 'failed') {
          walletChangeNotifier.submitPaymentFailedWalletResult(walletResult);
          Navigator.pushNamedAndRemoveUntil(
            context,
            Routes.myWalletFailed,
            (route) => route.settings.name == destination,
            arguments: false,
          );
        } else if (params['result'] == 'success') {
          walletChangeNotifier.submitPaymentSuccessWalletResult(walletResult);
          Navigator.pushNamedAndRemoveUntil(
            context,
            Routes.myWalletSuccess,
            (route) => route.settings.name == destination,
            arguments: walletResult['orderNo'],
          );
        }
      }
    } catch (e) {
      print('REDIRECTING WALLET PAYMENT WEBVIEW PAGE CATCH ERROR: $e');
    }
  }
}
