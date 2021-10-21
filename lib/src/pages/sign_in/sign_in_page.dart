import 'dart:io';

import 'package:markaa/env.dart';
import 'package:markaa/slack.dart';
import 'package:markaa/src/apis/api.dart';
import 'package:markaa/src/apis/endpoints.dart';
import 'package:markaa/src/change_notifier/auth_change_notifier.dart';
import 'package:markaa/src/change_notifier/home_change_notifier.dart';
import 'package:markaa/src/change_notifier/order_change_notifier.dart';
import 'package:markaa/src/change_notifier/address_change_notifier.dart';
import 'package:markaa/src/components/markaa_text_button.dart';
import 'package:markaa/src/data/mock/mock.dart';
import 'package:markaa/src/data/models/index.dart';
import 'package:markaa/src/pages/home/notification_setup.dart';
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
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:markaa/src/utils/services/flushbar_service.dart';
import 'package:markaa/src/utils/services/progress_service.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:string_validator/string_validator.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../preload.dart';

class SignInPage extends StatefulWidget {
  final bool isFromCheckout;

  SignInPage({this.isFromCheckout = false});

  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  FocusNode emailNode = FocusNode();
  FocusNode passNode = FocusNode();

  bool isShowPass = false;

  late AuthChangeNotifier authChangeNotifier;
  late HomeChangeNotifier homeChangeNotifier;
  late MyCartChangeNotifier myCartChangeNotifier;
  late WishlistChangeNotifier wishlistChangeNotifier;
  late OrderChangeNotifier orderChangeNotifier;
  late AddressChangeNotifier addressChangeNotifier;

  late ProgressService progressService;
  late FlushBarService flushBarService;

  final LocalStorageRepository localRepository = LocalStorageRepository();

  @override
  void initState() {
    super.initState();

    progressService = ProgressService(context: context);
    flushBarService = FlushBarService(context: context);

    authChangeNotifier = context.read<AuthChangeNotifier>();
    homeChangeNotifier = context.read<HomeChangeNotifier>();
    myCartChangeNotifier = context.read<MyCartChangeNotifier>();
    wishlistChangeNotifier = context.read<WishlistChangeNotifier>();
    orderChangeNotifier = context.read<OrderChangeNotifier>();
    addressChangeNotifier = context.read<AddressChangeNotifier>();
  }

