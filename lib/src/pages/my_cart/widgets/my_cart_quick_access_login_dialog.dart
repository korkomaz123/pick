import 'dart:io';

import 'package:adjust_sdk/adjust.dart';
import 'package:adjust_sdk/adjust_event.dart';
import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:google_sign_in/google_sign_in.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:markaa/env.dart';
import 'package:markaa/preload.dart';
import 'package:markaa/slack.dart';
import 'package:markaa/src/apis/api.dart';
import 'package:markaa/src/change_notifier/auth_change_notifier.dart';
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
import 'package:markaa/src/utils/services/flushbar_service.dart';
import 'package:markaa/src/utils/services/progress_service.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:provider/provider.dart';
import 'package:markaa/src/config/config.dart';
import 'package:markaa/src/data/mock/mock.dart';
import 'package:markaa/src/theme/icons.dart';
import 'package:markaa/src/theme/styles.dart';
import 'package:markaa/src/theme/theme.dart';
import 'package:markaa/src/utils/repositories/local_storage_repository.dart';

class MyCartQuickAccessLoginDialog extends StatefulWidget {
  final String cartId;
  final bool isCheckout;
  final Function prepareDetails;

  MyCartQuickAccessLoginDialog({
    required this.cartId,
    required this.isCheckout,
    required this.prepareDetails,
  });

  @override
  _MyCartQuickAccessLoginDialogState createState() => _MyCartQuickAccessLoginDialogState();
}

class _MyCartQuickAccessLoginDialogState extends State<MyCartQuickAccessLoginDialog> {
  final LocalStorageRepository localRepository = LocalStorageRepository();
  final SettingRepository settingRepository = SettingRepository();

  late AuthChangeNotifier authChangeNotifier;
  late HomeChangeNotifier homeChangeNotifier;
  late MarkaaAppChangeNotifier markaaAppChangeNotifier;
  late MyCartChangeNotifier myCartChangeNotifier;
  late WishlistChangeNotifier wishlistChangeNotifier;
  late OrderChangeNotifier orderChangeNotifier;
  late AddressChangeNotifier addressChangeNotifier;

  late ProgressService progressService;
  late FlushBarService flushBarService;

  @override
  void initState() {
    super.initState();

    progressService = ProgressService(context: context);
    flushBarService = FlushBarService(context: context);

    authChangeNotifier = context.read<AuthChangeNotifier>();
    homeChangeNotifier = context.read<HomeChangeNotifier>();
    addressChangeNotifier = context.read<AddressChangeNotifier>();
    markaaAppChangeNotifier = context.read<MarkaaAppChangeNotifier>();
    myCartChangeNotifier = context.read<MyCartChangeNotifier>();
    wishlistChangeNotifier = context.read<WishlistChangeNotifier>();
    orderChangeNotifier = context.read<OrderChangeNotifier>();
  }

