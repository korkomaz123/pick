import 'package:ciga/src/components/ciga_app_bar%20copy.dart';
import 'package:ciga/src/config/config.dart';
import 'package:ciga/src/data/models/enum.dart';
import 'package:ciga/src/theme/styles.dart';
import 'package:ciga/src/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:isco_custom_widgets/isco_custom_widgets.dart';

class CheckoutAddressPage extends StatefulWidget {
  @override
  _CheckoutAddressPageState createState() => _CheckoutAddressPageState();
}

class _CheckoutAddressPageState extends State<CheckoutAddressPage> {
  PageStyle pageStyle;
  TextEditingController noteController = TextEditingController();
  PaymentEnum payment;

  @override
  Widget build(BuildContext context) {
    pageStyle = PageStyle(context, designWidth, designHeight);
    pageStyle.initializePageStyles();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CigaCheckoutAppBar(pageStyle: pageStyle),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: pageStyle.unitWidth * 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: pageStyle.unitHeight * 30),
              Text(
                'Thank You',
                style: boldTextStyle.copyWith(
                  color: primaryColor,
                  fontSize: pageStyle.unitFontSize * 34,
                ),
              ),
              Container(
                width: double.infinity,
                margin: EdgeInsets.symmetric(
                  vertical: pageStyle.unitHeight * 10,
                ),
                padding: EdgeInsets.symmetric(
                  horizontal: pageStyle.unitWidth * 20,
                  vertical: pageStyle.unitWidth * 10,
                ),
                color: greyLightColor,
                child: Text(
                  'It\'s ordered!\nOrder No. #32212',
                  style: bookTextStyle.copyWith(
                    color: greyColor,
                    fontSize: pageStyle.unitFontSize * 14,
                  ),
                ),
              ),
              SizedBox(height: pageStyle.unitHeight * 20),
              Text(
                'You\'ve successfully placed the order',
                style: bookTextStyle.copyWith(
                  color: greyColor,
                  fontSize: pageStyle.unitFontSize * 17,
                ),
              ),
              SizedBox(height: pageStyle.unitHeight * 20),
              Padding(
                padding: EdgeInsets.only(left: pageStyle.unitWidth * 8),
                child: Text(
                  '''You can check status of your order by using our
Delivery status feature. You will receive an order
Confirmation e-mail with details cf your order and 
a link to track its progress.''',
                  style: bookTextStyle.copyWith(
                    color: greyColor,
                    fontSize: pageStyle.unitFontSize * 14,
                  ),
                ),
              ),
              _buildShowAllMyOrderedButton(),
              Text(
                'Your account',
                style: bookTextStyle.copyWith(
                  color: greyColor,
                  fontSize: pageStyle.unitFontSize * 17,
                ),
              ),
              SizedBox(height: pageStyle.unitHeight * 20),
              Padding(
                padding: EdgeInsets.only(left: pageStyle.unitWidth * 8),
                child: Text(
                  '''You can log to your account using e -mail and
Password defined easier. On your account you can
Edit your profile data. Check history of transactions.
Edit subscription to newsletter.''',
                  style: bookTextStyle.copyWith(
                    color: greyColor,
                    fontSize: pageStyle.unitFontSize * 14,
                  ),
                ),
              ),
              _buildBackToShopButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildShowAllMyOrderedButton() {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(vertical: pageStyle.unitHeight * 30),
      child: TextButton(
        title: 'SHOW ALL MY ORDERED',
        titleSize: pageStyle.unitFontSize * 17,
        titleColor: Colors.white,
        buttonColor: primaryColor,
        borderColor: Colors.transparent,
        onPressed: () => null,
        radius: 0,
      ),
    );
  }

  Widget _buildBackToShopButton() {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(vertical: pageStyle.unitHeight * 30),
      child: TextButton(
        title: 'BACK TO SHOP',
        titleSize: pageStyle.unitFontSize * 17,
        titleColor: greyColor,
        buttonColor: Colors.white,
        borderColor: greyColor,
        onPressed: () => null,
        radius: 0,
      ),
    );
  }
}

// class CheckoutAddressPage extends StatefulWidget {
//   @override
//   _CheckoutAddressPageState createState() => _CheckoutAddressPageState();
// }

// class _CheckoutAddressPageState extends State<CheckoutAddressPage> {
//   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
//   PageStyle pageStyle;

//   TextEditingController firstNameController = TextEditingController();
//   TextEditingController lastNameController = TextEditingController();
//   TextEditingController phoneNumberController = TextEditingController();
//   TextEditingController emailController = TextEditingController();
//   TextEditingController countryController = TextEditingController();
//   TextEditingController stateController = TextEditingController();
//   TextEditingController cityController = TextEditingController();
//   TextEditingController streetController = TextEditingController();
//   TextEditingController zipCodeController = TextEditingController();

//   PhoneNumber phoneNumber;

