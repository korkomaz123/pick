import 'package:ciga/src/config/config.dart';
import 'package:ciga/src/theme/icons.dart';
import 'package:ciga/src/theme/styles.dart';
import 'package:ciga/src/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:isco_custom_widgets/isco_custom_widgets.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  PageStyle pageStyle;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool agreeTerms = false;

  @override
  Widget build(BuildContext context) {
    pageStyle = PageStyle(context, designWidth, designHeight);
    pageStyle.initializePageStyles();
    return Scaffold(
      backgroundColor: primaryColor,
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
                  logoIcon,
                  width: pageStyle.unitWidth * 120,
                  height: pageStyle.unitHeight * 80,
                ),
              ),
              _buildFirstName(),
              _buildLastName(),
              _buildEmail(),
              _buildPassword(),
              SizedBox(height: 40),
              _buildTermsAndConditions(),
              SizedBox(height: 40),
              _buildSignUpButton(),
              SizedBox(height: 40),
              _buildSignInPhase(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFirstName() {
    return Container(
      width: pageStyle.deviceWidth,
      padding: EdgeInsets.symmetric(
        horizontal: pageStyle.unitWidth * 20,
      ),
      child: TextFormField(
        controller: firstNameController,
        style: bookTextStyle.copyWith(
          color: Colors.white,
          fontSize: pageStyle.unitFontSize * 15,
        ),
        decoration: InputDecoration(
          hintText: 'first_name'.tr(),
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

  Widget _buildLastName() {
    return Container(
      width: pageStyle.deviceWidth,
      padding: EdgeInsets.symmetric(
        horizontal: pageStyle.unitWidth * 20,
      ),
      child: TextFormField(
        controller: lastNameController,
        style: bookTextStyle.copyWith(
          color: Colors.white,
          fontSize: pageStyle.unitFontSize * 15,
        ),
        decoration: InputDecoration(
          hintText: 'last_name'.tr(),
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

  Widget _buildEmail() {
    return Container(
      width: pageStyle.deviceWidth,
      padding: EdgeInsets.symmetric(
        horizontal: pageStyle.unitWidth * 20,
      ),
      child: TextFormField(
        controller: emailController,
        style: bookTextStyle.copyWith(
          color: Colors.white,
          fontSize: pageStyle.unitFontSize * 15,
        ),
        decoration: InputDecoration(
          hintText: 'email_hint'.tr(),
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
        keyboardType: TextInputType.emailAddress,
      ),
    );
  }

  Widget _buildPassword() {
    return Container(
      width: pageStyle.deviceWidth,
      padding: EdgeInsets.symmetric(
        horizontal: pageStyle.unitWidth * 20,
      ),
      child: TextFormField(
        controller: passwordController,
        style: bookTextStyle.copyWith(
          color: Colors.white,
          fontSize: pageStyle.unitFontSize * 15,
        ),
        decoration: InputDecoration(
          hintText: 'password_hint'.tr(),
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
          suffix: InkWell(
            onTap: () => null,
            child: Text('reset'.tr()),
          ),
        ),
        obscureText: true,
      ),
    );
  }

  Widget _buildTermsAndConditions() {
    return Container(
      width: pageStyle.deviceWidth,
      padding: EdgeInsets.symmetric(horizontal: pageStyle.unitWidth * 20),
      child: CheckboxListTile(
        value: agreeTerms,
        onChanged: (value) {
          agreeTerms = value;
          setState(() {});
        },
        controlAffinity: ListTileControlAffinity.leading,
        checkColor: Colors.white,
        title: Row(
          children: [
            Text(
              'prefix_agree_terms'.tr() + ' ',
              style: bookTextStyle.copyWith(
                color: Colors.white,
                fontSize: pageStyle.unitFontSize * 16,
              ),
            ),
            InkWell(
              onTap: () => null,
              child: Text(
                'suffix_agree_terms'.tr(),
                style: bookTextStyle.copyWith(
                  color: primarySwatchColor,
                  fontSize: pageStyle.unitFontSize * 16,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildSignUpButton() {
    return Container(
      width: pageStyle.deviceWidth,
      height: pageStyle.unitHeight * 50,
      padding: EdgeInsets.symmetric(
        horizontal: pageStyle.unitWidth * 20,
      ),
      child: TextButton(
        title: 'create_account'.tr(),
        titleSize: pageStyle.unitFontSize * 19,
        titleColor: primaryColor,
        buttonColor: Colors.white,
        borderColor: Colors.transparent,
        onPressed: () => null,
        radius: 10,
      ),
    );
  }

  Widget _buildSignInPhase() {
    return Container(
      width: pageStyle.deviceWidth,
      alignment: Alignment.center,
      child: FlatButton(
        onPressed: () => Navigator.pop(context),
        child: Text(
          'login_account'.tr(),
          style: bookTextStyle.copyWith(
            color: Colors.white,
            fontSize: pageStyle.unitFontSize * 17,
          ),
        ),
      ),
    );
  }
}
