import 'dart:convert';

import 'package:ciga/src/components/ciga_checkout_app_bar.dart';
import 'package:ciga/src/components/ciga_country_input.dart';
import 'package:ciga/src/components/ciga_text_input.dart';
import 'package:ciga/src/config/config.dart';
import 'package:ciga/src/data/mock/mock.dart';
import 'package:ciga/src/pages/my_account/shipping_address/bloc/shipping_address_bloc.dart';
import 'package:ciga/src/pages/my_account/shipping_address/widgets/select_country_dialog.dart';
import 'package:ciga/src/routes/routes.dart';
import 'package:ciga/src/theme/theme.dart';
import 'package:ciga/src/utils/flushbar_service.dart';
import 'package:ciga/src/utils/progress_service.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:isco_custom_widgets/isco_custom_widgets.dart';

class CheckoutAddressPage extends StatefulWidget {
  @override
  _CheckoutAddressPageState createState() => _CheckoutAddressPageState();
}

class _CheckoutAddressPageState extends State<CheckoutAddressPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  PageStyle pageStyle;
  FlushBarService flushBarService;
  ProgressService progressService;
  ShippingAddressBloc shippingAddressBloc;
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController countryController = TextEditingController();
  TextEditingController stateController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController streetController = TextEditingController();
  TextEditingController zipCodeController = TextEditingController();
  PhoneNumber phoneNumber;
  String countryId;

  @override
  void initState() {
    super.initState();
    flushBarService = FlushBarService(context: context);
    progressService = ProgressService(context: context);
    shippingAddressBloc = context.bloc<ShippingAddressBloc>();
    phoneNumber = PhoneNumber(dialCode: '+965', isoCode: 'KW');
    firstNameController.text = user.firstName;
    lastNameController.text = user.lastName;
    emailController.text = user.email;
    _initForm();
  }

  @override
  Widget build(BuildContext context) {
    pageStyle = PageStyle(context, designWidth, designHeight);
    pageStyle.initializePageStyles();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CigaCheckoutAppBar(pageStyle: pageStyle, currentIndex: 0),
      body: BlocConsumer<ShippingAddressBloc, ShippingAddressState>(
        listener: (context, state) {
          if (state is ShippingAddressAddedInProcess) {
            progressService.showProgress();
          }
          if (state is ShippingAddressAddedSuccess) {
            progressService.hideProgress();
            flushBarService.showSuccessMessage(
              pageStyle,
              'Address added successfully',
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
          CigaTextInput(
            controller: firstNameController,
            width: pageStyle.deviceWidth,
            padding: pageStyle.unitWidth * 10,
            fontSize: pageStyle.unitFontSize * 14,
            hint: 'first_name'.tr(),
            validator: (value) => value.isEmpty ? 'required_field'.tr() : null,
            inputType: TextInputType.text,
            readOnly: true,
          ),
          CigaTextInput(
            controller: lastNameController,
            width: pageStyle.deviceWidth,
            padding: pageStyle.unitWidth * 10,
            fontSize: pageStyle.unitFontSize * 14,
            hint: 'last_name'.tr(),
            validator: (value) => value.isEmpty ? 'required_field'.tr() : null,
            inputType: TextInputType.text,
            readOnly: true,
          ),
          CigaTextInput(
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
          //     textStyle: bookTextStyle.copyWith(
          //       fontSize: pageStyle.unitFontSize * 14,
          //     ),
          //     textFieldController: phoneNumberController,
          //     selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
          //   ),
          // ),
          CigaTextInput(
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
          // _buildSearchingAddressButton(),
          // SizedBox(height: pageStyle.unitHeight * 5),
          _buildSelectAddressButton(),
          SizedBox(height: pageStyle.unitHeight * 20),
          CigaCountryInput(
            controller: countryController,
            countryCode: countryId,
            width: pageStyle.deviceWidth,
            padding: pageStyle.unitWidth * 10,
            fontSize: pageStyle.unitFontSize * 14,
            hint: 'country'.tr(),
            validator: (value) => value.isEmpty ? 'required_field'.tr() : null,
            inputType: TextInputType.text,
            readOnly: true,
            onTap: () => _onSelectCountry(),
            pageStyle: pageStyle,
          ),
          CigaTextInput(
            controller: stateController,
            width: pageStyle.deviceWidth,
            padding: pageStyle.unitWidth * 10,
            fontSize: pageStyle.unitFontSize * 14,
            hint: 'checkout_state_hint'.tr(),
            validator: (value) => value.isEmpty ? 'required_field'.tr() : null,
            inputType: TextInputType.text,
          ),
          CigaTextInput(
            controller: streetController,
            width: pageStyle.deviceWidth,
            padding: pageStyle.unitWidth * 10,
            fontSize: pageStyle.unitFontSize * 14,
            hint: 'checkout_street_name_hint'.tr(),
            validator: (value) => value.isEmpty ? 'required_field'.tr() : null,
            inputType: TextInputType.text,
          ),
          CigaTextInput(
            controller: zipCodeController,
            width: pageStyle.deviceWidth,
            padding: pageStyle.unitWidth * 10,
            fontSize: pageStyle.unitFontSize * 14,
            hint: 'checkout_zip_code_hint'.tr(),
            validator: (value) => value.isEmpty ? 'required_field'.tr() : null,
            inputType: TextInputType.number,
          ),
          SizedBox(height: pageStyle.unitHeight * 30),
          _buildToolbarButtons(),
          SizedBox(height: pageStyle.unitHeight * 20),
        ],
      ),
    );
  }

  // Widget _buildSearchingAddressButton() {
  //   return Container(
  //     width: pageStyle.deviceWidth,
  //     height: pageStyle.unitHeight * 50,
  //     padding: EdgeInsets.symmetric(horizontal: pageStyle.unitWidth * 10),
  //     child: TextButton(
  //       title: 'checkout_searching_address_button_title'.tr(),
  //       titleSize: pageStyle.unitFontSize * 12,
  //       titleColor: greyDarkColor,
  //       buttonColor: greyLightColor,
  //       borderColor: Colors.transparent,
  //       onPressed: () => Navigator.pushNamed(context, Routes.searchAddress),
  //       radius: 0,
  //     ),
  //   );
  // }

  Widget _buildSelectAddressButton() {
    return Container(
      width: pageStyle.deviceWidth,
      height: pageStyle.unitHeight * 50,
      padding: EdgeInsets.symmetric(horizontal: pageStyle.unitWidth * 10),
      child: TextButton(
        title: 'checkout_select_address_button_title'.tr(),
        titleSize: pageStyle.unitFontSize * 12,
        titleColor: greyDarkColor,
        buttonColor: greyLightColor,
        borderColor: Colors.transparent,
        onPressed: () => _onSelectAddress(),
        radius: 0,
      ),
    );
  }

  Widget _buildToolbarButtons() {
    return Container(
      width: pageStyle.deviceWidth,
      height: pageStyle.unitHeight * 50,
      padding: EdgeInsets.symmetric(horizontal: pageStyle.unitWidth * 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: pageStyle.unitWidth * 150,
            child: TextButton(
              title: 'checkout_save_address_button_title'.tr(),
              titleSize: pageStyle.unitFontSize * 12,
              titleColor: greyDarkColor,
              buttonColor: greyLightColor,
              borderColor: Colors.transparent,
              onPressed: () => _onSaveAddress(),
              radius: 30,
            ),
          ),
          Container(
            width: pageStyle.unitWidth * 197,
            child: TextButton(
              title: 'checkout_continue_shipping_button_title'.tr(),
              titleSize: pageStyle.unitFontSize * 12,
              titleColor: Colors.white,
              buttonColor: primaryColor,
              borderColor: Colors.transparent,
              onPressed: () => _onContinue(),
              radius: 30,
            ),
          ),
        ],
      ),
    );
  }

  void _initForm() {
    countryController.text = defaultAddress?.country;
    countryId = defaultAddress?.countryId;
    stateController.text = defaultAddress?.region;
    cityController.text = defaultAddress?.city;
    streetController.text = defaultAddress?.street;
    zipCodeController.text = defaultAddress?.zipCode;
    phoneNumberController.text = defaultAddress?.phoneNumber;
  }

  void _onSelectAddress() async {
    await Navigator.pushNamed(context, Routes.shippingAddress);
    _initForm();
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
    }
  }

  void _onSaveAddress() {
    shippingAddressBloc.add(ShippingAddressAdded(
      token: user.token,
      countryId: countryId,
      region: '',
      firstName: firstNameController.text,
      lastName: lastNameController.text,
      city: cityController.text,
      streetName: streetController.text,
      zipCode: zipCodeController.text,
      phone: phoneNumberController.text,
    ));
  }

  void _onContinue() {
    if (_formKey.currentState.validate()) {
      orderDetails['token'] = user.token;
      orderDetails['orderAddress'] = json.encode({
        'firstname': firstNameController.text,
        'lastname': lastNameController.text,
        'city': cityController.text,
        'street': streetController.text,
        'country_id': countryId,
        'region': '',
        'postcode': zipCodeController.text,
        'telephone': phoneNumberController.text,
        'save_in_address_book': '0',
      });
      Navigator.pushNamed(context, Routes.checkoutShipping);
    }
  }
}
