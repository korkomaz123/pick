import 'dart:convert';
import 'dart:io';

import 'package:markaa/src/change_notifier/home_change_notifier.dart';
import 'package:markaa/src/change_notifier/order_change_notifier.dart';
import 'package:markaa/src/change_notifier/address_change_notifier.dart';
import 'package:markaa/src/components/markaa_text_button.dart';
import 'package:markaa/src/config/config.dart';
import 'package:markaa/src/data/mock/mock.dart';
import 'package:markaa/src/data/models/index.dart';
import 'package:markaa/src/pages/sign_in/bloc/sign_in_bloc.dart';
import 'package:markaa/src/routes/routes.dart';
import 'package:markaa/src/theme/icons.dart';
import 'package:markaa/src/theme/styles.dart';
import 'package:markaa/src/theme/theme.dart';
import 'package:markaa/src/utils/repositories/local_storage_repository.dart';
import 'package:markaa/src/change_notifier/my_cart_change_notifier.dart';
import 'package:markaa/src/change_notifier/wishlist_change_notifier.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:faker/faker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:isco_custom_widgets/isco_custom_widgets.dart';
import 'package:markaa/src/utils/repositories/setting_repository.dart';
import 'package:markaa/src/utils/repositories/wishlist_repository.dart';
import 'package:markaa/src/utils/services/flushbar_service.dart';
import 'package:markaa/src/utils/services/progress_service.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:string_validator/string_validator.dart';

import '../../../config.dart';

class SignInPage extends StatefulWidget {
  final bool isFromCheckout;
  final bool isFromSplash;

  SignInPage({this.isFromCheckout = false, this.isFromSplash = false});

  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  PageStyle pageStyle;
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  FocusNode emailNode = FocusNode();
  FocusNode passNode = FocusNode();
  bool isShowPass = false;
  SignInBloc signInBloc;
  HomeChangeNotifier homeChangeNotifier;
  ProgressService progressService;
  FlushBarService flushBarService;
  LocalStorageRepository localRepo;
  WishlistRepository wishlistRepo;
  SettingRepository settingRepo;
  MyCartChangeNotifier myCartChangeNotifier;
  WishlistChangeNotifier wishlistChangeNotifier;
  OrderChangeNotifier orderChangeNotifier;
  AddressChangeNotifier addressChangeNotifier;
  @override
  void initState() {
    super.initState();
    progressService = ProgressService(context: context);
    flushBarService = FlushBarService(context: context);
    homeChangeNotifier = context.read<HomeChangeNotifier>();
    signInBloc = context.read<SignInBloc>();
    localRepo = context.read<LocalStorageRepository>();
    wishlistRepo = context.read<WishlistRepository>();
    settingRepo = context.read<SettingRepository>();
    myCartChangeNotifier = context.read<MyCartChangeNotifier>();
    wishlistChangeNotifier = context.read<WishlistChangeNotifier>();
    orderChangeNotifier = context.read<OrderChangeNotifier>();
    addressChangeNotifier = context.read<AddressChangeNotifier>();
  }

