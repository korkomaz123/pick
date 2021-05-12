import 'dart:convert';

import 'package:markaa/src/change_notifier/address_change_notifier.dart';
import 'package:markaa/src/components/markaa_checkout_app_bar.dart';
import 'package:markaa/src/components/markaa_text_button.dart';
import 'package:markaa/src/components/markaa_text_icon_button.dart';
import 'package:markaa/src/data/mock/mock.dart';
import 'package:markaa/src/data/models/order_entity.dart';
import 'package:markaa/src/routes/routes.dart';
import 'package:markaa/src/theme/icons.dart';
import 'package:markaa/src/theme/styles.dart';
import 'package:markaa/src/theme/theme.dart';
import 'package:markaa/src/utils/repositories/checkout_repository.dart';
import 'package:markaa/src/utils/repositories/local_storage_repository.dart';
import 'package:markaa/src/change_notifier/my_cart_change_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:markaa/src/utils/services/flushbar_service.dart';
import 'package:markaa/src/utils/services/progress_service.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CheckoutAddressPage extends StatefulWidget {
  final OrderEntity reorder;

  CheckoutAddressPage({this.reorder});

  @override
  _CheckoutAddressPageState createState() => _CheckoutAddressPageState();
}

class _CheckoutAddressPageState extends State<CheckoutAddressPage> {
  FlushBarService flushBarService;
  ProgressService progressService;
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController countryController = TextEditingController();
  TextEditingController stateController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController streetController = TextEditingController();
  TextEditingController zipCodeController = TextEditingController();
  TextEditingController companyController = TextEditingController();
  TextEditingController noteController = TextEditingController();
  String shippingMethodId;
  double serviceFees;
  final LocalStorageRepository localRepo = LocalStorageRepository();
  MyCartChangeNotifier myCartChangeNotifier;
  AddressChangeNotifier addressChangeNotifier;
  final CheckoutRepository checkoutRepo = CheckoutRepository();

