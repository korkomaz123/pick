import 'dart:convert';
import 'dart:io';

import 'package:adjust_sdk/adjust.dart';
import 'package:adjust_sdk/adjust_attribution.dart';
import 'package:adjust_sdk/adjust_config.dart';
import 'package:adjust_sdk/adjust_event_failure.dart';
import 'package:adjust_sdk/adjust_event_success.dart';
import 'package:adjust_sdk/adjust_session_failure.dart';
import 'package:adjust_sdk/adjust_session_success.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:markaa/src/utils/repositories/category_repository.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:provider/provider.dart';
import 'package:kommunicate_flutter/kommunicate_flutter.dart';
import 'package:markaa/src/change_notifier/address_change_notifier.dart';
import 'package:markaa/src/change_notifier/my_cart_change_notifier.dart';
import 'package:markaa/src/change_notifier/order_change_notifier.dart';
import 'package:markaa/src/change_notifier/wishlist_change_notifier.dart';
import 'package:markaa/src/routes/routes.dart';
import 'package:markaa/src/utils/repositories/app_repository.dart';
import 'package:markaa/src/utils/repositories/checkout_repository.dart';
import 'package:markaa/src/utils/repositories/shipping_address_repository.dart';

import 'src/change_notifier/home_change_notifier.dart';
import 'src/config/config.dart';
import 'src/data/mock/mock.dart';
import 'src/utils/repositories/local_storage_repository.dart';
import 'src/utils/repositories/sign_in_repository.dart';

import 'env.dart';

class Preload {
  static String baseUrl = "";
  static String imagesUrl = "";
  static String? languageCode;

  static String get language =>
      EasyLocalization.of(navigatorKey!.currentContext!)!
          .locale
          .languageCode
          .toLowerCase();
  static set language(String val) => setLanguage(val: val);

  static setLanguage({String? val}) {
    if (val != null && val.isNotEmpty) {
      lang = languageCode = val;
    } else {
      lang = languageCode = language;
    }

    final enLocale = EasyLocalization.of(navigatorKey!.currentContext!)!
        .supportedLocales
        .first;
    final arLocale = EasyLocalization.of(navigatorKey!.currentContext!)!
        .supportedLocales
        .last;

    if (lang == 'en') {
      navigatorKey!.currentContext!.setLocale(enLocale);
      FirebaseMessaging.instance
          .unsubscribeFromTopic(MarkaaNotificationChannels.arChannel);
      FirebaseMessaging.instance
          .subscribeToTopic(MarkaaNotificationChannels.enChannel);
    } else {
      navigatorKey!.currentContext!.setLocale(arLocale);
      FirebaseMessaging.instance
          .unsubscribeFromTopic(MarkaaNotificationChannels.enChannel);
      FirebaseMessaging.instance
          .subscribeToTopic(MarkaaNotificationChannels.arChannel);
    }
    OneSignal.shared.sendTag('lang', lang);
    loadAssetData();
    loadCustomerData();
  }

  static GlobalKey<NavigatorState>? navigatorKey = GlobalKey<NavigatorState>();

  static final homeChangeNotifier = HomeChangeNotifier();
  static final myCartChangeNotifier = MyCartChangeNotifier();

  static final categoryRepository = CategoryRepository();
  static final checkoutRepository = CheckoutRepository();
  static final shippingAddressRepository = ShippingAddressRepository();
  static final signInRepository = SignInRepository();
  static final localRepository = LocalStorageRepository();
  static final appRepository = AppRepository();

  static Future<dynamic> checkAppVersion() async {
    print('CHECKING THE APP VERSION');
    final versionEntity =
        await appRepository.checkAppVersion(Platform.isAndroid);
    if (versionEntity.updateMandatory) {
      Navigator.pushReplacementNamed(
        navigatorKey!.currentContext!,
        Routes.update,
        arguments: versionEntity.storeLink,
      );
    } else if (versionEntity.canUpdate) {}
    return versionEntity.updateMandatory;
  }

  static firebaseLogin() async {
    String? firebaseUserId = signInRepository.getFirebaseUser();
    if (firebaseUserId == null) {
      await signInRepository.loginFirebase(
        email: MarkaaReporter.email,
        password: MarkaaReporter.password,
      );
    }
  }

  static loadAssetData() {
    homeChangeNotifier.getHomeCategories();
    checkoutRepository
        .getShippingMethod()
        .then((result) => shippingMethods = result)
        .catchError((error) {
      print('GET SHIPPING METHOD TIMEOUT ERROR: $error');
    });
    checkoutRepository
        .getPaymentMethod()
        .then((result) => paymentMethods = result)
        .catchError((error) {
      print('GET PAYMENT METHOD TIMEOUT ERROR: $error');
    });
    shippingAddressRepository
        .getRegions()
        .then((result) => regions = result)
        .catchError((error) {
      print('GET REGION LIST TIMEOUT ERROR: $error');
    });
    categoryRepository
        .getMenuCategories()
        .then((result) => sideMenus[languageCode!])
        .catchError((error) {
      print('GET SIDEMENUS TIMEOUT ERROR: $error');
    });
  }

