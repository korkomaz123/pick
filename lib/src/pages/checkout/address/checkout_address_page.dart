import 'dart:convert';

import 'package:markaa/src/components/markaa_checkout_app_bar.dart';
import 'package:markaa/src/components/markaa_country_input.dart';
import 'package:markaa/src/components/markaa_text_button.dart';
import 'package:markaa/src/components/markaa_text_icon_button.dart';
import 'package:markaa/src/components/markaa_text_input.dart';
import 'package:markaa/src/config/config.dart';
import 'package:markaa/src/data/mock/mock.dart';
import 'package:markaa/src/data/models/address_entity.dart';
import 'package:markaa/src/data/models/order_entity.dart';
import 'package:markaa/src/data/models/region_entity.dart';
import 'package:markaa/src/pages/my_account/shipping_address/bloc/shipping_address_bloc.dart';
import 'package:markaa/src/pages/my_account/shipping_address/widgets/select_country_dialog.dart';
import 'package:markaa/src/pages/my_account/shipping_address/widgets/select_region_dialog.dart';
import 'package:markaa/src/pages/my_cart/bloc/my_cart_repository.dart';
import 'package:markaa/src/routes/routes.dart';
import 'package:markaa/src/theme/icons.dart';
import 'package:markaa/src/theme/styles.dart';
import 'package:markaa/src/theme/theme.dart';
import 'package:markaa/src/utils/flushbar_service.dart';
import 'package:markaa/src/utils/local_storage_repository.dart';
import 'package:markaa/src/utils/progress_service.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:isco_custom_widgets/isco_custom_widgets.dart';

import 'widgets/checkout_add_address_title_dialog.dart';

class CheckoutAddressPage extends StatefulWidget {
  final OrderEntity reorder;

  CheckoutAddressPage({this.reorder});

  @override
  _CheckoutAddressPageState createState() => _CheckoutAddressPageState();
}