  _loadData() async {
    addressChangeNotifier.initialize();
    if (user?.token != null)
      await addressChangeNotifier.loadAddresses(user.token);
    if (shippingMethods.isEmpty)
      shippingMethods = await checkoutRepo.getShippingMethod();
    shippingMethodId = shippingMethods[0].id;
    serviceFees = shippingMethods[0].serviceFees;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    myCartChangeNotifier = context.read<MyCartChangeNotifier>();
    addressChangeNotifier = context.read<AddressChangeNotifier>();
    flushBarService = FlushBarService(context: context);
    progressService = ProgressService(context: context);
    _loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: MarkaaCheckoutAppBar(currentIndex: 0),
      body: Consumer<AddressChangeNotifier>(
        builder: (_, model, __) {
          addressChangeNotifier = model;
          return SingleChildScrollView(
            child: Column(
              children: [
                if (model.defaultAddress != null) ...[
                  _buildSelectedAddress(model),
                ],
                if (model.keys.isEmpty) ...[
                  _buildNoAddress(),
                ],
                if (model.defaultAddress == null && model.keys.isNotEmpty) ...[
                  SizedBox(height: 50.h)
                ],
                if (model.defaultAddress != null) ...[
                  _buildChangeAddressButton(),
                ] else if (model.keys.isNotEmpty) ...[
                  _buildSelectAddressButton(),
                ] else ...[
                  _buildCreateAddressButton(),
                ],
                _buildNote(),
                _buildToolbarButtons(),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildNoAddress() {
    return Container(
      width: 375.w,
      padding: EdgeInsets.symmetric(vertical: 20.h),
      child: Column(
        children: [
          SvgPicture.asset(addressIcon),
          SizedBox(height: 10.h),
          Text(
            'no_saved_addresses'.tr(),
            style: mediumTextStyle.copyWith(
              fontSize: 12.sp,
              color: greyDarkColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSelectedAddress(AddressChangeNotifier model) {
    return Container(
      width: 375.w,
      margin: EdgeInsets.symmetric(horizontal: 10.w, vertical: 15.h),
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            model.defaultAddress.title,
            style: mediumTextStyle.copyWith(
              color: primaryColor,
              fontSize: 18.sp,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 6.h),
          Text(
            model.defaultAddress.country,
            style: mediumTextStyle.copyWith(
              color: greyDarkColor,
              fontSize: 14.sp,
            ),
          ),
          SizedBox(height: 6.h),
          Text(
            model.defaultAddress.city,
            style: mediumTextStyle.copyWith(
              color: greyDarkColor,
              fontSize: 14.sp,
            ),
          ),
          SizedBox(height: 6.h),
          Text(
            model.defaultAddress.street,
            style: mediumTextStyle.copyWith(
              color: greyDarkColor,
              fontSize: 14.sp,
            ),
          ),
          SizedBox(height: 6.h),
          Text(
            'phone_number_hint'.tr() + ': ' + model.defaultAddress.phoneNumber,
            style: mediumTextStyle.copyWith(
              color: greyDarkColor,
              fontSize: 14.sp,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChangeAddressButton() {
    return Container(
      width: 375.w,
      height: 50.h,
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      child: MarkaaTextIconButton(
        title: 'checkout_change_address_button_title'.tr(),
        titleSize: 14.sp,
        titleColor: greyColor,
        buttonColor: greyLightColor,
        borderColor: Colors.transparent,
        icon: SvgPicture.asset(selectAddrIcon),
        onPressed: () => _onChangeAddress(),
        radius: 0,
      ),
    );
  }

  Widget _buildSelectAddressButton() {
    return Container(
      width: 375.w,
      height: 50.h,
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      child: MarkaaTextIconButton(
        title: 'checkout_select_address_button_title'.tr(),
        titleSize: 14.sp,
        titleColor: greyColor,
        buttonColor: greyLightColor,
        borderColor: Colors.transparent,
        icon: SvgPicture.asset(selectAddrIcon),
        onPressed: () => _onChangeAddress(),
        radius: 0,
      ),
    );
  }

  Widget _buildCreateAddressButton() {
    return Container(
      width: 375.w,
      height: 50.h,
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      child: MarkaaTextIconButton(
        title: 'create_address_button_title'.tr(),
        titleSize: 14.sp,
        titleColor: greyColor,
        buttonColor: greyLightColor,
        borderColor: Colors.transparent,
        icon: SvgPicture.asset(selectAddrIcon),
        onPressed: () => Navigator.pushNamed(
          context,
          Routes.editAddress,
          arguments: {'isCheckout': true},
        ),
        radius: 0,
      ),
    );
  }

  Widget _buildNote() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 20.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'checkout_note_title'.tr(),
            style: mediumTextStyle.copyWith(
              color: greyDarkColor,
              fontSize: 17.sp,
            ),
          ),
          Container(
            width: double.infinity,
            child: TextFormField(
              controller: noteController,
              style: mediumTextStyle.copyWith(
                color: greyColor,
                fontSize: 14.sp,
              ),
              decoration: InputDecoration(
                hintText: 'checkout_note_hint'.tr(),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: greyColor),
                ),
              ),
              validator: (value) => null,
              keyboardType: TextInputType.text,
              maxLines: 3,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildToolbarButtons() {
    return Container(
      width: 210.w,
      child: MarkaaTextButton(
        title: 'checkout_continue_payment_button_title'.tr(),
        titleSize: 12.sp,
        titleColor: Colors.white,
        buttonColor: primaryColor,
        borderColor: Colors.transparent,
        onPressed: () => _onContinue(),
        radius: 30,
      ),
    );
  }

  void _onChangeAddress() async {
    await Navigator.pushNamed(
      context,
      Routes.shippingAddress,
      arguments: true,
    );
    setState(() {});
  }

  void _onContinue() async {
    if (addressChangeNotifier.defaultAddress != null) {
      progressService.showProgress();
      String cartId;
      if (widget.reorder != null) {
        cartId = myCartChangeNotifier.reorderCartId;
      } else {
        cartId = myCartChangeNotifier.cartId;
      }
      orderDetails['shipping'] = shippingMethodId;
      orderDetails['cartId'] = cartId;
      double totalPrice = .0;
      double subtotalPrice = .0;
      double discount = .0;
      if (widget.reorder != null) {
        subtotalPrice = myCartChangeNotifier.reorderCartTotalPrice;
      } else {
        discount = myCartChangeNotifier.type == 'fixed'
            ? myCartChangeNotifier.discount
            : myCartChangeNotifier.cartTotalPrice -
                myCartChangeNotifier.cartDiscountedTotalPrice;
        subtotalPrice = myCartChangeNotifier.cartTotalPrice;
      }
      totalPrice = subtotalPrice + serviceFees - discount;
      orderDetails['orderDetails'] = {};
      orderDetails['orderDetails']['discount'] = discount.toStringAsFixed(3);
      orderDetails['orderDetails']['totalPrice'] =
          totalPrice.toStringAsFixed(3);
      orderDetails['orderDetails']['subTotalPrice'] =
          subtotalPrice.toStringAsFixed(3);
      orderDetails['orderDetails']['fees'] = serviceFees.toStringAsFixed(3);
      orderDetails['token'] = user.token;
      orderDetails['orderAddress'] = jsonEncode({
        'customer_address_id': addressChangeNotifier.defaultAddress.addressId,
        'firstname': addressChangeNotifier.defaultAddress.firstName,
        'lastname': addressChangeNotifier.defaultAddress.lastName,
        'email': addressChangeNotifier.defaultAddress.email ?? user.email,
        'region': addressChangeNotifier.defaultAddress.region,
        'street': addressChangeNotifier.defaultAddress.street,
        'country_id': addressChangeNotifier.defaultAddress.countryId,
        'city': addressChangeNotifier.defaultAddress.city,
        'company': addressChangeNotifier.defaultAddress.company,
        'postcode': addressChangeNotifier.defaultAddress.postCode,
        'telephone': addressChangeNotifier.defaultAddress.phoneNumber,
        'save_in_address_book': '0',
        'prefix': addressChangeNotifier.defaultAddress.title,
      });
      progressService.hideProgress();
      Navigator.pushNamed(
        context,
        Routes.checkoutPayment,
        arguments: widget.reorder,
      );
    } else {
      flushBarService.showErrorMessage(
        'required_address_title'.tr(),
      );
    }
  }
}
