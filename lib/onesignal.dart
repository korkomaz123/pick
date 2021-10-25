import 'package:onesignal_flutter/onesignal_flutter.dart';

import 'src/utils/services/dynamic_link_service.dart';

class OneSignalNotification {
  static initOneSignalPlatform() {
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
      String launchUrl = action.clickUrl ?? '';
      print('LAUNCH URL >>>> $launchUrl');
      DynamicLinkService().expandShortUrl(launchUrl).then((redirectUri) {
        DynamicLinkService().dynamicLinkHandler(redirectUri);
      });
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
}
