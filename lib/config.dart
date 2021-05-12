import 'package:adjust_sdk/adjust.dart';
import 'package:adjust_sdk/adjust_attribution.dart';
import 'package:adjust_sdk/adjust_config.dart';
import 'package:adjust_sdk/adjust_event_failure.dart';
import 'package:adjust_sdk/adjust_event_success.dart';
import 'package:adjust_sdk/adjust_session_failure.dart';
import 'package:adjust_sdk/adjust_session_success.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/widgets.dart';
import 'package:markaa/src/change_notifier/address_change_notifier.dart';
import 'package:markaa/src/change_notifier/order_change_notifier.dart';
import 'package:markaa/src/change_notifier/wishlist_change_notifier.dart';
import 'package:markaa/src/utils/repositories/checkout_repository.dart';
import 'package:markaa/src/utils/repositories/shipping_address_repository.dart';

import 'package:provider/provider.dart';
import 'src/config/config.dart';
import 'src/data/mock/mock.dart';
import 'src/data/models/user_entity.dart';
import 'src/utils/repositories/local_storage_repository.dart';
import 'src/utils/repositories/sign_in_repository.dart';

class Config {
  static String baseUrl = "";
  static String imagesUrl = "";
  static String languageCode;
  static String get language => EasyLocalization.of(navigatorKey.currentContext)
      .locale
      .languageCode
      .toLowerCase();
  static set language(String val) => setLanguage(val: val);

  static setLanguage({String val}) {
    val != null && val.isNotEmpty
        ? languageCode = val
        : languageCode = EasyLocalization.of(navigatorKey.currentContext)
            .locale
            .languageCode
            .toLowerCase();
    lang = languageCode;
  }

  static GlobalKey<NavigatorState> navigatorKey =
      new GlobalKey<NavigatorState>();
  static CheckoutRepository checkoutRepo = CheckoutRepository();
  static ShippingAddressRepository shippingAddressRepo =
      ShippingAddressRepository();
  // static MyCartChangeNotifier myCartChangeNotifier = MyCartChangeNotifier();
  static SignInRepository signInRepo = SignInRepository();

  static LocalStorageRepository localRepo = LocalStorageRepository();
  static Future<void> checkAppVersion() async {
    // final versionEntity = await AppRepository().checkAppVersion(Platform.isAndroid, lang);
    // if (versionEntity.updateMandatory) {
    //   Navigator.pushReplacementNamed(
    //     context,
    //     Routes.update,
    //     arguments: versionEntity.storeLink,
    //   );
    // } else if (versionEntity.canUpdate) {
    //   final result = await showDialog(
    //     context: context,
    //     builder: (context) {
    //       return UpdateAvailableDialog(
    //         title: versionEntity.dialogTitle,
    //         content: versionEntity.dialogContent,
    //       );
    //     },
    //   );
    //   if (result != null) {
    //     if (await canLaunch(versionEntity.storeLink)) {
    //       await launch(versionEntity.storeLink);
    //     }
    //   }
    // }
  }

  static loadAssets() async {
    if (signInRepo.getFirebaseUser() == null) {
      await signInRepo.loginFirebase(
          email: MarkaaReporter.email, password: MarkaaReporter.password);
    }
    await _getCurrentUser();
    if (user?.token != null) {
      //   isNotification = await settingRepo.getNotificationSetting(user.token);
      navigatorKey.currentContext
          .read<WishlistChangeNotifier>()
          .getWishlistItems(user.token, lang);
      navigatorKey.currentContext
          .read<OrderChangeNotifier>()
          .loadOrderHistories(user.token, lang);
      navigatorKey.currentContext.read<AddressChangeNotifier>().initialize();
      navigatorKey.currentContext
          .read<AddressChangeNotifier>()
          .loadAddresses(user.token);
    }
    await _loadExtraData();
  }

  static Future _loadExtraData() async {
    shippingMethods = await checkoutRepo.getShippingMethod();
    paymentMethods = await checkoutRepo.getPaymentMethod();
    regions = await shippingAddressRepo.getRegions();
    print("regions");
    print(regions);
  }

  static Future<void> _getCurrentUser() async {
    String token = await localRepo.getToken();
    if (token.isNotEmpty) {
      SignInRepository signInRepo = SignInRepository();
      final result = await signInRepo.getCurrentUser(token);
      if (result['code'] == 'SUCCESS') {
        result['data']['customer']['token'] = token;
        result['data']['customer']['profileUrl'] = result['data']['profileUrl'];
        user = UserEntity.fromJson(result['data']['customer']);
      } else {
        await localRepo.removeToken();
      }
    }
  }

  static appOpen() async {
    await checkAppVersion();
    bool isExist = await LocalStorageRepository().existItem('usage');
    if (isExist) {
      loadAssets();
    }
  }

