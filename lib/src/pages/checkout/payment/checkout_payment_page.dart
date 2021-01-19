import 'dart:convert';
import 'dart:io';
import 'package:markaa/src/components/markaa_checkout_app_bar.dart';
import 'package:markaa/src/components/markaa_text_button.dart';
import 'package:markaa/src/config/config.dart';
import 'package:markaa/src/data/mock/mock.dart';
import 'package:markaa/src/data/models/order_entity.dart';
import 'package:markaa/src/data/models/payment_method_entity.dart';
import 'package:markaa/src/pages/checkout/bloc/checkout_bloc.dart';
import 'package:markaa/src/pages/checkout/payment/awesome_loader.dart';
import 'package:markaa/src/pages/markaa_app/bloc/cart_item_count/cart_item_count_bloc.dart';
import 'package:markaa/src/pages/my_cart/bloc/my_cart_repository.dart';
import 'package:markaa/src/routes/routes.dart';
import 'package:markaa/src/theme/styles.dart';
import 'package:markaa/src/theme/theme.dart';
import 'package:markaa/src/utils/flushbar_service.dart';
import 'package:markaa/src/utils/local_storage_repository.dart';
import 'package:markaa/src/utils/progress_service.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_sell_sdk_flutter/go_sell_sdk_flutter.dart';
import 'package:go_sell_sdk_flutter/model/models.dart';
import 'package:isco_custom_widgets/isco_custom_widgets.dart';

class CheckoutPaymentPage extends StatefulWidget {
  final OrderEntity reorder;

  CheckoutPaymentPage({this.reorder});

  @override
  _CheckoutPaymentPageState createState() => _CheckoutPaymentPageState();
}