  void _loggedInSuccess(UserEntity loggedInUser) async {
    try {
      user = loggedInUser;
      await localRepo.setToken(user.token);
      await orderChangeNotifier.loadOrderHistories(user.token, lang);
      await myCartChangeNotifier.getCartId();
      await myCartChangeNotifier.transferCartItems();
      await myCartChangeNotifier.getCartItems(lang);
      await wishlistChangeNotifier.getWishlistItems(user.token, lang);
      addressChangeNotifier.initialize();
      await addressChangeNotifier.loadAddresses(user.token);
      await settingRepo.updateFcmDeviceToken(
        user.token,
        Platform.isAndroid ? deviceToken : '',
        Platform.isIOS ? deviceToken : '',
        Platform.isAndroid ? lang : '',
        Platform.isIOS ? lang : '',
      );
    } catch (e) {
      print(e.toString());
    }
    homeChangeNotifier.loadRecentlyViewedCustomer(user.token, lang);
    progressService.hideProgress();
    if (Navigator.of(Config.navigatorKey.currentContext).canPop())
      Navigator.of(Config.navigatorKey.currentContext).pop(context);
    else
      Navigator.pushNamedAndRemoveUntil(context, Routes.home, (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    Config.pageStyle = PageStyle(context, designWidth, designHeight);
    Config.pageStyle.initializePageStyles();
    Config.language = EasyLocalization.of(Config.navigatorKey.currentContext).locale.languageCode.toLowerCase();
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: primarySwatchColor,
      body: BlocConsumer<SignInBloc, SignInState>(
        listener: (context, state) {
          if (state is SignInSubmittedInProcess) {
            progressService.showProgress();
          }
          if (state is SignInSubmittedSuccess) {
            _loggedInSuccess(state.user);
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
                    width: Config.pageStyle.deviceWidth,
                    padding: EdgeInsets.only(
                      top: Config.pageStyle.unitHeight * 30,
                      bottom: Config.pageStyle.unitHeight * 30,
                    ),
                    alignment: lang == 'en' ? Alignment.centerLeft : Alignment.centerRight,
                    child: IconButton(
                      icon: Icon(Icons.arrow_back_ios, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(
                      top: Config.pageStyle.unitHeight * 40,
                      bottom: Config.pageStyle.unitHeight * 100,
                    ),
                    alignment: Alignment.center,
                    child: SvgPicture.asset(
                      hLogoIcon,
                      width: Config.pageStyle.unitWidth * 120,
                      height: Config.pageStyle.unitHeight * 45,
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
                  if (!widget.isFromCheckout) ...[_buildSignUpPhase()],
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
      width: Config.pageStyle.deviceWidth,
      padding: EdgeInsets.symmetric(
        horizontal: Config.pageStyle.unitWidth * 20,
      ),
      child: TextFormField(
        controller: emailController,
        style: mediumTextStyle.copyWith(
          color: Colors.white,
          fontSize: Config.pageStyle.unitFontSize * 15,
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
        focusNode: emailNode,
        textInputAction: TextInputAction.next,
        onEditingComplete: () => passNode.requestFocus(),
        decoration: InputDecoration(
          hintText: 'email'.tr(),
          hintStyle: mediumTextStyle.copyWith(
            color: Colors.white,
            fontSize: Config.pageStyle.unitFontSize * 15,
          ),
          errorStyle: mediumTextStyle.copyWith(
            color: Color(0xFF00F5FF),
            fontSize: Config.pageStyle.unitFontSize * 12,
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
      width: Config.pageStyle.deviceWidth,
      padding: EdgeInsets.symmetric(
        vertical: Config.pageStyle.unitHeight * 10,
        horizontal: Config.pageStyle.unitWidth * 20,
      ),
      child: TextFormField(
        controller: passwordController,
        style: mediumTextStyle.copyWith(
          color: Colors.white,
          fontSize: Config.pageStyle.unitFontSize * 15,
        ),
        validator: (value) {
          if (value.isEmpty) {
            return 'required_password'.tr();
          } else if (!isLength(value, 5)) {
            return 'short_length_password'.tr();
          }
          return null;
        },
        focusNode: passNode,
        textInputAction: TextInputAction.done,
        onEditingComplete: () {
          passNode.unfocus();
          _signIn();
        },
        decoration: InputDecoration(
          hintText: 'password'.tr(),
          hintStyle: mediumTextStyle.copyWith(
            color: Colors.white,
            fontSize: Config.pageStyle.unitFontSize * 15,
          ),
          errorStyle: mediumTextStyle.copyWith(
            color: Color(0xFF00F5FF),
            fontSize: Config.pageStyle.unitFontSize * 12,
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
              size: Config.pageStyle.unitFontSize * 20,
            ),
          ),
        ),
        obscureText: !isShowPass,
      ),
    );
  }

  Widget _buildSignInButton() {
    return Container(
      width: Config.pageStyle.deviceWidth,
      height: Config.pageStyle.unitHeight * 50,
      padding: EdgeInsets.symmetric(
        horizontal: Config.pageStyle.unitWidth * 20,
      ),
      child: MarkaaTextButton(
        title: 'sign_in'.tr(),
        titleSize: Config.pageStyle.unitFontSize * 19,
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
      width: Config.pageStyle.deviceWidth,
      padding: EdgeInsets.symmetric(horizontal: Config.pageStyle.unitWidth * 20),
      alignment: Alignment.centerRight,
      child: InkWell(
        onTap: () => Navigator.pushNamed(
          context,
          Routes.forgotPassword,
          arguments: widget.isFromCheckout,
        ),
        child: Text(
          'ask_forgot_password'.tr(),
          style: mediumTextStyle.copyWith(
            color: Colors.white54,
            fontSize: Config.pageStyle.unitFontSize * 14,
          ),
        ),
      ),
    );
  }

  Widget _buildOrDivider() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: Config.pageStyle.unitWidth * 50),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(child: Divider(color: greyLightColor, thickness: 0.5)),
          Text(
            'or_divider'.tr(),
            style: mediumTextStyle.copyWith(
              fontSize: Config.pageStyle.unitFontSize * 17,
              color: Colors.white,
            ),
          ),
          Expanded(child: Divider(color: greyLightColor, thickness: 0.5)),
        ],
      ),
    );
  }

  Widget _buildExternalSignInButtons() {
    return Container(
      width: Config.pageStyle.deviceWidth,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          InkWell(
            onTap: () => _onFacebookSign(),
            child: SvgPicture.asset(facebookIcon),
          ),
          SizedBox(width: Config.pageStyle.unitWidth * 20),
          InkWell(
            onTap: () => _onGoogleSign(),
            child: SvgPicture.asset(googleIcon),
          ),
          if (Platform.isIOS) ...[
            Row(
              children: [
                SizedBox(width: Config.pageStyle.unitWidth * 20),
                InkWell(
                  onTap: () => _onAppleSign(),
                  child: SvgPicture.asset(appleIcon),
                ),
              ],
            )
          ],
        ],
      ),
    );
  }

  Widget _buildSignUpPhase() {
    return Container(
      width: Config.pageStyle.deviceWidth,
      padding: EdgeInsets.only(bottom: Config.pageStyle.unitHeight * 60),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'ask_have_account'.tr() + ' ',
            style: mediumTextStyle.copyWith(
              color: Colors.white,
              fontSize: Config.pageStyle.unitFontSize * 17,
            ),
          ),
          InkWell(
            onTap: () => Navigator.pushNamed(context, Routes.signUp),
            child: Text(
              'sign_up'.tr(),
              style: mediumTextStyle.copyWith(
                color: Colors.white,
                fontSize: Config.pageStyle.unitFontSize * 17,
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
        print('/// Canceled By User ///');
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
      final graphResponse =
          await http.get(Uri.parse('https://graph.facebook.com/v2.12/me?fields=name,first_name,last_name,email&access_token=$token'));
      final profile = json.decode(graphResponse.body);
      String firstName = profile['first_name'];
      String lastName = profile['last_name'];
      String email = profile['email'];
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
      if (googleAccount != null) {
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
      }
    } catch (error) {
      print(error);
    }
  }

  void _onAppleSign() async {
    try {
      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );
      String email = credential.email;
      String appleId = credential.userIdentifier;
      String firstName = credential.givenName;
      String lastName = credential.familyName;
      if (email == null) {
        final faker = Faker();
        String fakeEmail = faker.internet.freeEmail();
        int timestamp = DateTime.now().microsecondsSinceEpoch;
        email = '$timestamp-$fakeEmail';
      }
      signInBloc.add(SocialSignInSubmitted(
        email: email,
        firstName: firstName,
        lastName: lastName,
        loginType: 'apple',
        lang: lang,
        appleId: appleId,
      ));
    } catch (error) {
      print(error);
    }
  }
}
