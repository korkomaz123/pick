import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:markaa/config.dart';
import 'package:markaa/src/config/config.dart';

class GlobalProvider extends ChangeNotifier {
  List<dynamic> languages = <dynamic>['EN', 'AR'];
  Future<void> changeLanguage(String val) async {
    print("val $val");
    String _current = currentLanguage;
    _current == 'ar'
        ? await Config.navigatorKey.currentContext.setLocale(EasyLocalization.of(Config.navigatorKey.currentContext).supportedLocales.first)
        : await Config.navigatorKey.currentContext.setLocale(EasyLocalization.of(Config.navigatorKey.currentContext).supportedLocales.last);
    print("_current $_current");
    await FirebaseMessaging.instance
        .unsubscribeFromTopic(_current == 'en' ? MarkaaNotificationChannels.arChannel : MarkaaNotificationChannels.enChannel);
    await FirebaseMessaging.instance.subscribeToTopic(_current == 'ar' ? MarkaaNotificationChannels.arChannel : MarkaaNotificationChannels.enChannel);
    // get categories with the new languages and update menu
    notifyListeners();
  }

  String get currentLanguage => EasyLocalization.of(Config.navigatorKey.currentContext).locale.languageCode.toLowerCase();
}
