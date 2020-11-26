import 'dart:convert';
import 'dart:io';
import 'package:ciga/src/utils/flushbar_service.dart';
import 'package:ciga/src/utils/local_storage_repository.dart';
import 'package:http/http.dart' as http;
import 'package:ciga/src/config/config.dart';
import 'package:ciga/src/data/mock/mock.dart';
import 'package:ciga/src/data/models/index.dart';
import 'package:ciga/src/pages/sign_in/bloc/sign_in_bloc.dart';
import 'package:ciga/src/routes/routes.dart';
import 'package:ciga/src/theme/icons.dart';
import 'package:ciga/src/theme/styles.dart';
import 'package:ciga/src/theme/theme.dart';
import 'package:ciga/src/utils/progress_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:isco_custom_widgets/isco_custom_widgets.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:string_validator/string_validator.dart';

class SignInPage extends StatefulWidget {
  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  PageStyle pageStyle;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool isShowPass = false;
  SignInBloc signInBloc;
  ProgressService progressService;
  FlushBarService flushBarService;
  LocalStorageRepository localRepo;

  @override
  void initState() {
    super.initState();
    progressService = ProgressService(context: context);
    flushBarService = FlushBarService(context: context);
    signInBloc = context.bloc<SignInBloc>();
    localRepo = context.repository<LocalStorageRepository>();
  }

  void _saveToken(UserEntity loggedInUser) async {
    user = loggedInUser;
    await localRepo.setToken(loggedInUser.token);
  }