  void _onPrivacyPolicy() async {
    String url = EndPoints.privacyAndPolicy;
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      flushBarService.showErrorDialog('can_not_launch_url'.tr());
    }
  }

  @override
  Widget build(BuildContext context) {
    Preload.setLanguage();
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: primarySwatchColor,
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Container(
                width: 375.w,
                padding: EdgeInsets.only(top: 30.h, bottom: 30.h),
                alignment:
                    lang == 'en' ? Alignment.centerLeft : Alignment.centerRight,
                child: IconButton(
                  icon: Icon(Icons.arrow_back_ios, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
              Container(
                padding: EdgeInsets.only(top: 40.h, bottom: 100.h),
                alignment: Alignment.center,
                child: SvgPicture.asset(
                  hLogoIcon,
                  width: 120.w,
                  height: 45.h,
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
              Center(
                child: InkWell(
                  onTap: _onPrivacyPolicy,
                  child: Text(
                    'suffix_agree_terms'.tr(),
                    style: mediumTextStyle.copyWith(
                      color: Colors.white54,
                      fontSize: 16.sp,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmail() {
    return Container(
      width: 375.w,
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: TextFormField(
        controller: emailController,
        style: mediumTextStyle.copyWith(
          color: Colors.white,
          fontSize: 15.sp,
        ),
        validator: (value) {
          if (value!.isEmpty) {
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
            fontSize: 15.sp,
          ),
          errorStyle: mediumTextStyle.copyWith(
            color: Color(0xFF00F5FF),
            fontSize: 12.sp,
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
      width: 375.w,
      padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 20.w),
      child: TextFormField(
        controller: passwordController,
        style: mediumTextStyle.copyWith(
          color: Colors.white,
          fontSize: 15.sp,
        ),
        validator: (value) {
          if (value!.isEmpty) {
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
            fontSize: 15.sp,
          ),
          errorStyle: mediumTextStyle.copyWith(
            color: Color(0xFF00F5FF),
            fontSize: 12.sp,
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
              size: 20.sp,
            ),
          ),
        ),
        obscureText: !isShowPass,
      ),
    );
  }

  Widget _buildSignInButton() {
    return Container(
      width: 375.w,
      height: 45.h,
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: MarkaaTextButton(
        title: 'sign_in'.tr(),
        titleSize: 18.sp,
        titleColor: primaryColor,
        buttonColor: Colors.white,
        borderColor: Colors.transparent,
        onPressed: () => _signIn(),
        radius: 30,
      ),
    );
  }

  Widget _buildForgotPassword() {
    return Container(
      width: 375.w,
      padding: EdgeInsets.symmetric(horizontal: 20.w),
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
            fontSize: 14.sp,
          ),
        ),
      ),
    );
  }

  Widget _buildOrDivider() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 50.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(child: Divider(color: greyLightColor, thickness: 0.5)),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Text(
              'or_divider'.tr(),
              style: mediumTextStyle.copyWith(
                fontSize: 17.sp,
                color: Colors.white,
              ),
            ),
          ),
          Expanded(child: Divider(color: greyLightColor, thickness: 0.5)),
        ],
      ),
    );
  }

  Widget _buildExternalSignInButtons() {
    return Container(
      width: 375.w,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          InkWell(
            onTap: () => _onFacebookSign(),
            child: SvgPicture.asset(facebookIcon),
          ),
          SizedBox(width: 20.w),
          InkWell(
            onTap: () => _onGoogleSign(),
            child: SvgPicture.asset(googleIcon),
          ),
          if (Platform.isIOS) ...[
            Row(
              children: [
                SizedBox(width: 20.w),
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
      width: 375.w,
      padding: EdgeInsets.only(bottom: 60.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'ask_have_account'.tr() + ' ',
            style: mediumTextStyle.copyWith(
              color: Colors.white,
              fontSize: 17.sp,
            ),
          ),
          InkWell(
            onTap: () => Navigator.pushNamed(context, Routes.signUp),
            child: Text(
              'sign_up'.tr(),
              style: mediumTextStyle.copyWith(
                color: Colors.white,
                fontSize: 17.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }

  _onLoginProcess() {
    progressService.showProgress();
  }

  Future _onLoginSuccess(UserEntity loggedInUser) async {
    try {
      user = loggedInUser;
      SlackChannels.send(
        '$env CUSTOMER LOGIN [${user!.email}][${user!.toJson()}]',
        SlackChannels.logAppUsers,
      );
      addressChangeNotifier.initialize();
      Future.wait([
        localRepository.setToken(user!.token),
        orderChangeNotifier.loadOrderHistories(user!.token, lang),
        myCartChangeNotifier.getCartId(),
        myCartChangeNotifier.transferCartItems(),
        myCartChangeNotifier.getCartItems(lang),
        wishlistChangeNotifier.getWishlistItems(user!.token, lang),
        addressChangeNotifier.loadAddresses(user!.token),
        homeChangeNotifier.loadRecentlyViewedCustomer(),
        NotificationSetup().updateFcmDeviceToken(),
      ]);
    } catch (e) {
      print(
          'LOADING CUSTOMER DATA WHEN LOGIN SUCCESS ON LOGIN PAGE CATCH ERROR: $e');
    }
    progressService.hideProgress();
    if (Navigator.of(context).canPop()) {
      Navigator.pop(context);
    } else {
      Navigator.pushNamedAndRemoveUntil(context, Routes.home, (route) => false);
    }
  }

  _onLoginFailure(message) {
    progressService.hideProgress();
    flushBarService.showErrorDialog(message);
  }

  _signIn() {
    if (_formKey.currentState!.validate()) {
      authChangeNotifier.login(
        emailController.text,
        passwordController.text,
        onProcess: _onLoginProcess,
        onSuccess: _onLoginSuccess,
        onFailure: _onLoginFailure,
      );
    }
  }

  void _onFacebookSign() async {
    final facebookAuth = FacebookAuth.instance;
    final result = await facebookAuth.login();
    if (result.status == LoginStatus.operationInProgress) return;
    switch (result.status) {
      case LoginStatus.success:
        _loadFacebookAccount(result);
        break;
      case LoginStatus.cancelled:
        flushBarService.showErrorDialog('FACEBOOK LOGIN: CANCELED');
        break;
      case LoginStatus.failed:
        print('FACEBOOK LOGIN: FAILED: ${result.message!}');
        flushBarService.showErrorDialog(result.message!);
        break;
      default:
        print('FACEBOOK LOGIN: UNKNOWN STATUS');
        flushBarService.showErrorDialog('Login failed, try again later.');
    }
  }

  void _loadFacebookAccount(LoginResult result) async {
    try {
      final token = result.accessToken!.token;
      final profile = await Api.getMethod(
          'https://graph.facebook.com/v2.12/me?fields=name,first_name,last_name,email&access_token=$token');
      String firstName = profile['first_name'];
      String lastName = profile['last_name'];
      String email = profile['email'];
      authChangeNotifier.loginWithSocial(
          email, firstName, lastName, 'Facebook Sign', lang,
          onProcess: _onLoginProcess,
          onSuccess: _onLoginSuccess,
          onFailure: _onLoginFailure);
    } catch (e) {
      print('LOAD FACEBOOK CREDENTIAL: CATCH ERROR $e');
    }
  }

  void _onGoogleSign() async {
    GoogleSignIn _googleSignIn = GoogleSignIn();
    try {
      await _googleSignIn.signOut();
      final googleAccount = await _googleSignIn.signIn();
      if (googleAccount != null) {
        String email = googleAccount.email;
        String displayName = googleAccount.displayName!;
        String firstName = displayName.split(' ')[0];
        String lastName = displayName.split(' ')[1];
        authChangeNotifier.loginWithSocial(
            email, firstName, lastName, 'Google Sign', lang,
            onProcess: _onLoginProcess,
            onSuccess: _onLoginSuccess,
            onFailure: _onLoginFailure);
      }
    } catch (e) {
      print('/// LOGIN WITH GOOGLE ERROR: $e ///');
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
      String? email = credential.email;
      String appleId = credential.userIdentifier!;
      String firstName = credential.givenName!;
      String lastName = credential.familyName!;
      if (email == null) {
        final faker = Faker();
        String fakeEmail = faker.internet.freeEmail();
        int timestamp = DateTime.now().microsecondsSinceEpoch;
        email = '$timestamp-$fakeEmail';
      }
      authChangeNotifier.loginWithSocial(
          email, firstName, lastName, 'apple', lang,
          appleId: appleId,
          onProcess: _onLoginProcess,
          onSuccess: _onLoginSuccess,
          onFailure: _onLoginFailure);
    } catch (e) {
      print('LOGIN WITH APPLE ERROR: $e');
    }
  }
}