  void _onLoginSuccess(UserEntity loggedInUser) async {
    try {
      user = loggedInUser;
      SlackChannels.send(
        '$env CUSTOMER LOGIN [${user!.email}][${user!.toJson()}]\r\n [DashboardVisitorUrl => $gDashboardVisitorUrl] [DashboardSessionUrl => $gDashboardSessionUrl]',
        SlackChannels.logAppUsers,
      );
      addressChangeNotifier.initialize();
      // Future.wait([
      await localRepository.setToken(user!.token);
      await myCartChangeNotifier.getCartId();
      await myCartChangeNotifier.transferCartItems();
      await myCartChangeNotifier.getCartItems(lang);
      await wishlistChangeNotifier.getWishlistItems(user!.token, lang);
      await orderChangeNotifier.loadOrderHistories(user!.token, lang);
      await addressChangeNotifier.loadCustomerAddresses(user!.token);
      await homeChangeNotifier.loadRecentlyViewedCustomer();
      await settingRepository.updateFcmDeviceToken(
        user!.token,
        Platform.isAndroid ? deviceToken : '',
        Platform.isIOS ? deviceToken : '',
        Platform.isAndroid ? lang : '',
        Platform.isIOS ? lang : '',
      );
      // ]);
    } catch (e) {
      print('LOADING CUSTOMER DATA WHEN LOGIN SUCCESS ON QUICK ACCESS LOGIN PAGE $e');
    }
    progressService.hideProgress();
    markaaAppChangeNotifier.rebuild();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Material(
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
                  alignment: Preload.languageCode == 'en' ? Alignment.topRight : Alignment.topLeft,
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
                  AdjustEvent adjustEvent = new AdjustEvent(AdjustSDKConfig.initiateCheckout);
                  Adjust.trackEvent(adjustEvent);

                  adjustEvent = new AdjustEvent(AdjustSDKConfig.checkout);
                  Adjust.trackEvent(adjustEvent);

                  await myCartChangeNotifier.getCartItems(lang, _onProcess, _onReloadItemSuccess, _onFailure);
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

  void _onReloadItemSuccess(int count) {
    progressService.hideProgress();
    List<String> keys = myCartChangeNotifier.cartItemsMap.keys.toList();
    if (count == 0) {
      flushBarService.showErrorDialog('cart_empty_error'.tr());
      return;
    }
    for (int i = 0; i < myCartChangeNotifier.cartItemCount; i++) {
      var item = myCartChangeNotifier.cartItemsMap[keys[i]]!;
      if (item.availableCount == 0) {
        flushBarService.showErrorDialog(
          '${item.product.name}' + 'out_stock_items_error'.tr(),
          'no_qty.svg',
        );
        return;
      }
      if (item.itemCount > item.availableCount) {
        flushBarService.showErrorDialog(
          'inventory_qty_exceed_error'.tr().replaceFirst('A', item.product.name),
          'no_qty.svg',
        );
        return;
      }
    }
    widget.prepareDetails();
    Navigator.popAndPushNamed(context, Routes.checkout);
  }

  void _onProcess() {
    progressService.showProgress();
  }

  void _onFailure(String message) {
    progressService.hideProgress();
    flushBarService.showErrorDialog(message);
  }

  void _onLogin() async {
    await Navigator.pushNamed(context, Routes.signIn, arguments: true);
    if (user != null) Navigator.pop(context);
  }

  void _onRegister() async {
    await Navigator.pushNamed(context, Routes.signUp, arguments: true);
    if (user != null) Navigator.pop(context);
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
      authChangeNotifier.loginWithSocial(email, firstName, lastName, 'Facebook Sign', lang,
          onProcess: _onProcess, onSuccess: _onLoginSuccess, onFailure: _onFailure);
    } catch (e) {
      print('LOAD FACEBOOK CREDENTIAL: CATCH ERROR $e');
    }
  }

  void _onGoogleSign() async {
    GoogleSignIn _googleSignIn = GoogleSignIn();
    try {
      final googleAccount = await _googleSignIn.signIn();
      if (googleAccount != null) {
        String email = googleAccount.email;
        String displayName = googleAccount.displayName!;
        String firstName = displayName.split(' ')[0];
        String lastName = displayName.split(' ')[1];
        authChangeNotifier.loginWithSocial(email, firstName, lastName, 'Google Sign', lang,
            onProcess: _onProcess, onSuccess: _onLoginSuccess, onFailure: _onFailure);
      }
    } catch (e) {
      print('GOOGLE LOGIN CATCH ERROR: $e');
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
      String firstName = credential.givenName!;
      String lastName = credential.familyName!;
      String appleId = credential.userIdentifier!;
      if (email == null) {
        final faker = Faker();
        String fakeEmail = faker.internet.freeEmail();
        int timestamp = DateTime.now().microsecondsSinceEpoch;
        email = '$timestamp-$fakeEmail';
      }
      authChangeNotifier.loginWithSocial(email, firstName, lastName, 'apple', lang,
          appleId: appleId, onProcess: _onProcess, onSuccess: _onLoginSuccess, onFailure: _onFailure);
    } catch (e) {
      print('LOGIN WITH APPLE CATCH ERROR: $e');
    }
  }
}
