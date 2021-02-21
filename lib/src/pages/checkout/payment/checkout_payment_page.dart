import 'package:markaa/src/change_notifier/markaa_app_change_notifier.dart';
import 'package:markaa/src/components/markaa_checkout_app_bar.dart';
import 'package:markaa/src/components/markaa_text_button.dart';
import 'package:markaa/src/config/config.dart';
import 'package:markaa/src/data/mock/mock.dart';
import 'package:markaa/src/data/models/order_entity.dart';
import 'package:markaa/src/data/models/payment_method_entity.dart';
import 'package:markaa/src/pages/checkout/bloc/checkout_bloc.dart';
import 'package:markaa/src/pages/checkout/payment/awesome_loader.dart';
import 'package:markaa/src/routes/routes.dart';
import 'package:markaa/src/theme/styles.dart';
import 'package:markaa/src/theme/theme.dart';
import 'package:markaa/src/change_notifier/my_cart_change_notifier.dart';
import 'package:markaa/src/utils/flushbar_service.dart';
import 'package:markaa/src/utils/local_storage_repository.dart';
import 'package:markaa/src/utils/progress_service.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
  LocalStorageRepository localStorageRepo;
  MyCartChangeNotifier myCartChangeNotifier;
  AwesomeLoaderController loaderController = AwesomeLoaderController();
  MarkaaAppChangeNotifier markaaAppChangeNotifier;

  @override
  void initState() {
    super.initState();
    if (widget.reorder != null) {
      payment = widget.reorder.paymentMethod.id;
    } else {
      payment = paymentMethods[0].id;
    }
    progressService = ProgressService(context: context);
    flushBarService = FlushBarService(context: context);
    checkoutBloc = context.read<CheckoutBloc>();
    localStorageRepo = context.read<LocalStorageRepository>();
    markaaAppChangeNotifier = context.read<MarkaaAppChangeNotifier>();
    myCartChangeNotifier = context.read<MyCartChangeNotifier>();
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
                  Consumer<MarkaaAppChangeNotifier>(builder: (_, __, ___) {
                    return Column(
                      children: paymentMethods.map((method) {
                        return _buildPaymentCard(method);
                      }).toList(),
                    );
                  }),
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
          markaaAppChangeNotifier.rebuild();
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
                    ' ${double.parse(orderDetails['orderDetails']['subTotalPrice']).toStringAsFixed(2)}',
                style: mediumTextStyle.copyWith(
                  color: greyColor,
                  fontSize: pageStyle.unitFontSize * 14,
                ),
              )
            ],
          ),
          if (double.parse(orderDetails['orderDetails']['discount']) > 0) ...[
            SizedBox(height: pageStyle.unitHeight * 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'discount'.tr(),
                  style: mediumTextStyle.copyWith(
                    color: darkColor,
                    fontSize: pageStyle.unitFontSize * 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  'currency'.tr() +
                      ' ${orderDetails['orderDetails']['discount']}',
                  style: mediumTextStyle.copyWith(
                    color: darkColor,
                    fontSize: pageStyle.unitFontSize * 14,
                    fontWeight: FontWeight.w700,
                  ),
                )
              ],
            ),
          ],
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
                double.parse(orderDetails['orderDetails']['fees']) == .0
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
          orderDetails['paymentMethod'] = payment;
          print(payment);
          if (payment == 'cashondelivery') {
            checkoutBloc.add(
              OrderSubmitted(
                orderDetails: orderDetails,
                lang: lang,
              ),
            );
          } else {
            final result = await Navigator.pushNamed(
              context,
              Routes.checkoutPaymentCard,
              arguments: orderDetails,
            );
            if (result != null) {
              if (result == 'success') {
                checkoutBloc.add(
                  OrderSubmitted(
                    orderDetails: orderDetails,
                    lang: lang,
                  ),
                );
              } else {
                flushBarService.showErrorMessage(pageStyle, result);
              }
            } else {
              flushBarService.showErrorMessage(
                pageStyle,
                'payment_canceled'.tr(),
              );
            }
          }
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
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
            Icon(Icons.lock_outline, color: Colors.white),
          ],
        ),
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
    if (widget.reorder != null) {
      myCartChangeNotifier.initializeReorderCart();
    } else {
      myCartChangeNotifier.initialize();
    }
    Navigator.pushNamedAndRemoveUntil(
      context,
      Routes.checkoutConfirmed,
      (route) => route.settings.name == Routes.home,
      arguments: orderNo,
    );
  }
}