class _CheckoutPaymentPageState extends State<CheckoutPaymentPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  TextEditingController noteController = TextEditingController();
  String payment;
  PageStyle pageStyle;
  ProgressService progressService;
  FlushBarService flushBarService;
  CheckoutBloc checkoutBloc;
  CartItemCountBloc cartItemCountBloc;
  LocalStorageRepository localStorageRepo;
  MyCartRepository cartRepo;

  Map<dynamic, dynamic> tapSDKResult;
  String responseID = "";
  String sdkStatus = "";
  String sdkErrorCode;
  String sdkErrorMessage;
  String sdkErrorDescription;
  AwesomeLoaderController loaderController = AwesomeLoaderController();
  PaymentType paymentType;

  @override
  void initState() {
    super.initState();
    if (widget.reorder != null) {
      payment = widget.reorder.paymentMethod.id;
    } else {
      payment = paymentMethods[0].id;
    }
    paymentType = payment == 'knet' ? PaymentType.WEB : PaymentType.CARD;
    progressService = ProgressService(context: context);
    flushBarService = FlushBarService(context: context);
    checkoutBloc = context.read<CheckoutBloc>();
    cartItemCountBloc = context.read<CartItemCountBloc>();
    localStorageRepo = context.read<LocalStorageRepository>();
    cartRepo = context.read<MyCartRepository>();
    print(orderDetails);
    configureSDK();
  }

  @override
  Widget build(BuildContext context) {
    pageStyle = PageStyle(context, designWidth, designHeight);
    pageStyle.initializePageStyles();
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      appBar: MarkaaCheckoutAppBar(pageStyle: pageStyle, currentIndex: 3),
      body: BlocConsumer<CheckoutBloc, CheckoutState>(
        listener: (context, state) {
          if (state is OrderSubmittedInProcess) {
            progressService.showProgress();
          }
          if (state is OrderSubmittedSuccess) {
            progressService.hideProgress();
            _onOrderSubmittedSuccess(state.orderNo);
          }
          if (state is OrderSubmittedFailure) {
            progressService.hideProgress();
            flushBarService.showErrorMessage(pageStyle, state.message);
          }
        },
        builder: (context, state) {
          return SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: pageStyle.unitWidth * 10,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    children: paymentMethods.map((method) {
                      return _buildPaymentCard(method);
                    }).toList(),
                  ),
                  SizedBox(height: pageStyle.unitHeight * 50),
                  Divider(
                    color: greyLightColor,
                    height: pageStyle.unitHeight * 10,
                    thickness: pageStyle.unitHeight * 1,
                  ),
                  _buildDetails(),
                  SizedBox(height: pageStyle.unitHeight * 30),
                  _buildPlacePaymentButton(),
                  _buildBackToReviewButton(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildPaymentCard(PaymentMethodEntity method) {
    print("title:" + method.title);
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(
        vertical: pageStyle.unitHeight * 10,
      ),
      padding: EdgeInsets.all(pageStyle.unitWidth * 10),
      color: greyLightColor,
      child: RadioListTile(
        value: method.id,
        groupValue: payment,
        onChanged: (value) {
          payment = value;
          paymentType = payment == 'knet' ? PaymentType.WEB : PaymentType.CARD;
          setupSDKSession();
          print("payment type : $payment");
          setState(() {});
        },
        activeColor: primaryColor,
        title: Row(
          children: [
            if (method.title == 'Cash On Delivery' ||
                method.title == 'الدفع عند التوصيل') ...[
              SvgPicture.asset(
                'lib/public/icons/cashondelivery.svg',
                height: 19,
                width: 39,
              ),
              Text(
                "    " + method.title,
                style: mediumTextStyle.copyWith(
                  color: greyColor,
                  fontSize: pageStyle.unitFontSize * 14,
                ),
              ),
            ] else if (method.title == 'Knet' || method.title == 'كي نت') ...[
              SvgPicture.asset(
                'lib/public/icons/knet.svg',
                height: 46,
                width: 61,
              ),
            ] else ...[
              Image.asset(
                'lib/public/images/visa-card.png',
                height: 35,
                width: 95,
              ),
              SizedBox(
                width: 10,
              ),
              SvgPicture.asset(
                'lib/public/icons/line.svg',
                height: 41,
                width: 10,
              ),
              SizedBox(
                width: 15,
              ),
              SvgPicture.asset(
                'lib/public/icons/master-card.svg',
                height: 42,
                width: 54,
              ),
            ]
          ],
        ),
      ),
    );
  }

  Widget _buildDetails() {
    return Container(
      width: double.infinity,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'checkout_subtotal_title'.tr(),
                style: mediumTextStyle.copyWith(
                  color: greyColor,
                  fontSize: pageStyle.unitFontSize * 14,
                ),
              ),
              Text(
                'currency'.tr() +
                    ' ${orderDetails['orderDetails']['subTotalPrice']}',
                style: mediumTextStyle.copyWith(
                  color: greyColor,
                  fontSize: pageStyle.unitFontSize * 14,
                ),
              )
            ],
          ),
          SizedBox(height: pageStyle.unitHeight * 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'checkout_shipping_cost_title'.tr(),
                style: mediumTextStyle.copyWith(
                  color: greyColor,
                  fontSize: pageStyle.unitFontSize * 14,
                ),
              ),
              Text(
                int.parse(orderDetails['orderDetails']['fees']) == 0
                    ? 'free'.tr()
                    : 'currency'.tr() +
                        ' ${orderDetails['orderDetails']['fees']}',
                style: mediumTextStyle.copyWith(
                  color: greyColor,
                  fontSize: pageStyle.unitFontSize * 14,
                ),
              )
            ],
          ),
          SizedBox(height: pageStyle.unitHeight * 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'total'.tr(),
                style: mediumTextStyle.copyWith(
                  color: greyColor,
                  fontSize: pageStyle.unitFontSize * 14,
                ),
              ),
              Text(
                'currency'.tr() +
                    ' ${orderDetails['orderDetails']['totalPrice']}',
                style: mediumTextStyle.copyWith(
                  color: greyColor,
                  fontSize: pageStyle.unitFontSize * 17,
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPlacePaymentButton() {
    return SizedBox(
      height: 45,
      child: RaisedButton(
        color: primaryColor,
        clipBehavior: Clip.hardEdge,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadiusDirectional.all(Radius.circular(30)),
        ),
        onPressed: () async {
          if (payment == 'cashondelivery') {
            orderDetails['paymentMethod'] = payment;
            checkoutBloc.add(
              OrderSubmitted(
                orderDetails: orderDetails,
                lang: lang,
              ),
            );
          } else {
            bool res = await startSDK();
            if (res == true) {
              orderDetails['paymentMethod'] = payment;
              checkoutBloc.add(
                OrderSubmitted(
                  orderDetails: orderDetails,
                  lang: lang,
                ),
              );
            } else {
              _scaffoldKey.currentState.showSnackBar(
                new SnackBar(
                  backgroundColor: Colors.red,
                  content: new Text(sdkStatus == ""
                      ? 'Status: Failed'
                      : 'Status: [$sdkStatus $responseID ]'),
                  duration: Duration(seconds: 5),
                ),
              );
            }
          }
        },
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Container(
            width: 25,
            height: 25,
            child: AwesomeLoader(
              outerColor: Colors.white,
              innerColor: Colors.white,
              strokeWidth: 3.0,
              controller: loaderController,
            ),
          ),
          Spacer(),
          Text(
            'checkout_place_payment_button_title'.tr(),
            style: TextStyle(color: Colors.white, fontSize: 16.0),
          ),
          Spacer(),
          Icon(
            Icons.lock_outline,
            color: Colors.white,
          ),
        ]),
      ),
    );
  }

  Widget _buildBackToReviewButton() {
    return Container(
      width: pageStyle.deviceWidth,
      padding: EdgeInsets.symmetric(horizontal: pageStyle.unitWidth * 60),
      child: MarkaaTextButton(
        title: 'checkout_back_review_button_title'.tr(),
        titleSize: pageStyle.unitFontSize * 12,
        titleColor: greyColor,
        buttonColor: Colors.white,
        borderColor: Colors.transparent,
        onPressed: () => Navigator.pop(context),
        radius: 30,
      ),
    );
  }

  void _onOrderSubmittedSuccess(String orderNo) async {
    myCartItems = [];
    cartItemCountBloc.add(CartItemCountSet(cartItemCount: 0));
    if (widget.reorder != null) {
      await localStorageRepo.setItem('reorderCartId', '');
    } else {
      await localStorageRepo.setCartId('');
    }
    Navigator.pushNamedAndRemoveUntil(
      context,
      Routes.checkoutConfirmed,
      (route) => route.settings.name == Routes.home,
      arguments: orderNo,
    );
  }

  // configure SDK
  Future<void> configureSDK() async {
    // configure app
    configureApp();
    // sdk session configurations
    setupSDKSession();
  }

  // configure app key and bundle-id (You must get those keys from tap)
  Future<void> configureApp() async {
    GoSellSdkFlutter.configureApp(
        bundleId: Platform.isAndroid ? "com.app.markaa" : "com.markaa.app",
        productionSecreteKey: Platform.isAndroid
            ? "sk_live_yhvSZwp2NcQIDCYW9k3EzLf6"
            : "sk_live_1w4nP6Ne5OFUoS0bY9uTyzJR",
        sandBoxsecretKey: Platform.isAndroid
            ? "sk_test_ge1wCvn8pADBXcjasGu9drNS"
            : "sk_test_8vcH9RlXrGqnxh2DYij1ECQO",
        lang: "en");
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> setupSDKSession() async {
    try {
      final data = jsonDecode(orderDetails['orderAddress']);

      GoSellSdkFlutter.sessionConfigurations(
        trxMode: TransactionMode.PURCHASE,
        transactionCurrency: "kwd",
        amount: orderDetails['orderDetails']['totalPrice'],
        customer: Customer(
          customerId:
              "", // customer id is important to retrieve cards saved for this customer
          email: data['email'],
          isdNumber: "965",
          number: data['telephone'],
          firstName: data['firstname'],
          middleName: "",
          lastName: data['lastname'],
          metaData: null,
        ),
        paymentItems: <PaymentItem>[],
        // List of taxes
        taxes: [],
        // List of shippnig
        shippings: [
          Shipping(
            name: data['firstname'] + data['lastname'],
            amount: int.parse(orderDetails['orderDetails']['fees']) + .0,
            description: "Shopping",
          ),
        ],
        // Post URL
        postURL: "https://tap.company",
        // Payment description
        paymentDescription: "paymentDescription",
        // Payment Metadata
        paymentMetaData: {
          "a": "a meta",
          "b": "b meta",
        },
        // Payment Reference
        paymentReference: Reference(
          acquirer: "acquirer",
          gateway: "gateway",
          payment: "payment",
          track: "track",
          transaction: "trans_910101",
          order: "order_262625",
        ),
        // payment Descriptor
        paymentStatementDescriptor: "paymentStatementDescriptor",
        // Save Card Switch
        isUserAllowedToSaveCard: true,
        // Enable/Disable 3DSecure
        isRequires3DSecure: true,
        // Receipt SMS/Email
        receipt: Receipt(true, false),
        // Authorize Action [Capture - Void]
        authorizeAction: AuthorizeAction(
          type: AuthorizeActionType.CAPTURE,
          timeInHours: 10,
        ),
        // Destinations
        destinations: null,
        // merchant id
        merchantID: "",
        // Allowed cards
        // allowedCadTypes: CardType.DEBIT,
        applePayMerchantID: "applePayMerchantID",
        allowsToSaveSameCardMoreThanOnce: false,
        // pass the card holder name to the SDK
        cardHolderName: data['firstname'],
        // disable changing the card holder name by the user
        allowsToEditCardHolderName: true,
        // select payments you need to show [Default is all, and you can choose between WEB-CARD-APPLEPAY ]
        paymentType: paymentType,
        // Transaction mode
        sdkMode: SDKMode.Sandbox,
      );
    } on PlatformException {
      // platformVersion = 'Failed to get platform version.';
      print("error occured in try block");
    }

    if (!mounted) return;

    setState(() {
      tapSDKResult = {};
    });
  }

  Future<bool> startSDK() async {
    bool result = false;
    setState(() {
      loaderController.start();
    });

    tapSDKResult = await GoSellSdkFlutter.startPaymentSDK;
    loaderController.stopWhenFull();

    print('>>>> ${tapSDKResult['sdk_result']}');
    setState(() {
      switch (tapSDKResult['sdk_result']) {
        case "SUCCESS":
          sdkStatus = "SUCCESS";
          result = true;
          handleSDKResult();
          break;
        case "FAILED":
          sdkStatus = "FAILED";
          handleSDKResult();
          break;
        case "SDK_ERROR":
          print('sdk error............');
          print(tapSDKResult['sdk_error_code']);
          print(tapSDKResult['sdk_error_message']);
          print(tapSDKResult['sdk_error_description']);
          print('sdk error............');
          sdkErrorCode = tapSDKResult['sdk_error_code'].toString();
          sdkErrorMessage = tapSDKResult['sdk_error_message'];
          sdkErrorDescription = tapSDKResult['sdk_error_description'];
          break;

        case "NOT_IMPLEMENTED":
          sdkStatus = "NOT_IMPLEMENTED";
          break;
      }
    });
    return result;
  }

  void handleSDKResult() {
    switch (tapSDKResult['trx_mode']) {
      case "CHARGE":
        printSDKResult('Charge');
        break;

      case "AUTHORIZE":
        printSDKResult('Authorize');
        break;

      case "SAVE_CARD":
        printSDKResult('Save Card');
        break;

      case "TOKENIZE":
        print('TOKENIZE token : ${tapSDKResult['token']}');
        print('TOKENIZE token_currency  : ${tapSDKResult['token_currency']}');
        print('TOKENIZE card_first_six : ${tapSDKResult['card_first_six']}');
        print('TOKENIZE card_last_four : ${tapSDKResult['card_last_four']}');
        print('TOKENIZE card_object  : ${tapSDKResult['card_object']}');
        print('TOKENIZE card_exp_month : ${tapSDKResult['card_exp_month']}');
        print('TOKENIZE card_exp_year    : ${tapSDKResult['card_exp_year']}');

        responseID = tapSDKResult['token'];
        break;
    }
  }

  void printSDKResult(String trxMode) {
    print('$trxMode status                : ${tapSDKResult['status']}');
    print('$trxMode id               : ${tapSDKResult['charge_id']}');
    print('$trxMode  description        : ${tapSDKResult['description']}');
    print('$trxMode  message           : ${tapSDKResult['message']}');
    print('$trxMode  card_first_six : ${tapSDKResult['card_first_six']}');
    print('$trxMode  card_last_four   : ${tapSDKResult['card_last_four']}');
    print('$trxMode  card_object         : ${tapSDKResult['card_object']}');
    print('$trxMode  card_brand          : ${tapSDKResult['card_brand']}');
    print('$trxMode  card_exp_month  : ${tapSDKResult['card_exp_month']}');
    print('$trxMode  card_exp_year: ${tapSDKResult['card_exp_year']}');
    print('$trxMode  acquirer_id  : ${tapSDKResult['acquirer_id']}');
    print(
        '$trxMode  acquirer_response_code : ${tapSDKResult['acquirer_response_code']}');
    print(
        '$trxMode  acquirer_response_message: ${tapSDKResult['acquirer_response_message']}');
    print('$trxMode  source_id: ${tapSDKResult['source_id']}');
    print('$trxMode  source_channel     : ${tapSDKResult['source_channel']}');
    print('$trxMode  source_object      : ${tapSDKResult['source_object']}');
    print(
        '$trxMode source_payment_type : ${tapSDKResult['source_payment_type']}');
    responseID = tapSDKResult['charge_id'];
  }
}
