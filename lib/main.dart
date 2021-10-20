import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:app_tracking_transparency/app_tracking_transparency.dart';

// import 'slack.dart';
import 'src/routes/routes.dart';
import 'src/pages/markaa_app/markaa_app.dart';
import 'src/utils/services/dynamic_link_service.dart';

const bool USE_FIRESTORE_EMULATOR = false;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  /// Firebase initialize
  await Firebase.initializeApp();
  await EasyLocalization.ensureInitialized();
  await DefaultCacheManager().emptyCache();

  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
      overlays: SystemUiOverlay.values);
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  EquatableConfig.stringify = kDebugMode;
  // ErrorWidget.builder = ((FlutterErrorDetails e) {
  //   int _errorLength = e.stack.toString().length;
  //   SlackChannels.send('''${e.exceptionAsString()}
  //    ${e.stack.toString().substring(0, _errorLength > 500 ? 500 : _errorLength)}''',
  //       SlackChannels.logAppErrors);
  //   return Center(
  //     child: Text("Something went wrong"),
  //   );
  // });

  if (USE_FIRESTORE_EMULATOR)
    FirebaseFirestore.instance.settings = const Settings(
      host: 'localhost:8080',
      sslEnabled: false,
      persistenceEnabled: false,
    );

  if (Platform.isIOS)
    try {
      final status = await AppTrackingTransparency.trackingAuthorizationStatus;
      if (status == TrackingStatus.notDetermined) {
        await AppTrackingTransparency.requestTrackingAuthorization();
      }
      final uuid = await AppTrackingTransparency.getAdvertisingIdentifier();
      print("uuid ==> $uuid");
    } on PlatformException {}

  final uuid = await AppTrackingTransparency.getAdvertisingIdentifier();
  print("UUID: $uuid");

  initOneSignalPlatform();

  runApp(
    EasyLocalization(
      path: 'lib/public/languages',
      useOnlyLangCode: true,
      supportedLocales: [
        Locale('en', 'EN'),
        Locale('ar', 'AR'),
      ],
      saveLocale: true,
      child: MarkaaApp(home: Routes.start),
    ),
  );
}

initOneSignalPlatform() {
  //Remove this method to stop OneSignal Debugging
  OneSignal.shared.setLogLevel(OSLogLevel.verbose, OSLogLevel.none);

  OneSignal.shared.setAppId("ea06fe9d-67f8-4929-b3f2-7cc3828626f2");

// The promptForPushNotificationsWithUserResponse function will show the iOS push notification prompt. We recommend removing the following code and instead using an In-App Message to prompt for notification permission
  OneSignal.shared.promptUserForPushNotificationPermission().then((accepted) {
    print("Accepted permission: $accepted");
  });

  OneSignal.shared.setNotificationWillShowInForegroundHandler(
      (OSNotificationReceivedEvent event) {
    // Will be called whenever a notification is received in foreground
    // Display Notification, pass null param for not displaying the notification
    event.complete(event.notification);
  });

  OneSignal.shared
      .setNotificationOpenedHandler((OSNotificationOpenedResult result) {
    // Will be called whenever a notification is opened/button pressed.
    String launchUrl = result.notification.launchUrl!;
    print('LAUNCH URL >>>> $launchUrl');
    DynamicLinkService().expandShortUrl(launchUrl).then((redirectUri) {
      DynamicLinkService().dynamicLinkHandler(redirectUri);
    });
  });

  OneSignal.shared.setInAppMessageClickedHandler((action) {
    String actionId = action.clickName!;
    DynamicLinkService().dynamicLinkHandler(Uri.parse(actionId));
  });

  OneSignal.shared.setPermissionObserver((OSPermissionStateChanges changes) {
    // Will be called whenever the permission changes
    // (ie. user taps Allow on the permission prompt in iOS)
  });

  OneSignal.shared
      .setSubscriptionObserver((OSSubscriptionStateChanges changes) {
    // Will be called whenever the subscription changes
    // (ie. user gets registered with OneSignal and gets a user ID)
  });

  OneSignal.shared.setEmailSubscriptionObserver(
      (OSEmailSubscriptionStateChanges emailChanges) {
    // Will be called whenever then user's email subscription changes
    // (ie. OneSignal.setEmail(email) is called and the user gets registered
  });
}
