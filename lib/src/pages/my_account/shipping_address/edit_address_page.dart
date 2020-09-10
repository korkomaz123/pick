import 'package:ciga/src/components/ciga_app_bar.dart';
import 'package:ciga/src/components/ciga_bottom_bar.dart';
import 'package:ciga/src/components/ciga_side_menu.dart';
import 'package:ciga/src/components/ciga_text_input.dart';
import 'package:ciga/src/config/config.dart';
import 'package:ciga/src/data/models/adress_entity.dart';
import 'package:ciga/src/data/models/index.dart';
import 'package:ciga/src/theme/styles.dart';
import 'package:ciga/src/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:isco_custom_widgets/isco_custom_widgets.dart';

class EditAddressPage extends StatefulWidget {
  final AddressEntity address;

  EditAddressPage({this.address});

  @override
  _EditAddressPageState createState() => _EditAddressPageState();
}

class _EditAddressPageState extends State<EditAddressPage> {
  PageStyle pageStyle;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  TextEditingController countryController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController streetController = TextEditingController();
  TextEditingController zipCodeController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();

  @override
  void initState() {
    super.initState();
    countryController.text = widget.address.country;
    cityController.text = widget.address.city;
    streetController.text = widget.address.street;
    zipCodeController.text = widget.address.zipCode;
    phoneNumberController.text = widget.address.phoneNumber;
  }

  @override
  Widget build(BuildContext context) {
    pageStyle = PageStyle(context, designWidth, designHeight);
    pageStyle.initializePageStyles();
    return Scaffold(
      key: scaffoldKey,
      appBar: CigaAppBar(scaffoldKey: scaffoldKey, pageStyle: pageStyle),
      drawer: CigaSideMenu(pageStyle: pageStyle),
      body: Column(
        children: [
          _buildAppBar(),
          _buildEditFormView(),
        ],
      ),
      bottomNavigationBar: CigaBottomBar(
        pageStyle: pageStyle,
        activeItem: BottomEnum.account,
      ),
    );
  }

  Widget _buildAppBar() {
    return AppBar(
      elevation: 0,
      leading: IconButton(
        onPressed: () => Navigator.pop(context),
        icon: Icon(Icons.arrow_back_ios, size: pageStyle.unitFontSize * 22),
      ),
      centerTitle: true,
      title: Text(
        'shipping_address_title'.tr(),
        style: boldTextStyle.copyWith(
          color: Colors.white,
          fontSize: pageStyle.unitFontSize * 17,
        ),
      ),
    );
  }

  Widget _buildEditFormView() {
    return Expanded(
      child: SingleChildScrollView(
        child: Column(
          children: [
            Column(
              children: [
                CigaTextInput(
                  controller: countryController,
                  width: pageStyle.deviceWidth,
                  padding: pageStyle.unitWidth * 10,
                  fontSize: pageStyle.unitFontSize * 14,
                  hint: 'country'.tr(),
                  validator: (value) => null,
                  inputType: TextInputType.text,
                ),
                CigaTextInput(
                  controller: cityController,
                  width: pageStyle.deviceWidth,
                  padding: pageStyle.unitWidth * 10,
                  fontSize: pageStyle.unitFontSize * 14,
                  hint: 'city'.tr(),
                  validator: (value) => null,
                  inputType: TextInputType.text,
                ),
                CigaTextInput(
                  controller: streetController,
                  width: pageStyle.deviceWidth,
                  padding: pageStyle.unitWidth * 10,
                  fontSize: pageStyle.unitFontSize * 14,
                  hint: 'checkout_street_name_hint'.tr(),
                  validator: (value) => null,
                  inputType: TextInputType.text,
                ),
                CigaTextInput(
                  controller: zipCodeController,
                  width: pageStyle.deviceWidth,
                  padding: pageStyle.unitWidth * 10,
                  fontSize: pageStyle.unitFontSize * 14,
                  hint: 'checkout_zip_code_hint'.tr(),
                  validator: (value) => null,
                  inputType: TextInputType.number,
                ),
                CigaTextInput(
                  controller: phoneNumberController,
                  width: pageStyle.deviceWidth,
                  padding: pageStyle.unitWidth * 10,
                  fontSize: pageStyle.unitFontSize * 14,
                  hint: 'phone_number_hint'.tr(),
                  validator: (value) => null,
                  inputType: TextInputType.phone,
                ),
              ],
            ),
            _buildSaveButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildSaveButton() {
    return Container(
      width: pageStyle.deviceWidth,
      height: pageStyle.unitHeight * 50,
      margin: EdgeInsets.symmetric(
        horizontal: pageStyle.unitWidth * 30,
        vertical: pageStyle.unitHeight * 30,
      ),
      child: MaterialButton(
        onPressed: () => null,
        color: primaryColor,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Text(
          'save_address_button_title'.tr(),
          style: mediumTextStyle.copyWith(
            color: Colors.white,
            fontSize: pageStyle.unitFontSize * 21,
          ),
        ),
      ),
    );
  }
}
