import 'dart:convert';

import 'package:markaa/src/components/markaa_checkout_app_bar.dart';
import 'package:markaa/src/components/markaa_text_button.dart';
import 'package:markaa/src/components/markaa_text_icon_button.dart';
import 'package:markaa/src/config/config.dart';
import 'package:markaa/src/data/mock/mock.dart';
import 'package:markaa/src/data/models/address_entity.dart';
import 'package:markaa/src/data/models/order_entity.dart';
import 'package:markaa/src/pages/my_account/shipping_address/bloc/shipping_address_bloc.dart';
import 'package:markaa/src/routes/routes.dart';
import 'package:markaa/src/theme/icons.dart';
import 'package:markaa/src/theme/styles.dart';
import 'package:markaa/src/theme/theme.dart';
import 'package:markaa/src/utils/flushbar_service.dart';
import 'package:markaa/src/utils/progress_service.dart';
import 'package:markaa/src/utils/local_storage_repository.dart';
import 'package:markaa/src/change_notifier/my_cart_change_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:isco_custom_widgets/isco_custom_widgets.dart';

class CheckoutAddressPage extends StatefulWidget {
  final OrderEntity reorder;

  CheckoutAddressPage({this.reorder});

  @override
  _CheckoutAddressPageState createState() => _CheckoutAddressPageState();
}

class _CheckoutAddressPageState extends State<CheckoutAddressPage> {
  PageStyle pageStyle;
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
  LocalStorageRepository localRepo;
  ShippingAddressBloc shippingAddressBloc;
  MyCartChangeNotifier myCartChangeNotifier;

  @override
  void initState() {
    super.initState();
    if (widget.reorder != null) {
      shippingMethodId = widget.reorder.shippingMethod.id;
      serviceFees = widget.reorder.shippingMethod.serviceFees;
    } else {
      shippingMethodId = shippingMethods[0].id;
      serviceFees = shippingMethods[0].serviceFees;
    }
    shippingAddressBloc = context.read<ShippingAddressBloc>();
    localRepo = context.read<LocalStorageRepository>();
    myCartChangeNotifier = context.read<MyCartChangeNotifier>();
    flushBarService = FlushBarService(context: context);
    progressService = ProgressService(context: context);
  }

  void _onAddedSuccess() {
    Navigator.popUntil(
      context,
      (route) => route.settings.name == Routes.checkoutAddress,
    );
    shippingAddressBloc.add(ShippingAddressInitialized());
    Future.delayed(Duration(milliseconds: 500), () {
      shippingAddressBloc.add(ShippingAddressLoaded(token: user.token));
    });
  }

