import 'dart:io';

import 'package:adjust_sdk/adjust.dart';
import 'package:adjust_sdk/adjust_event.dart';
import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:markaa/preload.dart';
import 'package:markaa/src/apis/api.dart';
import 'package:markaa/src/change_notifier/home_change_notifier.dart';
import 'package:markaa/src/change_notifier/markaa_app_change_notifier.dart';
import 'package:markaa/src/change_notifier/my_cart_change_notifier.dart';
import 'package:markaa/src/change_notifier/order_change_notifier.dart';
import 'package:markaa/src/change_notifier/wishlist_change_notifier.dart';
import 'package:markaa/src/change_notifier/address_change_notifier.dart';
import 'package:markaa/src/components/markaa_text_button.dart';
import 'package:markaa/src/components/markaa_text_icon_button.dart';
import 'package:markaa/src/data/models/index.dart';
import 'package:markaa/src/routes/routes.dart';
import 'package:markaa/src/utils/repositories/setting_repository.dart';
import 'package:markaa/src/utils/repositories/wishlist_repository.dart';
import 'package:markaa/src/utils/services/flushbar_service.dart';
import 'package:markaa/src/utils/services/progress_service.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';

import 'package:markaa/src/config/config.dart';
import 'package:markaa/src/data/mock/mock.dart';
import 'package:markaa/src/theme/icons.dart';
import 'package:markaa/src/theme/styles.dart';
import 'package:markaa/src/theme/theme.dart';
import 'package:markaa/src/utils/repositories/local_storage_repository.dart';
import 'package:markaa/src/pages/sign_in/bloc/sign_in_bloc.dart';

class MyCartQuickAccessLoginDialog extends StatefulWidget {
  final String cartId;
  final bool isCheckout;
  final Function prepareDetails;

  MyCartQuickAccessLoginDialog({
    this.cartId,
    this.isCheckout,
    this.prepareDetails,
  });

  @override
  _MyCartQuickAccessLoginDialogState createState() =>
      _MyCartQuickAccessLoginDialogState();
}

