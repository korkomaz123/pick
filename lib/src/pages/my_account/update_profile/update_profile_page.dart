import 'dart:io';

import 'package:ciga/src/components/ciga_app_bar.dart';
import 'package:ciga/src/components/ciga_bottom_bar.dart';
import 'package:ciga/src/components/ciga_side_menu.dart';
import 'package:ciga/src/config/config.dart';
import 'package:ciga/src/data/models/enum.dart';
import 'package:ciga/src/theme/icons.dart';
import 'package:ciga/src/theme/styles.dart';
import 'package:ciga/src/theme/theme.dart';
import 'package:ciga/src/utils/image_custom_picker_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:isco_custom_widgets/isco_custom_widgets.dart';

class UpdateProfilePage extends StatefulWidget {
  @override
  _UpdateProfilePageState createState() => _UpdateProfilePageState();
}

class _UpdateProfilePageState extends State<UpdateProfilePage> {
  PageStyle pageStyle;
  TextEditingController displayNameController = TextEditingController();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  File image;
  ImageCustomPickerService imageCustomPickerService;

  @override
  void initState() {
    super.initState();
    imageCustomPickerService = ImageCustomPickerService(
      context: context,
      backgroundColor: Colors.white,
      titleColor: primaryColor,
      video: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    pageStyle = PageStyle(context, designWidth, designHeight);
    pageStyle.initializePageStyles();
    return Scaffold(
      key: scaffoldKey,
      appBar: CigaAppBar(pageStyle: pageStyle, scaffoldKey: scaffoldKey),
      drawer: CigaSideMenu(pageStyle: pageStyle),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildProfilePicture(),
            _buildEmail(),
            _buildDisplayName(),
            SizedBox(height: pageStyle.unitHeight * 10),
            _buildFirstName(),
            SizedBox(height: pageStyle.unitHeight * 10),
            _buildLastName(),
            SizedBox(height: pageStyle.unitHeight * 10),
            _buildPhoneNumber(),
            SizedBox(height: pageStyle.unitHeight * 10),
            _buildNewPassword(),
            SizedBox(height: pageStyle.unitHeight * 50),
            _buildUpdateButton(),
            SizedBox(height: pageStyle.unitHeight * 30),
          ],
        ),
      ),
      bottomNavigationBar: CigaBottomBar(
        pageStyle: pageStyle,
        activeItem: BottomEnum.account,
      ),
    );
  }

  Widget _buildProfilePicture() {
    return Center(
      child: Container(
        width: pageStyle.unitWidth * 140,
        height: pageStyle.unitHeight * 140,
        margin: EdgeInsets.symmetric(vertical: pageStyle.unitHeight * 30),
        child: Stack(
          children: [
            Container(
              width: pageStyle.unitWidth * 140,
              height: pageStyle.unitHeight * 140,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: image != null
                      ? FileImage(image)
                      : AssetImage('lib/public/images/profile.png'),
                  fit: BoxFit.cover,
                ),
                shape: BoxShape.circle,
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: InkWell(
                onTap: () => _onChangeImage(),
                child: Container(
                  margin: EdgeInsets.only(right: pageStyle.unitWidth * 20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: SvgPicture.asset(addIcon),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmail() {
    return Container(
      width: pageStyle.deviceWidth,
      padding: EdgeInsets.symmetric(horizontal: pageStyle.unitWidth * 20),
      child: ListTile(
        contentPadding: EdgeInsets.all(0),
        leading: Container(
          width: pageStyle.unitWidth * 22,
          height: pageStyle.unitHeight * 22,
          child: SvgPicture.asset(emailIcon),
        ),
        title: Text(
          'okorkomaz1@gmail.com',
          style: mediumTextStyle.copyWith(
            fontSize: pageStyle.unitFontSize * 16,
          ),
        ),
      ),
    );
  }

  Widget _buildDisplayName() {
    return Container(
      width: pageStyle.deviceWidth,
      padding: EdgeInsets.symmetric(horizontal: pageStyle.unitFontSize * 20),
      child: InputField(
        width: double.infinity,
        controller: displayNameController,
        space: pageStyle.unitHeight * 4,
        radius: 4,
        fontSize: pageStyle.unitFontSize * 16,
        fontColor: greyDarkColor,
        label: 'display_name'.tr(),
        labelColor: greyColor,
        labelSize: pageStyle.unitFontSize * 16,
        fillColor: Colors.grey.shade300,
        bordered: false,
      ),
    );
  }

  Widget _buildFirstName() {
    return Container(
      width: pageStyle.deviceWidth,
      padding: EdgeInsets.symmetric(horizontal: pageStyle.unitFontSize * 20),
      child: InputField(
        width: double.infinity,
        controller: firstNameController,
        space: pageStyle.unitHeight * 4,
        radius: 4,
        fontSize: pageStyle.unitFontSize * 16,
        fontColor: greyDarkColor,
        label: 'first_name'.tr(),
        labelColor: greyColor,
        labelSize: pageStyle.unitFontSize * 16,
        fillColor: Colors.grey.shade300,
        bordered: false,
      ),
    );
  }

  Widget _buildLastName() {
    return Container(
      width: pageStyle.deviceWidth,
      padding: EdgeInsets.symmetric(horizontal: pageStyle.unitFontSize * 20),
      child: InputField(
        width: double.infinity,
        controller: lastNameController,
        space: pageStyle.unitHeight * 4,
        radius: 4,
        fontSize: pageStyle.unitFontSize * 16,
        fontColor: greyDarkColor,
        label: 'last_name'.tr(),
        labelColor: greyColor,
        labelSize: pageStyle.unitFontSize * 16,
        fillColor: Colors.grey.shade300,
        bordered: false,
      ),
    );
  }

  Widget _buildPhoneNumber() {
    return Container(
      width: pageStyle.deviceWidth,
      padding: EdgeInsets.symmetric(horizontal: pageStyle.unitFontSize * 20),
      child: InputField(
        width: double.infinity,
        controller: phoneNumberController,
        space: pageStyle.unitHeight * 4,
        radius: 4,
        fontSize: pageStyle.unitFontSize * 16,
        fontColor: greyDarkColor,
        label: 'phone_number_hint'.tr(),
        labelColor: greyColor,
        labelSize: pageStyle.unitFontSize * 16,
        fillColor: Colors.grey.shade300,
        bordered: false,
        keyboardType: TextInputType.phone,
      ),
    );
  }

  Widget _buildNewPassword() {
    return Container(
      width: pageStyle.deviceWidth,
      padding: EdgeInsets.symmetric(horizontal: pageStyle.unitFontSize * 20),
      child: InputField(
        width: double.infinity,
        controller: newPasswordController,
        space: pageStyle.unitHeight * 4,
        radius: 4,
        fontSize: pageStyle.unitFontSize * 16,
        fontColor: greyDarkColor,
        label: 'new_password'.tr(),
        labelColor: greyColor,
        labelSize: pageStyle.unitFontSize * 16,
        fillColor: Colors.grey.shade300,
        bordered: false,
        obsecureText: true,
      ),
    );
  }

  Widget _buildUpdateButton() {
    return Container(
      width: pageStyle.deviceWidth,
      padding: EdgeInsets.symmetric(horizontal: pageStyle.unitWidth * 20),
      child: TextButton(
        title: 'update_button_title'.tr(),
        titleSize: pageStyle.unitFontSize * 14,
        titleColor: Colors.white,
        buttonColor: primaryColor,
        borderColor: Colors.transparent,
        onPressed: () => Navigator.pop(context),
        radius: 0,
      ),
    );
  }

  void _onChangeImage() async {
    image = await imageCustomPickerService.getImageWithDialog();
    if (image != null) {
      setState(() {});
    }
  }
}