  static loadCustomerData() async {
    if (user != null) {
      navigatorKey!.currentContext!
          .read<WishlistChangeNotifier>()
          .getWishlistItems(user!.token, lang);
      navigatorKey!.currentContext!
          .read<OrderChangeNotifier>()
          .loadOrderHistories(user!.token, lang);
      navigatorKey!.currentContext!.read<AddressChangeNotifier>().initialize();
      navigatorKey!.currentContext!
          .read<AddressChangeNotifier>()
          .loadAddresses(user!.token);
    }
  }

  static setupAdjustSDK() async {
    AdjustConfig config = new AdjustConfig(
      AdjustSDKConfig.app,
      dev ? AdjustEnvironment.sandbox : AdjustEnvironment.production,
    );
    config.logLevel = AdjustLogLevel.verbose;

    config.attributionCallback = (AdjustAttribution attributionChangedData) {
      print('[Adjust]: Attribution changed!');
      print('[Adjust]: Tracker token: ' + attributionChangedData.trackerToken!);
      print('[Adjust]: Tracker name: ' + attributionChangedData.trackerName!);
      print('[Adjust]: Campaign: ' + attributionChangedData.campaign!);
      print('[Adjust]: Network: ' + attributionChangedData.network!);
      print('[Adjust]: Creative: ' + attributionChangedData.creative!);
      print('[Adjust]: Adgroup: ' + attributionChangedData.adgroup!);
      print('[Adjust]: Click label: ' + attributionChangedData.clickLabel!);
      print('[Adjust]: Adid: ' + attributionChangedData.adid!);
    };

    config.sessionSuccessCallback = (AdjustSessionSuccess sessionSuccessData) {
      print('[Adjust]: Session tracking success!');
      print('[Adjust]: Message: ' + sessionSuccessData.message!);
      print('[Adjust]: Timestamp: ' + sessionSuccessData.timestamp!);
      print('[Adjust]: Adid: ' + sessionSuccessData.adid!);
      print('[Adjust]: JSON response: ' + sessionSuccessData.jsonResponse!);
    };

    config.sessionFailureCallback = (AdjustSessionFailure sessionFailureData) {
      print('[Adjust]: Session tracking failure!');
      print('[Adjust]: Message: ' + sessionFailureData.message!);
      print('[Adjust]: Timestamp: ' + sessionFailureData.timestamp!);
      print('[Adjust]: Adid: ' + sessionFailureData.adid!);
      print('[Adjust]: Will retry: ' + sessionFailureData.willRetry.toString());
      print('[Adjust]: JSON response: ' + sessionFailureData.jsonResponse!);
    };

    config.eventSuccessCallback = (AdjustEventSuccess eventSuccessData) {
      print('[Adjust]: Event tracking success!');
      print('[Adjust]: Event token: ' + eventSuccessData.eventToken!);
      print('[Adjust]: Message: ' + eventSuccessData.message!);
      print('[Adjust]: Timestamp: ' + eventSuccessData.timestamp!);
      print('[Adjust]: Adid: ' + eventSuccessData.adid!);
      print('[Adjust]: Callback ID: ' + eventSuccessData.callbackId!);
      print('[Adjust]: JSON response: ' + eventSuccessData.jsonResponse!);
    };

    config.eventFailureCallback = (AdjustEventFailure eventFailureData) {
      print('[Adjust]: Event tracking failure!');
      print('[Adjust]: Event token: ' + eventFailureData.eventToken!);
      print('[Adjust]: Message: ' + eventFailureData.message!);
      print('[Adjust]: Timestamp: ' + eventFailureData.timestamp!);
      print('[Adjust]: Adid: ' + eventFailureData.adid!);
      print('[Adjust]: Callback ID: ' + eventFailureData.callbackId!);
      print('[Adjust]: Will retry: ${eventFailureData.willRetry!}');
      print('[Adjust]: JSON response: ' + eventFailureData.jsonResponse!);
    };

    config.launchDeferredDeeplink = true;
    config.deferredDeeplinkCallback = (String? uri) {
      print('[Adjust]: Received deferred deeplink: ' + uri!);
    };

    // Add session callback parameters.
    Adjust.addSessionCallbackParameter('scp_foo_1', 'scp_bar');
    Adjust.addSessionCallbackParameter('scp_foo_2', 'scp_value');

    // Add session Partner parameters.
    Adjust.addSessionPartnerParameter('spp_foo_1', 'spp_bar');
    Adjust.addSessionPartnerParameter('spp_foo_2', 'spp_value');

    // Remove session callback parameters.
    Adjust.removeSessionCallbackParameter('scp_foo_1');
    Adjust.removeSessionPartnerParameter('spp_foo_1');

    // Clear all session callback parameters.
    Adjust.resetSessionCallbackParameters();

    // Clear all session partner parameters.
    Adjust.resetSessionPartnerParameters();

    // Start SDK.
    Adjust.start(config);
  }

  static bool chatInitiated = false;
  static Future startSupportChat() async {
    dynamic kmUser, conversationObject = {'appId': ChatSupport.appKey};
    kmUser = {
      'userId': user!.customerId,
      'displayName': user!.firstName + " " + user!.lastName,
      'contactNumber': user!.phoneNumber,
      'email': user!.email,
    };
    conversationObject['kmUser'] = jsonEncode(kmUser);
    dynamic clientConversationId =
        await KommunicateFlutterPlugin.buildConversation(conversationObject);
    print("Conversation builder success : " + clientConversationId.toString());
    chatInitiated = true;
  }
}
