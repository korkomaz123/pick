import 'package:flutter_smartlook/flutter_smartlook.dart';

import 'src/data/mock/mock.dart';

class CustomIntegrationListener implements IntegrationListener {
  @override
  void onSessionReady(String? dashboardSessionUrl) {
    print("DashboardUrl:");
    print(dashboardSessionUrl);
    gDashboardSessionUrl = dashboardSessionUrl ?? '';
  }

  @override
  void onVisitorReady(String? dashboardVisitorUrl) {
    print("DashboardVisitorUrl:");
    print(dashboardVisitorUrl);
    gDashboardVisitorUrl = dashboardVisitorUrl ?? '';
  }
}

class SmartlookTrack {
  static setupSDK() async {
    SetupOptions options = (new SetupOptionsBuilder('ed7cae14a0a462fe8be2b38ae3460e7ae7bbbfb8')
          ..Fps = 2
          ..StartNewSession = true)
        .build();
    Smartlook.setupAndStartRecording(options);
    Smartlook.setEventTrackingMode(EventTrackingMode.FULL_TRACKING);
    List<EventTrackingMode> eventTrackingModes = [
      EventTrackingMode.FULL_TRACKING,
      EventTrackingMode.IGNORE_USER_INTERACTION
    ];
    Smartlook.setEventTrackingModes(eventTrackingModes);
    Smartlook.registerIntegrationListener(new CustomIntegrationListener());
    String? dashboardVisitorUrl = await Smartlook.getDashboardVisitorUrl();
    if (dashboardVisitorUrl != null) {
      String visitorId = dashboardVisitorUrl.split('visitor/')[1];
      Smartlook.setUserIdentifier(visitorId);
    }
    Smartlook.enableWebviewRecording(true);
    Smartlook.enableCrashlytics(true);
    Smartlook.getDashboardSessionUrl(true);
  }
}
