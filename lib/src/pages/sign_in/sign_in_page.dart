import 'package:ciga/src/config/config.dart';
import 'package:ciga/src/routes/routes.dart';
import 'package:ciga/src/theme/icons.dart';
import 'package:ciga/src/theme/styles.dart';
import 'package:ciga/src/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:isco_custom_widgets/isco_custom_widgets.dart';

class SignInPage extends StatefulWidget {
  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  PageStyle pageStyle;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController userNameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool isShowPass = false;

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
                  vertical: pageStyle.unitHeight * 100,
                ),
                alignment: Alignment.center,
                child: SvgPicture.asset(
                  logoIcon,
                  width: pageStyle.unitWidth * 120,
                  height: pageStyle.unitHeight * 80,
                ),
              ),
              _buildUsername(),
              _buildPassword(),
              SizedBox(height: 40),
              _buildSignInButton(),
              SizedBox(height: 10),
              _buildForgotPassword(),
              SizedBox(height: 40),
              _buildOrDivider(),
              SizedBox(height: 40),
              _buildExternalSignInButtons(),
              SizedBox(height: 40),
              _buildSignUpPhase(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUsername() {
    return Container(
      width: pageStyle.deviceWidth,
      padding: EdgeInsets.symmetric(
        horizontal: pageStyle.unitWidth * 20,
      ),
      child: TextFormField(
        controller: userNameController,
        style: bookTextStyle.copyWith(
          color: Colors.white,
          fontSize: pageStyle.unitFontSize * 15,
        ),
        decoration: InputDecoration(
          hintText: 'username'.tr(),
          hintStyle: bookTextStyle.copyWith(
            color: Colors.white,
            fontSize: pageStyle.unitFontSize * 15,
          ),
          border: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white, width: 0.5),
          ),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white, width: 0.5),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white, width: 0.5),
          ),
        ),
      ),
    );
  }

  Widget _buildPassword() {
    return Container(
      width: pageStyle.deviceWidth,
      padding: EdgeInsets.symmetric(
        vertical: pageStyle.unitHeight * 10,
        horizontal: pageStyle.unitWidth * 20,
      ),
      child: TextFormField(
        controller: passwordController,
        style: bookTextStyle.copyWith(
          color: Colors.white,
          fontSize: pageStyle.unitFontSize * 15,
        ),
        decoration: InputDecoration(
          hintText: 'password'.tr(),
          hintStyle: bookTextStyle.copyWith(
            color: Colors.white,
            fontSize: pageStyle.unitFontSize * 15,
          ),
          border: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white, width: 0.5),
          ),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white, width: 0.5),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white, width: 0.5),
          ),
          suffixIcon: InkWell(
            onTap: () {
              setState(() {
                isShowPass = !isShowPass;
              });
            },
            child: Icon(
              !isShowPass ? FontAwesomeIcons.eye : FontAwesomeIcons.eyeSlash,
              color: Colors.white54,
              size: pageStyle.unitFontSize * 20,
            ),
          ),
        ),
        obscureText: !isShowPass,
      ),
    );
  }

  Widget _buildSignInButton() {
    return Container(
      width: pageStyle.deviceWidth,
      height: pageStyle.unitHeight * 50,
      padding: EdgeInsets.symmetric(
        horizontal: pageStyle.unitWidth * 20,
      ),
      child: TextButton(
        title: 'sign_in'.tr(),
        titleSize: pageStyle.unitFontSize * 19,
        titleColor: primaryColor,
        buttonColor: Colors.white,
        borderColor: Colors.transparent,
        onPressed: () => Navigator.pushNamedAndRemoveUntil(
          context,
          Routes.home,
          (route) => false,
        ),
        radius: 20,
      ),
    );
  }

  Widget _buildForgotPassword() {
    return Container(
      width: pageStyle.deviceWidth,
      padding: EdgeInsets.symmetric(horizontal: pageStyle.unitWidth * 20),
      alignment: Alignment.centerRight,
      child: InkWell(
        onTap: () => Navigator.pushNamed(context, Routes.forgotPassword),
        child: Text(
          'ask_forgot_password'.tr(),
          style: mediumTextStyle.copyWith(
            color: Colors.white54,
            fontSize: pageStyle.unitFontSize * 14,
          ),
        ),
      ),
    );
  }

  Widget _buildOrDivider() {
    return Container(
      width: pageStyle.deviceWidth,
      padding: EdgeInsets.symmetric(horizontal: pageStyle.unitWidth * 50),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: pageStyle.unitWidth * 100,
            child: Divider(color: greyLightColor, thickness: 0.5),
          ),
          Text(
            'OR',
            style: boldTextStyle.copyWith(
              fontSize: pageStyle.unitFontSize * 17,
              color: Colors.white,
            ),
          ),
          Container(
            width: pageStyle.unitWidth * 100,
            child: Divider(color: greyLightColor, thickness: 0.5),
          ),
        ],
      ),
    );
  }

  Widget _buildExternalSignInButtons() {
    return Container(
      width: pageStyle.deviceWidth,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(facebookIcon),
          SizedBox(width: pageStyle.unitWidth * 20),
          SvgPicture.asset(googleIcon),
          // SizedBox(width: pageStyle.unitWidth * 20),
          // SvgPicture.asset(smsIcon),
        ],
      ),
    );
  }

  Widget _buildSignUpPhase() {
    return Container(
      width: pageStyle.deviceWidth,
      padding: EdgeInsets.only(bottom: pageStyle.unitHeight * 60),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'ask_have_account'.tr() + ' ',
            style: bookTextStyle.copyWith(
              color: Colors.white,
              fontSize: pageStyle.unitFontSize * 17,
            ),
          ),
          InkWell(
            onTap: () => Navigator.pushNamed(context, Routes.signUp),
            child: Text(
              'sign_up'.tr(),
              style: bookTextStyle.copyWith(
                color: Colors.white,
                fontSize: pageStyle.unitFontSize * 17,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