  static setupAdjustSDK() async {
    AdjustConfig config = new AdjustConfig(
      AdjustSDKConfig.appToken,
      AdjustEnvironment.sandbox,
    );
    config.logLevel = AdjustLogLevel.verbose;

    config.attributionCallback = (AdjustAttribution attributionChangedData) {
      print('[Adjust]: Attribution changed!');

      if (attributionChangedData.trackerToken != null) {
        print(
            '[Adjust]: Tracker token: ' + attributionChangedData.trackerToken);
      }
      if (attributionChangedData.trackerName != null) {
        print('[Adjust]: Tracker name: ' + attributionChangedData.trackerName);
      }
      if (attributionChangedData.campaign != null) {
        print('[Adjust]: Campaign: ' + attributionChangedData.campaign);
      }
      if (attributionChangedData.network != null) {
        print('[Adjust]: Network: ' + attributionChangedData.network);
      }
      if (attributionChangedData.creative != null) {
        print('[Adjust]: Creative: ' + attributionChangedData.creative);
      }
      if (attributionChangedData.adgroup != null) {
        print('[Adjust]: Adgroup: ' + attributionChangedData.adgroup);
      }
      if (attributionChangedData.clickLabel != null) {
        print('[Adjust]: Click label: ' + attributionChangedData.clickLabel);
      }
      if (attributionChangedData.adid != null) {
        print('[Adjust]: Adid: ' + attributionChangedData.adid);
      }
    };

    config.sessionSuccessCallback = (AdjustSessionSuccess sessionSuccessData) {
      print('[Adjust]: Session tracking success!');

      if (sessionSuccessData.message != null) {
        print('[Adjust]: Message: ' + sessionSuccessData.message);
      }
      if (sessionSuccessData.timestamp != null) {
        print('[Adjust]: Timestamp: ' + sessionSuccessData.timestamp);
      }
      if (sessionSuccessData.adid != null) {
        print('[Adjust]: Adid: ' + sessionSuccessData.adid);
      }
      if (sessionSuccessData.jsonResponse != null) {
        print('[Adjust]: JSON response: ' + sessionSuccessData.jsonResponse);
      }
    };

    config.sessionFailureCallback = (AdjustSessionFailure sessionFailureData) {
      print('[Adjust]: Session tracking failure!');

      if (sessionFailureData.message != null) {
        print('[Adjust]: Message: ' + sessionFailureData.message);
      }
      if (sessionFailureData.timestamp != null) {
        print('[Adjust]: Timestamp: ' + sessionFailureData.timestamp);
      }
      if (sessionFailureData.adid != null) {
        print('[Adjust]: Adid: ' + sessionFailureData.adid);
      }
      if (sessionFailureData.willRetry != null) {
        print(
            '[Adjust]: Will retry: ' + sessionFailureData.willRetry.toString());
      }
      if (sessionFailureData.jsonResponse != null) {
        print('[Adjust]: JSON response: ' + sessionFailureData.jsonResponse);
      }
    };

    config.eventSuccessCallback = (AdjustEventSuccess eventSuccessData) {
      print('[Adjust]: Event tracking success!');

      if (eventSuccessData.eventToken != null) {
        print('[Adjust]: Event token: ' + eventSuccessData.eventToken);
      }
      if (eventSuccessData.message != null) {
        print('[Adjust]: Message: ' + eventSuccessData.message);
      }
      if (eventSuccessData.timestamp != null) {
        print('[Adjust]: Timestamp: ' + eventSuccessData.timestamp);
      }
      if (eventSuccessData.adid != null) {
        print('[Adjust]: Adid: ' + eventSuccessData.adid);
      }
      if (eventSuccessData.callbackId != null) {
        print('[Adjust]: Callback ID: ' + eventSuccessData.callbackId);
      }
      if (eventSuccessData.jsonResponse != null) {
        print('[Adjust]: JSON response: ' + eventSuccessData.jsonResponse);
      }
    };

    config.eventFailureCallback = (AdjustEventFailure eventFailureData) {
      print('[Adjust]: Event tracking failure!');

      if (eventFailureData.eventToken != null) {
        print('[Adjust]: Event token: ' + eventFailureData.eventToken);
      }
      if (eventFailureData.message != null) {
        print('[Adjust]: Message: ' + eventFailureData.message);
      }
      if (eventFailureData.timestamp != null) {
        print('[Adjust]: Timestamp: ' + eventFailureData.timestamp);
      }
      if (eventFailureData.adid != null) {
        print('[Adjust]: Adid: ' + eventFailureData.adid);
      }
      if (eventFailureData.callbackId != null) {
        print('[Adjust]: Callback ID: ' + eventFailureData.callbackId);
      }
      if (eventFailureData.willRetry != null) {
        print('[Adjust]: Will retry: ' + eventFailureData.willRetry.toString());
      }
      if (eventFailureData.jsonResponse != null) {
        print('[Adjust]: JSON response: ' + eventFailureData.jsonResponse);
      }
    };

    config.launchDeferredDeeplink = true;
    config.deferredDeeplinkCallback = (String uri) {
      print('[Adjust]: Received deferred deeplink: ' + uri);
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
}
