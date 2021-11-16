import 'package:onesignal_flutter/onesignal_flutter.dart';

import 'src/utils/services/dynamic_link_service.dart';

class OneSignalNotification {
  static initOneSignalPlatform() async {
    //Remove this method to stop OneSignal Debugging
    print(1);
    await OneSignal.shared.setLogLevel(OSLogLevel.none, OSLogLevel.none);

    print(1);
    await OneSignal.shared.setAppId("ea06fe9d-67f8-4929-b3f2-7cc3828626f2");

    print(1);
    // The promptForPushNotificationsWithUserResponse function will show the iOS push notification prompt. We recommend removing the following code and instead using an In-App Message to prompt for notification permission
    OneSignal.shared.promptUserForPushNotificationPermission().then((accepted) {
      print("Accepted permission: $accepted");
    });
    OneSignal.shared.setNotificationWillShowInForegroundHandler((OSNotificationReceivedEvent event) {
      print('setNotificationWillShowInForegroundHandler >>>>>>>>>>>>>>>>');
      // Will be called whenever a notification is received in foreground
      // Display Notification, pass null param for not displaying the notification
      event.complete(event.notification);
    });

    OneSignal.shared.setNotificationOpenedHandler((OSNotificationOpenedResult result) {
      // Will be called whenever a notification is opened/button pressed.
      print('setNotificationOpenedHandler >>>>>>>>>>>>>>>>');
      print(result.notification.additionalData);
      print('result.notification.launchUrl');
      print(result.notification.launchUrl);
      if (result.notification.additionalData != null) {
        String launchUrl = result.notification.additionalData?['launchUrl'];
        DynamicLinkService().expandShortUrl(launchUrl).then((redirectUri) {
          DynamicLinkService().dynamicLinkHandler(redirectUri);
        });
      }
    });

    OneSignal.shared.setInAppMessageClickedHandler((action) {
      print('setInAppMessageClickedHandler >>>>>>>>>>>>>>>>');
      String? launchUrl = action.clickName;
      if (launchUrl != null) {
        DynamicLinkService().expandShortUrl(launchUrl).then((redirectUri) {
          DynamicLinkService().dynamicLinkHandler(redirectUri);
        });
      }
    });
  }
}