//   @override
//   Widget build(BuildContext context) {
//     pageStyle = PageStyle(context, designWidth, designHeight);
//     pageStyle.initializePageStyles();
//     return Scaffold(
//       appBar: CigaCheckoutAppBar(pageStyle: pageStyle),
//       body: SingleChildScrollView(
//         child: Form(
//           key: _formKey,
//           child: Column(
//             children: [
//               CigaTextInput(
//                 controller: firstNameController,
//                 width: pageStyle.deviceWidth,
//                 padding: pageStyle.unitWidth * 10,
//                 fontSize: pageStyle.unitFontSize * 14,
//                 hint: 'First Name',
//                 validator: (value) => null,
//                 inputType: TextInputType.text,
//               ),
//               CigaTextInput(
//                 controller: lastNameController,
//                 width: pageStyle.deviceWidth,
//                 padding: pageStyle.unitWidth * 10,
//                 fontSize: pageStyle.unitFontSize * 14,
//                 hint: 'Last Name',
//                 validator: (value) => null,
//                 inputType: TextInputType.text,
//               ),
//               Container(
//                 width: pageStyle.deviceWidth,
//                 padding: EdgeInsets.symmetric(
//                   horizontal: pageStyle.unitWidth * 10,
//                 ),
//                 child: InternationalPhoneNumberInput(
//                   onInputChanged: (value) {
//                     phoneNumber = value;
//                   },
//                   initialValue: phoneNumber,
//                   ignoreBlank: false,
//                   autoValidate: false,
//                   hintText: 'Phone Number',
//                   errorMessage: "",
//                   textFieldController: phoneNumberController,
//                   selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
//                 ),
//               ),
//               CigaTextInput(
//                 controller: emailController,
//                 width: pageStyle.deviceWidth,
//                 padding: pageStyle.unitWidth * 10,
//                 fontSize: pageStyle.unitFontSize * 14,
//                 hint: 'Email',
//                 validator: (value) => null,
//                 inputType: TextInputType.emailAddress,
//               ),
//               SizedBox(height: pageStyle.unitHeight * 30),
//               _buildSearchingAddressButton(),
//               SizedBox(height: pageStyle.unitHeight * 5),
//               _buildSelectAddressButton(),
//               SizedBox(height: pageStyle.unitHeight * 20),
//               CigaTextInput(
//                 controller: countryController,
//                 width: pageStyle.deviceWidth,
//                 padding: pageStyle.unitWidth * 10,
//                 fontSize: pageStyle.unitFontSize * 14,
//                 hint: 'Country',
//                 validator: (value) => null,
//                 inputType: TextInputType.text,
//               ),
//               CigaTextInput(
//                 controller: stateController,
//                 width: pageStyle.deviceWidth,
//                 padding: pageStyle.unitWidth * 10,
//                 fontSize: pageStyle.unitFontSize * 14,
//                 hint: 'State / Province',
//                 validator: (value) => null,
//                 inputType: TextInputType.text,
//               ),
//               CigaTextInput(
//                 controller: streetController,
//                 width: pageStyle.deviceWidth,
//                 padding: pageStyle.unitWidth * 10,
//                 fontSize: pageStyle.unitFontSize * 14,
//                 hint: 'Street Name',
//                 validator: (value) => null,
//                 inputType: TextInputType.text,
//               ),
//               CigaTextInput(
//                 controller: zipCodeController,
//                 width: pageStyle.deviceWidth,
//                 padding: pageStyle.unitWidth * 10,
//                 fontSize: pageStyle.unitFontSize * 14,
//                 hint: 'Zip - Code',
//                 validator: (value) => null,
//                 inputType: TextInputType.number,
//               ),
//               SizedBox(height: pageStyle.unitHeight * 30),
//               _buildToolbarButtons(),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildSearchingAddressButton() {
//     return Container(
//       width: pageStyle.deviceWidth,
//       height: pageStyle.unitHeight * 50,
//       padding: EdgeInsets.symmetric(horizontal: pageStyle.unitWidth * 10),
//       child: TextButton(
//         title: 'SEARCHING ADDRESS',
//         titleSize: pageStyle.unitFontSize * 14,
//         titleColor: greyDarkColor,
//         buttonColor: greyLightColor,
//         borderColor: Colors.transparent,
//         onPressed: () => null,
//         radius: 0,
//       ),
//     );
//   }

//   Widget _buildSelectAddressButton() {
//     return Container(
//       width: pageStyle.deviceWidth,
//       height: pageStyle.unitHeight * 50,
//       padding: EdgeInsets.symmetric(horizontal: pageStyle.unitWidth * 10),
//       child: TextButton(
//         title: 'SELECT ADDRESS',
//         titleSize: pageStyle.unitFontSize * 14,
//         titleColor: greyDarkColor,
//         buttonColor: greyLightColor,
//         borderColor: Colors.transparent,
//         onPressed: () => null,
//         radius: 0,
//       ),
//     );
//   }

//   Widget _buildToolbarButtons() {
//     return Container(
//       width: pageStyle.deviceWidth,
//       height: pageStyle.unitHeight * 50,
//       padding: EdgeInsets.symmetric(horizontal: pageStyle.unitWidth * 10),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Container(
//             width: pageStyle.unitWidth * 150,
//             child: TextButton(
//               title: 'SAVE ADDRESS',
//               titleSize: pageStyle.unitFontSize * 14,
//               titleColor: greyDarkColor,
//               buttonColor: greyLightColor,
//               borderColor: Colors.transparent,
//               onPressed: () => null,
//               radius: 30,
//             ),
//           ),
//           Container(
//             width: pageStyle.unitWidth * 197,
//             child: TextButton(
//               title: 'CONTINUE TO SHIPPING',
//               titleSize: pageStyle.unitFontSize * 14,
//               titleColor: Colors.white,
//               buttonColor: primaryColor,
//               borderColor: Colors.transparent,
//               onPressed: () => null,
//               radius: 30,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
