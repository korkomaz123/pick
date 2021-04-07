import 'dart:convert';
import 'dart:io';

import 'package:adjust_sdk/adjust.dart';
import 'package:adjust_sdk/adjust_event.dart';
import 'package:faker/faker.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:markaa/src/change_notifier/home_change_notifier.dart';
import 'package:markaa/src/change_notifier/markaa_app_change_notifier.dart';
import 'package:markaa/src/change_notifier/my_cart_change_notifier.dart';
import 'package:markaa/src/change_notifier/order_change_notifier.dart';
import 'package:markaa/src/change_notifier/wishlist_change_notifier.dart';
import 'package:markaa/src/change_notifier/address_change_notifier.dart';
import 'package:markaa/src/components/markaa_text_button.dart';
import 'package:markaa/src/data/models/index.dart';
import 'package:markaa/src/routes/routes.dart';
import 'package:markaa/src/utils/repositories/setting_repository.dart';
import 'package:markaa/src/utils/repositories/wishlist_repository.dart';
import 'package:markaa/src/utils/services/flushbar_service.dart';
import 'package:markaa/src/utils/services/progress_service.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:isco_custom_widgets/isco_custom_widgets.dart';
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
  final Function onClose;
  final bool isCheckout;

  MyCartQuickAccessLoginDialog({this.cartId, this.onClose, this.isCheckout});

  @override
  _MyCartQuickAccessLoginDialogState createState() =>
      _MyCartQuickAccessLoginDialogState();
}

class _MyCartQuickAccessLoginDialogState
    extends State<MyCartQuickAccessLoginDialog> {
  SignInBloc signInBloc;
  PageStyle pageStyle;
  LocalStorageRepository localRepo;
  HomeChangeNotifier homeChangeNotifier;
  ProgressService progressService;
  FlushBarService flushBarService;
  WishlistRepository wishlistRepo;
  SettingRepository settingRepo;
  MarkaaAppChangeNotifier markaaAppChangeNotifier;
  MyCartChangeNotifier myCartChangeNotifier;
  WishlistChangeNotifier wishlistChangeNotifier;
  OrderChangeNotifier orderChangeNotifier;
  AddressChangeNotifier addressChangeNotifier;

  @override
  void initState() {
    super.initState();
    signInBloc = context.read<SignInBloc>();
    progressService = ProgressService(context: context);
    flushBarService = FlushBarService(context: context);
    homeChangeNotifier = context.read<HomeChangeNotifier>();
    localRepo = context.read<LocalStorageRepository>();
    wishlistRepo = context.read<WishlistRepository>();
    settingRepo = context.read<SettingRepository>();
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
    homeChangeNotifier.loadRecentlyViewedCustomer(user.token, lang);
    progressService.hideProgress();
    markaaAppChangeNotifier.rebuild();
    widget.onClose();
  }

  @override
  Widget build(BuildContext context) {
    pageStyle = PageStyle(context, designWidth, designHeight);
    pageStyle.initializePageStyles();
    return Stack(
      children: [
        _buildBloc(),
        Container(
          width: pageStyle.deviceWidth,
          padding: EdgeInsets.symmetric(vertical: pageStyle.unitHeight * 10),
          color: primarySwatchColor,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'login_with'.tr(),
                style: mediumTextStyle.copyWith(
                  color: Colors.white,
                  fontSize: pageStyle.unitFontSize * 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: pageStyle.unitHeight * 10),
              _buildSocialSignInButtons(),
              SizedBox(height: pageStyle.unitHeight * 20),
              _buildAuthChoice(),
              SizedBox(height: pageStyle.unitHeight * 20),
              if (widget.isCheckout) ...[
                _buildContinueAsGuest(),
              ]
            ],
          ),
        ),
        Positioned(
          top: 0,
          right: 0,
          child: IconButton(
            icon: SvgPicture.asset(closeIcon, color: Colors.white),
            onPressed: widget.onClose,
          ),
        ),
      ],
    );
  }

  Widget _buildBloc() {
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
          flushBarService.showErrorMessage(pageStyle, state.message);
        }
      },
      child: Container(
        width: pageStyle.deviceWidth,
        height: pageStyle.deviceHeight,
        color: Colors.black38,
      ),
    );
  }

  Widget _buildSocialSignInButtons() {
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
          if (Platform.isIOS) ...[
            Row(
              children: [
                SizedBox(width: pageStyle.unitWidth * 20),
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

  Widget _buildAuthChoice() {
    return Container(
      width: pageStyle.deviceWidth,
      padding: EdgeInsets.symmetric(horizontal: pageStyle.unitWidth * 50),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          InkWell(
            onTap: () => _onLogin(),
            child: Text(
              'login'.tr(),
              style: mediumTextStyle.copyWith(
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
            onTap: () => _onRegister(),
            child: Text(
              'register'.tr(),
              style: mediumTextStyle.copyWith(
                color: Colors.white,
                fontSize: pageStyle.unitFontSize * 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContinueAsGuest() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: pageStyle.unitWidth * 60),
      child: MarkaaTextButton(
        title: 'continue_as_guest'.tr(),
        titleColor: Colors.white70,
        titleSize: pageStyle.unitFontSize * 16,
        buttonColor: primarySwatchColor,
        borderColor: Colors.white70,
        radius: pageStyle.unitFontSize * 10,
        onPressed: () async {
          AdjustEvent adjustEvent =
              new AdjustEvent(AdjustSDKConfig.completePurchaseToken);
          Adjust.trackEvent(adjustEvent);
          await myCartChangeNotifier.getCartItems(
              lang, _onProcess, _onReloadItemSuccess, _onFailure);
          widget.onClose();
        },
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
        flushBarService.showErrorMessage(
          pageStyle,
          '${myCartChangeNotifier.cartItemsMap[keys[i]].product.name}' +
              'out_stock_items_error'.tr(),
        );
        return;
      }
    }
    Navigator.pushNamed(context, Routes.checkoutGuestAddress);
  }

  void _onFailure(String message) {
    progressService.hideProgress();
    flushBarService.showErrorMessage(pageStyle, message);
  }

  void _onLogin() async {
    await Navigator.pushNamed(context, Routes.signIn, arguments: true);
    if (user?.token != null) {
      markaaAppChangeNotifier.rebuild();
      widget.onClose();
    }
  }

  void _onRegister() async {
    await Navigator.pushNamed(context, Routes.signUp, arguments: true);
    if (user?.token != null) {
      markaaAppChangeNotifier.rebuild();
      widget.onClose();
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
        flushBarService.showErrorMessage(pageStyle, 'Canceled by User');
        break;
      case FacebookLoginStatus.error:
        print('/// Facebook Login Error ///');
        print(result.errorMessage);
        flushBarService.showErrorMessage(pageStyle, result.errorMessage);
        break;
    }
  }

  void _loginWithFacebook(FacebookLoginResult result) async {
    try {
      final token = result.accessToken.token;
      final graphResponse = await http.get(
          'https://graph.facebook.com/v2.12/me?fields=name,first_name,last_name,email&access_token=$token');
      final profile = jsonDecode(graphResponse.body);
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