class _MyCartQuickAccessLoginDialogState
    extends State<MyCartQuickAccessLoginDialog> {
  SignInBloc signInBloc;

  final LocalStorageRepository localRepo = LocalStorageRepository();
  final WishlistRepository wishlistRepo = WishlistRepository();
  final SettingRepository settingRepo = SettingRepository();

  HomeChangeNotifier homeChangeNotifier;
  MarkaaAppChangeNotifier markaaAppChangeNotifier;
  MyCartChangeNotifier myCartChangeNotifier;
  WishlistChangeNotifier wishlistChangeNotifier;
  OrderChangeNotifier orderChangeNotifier;
  AddressChangeNotifier addressChangeNotifier;

  ProgressService progressService;
  FlushBarService flushBarService;

  @override
  void initState() {
    super.initState();

    signInBloc = context.read<SignInBloc>();

    progressService = ProgressService(context: context);
    flushBarService = FlushBarService(context: context);

    homeChangeNotifier = context.read<HomeChangeNotifier>();
    addressChangeNotifier = context.read<AddressChangeNotifier>();
    markaaAppChangeNotifier = context.read<MarkaaAppChangeNotifier>();
    myCartChangeNotifier = context.read<MyCartChangeNotifier>();
    wishlistChangeNotifier = context.read<WishlistChangeNotifier>();
    orderChangeNotifier = context.read<OrderChangeNotifier>();
  }

  void _loggedInSuccess(UserEntity loggedInUser) async {
    try {
      user = loggedInUser;
      await localRepo.setToken(user.token);
      await myCartChangeNotifier.getCartId();
      await myCartChangeNotifier.transferCartItems();
      await myCartChangeNotifier.getCartItems(lang);
      await wishlistChangeNotifier.getWishlistItems(user.token, lang);
      await orderChangeNotifier.loadOrderHistories(user.token, lang);
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
    homeChangeNotifier.loadRecentlyViewedCustomer();
    progressService.hideProgress();
    markaaAppChangeNotifier.rebuild();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SignInBloc, SignInState>(
      listener: (context, state) {
        if (state is SignInSubmittedInProcess) {
          progressService.showProgress();
        }
        if (state is SignInSubmittedSuccess) {
          _loggedInSuccess(state.user);
        }
        if (state is SignInSubmittedFailure) {
          progressService.hideProgress();
          flushBarService.showErrorDialog(state.message);
        }
      },
      child: Material(
        color: Colors.black38,
        type: MaterialType.transparency,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 375.w,
              padding: EdgeInsets.only(bottom: 20.h),
              color: Colors.white,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Align(
                    alignment: Preload.languageCode == 'en'
                        ? Alignment.topRight
                        : Alignment.topLeft,
                    child: IconButton(
                      icon: SvgPicture.asset(closeIcon),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                  Text(
                    'login_with'.tr(),
                    style: mediumTextStyle.copyWith(
                      color: primaryColor,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10.h),
                  _buildSocialSignInButtons(),
                  SizedBox(height: 20.h),
                  _buildAuthChoice(),
                  SizedBox(height: 20.h),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSocialSignInButtons() {
    return Container(
      width: 375.w,
      child: Column(
        children: [
          Container(
            width: 220.w,
            height: 50.h,
            child: MarkaaTextIconButton(
              title: 'continue_with_google'.tr(),
              titleSize: 12.sp,
              titleColor: primaryColor,
              buttonColor: Colors.white,
              borderColor: greyLightColor,
              icon: SvgPicture.asset(googleIcon),
              radius: 30.sp,
              onPressed: _onGoogleSign,
            ),
          ),
          SizedBox(height: 10.h),
          Container(
            width: 220.w,
            height: 50.h,
            child: MarkaaTextIconButton(
              title: 'continue_with_facebook'.tr(),
              titleSize: 12.sp,
              titleColor: Colors.white,
              buttonColor: primaryColor,
              borderColor: greyLightColor,
              icon: SvgPicture.asset(facebookCircleIcon),
              radius: 30.sp,
              onPressed: _onFacebookSign,
            ),
          ),
          if (Platform.isIOS) ...[
            SizedBox(height: 10.h),
            Container(
              width: 220.w,
              height: 50.h,
              child: MarkaaTextIconButton(
                title: 'continue_with_apple'.tr(),
                titleSize: 12.sp,
                titleColor: Colors.white,
                buttonColor: darkColor,
                borderColor: darkColor,
                icon: SvgPicture.asset(appleCircleIcon),
                radius: 30.sp,
                onPressed: _onAppleSign,
              ),
            ),
          ],
          if (widget.isCheckout) ...[
            SizedBox(height: 10.h),
            Container(
              width: 220.w,
              height: 50.h,
              child: MarkaaTextButton(
                title: 'continue_as_guest'.tr(),
                titleSize: 12.sp,
                titleColor: primaryColor,
                buttonColor: Colors.white,
                borderColor: primaryColor,
                radius: 30.sp,
                onPressed: () async {
                  AdjustEvent adjustEvent =
                      new AdjustEvent(AdjustSDKConfig.initiateCheckout);
                  Adjust.trackEvent(adjustEvent);

                  adjustEvent = new AdjustEvent(AdjustSDKConfig.checkout);
                  Adjust.trackEvent(adjustEvent);

                  await myCartChangeNotifier.getCartItems(
                      lang, _onProcess, _onReloadItemSuccess, _onFailure);
                },
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildAuthChoice() {
    return Container(
      width: 375.w,
      padding: EdgeInsets.symmetric(horizontal: 50.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          InkWell(
            onTap: () => _onLogin(),
            child: Text(
              'login'.tr(),
              style: mediumTextStyle.copyWith(
                fontSize: 14.sp,
              ),
            ),
          ),
          Container(
            height: 20.h,
            child: VerticalDivider(color: darkColor, thickness: 0.5),
          ),
          InkWell(
            onTap: () => _onRegister(),
            child: Text(
              'register'.tr(),
              style: mediumTextStyle.copyWith(
                fontSize: 14.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _onProcess() {
    progressService.showProgress();
  }

  void _onReloadItemSuccess() {
    progressService.hideProgress();
    List<String> keys = myCartChangeNotifier.cartItemsMap.keys.toList();
    for (int i = 0; i < myCartChangeNotifier.cartItemCount; i++) {
      if (myCartChangeNotifier.cartItemsMap[keys[i]].availableCount == 0) {
        flushBarService.showErrorDialog(
          '${myCartChangeNotifier.cartItemsMap[keys[i]].product.name}' +
              'out_stock_items_error'.tr(),
        );
        return;
      }
    }
    widget.prepareDetails();
    Navigator.popAndPushNamed(context, Routes.checkout);
  }

  void _onFailure(String message) {
    progressService.hideProgress();
    flushBarService.showErrorDialog(message);
  }

  void _onLogin() async {
    await Navigator.pushNamed(context, Routes.signIn, arguments: true);
    if (user?.token != null) {
      Navigator.pop(context);
    }
  }

  void _onRegister() async {
    await Navigator.pushNamed(context, Routes.signUp, arguments: true);
    if (user?.token != null) {
      Navigator.pop(context);
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
        flushBarService.showErrorDialog('Canceled by User');
        break;
      case FacebookLoginStatus.error:
        print('/// Facebook Login Error ///');
        print(result.errorMessage);
        flushBarService.showErrorDialog(result.errorMessage);
        break;
    }
  }

  void _loginWithFacebook(FacebookLoginResult result) async {
    try {
      final token = result.accessToken.token;
      final profile = await Api.getMethod(
          'https://graph.facebook.com/v2.12/me?fields=name,first_name,last_name,email&access_token=$token');
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
      String firstName = credential.givenName;
      String lastName = credential.familyName;
      String appleId = credential.userIdentifier;
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