  @override
  Widget build(BuildContext context) {
    pageStyle = PageStyle(context, designWidth, designHeight);
    pageStyle.initializePageStyles();
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: primarySwatchColor,
      body: BlocConsumer<SignInBloc, SignInState>(
        listener: (context, state) {
          if (state is SignInSubmittedInProcess) {
            progressService.showProgress();
          }
          if (state is SignInSubmittedSuccess) {
            _saveToken(state.user);
            progressService.hideProgress();
            Navigator.pop(context);
          }
          if (state is SignInSubmittedFailure) {
            progressService.hideProgress();
            flushBarService.showErrorMessage(pageStyle, state.message);
          }
        },
        builder: (context, state) {
          return SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Container(
                    width: pageStyle.deviceWidth,
                    padding: EdgeInsets.only(
                      top: pageStyle.unitHeight * 30,
                      bottom: pageStyle.unitHeight * 30,
                    ),
                    alignment: Alignment.centerLeft,
                    child: IconButton(
                      icon: Icon(Icons.arrow_back_ios, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(
                      top: pageStyle.unitHeight * 40,
                      bottom: pageStyle.unitHeight * 100,
                    ),
                    alignment: Alignment.center,
                    child: SvgPicture.asset(
                      hLogoIcon,
                      width: pageStyle.unitWidth * 120,
                      height: pageStyle.unitHeight * 45,
                    ),
                  ),
                  _buildEmail(),
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
          );
        },
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
        validator: (value) {
          if (value.isEmpty) {
            return 'required_email'.tr();
          } else if (!isEmail(value)) {
            return 'invalid_email'.tr();
          }
          return null;
        },
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
          hintText: 'email'.tr(),
          hintStyle: bookTextStyle.copyWith(
            color: Colors.white,
            fontSize: pageStyle.unitFontSize * 15,
          ),
          errorStyle: bookTextStyle.copyWith(
            color: Color(0xFF00F5FF),
            fontSize: pageStyle.unitFontSize * 12,
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
          focusedErrorBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Color(0xFF00F5FF), width: 1),
          ),
          errorBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Color(0xFF00F5FF), width: 0.5),
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
        validator: (value) {
          if (value.isEmpty) {
            return 'required_password'.tr();
          } else if (!isLength(value, 5)) {
            return 'short_length_password'.tr();
          }
          return null;
        },
        decoration: InputDecoration(
          hintText: 'password'.tr(),
          hintStyle: bookTextStyle.copyWith(
            color: Colors.white,
            fontSize: pageStyle.unitFontSize * 15,
          ),
          errorStyle: bookTextStyle.copyWith(
            color: Color(0xFF00F5FF),
            fontSize: pageStyle.unitFontSize * 12,
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
          errorBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Color(0xFF00F5FF), width: 0.5),
          ),
          focusedErrorBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Color(0xFF00F5FF), width: 1),
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
        onPressed: () => _signIn(),
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
            width: lang == 'en'
                ? pageStyle.unitWidth * 100
                : pageStyle.unitWidth * 80,
            child: Divider(color: greyLightColor, thickness: 0.5),
          ),
          Text(
            'or_divider'.tr(),
            style: boldTextStyle.copyWith(
              fontSize: pageStyle.unitFontSize * 17,
              color: Colors.white,
            ),
          ),
          Container(
            width: lang == 'en'
                ? pageStyle.unitWidth * 100
                : pageStyle.unitWidth * 80,
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
          InkWell(
            onTap: () => _onFacebookSign(),
            child: SvgPicture.asset(facebookIcon),
          ),
          SizedBox(width: pageStyle.unitWidth * 20),
          InkWell(
            onTap: () => _onGoogleSign(),
            child: SvgPicture.asset(googleIcon),
          ),
          SizedBox(width: pageStyle.unitWidth * 20),
          InkWell(
            onTap: () => _onTwitterSign(),
            child: SvgPicture.asset(twitterIcon),
          ),
          Platform.isIOS
              ? Row(
                  children: [
                    SizedBox(width: pageStyle.unitWidth * 20),
                    InkWell(
                      onTap: () => _onAppleSign(),
                      child: SvgPicture.asset(appleIcon),
                    ),
                  ],
                )
              : SizedBox.shrink(),
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

  void _signIn() {
    if (_formKey.currentState.validate()) {
      signInBloc.add(SignInSubmitted(
        email: emailController.text,
        password: passwordController.text,
      ));
    }
  }

  void _onFacebookSign() async {
    final facebookLogin = FacebookLogin();
    final result = await facebookLogin.logIn(['email']);
    switch (result.status) {
      case FacebookLoginStatus.loggedIn:
        _loginWithFacebook(result);
        break;
      case FacebookLoginStatus.cancelledByUser:
        print('/// Cancelled By User ///');
        break;
      case FacebookLoginStatus.error:
        print('/// Facebook Login Error ///');
        print(result.errorMessage);
        break;
    }
  }

  void _loginWithFacebook(FacebookLoginResult result) async {
    try {
      final token = result.accessToken.token;
      final graphResponse = await http.get('https://graph.facebook.com/v2.12/me?fields=name,first_name,last_name,email&access_token=$token');
      final profile = json.decode(graphResponse.body);
      String firstName = profile['first_name'];
      String lastName = profile['last_name'];
      String email = profile['email'];
      print(profile);
      signInBloc.add(SocialSignInSubmitted(
        email: email,
        firstName: firstName,
        lastName: lastName,
        loginType: 'Facebook Sign',
        lang: lang,
      ));
    } catch (e) {
      print('/// _loginWithFacebook Error ///');
      print(e.toString());
    }
  }

  void _onGoogleSign() async {
    GoogleSignIn _googleSignIn = GoogleSignIn();
    try {
      final googleAccount = await _googleSignIn.signIn();
      String email = googleAccount.email;
      String displayName = googleAccount.displayName;
      String firstName = displayName.split(' ')[0];
      String lastName = displayName.split(' ')[1];
      signInBloc.add(SocialSignInSubmitted(
        email: email,
        firstName: firstName,
        lastName: lastName,
        loginType: 'Google Sign',
        lang: lang,
      ));
    } catch (error) {
      print(error);
    }
  }

  void _onTwitterSign() {}

  void _onAppleSign() async {
    try {
      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );
      String email = credential.email;
      String firstName = credential.givenName;
      String lastName = credential.familyName;
      signInBloc.add(SocialSignInSubmitted(
        email: email,
        firstName: firstName,
        lastName: lastName,
        loginType: 'Apple Sign',
        lang: lang,
      ));
    } catch (error) {
      print(error);
    }
  }
}
