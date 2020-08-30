import 'package:ciga/src/components/ciga_checkout_app_bar.dart';
import 'package:ciga/src/components/ciga_text_input.dart';
import 'package:ciga/src/config/config.dart';
import 'package:ciga/src/routes/routes.dart';
import 'package:ciga/src/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:isco_custom_widgets/isco_custom_widgets.dart';

class CheckoutAddressPage extends StatefulWidget {
  @override
  _CheckoutAddressPageState createState() => _CheckoutAddressPageState();
}

class _CheckoutAddressPageState extends State<CheckoutAddressPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  PageStyle pageStyle;

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

  @override
  Widget build(BuildContext context) {
    pageStyle = PageStyle(context, designWidth, designHeight);
    pageStyle.initializePageStyles();
    return Scaffold(
      appBar: CigaCheckoutAppBar(pageStyle: pageStyle, currentIndex: 0),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              CigaTextInput(
                controller: firstNameController,
                width: pageStyle.deviceWidth,
                padding: pageStyle.unitWidth * 10,
                fontSize: pageStyle.unitFontSize * 14,
                hint: 'First Name',
                validator: (value) => null,
                inputType: TextInputType.text,
              ),
              CigaTextInput(
                controller: lastNameController,
                width: pageStyle.deviceWidth,
                padding: pageStyle.unitWidth * 10,
                fontSize: pageStyle.unitFontSize * 14,
                hint: 'Last Name',
                validator: (value) => null,
                inputType: TextInputType.text,
              ),
              Container(
                width: pageStyle.deviceWidth,
                padding: EdgeInsets.symmetric(
                  horizontal: pageStyle.unitWidth * 10,
                ),
                child: InternationalPhoneNumberInput(
                  onInputChanged: (value) {
                    phoneNumber = value;
                  },
                  initialValue: phoneNumber,
                  ignoreBlank: false,
                  autoValidate: false,
                  hintText: 'Phone Number',
                  errorMessage: "",
                  textFieldController: phoneNumberController,
                  selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
                ),
              ),
              CigaTextInput(
                controller: emailController,
                width: pageStyle.deviceWidth,
                padding: pageStyle.unitWidth * 10,
                fontSize: pageStyle.unitFontSize * 14,
                hint: 'Email',
                validator: (value) => null,
                inputType: TextInputType.emailAddress,
              ),
              SizedBox(height: pageStyle.unitHeight * 30),
              _buildSearchingAddressButton(),
              SizedBox(height: pageStyle.unitHeight * 5),
              _buildSelectAddressButton(),
              SizedBox(height: pageStyle.unitHeight * 20),
              CigaTextInput(
                controller: countryController,
                width: pageStyle.deviceWidth,
                padding: pageStyle.unitWidth * 10,
                fontSize: pageStyle.unitFontSize * 14,
                hint: 'Country',
                validator: (value) => null,
                inputType: TextInputType.text,
              ),
              CigaTextInput(
                controller: stateController,
                width: pageStyle.deviceWidth,
                padding: pageStyle.unitWidth * 10,
                fontSize: pageStyle.unitFontSize * 14,
                hint: 'State / Province',
                validator: (value) => null,
                inputType: TextInputType.text,
              ),
              CigaTextInput(
                controller: streetController,
                width: pageStyle.deviceWidth,
                padding: pageStyle.unitWidth * 10,
                fontSize: pageStyle.unitFontSize * 14,
                hint: 'Street Name',
                validator: (value) => null,
                inputType: TextInputType.text,
              ),
              CigaTextInput(
                controller: zipCodeController,
                width: pageStyle.deviceWidth,
                padding: pageStyle.unitWidth * 10,
                fontSize: pageStyle.unitFontSize * 14,
                hint: 'Zip - Code',
                validator: (value) => null,
                inputType: TextInputType.number,
              ),
              SizedBox(height: pageStyle.unitHeight * 30),
              _buildToolbarButtons(),
              SizedBox(height: pageStyle.unitHeight * 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchingAddressButton() {
    return Container(
      width: pageStyle.deviceWidth,
      height: pageStyle.unitHeight * 50,
      padding: EdgeInsets.symmetric(horizontal: pageStyle.unitWidth * 10),
      child: TextButton(
        title: 'SEARCHING ADDRESS',
        titleSize: pageStyle.unitFontSize * 14,
        titleColor: greyDarkColor,
        buttonColor: greyLightColor,
        borderColor: Colors.transparent,
        onPressed: () => null,
        radius: 0,
      ),
    );
  }

  Widget _buildSelectAddressButton() {
    return Container(
      width: pageStyle.deviceWidth,
      height: pageStyle.unitHeight * 50,
      padding: EdgeInsets.symmetric(horizontal: pageStyle.unitWidth * 10),
      child: TextButton(
        title: 'SELECT ADDRESS',
        titleSize: pageStyle.unitFontSize * 14,
        titleColor: greyDarkColor,
        buttonColor: greyLightColor,
        borderColor: Colors.transparent,
        onPressed: () => null,
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
              title: 'SAVE ADDRESS',
              titleSize: pageStyle.unitFontSize * 14,
              titleColor: greyDarkColor,
              buttonColor: greyLightColor,
              borderColor: Colors.transparent,
              onPressed: () => null,
              radius: 30,
            ),
          ),
          Container(
            width: pageStyle.unitWidth * 197,
            child: TextButton(
              title: 'CONTINUE TO SHIPPING',
              titleSize: pageStyle.unitFontSize * 14,
              titleColor: Colors.white,
              buttonColor: primaryColor,
              borderColor: Colors.transparent,
              onPressed: () => Navigator.pushNamed(
                context,
                Routes.checkoutShipping,
              ),
              radius: 30,
            ),
          ),
        ],
      ),
    );
  }
}