class _CheckoutAddressPageState extends State<CheckoutAddressPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  PageStyle pageStyle;
  FlushBarService flushBarService;
  ProgressService progressService;
  // ShippingAddressBloc shippingAddressBloc;
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
  PhoneNumber phoneNumber;
  String countryId;
  String regionId;
  bool isSave;
  String shippingMethodId;
  double serviceFees;
  LocalStorageRepository localRepo;
  MyCartRepository cartRepo;

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
    localRepo = context.read<LocalStorageRepository>();
    cartRepo = context.read<MyCartRepository>();
    flushBarService = FlushBarService(context: context);
    progressService = ProgressService(context: context);
    // shippingAddressBloc = context.read<ShippingAddressBloc>();
    phoneNumber = PhoneNumber(dialCode: '+965', isoCode: 'KW');
    firstNameController.text = user.firstName;
    lastNameController.text = user.lastName;
    emailController.text = user.email;
    isSave = false;
    _initForm();
  }

  @override
  Widget build(BuildContext context) {
    pageStyle = PageStyle(context, designWidth, designHeight);
    pageStyle.initializePageStyles();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: MarkaaCheckoutAppBar(pageStyle: pageStyle, currentIndex: 0),
      body: BlocConsumer<ShippingAddressBloc, ShippingAddressState>(
        listener: (context, state) {
          if (state is ShippingAddressAddedInProcess) {
            progressService.showProgress();
          }
          if (state is ShippingAddressAddedSuccess) {
            progressService.hideProgress();
            flushBarService.showSuccessMessage(
              pageStyle,
              'success'.tr(),
            );
          }
          if (state is ShippingAddressAddedFailure) {
            progressService.hideProgress();
            flushBarService.showErrorMessage(pageStyle, state.message);
          }
        },
        builder: (context, state) {
          return SingleChildScrollView(
            child: _buildForm(),
          );
        },
      ),
    );
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          MarkaaTextInput(
            controller: firstNameController,
            width: pageStyle.deviceWidth,
            padding: pageStyle.unitWidth * 10,
            fontSize: pageStyle.unitFontSize * 14,
            hint: 'first_name'.tr(),
            validator: (value) => value.isEmpty ? 'required_field'.tr() : null,
            inputType: TextInputType.text,
            readOnly: true,
          ),
          MarkaaTextInput(
            controller: lastNameController,
            width: pageStyle.deviceWidth,
            padding: pageStyle.unitWidth * 10,
            fontSize: pageStyle.unitFontSize * 14,
            hint: 'last_name'.tr(),
            validator: (value) => value.isEmpty ? 'required_field'.tr() : null,
            inputType: TextInputType.text,
            readOnly: true,
          ),
          MarkaaTextInput(
            controller: phoneNumberController,
            width: pageStyle.deviceWidth,
            padding: pageStyle.unitWidth * 10,
            fontSize: pageStyle.unitFontSize * 14,
            hint: 'phone_number_hint'.tr(),
            validator: (value) => value.isEmpty ? 'required_field'.tr() : null,
            inputType: TextInputType.phone,
          ),
          // Container(
          //   width: pageStyle.deviceWidth,
          //   padding: EdgeInsets.symmetric(
          //     horizontal: pageStyle.unitWidth * 10,
          //   ),
          //   child: InternationalPhoneNumberInput(
          //     onInputChanged: (value) {
          //       phoneNumber = value;
          //     },
          //     initialValue: phoneNumber,
          //     ignoreBlank: false,
          //     autoValidate: false,
          //     hintText: 'phone_number_hint'.tr(),
          //     errorMessage: "",
          //     textStyle: mediumTextStyle.copyWith(
          //       fontSize: pageStyle.unitFontSize * 14,
          //     ),
          //     textFieldController: phoneNumberController,
          //     selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
          //   ),
          // ),
          MarkaaTextInput(
            controller: emailController,
            width: pageStyle.deviceWidth,
            padding: pageStyle.unitWidth * 10,
            fontSize: pageStyle.unitFontSize * 14,
            hint: 'email_hint'.tr(),
            validator: (value) => value.isEmpty ? 'required_field'.tr() : null,
            inputType: TextInputType.emailAddress,
            readOnly: true,
          ),
          SizedBox(height: pageStyle.unitHeight * 30),
          _buildSearchingAddressButton(),
          SizedBox(height: pageStyle.unitHeight * 5),
          _buildSelectAddressButton(),
          SizedBox(height: pageStyle.unitHeight * 20),
          MarkaaCountryInput(
            controller: countryController,
            countryCode: countryId,
            width: pageStyle.deviceWidth,
            padding: pageStyle.unitWidth * 10,
            fontSize: pageStyle.unitFontSize * 14,
            hint: 'checkout_country_hint'.tr(),
            validator: (value) => value.isEmpty ? 'required_field'.tr() : null,
            inputType: TextInputType.text,
            readOnly: true,
            onTap: () => _onSelectCountry(),
            pageStyle: pageStyle,
          ),
          MarkaaTextInput(
            controller: stateController,
            width: pageStyle.deviceWidth,
            padding: pageStyle.unitWidth * 10,
            fontSize: pageStyle.unitFontSize * 14,
            hint: 'checkout_state_hint'.tr(),
            validator: (value) => value.isEmpty ? 'required_field'.tr() : null,
            inputType: TextInputType.text,
            readOnly: true,
            onTap: () => _onSelectState(),
          ),
          MarkaaTextInput(
            controller: companyController,
            width: pageStyle.deviceWidth,
            padding: pageStyle.unitWidth * 10,
            fontSize: pageStyle.unitFontSize * 14,
            hint: 'checkout_company_hint'.tr(),
            validator: (value) => value.isEmpty ? 'required_field'.tr() : null,
            inputType: TextInputType.text,
          ),
          MarkaaTextInput(
            controller: streetController,
            width: pageStyle.deviceWidth,
            padding: pageStyle.unitWidth * 10,
            fontSize: pageStyle.unitFontSize * 14,
            hint: 'checkout_street_name_hint'.tr(),
            validator: (value) => value.isEmpty ? 'required_field'.tr() : null,
            inputType: TextInputType.text,
          ),
          MarkaaTextInput(
            controller: cityController,
            width: pageStyle.deviceWidth,
            padding: pageStyle.unitWidth * 10,
            fontSize: pageStyle.unitFontSize * 14,
            hint: 'checkout_city_hint'.tr(),
            validator: (value) => null,
            inputType: TextInputType.text,
          ),

          MarkaaTextInput(
            controller: zipCodeController,
            width: pageStyle.deviceWidth,
            padding: pageStyle.unitWidth * 10,
            fontSize: pageStyle.unitFontSize * 14,
            hint: 'checkout_zip_code_hint'.tr(),
            validator: (value) => null,
            inputType: TextInputType.number,
          ),
          SizedBox(height: pageStyle.unitHeight * 30),
          _buildSaveAddressCheckbox(),
          SizedBox(height: pageStyle.unitHeight * 10),
          _buildToolbarButtons(),
          SizedBox(height: pageStyle.unitHeight * 20),
        ],
      ),
    );
  }

  Widget _buildSearchingAddressButton() {
    return Container(
      width: pageStyle.deviceWidth,
      height: pageStyle.unitHeight * 50,
      padding: EdgeInsets.symmetric(horizontal: pageStyle.unitWidth * 10),
      child: MarkaaTextIconButton(
        title: 'checkout_searching_address_button_title'.tr(),
        titleSize: pageStyle.unitFontSize * 14,
        titleColor: greyColor,
        buttonColor: greyLightColor,
        borderColor: Colors.transparent,
        icon: SvgPicture.asset(searchAddrIcon),
        onPressed: () => _onSearchAddress(),
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
        onPressed: () => _onSelectAddress(),
        radius: 0,
        pageStyle: pageStyle,
      ),
    );
  }

  Widget _buildSaveAddressCheckbox() {
    return Container(
      width: double.infinity,
      child: InkWell(
        onTap: () => setState(() {
          isSave = !isSave;
        }),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(isSave ? selectedIcon : unSelectedIcon),
            SizedBox(width: pageStyle.unitWidth * 10),
            Text(
              'checkout_save_address_button_title'.tr(),
              style: mediumTextStyle.copyWith(
                color: greyColor,
                fontSize: pageStyle.unitFontSize * 12,
              ),
            ),
          ],
        ),
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

  void _initForm([AddressEntity selectedAddress]) {
    countryController.clear();
    countryId = null;
    stateController.clear();
    cityController.clear();
    streetController.clear();
    zipCodeController.clear();
    companyController.clear();
    phoneNumberController.clear();
    if (selectedAddress == null) {
      selectedAddress = defaultAddress;
    }
    countryController.text = selectedAddress?.country;
    countryId = selectedAddress?.countryId;
    stateController.text = selectedAddress?.region;
    cityController.text = selectedAddress?.city;
    streetController.text = selectedAddress?.street;
    zipCodeController.text = selectedAddress?.zipCode;
    companyController.text = selectedAddress?.company;
    phoneNumberController.text = selectedAddress?.phoneNumber;
    setState(() {});
  }

  void _onSelectAddress() async {
    final result = await Navigator.pushNamed(
      context,
      Routes.shippingAddress,
      arguments: true,
    );
    if (result != null) {
      _initForm(result as AddressEntity);
    }
  }

  void _onSearchAddress() async {
    final result = await Navigator.pushNamed(context, Routes.searchAddress);
    if (result != null) {
      _initForm(result as AddressEntity);
    }
  }

  void _onSelectCountry() async {
    final result = await showDialog(
      context: context,
      builder: (context) {
        return SelectCountryDialog(pageStyle: pageStyle, value: countryId);
      },
    );
    if (result != null) {
      countryId = result['code'];
      countryController.text = result['name'];
      setState(() {});
    }
  }

  // void _onSaveAddress() {
  //   if (_formKey.currentState.validate()) {
  //     shippingAddressBloc.add(ShippingAddressAdded(
  //       token: user.token,
  //       countryId: countryId,
  //       region: '',
  //       firstName: firstNameController.text,
  //       lastName: lastNameController.text,
  //       city: cityController.text,
  //       streetName: streetController.text,
  //       zipCode: zipCodeController.text,
  //       phone: phoneNumberController.text,
  //     ));
  //   }
  // }

  void _onContinue() async {
    if (_formKey.currentState.validate()) {
      String addressTitle = '';
      if (isSave) {
        final result = await showDialog(
          context: context,
          builder: (context) {
            return CheckoutAddAddressTitleDialog(
              pageStyle: pageStyle,
            );
          },
        );
        if (result != null) {
          addressTitle = result;
        }
      }
      if (!isSave || addressTitle.isNotEmpty) {
        progressService.showProgress();
        String cartId;
        if (widget.reorder != null) {
          cartId = await localRepo.getItem('reorderCartId');
        } else {
          final result = await cartRepo.getCartId(user.token);
          if (result['code'] == 'SUCCESS') {
            cartId = result['cartId'];
          }
        }
        orderDetails['shipping'] = shippingMethodId;
        orderDetails['cartId'] = cartId;
        double totalPrice = 0;
        double subtotalPrice = 0;
        if (widget.reorder != null) {
          for (int i = 0; i < reorderCartItems.length; i++) {
            subtotalPrice += reorderCartItems[i].rowPrice;
          }
        } else {
          for (int i = 0; i < myCartItems.length; i++) {
            subtotalPrice += myCartItems[i].rowPrice;
          }
        }

        totalPrice = subtotalPrice + serviceFees;
        orderDetails['orderDetails'] = {};
        orderDetails['orderDetails']['totalPrice'] = totalPrice.toString();
        orderDetails['orderDetails']['subTotalPrice'] =
            subtotalPrice.toString();
        orderDetails['orderDetails']['fees'] = serviceFees.toString();
        orderDetails['token'] = user.token;
        orderDetails['orderAddress'] = json.encode({
          'firstname': firstNameController.text,
          'lastname': lastNameController.text,
          'email': emailController.text,
          'region': stateController.text,
          'street': streetController.text,
          'country_id': countryId,
          'city': cityController.text,
          'company': companyController.text,
          'postcode': zipCodeController.text,
          'telephone': phoneNumberController.text,
          'save_in_address_book': '${isSave ? 1 : 0}',
          'prefix': addressTitle,
        });
        progressService.hideProgress();
        Navigator.pushNamed(
          context,
          Routes.checkoutPayment,
          arguments: widget.reorder,
        );
      }
    }
  }

  void _onSelectState() async {
    final result = await showDialog(
      context: context,
      builder: (context) {
        return SelectRegionDialog(pageStyle: pageStyle, value: regionId);
      },
    );
    if (result != null) {
      RegionEntity selectedRegion = result as RegionEntity;
      regionId = selectedRegion.regionId;
      stateController.text = selectedRegion.defaultName;
      setState(() {});
    }
  }
}