  void _onLoadedSuccess(List<AddressEntity> list) {
    addresses = list;
    for (int i = 0; i < addresses.length; i++) {
      if (addresses[i].defaultShippingAddress == 1) {
        defaultAddress = addresses[i];
      }
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    pageStyle = PageStyle(context, designWidth, designHeight);
    pageStyle.initializePageStyles();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: MarkaaCheckoutAppBar(pageStyle: pageStyle, currentIndex: 0),
      body: SingleChildScrollView(
        child: Column(
          children: [
            if (addresses.isEmpty) ...[_buildListener()],
            if (defaultAddress != null) ...[_buildSelectedAddress()],
            if (addresses.isEmpty) ...[_buildNoAddress()],
            if (defaultAddress == null && addresses.isNotEmpty) ...[
              SizedBox(height: pageStyle.unitHeight * 50)
            ],
            if (defaultAddress != null) ...[
              _buildChangeAddressButton()
            ] else if (addresses.isNotEmpty) ...[
              _buildSelectAddressButton()
            ] else ...[
              _buildCreateAddressButton()
            ],
            _buildNote(),
            _buildToolbarButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildListener() {
    return BlocListener<ShippingAddressBloc, ShippingAddressState>(
      listener: (context, state) {
        if (state is ShippingAddressAddedSuccess) {
          _onAddedSuccess();
        }
        if (state is ShippingAddressLoadedSuccess) {
          _onLoadedSuccess(state.addresses);
        }
      },
      child: Container(),
    );
  }

  Widget _buildNoAddress() {
    return Container(
      width: pageStyle.deviceWidth,
      padding: EdgeInsets.symmetric(vertical: pageStyle.unitHeight * 20),
      child: Column(
        children: [
          SvgPicture.asset(addressIcon),
          SizedBox(height: pageStyle.unitHeight * 10),
          Text(
            'no_saved_addresses'.tr(),
            style: mediumTextStyle.copyWith(
              fontSize: pageStyle.unitFontSize * 12,
              color: greyDarkColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSelectedAddress() {
    return Container(
      width: pageStyle.deviceWidth,
      margin: EdgeInsets.symmetric(
        horizontal: pageStyle.unitWidth * 10,
        vertical: pageStyle.unitHeight * 15,
      ),
      padding: EdgeInsets.symmetric(
        horizontal: pageStyle.unitWidth * 20,
        vertical: pageStyle.unitHeight * 15,
      ),
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            defaultAddress.title,
            style: mediumTextStyle.copyWith(
              color: primaryColor,
              fontSize: pageStyle.unitFontSize * 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: pageStyle.unitHeight * 6),
          Text(
            defaultAddress.country,
            style: mediumTextStyle.copyWith(
              color: greyDarkColor,
              fontSize: pageStyle.unitFontSize * 14,
            ),
          ),
          SizedBox(height: pageStyle.unitHeight * 6),
          Text(
            defaultAddress.city,
            style: mediumTextStyle.copyWith(
              color: greyDarkColor,
              fontSize: pageStyle.unitFontSize * 14,
            ),
          ),
          SizedBox(height: pageStyle.unitHeight * 6),
          Text(
            defaultAddress.street,
            style: mediumTextStyle.copyWith(
              color: greyDarkColor,
              fontSize: pageStyle.unitFontSize * 14,
            ),
          ),
          SizedBox(height: pageStyle.unitHeight * 6),
          Text(
            'phone_number_hint'.tr() + ': ' + defaultAddress.phoneNumber,
            style: mediumTextStyle.copyWith(
              color: greyDarkColor,
              fontSize: pageStyle.unitFontSize * 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChangeAddressButton() {
    return Container(
      width: pageStyle.deviceWidth,
      height: pageStyle.unitHeight * 50,
      padding: EdgeInsets.symmetric(horizontal: pageStyle.unitWidth * 10),
      child: MarkaaTextIconButton(
        title: 'checkout_change_address_button_title'.tr(),
        titleSize: pageStyle.unitFontSize * 14,
        titleColor: greyColor,
        buttonColor: greyLightColor,
        borderColor: Colors.transparent,
        icon: SvgPicture.asset(selectAddrIcon),
        onPressed: () => _onChangeAddress(),
        radius: 0,
        pageStyle: pageStyle,
      ),
    );
  }

  Widget _buildSelectAddressButton() {
    return Container(
      width: pageStyle.deviceWidth,
      height: pageStyle.unitHeight * 50,
      padding: EdgeInsets.symmetric(horizontal: pageStyle.unitWidth * 10),
      child: MarkaaTextIconButton(
        title: 'checkout_select_address_button_title'.tr(),
        titleSize: pageStyle.unitFontSize * 14,
        titleColor: greyColor,
        buttonColor: greyLightColor,
        borderColor: Colors.transparent,
        icon: SvgPicture.asset(selectAddrIcon),
        onPressed: () => _onChangeAddress(),
        radius: 0,
        pageStyle: pageStyle,
      ),
    );
  }

  Widget _buildCreateAddressButton() {
    return Container(
      width: pageStyle.deviceWidth,
      height: pageStyle.unitHeight * 50,
      padding: EdgeInsets.symmetric(horizontal: pageStyle.unitWidth * 10),
      child: MarkaaTextIconButton(
        title: 'create_address_button_title'.tr(),
        titleSize: pageStyle.unitFontSize * 14,
        titleColor: greyColor,
        buttonColor: greyLightColor,
        borderColor: Colors.transparent,
        icon: SvgPicture.asset(selectAddrIcon),
        onPressed: () => Navigator.pushNamed(context, Routes.editAddress),
        radius: 0,
        pageStyle: pageStyle,
      ),
    );
  }

  Widget _buildNote() {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: pageStyle.unitWidth * 10,
        vertical: pageStyle.unitHeight * 20,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'checkout_note_title'.tr(),
            style: mediumTextStyle.copyWith(
              color: greyDarkColor,
              fontSize: pageStyle.unitFontSize * 17,
            ),
          ),
          Container(
            width: double.infinity,
            child: TextFormField(
              controller: noteController,
              style: mediumTextStyle.copyWith(
                color: greyColor,
                fontSize: pageStyle.unitFontSize * 14,
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
      width: pageStyle.unitWidth * 210,
      child: MarkaaTextButton(
        title: 'checkout_continue_shipping_button_title'.tr(),
        titleSize: pageStyle.unitFontSize * 12,
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
    if (defaultAddress != null) {
      progressService.showProgress();
      String cartId;
      if (widget.reorder != null) {
        cartId = myCartChangeNotifier.reorderCartId;
      } else {
        cartId = myCartChangeNotifier.cartId;
      }
      orderDetails['shipping'] = shippingMethodId;
      orderDetails['cartId'] = cartId;
      double totalPrice = 0;
      double subtotalPrice = 0;
      if (widget.reorder != null) {
        subtotalPrice = myCartChangeNotifier.reorderCartTotalPrice;
      } else {
        subtotalPrice = myCartChangeNotifier.cartTotalPrice;
      }
      totalPrice = subtotalPrice + serviceFees;
      orderDetails['orderDetails'] = {};
      orderDetails['orderDetails']['totalPrice'] = totalPrice.toString();
      orderDetails['orderDetails']['subTotalPrice'] = subtotalPrice.toString();
      orderDetails['orderDetails']['fees'] = serviceFees.toString();
      orderDetails['token'] = user.token;
      orderDetails['orderAddress'] = json.encode({
        'customer_address_id': defaultAddress.addressId,
        'firstname': defaultAddress.firstName,
        'lastname': defaultAddress.lastName,
        'email': defaultAddress.email ?? user.email,
        'region': defaultAddress.region,
        'street': defaultAddress.street,
        'country_id': defaultAddress.countryId,
        'city': defaultAddress.city,
        'company': defaultAddress.company,
        'postcode': defaultAddress.postCode,
        'telephone': defaultAddress.phoneNumber,
        'save_in_address_book': '0',
        'prefix': defaultAddress.title,
      });
      progressService.hideProgress();
      Navigator.pushNamed(
        context,
        Routes.checkoutPayment,
        arguments: widget.reorder,
      );
    } else {
      flushBarService.showErrorMessage(
        pageStyle,
        'required_address_title'.tr(),
      );
    }
  }
}
