import 'package:ciga/src/config/config.dart';
import 'package:ciga/src/routes/routes.dart';
import 'package:ciga/src/theme/icons.dart';
import 'package:ciga/src/theme/styles.dart';
import 'package:ciga/src/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:isco_custom_widgets/isco_custom_widgets.dart';

class ForgotPasswordPage extends StatefulWidget {
  @override
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  PageStyle pageStyle;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController userNameOrEmailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    pageStyle = PageStyle(context, designWidth, designHeight);
    pageStyle.initializePageStyles();
    return Scaffold(
      backgroundColor: primarySwatchColor,
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.symmetric(
                  vertical: pageStyle.unitHeight * 120,
                ),
                alignment: Alignment.center,
                child: SvgPicture.asset(
                  hLogoIcon,
                  width: pageStyle.unitWidth * 120,
                  height: pageStyle.unitHeight * 45,
                ),
              ),
              Container(
                alignment: Alignment.center,
                child: Text(
                  'forgot_password_title'.tr(),
                  style: bookTextStyle.copyWith(
                    color: Colors.white,
                    fontSize: pageStyle.unitFontSize * 14,
                  ),
                ),
              ),
              SizedBox(height: 30),
              _buildUsernameOrEmail(),
              SizedBox(height: 40),
              _buildGetNewPassButton(),
              SizedBox(height: 60),
              _buildAuthChoiceDivider(),
              SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUsernameOrEmail() {
    return Container(
      width: pageStyle.deviceWidth,
      padding: EdgeInsets.symmetric(
        horizontal: pageStyle.unitWidth * 20,
      ),
      child: TextFormField(
        controller: userNameOrEmailController,
        textAlign: TextAlign.center,
        style: bookTextStyle.copyWith(
          color: greyDarkColor,
          fontSize: pageStyle.unitFontSize * 14,
        ),
        decoration: InputDecoration(
          contentPadding: EdgeInsets.all(0),
          hintText: 'username'.tr().toUpperCase() +
              ' ' +
              'or'.tr() +
              ' ' +
              'email'.tr().toUpperCase(),
          hintStyle: bookTextStyle.copyWith(
            color: greyColor,
            fontSize: pageStyle.unitFontSize * 14,
          ),
          border: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white, width: 0.5),
            borderRadius: BorderRadius.circular(30),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white, width: 0.5),
            borderRadius: BorderRadius.circular(30),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white, width: 0.5),
            borderRadius: BorderRadius.circular(30),
          ),
          fillColor: Colors.white,
          filled: true,
        ),
      ),
    );
  }

  Widget _buildGetNewPassButton() {
    return Container(
      width: pageStyle.deviceWidth,
      height: pageStyle.unitHeight * 50,
      padding: EdgeInsets.symmetric(
        horizontal: pageStyle.unitWidth * 20,
      ),
      child: TextButton(
        title: 'get_new_password'.tr(),
        titleSize: pageStyle.unitFontSize * 19,
        titleColor: primaryColor,
        buttonColor: Colors.white,
        borderColor: Colors.transparent,
        onPressed: () => null,
        radius: 10,
      ),
    );
  }

  Widget _buildAuthChoiceDivider() {
    return Container(
      width: pageStyle.deviceWidth,
      padding: EdgeInsets.symmetric(horizontal: pageStyle.unitWidth * 50),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          InkWell(
            onTap: () => Navigator.pop(context),
            child: Text(
              'login'.tr(),
              style: bookTextStyle.copyWith(
                color: Colors.white,
                fontSize: pageStyle.unitFontSize * 14,
              ),
            ),
          ),
          Container(
            height: pageStyle.unitHeight * 20,
            child: VerticalDivider(color: Colors.white, thickness: 0.5),
          ),
          InkWell(
            onTap: () => Navigator.pushReplacementNamed(context, Routes.signUp),
            child: Text(
              'register'.tr(),
              style: bookTextStyle.copyWith(
                color: Colors.white,
                fontSize: pageStyle.unitFontSize * 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
