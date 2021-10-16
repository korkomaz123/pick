import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:markaa/preload.dart';
import 'package:markaa/src/config/config.dart';
import 'package:markaa/src/data/mock/mock.dart';
import 'package:markaa/src/data/models/category_menu_entity.dart';
import 'package:markaa/src/data/models/index.dart';
import 'package:markaa/src/utils/repositories/category_repository.dart';

class GlobalProvider extends ChangeNotifier {
  Map<String, List<CategoryMenuEntity>> sideMenus = {"ar": [], "en": []};
  List<dynamic> languages = <dynamic>['EN', 'عربى'];
  List<PaymentMethodEntity> paymentMethods = [];

  changeLanguage(String val, {fromSplash = false}) {
    BuildContext _context = Preload.navigatorKey!.currentContext!;
    String _current = currentLanguage;
    if (_current != val) {
      final enLocale = EasyLocalization.of(_context)!.supportedLocales.first;
      final arLocale = EasyLocalization.of(_context)!.supportedLocales.last;

      _current == 'ar'
          ? _context.setLocale(enLocale)
          : _context.setLocale(arLocale);

      lang = Preload.language = _current == "ar" ? "en" : "ar";

      FirebaseMessaging.instance.unsubscribeFromTopic(lang == 'en'
          ? MarkaaNotificationChannels.arChannel
          : MarkaaNotificationChannels.enChannel);
      FirebaseMessaging.instance.subscribeToTopic(lang == 'en'
          ? MarkaaNotificationChannels.enChannel
          : MarkaaNotificationChannels.arChannel);
    }
    getSideMenus();
  }

  GlobalProvider() {
    getSideMenus();
  }

  getSideMenus() async {
    String _lang = currentLanguage;
    if (sideMenus[_lang]!.isEmpty)
      sideMenus[_lang] = await CategoryRepository().getMenuCategories(_lang);
    notifyListeners();
  }

  String activeMenu = '';
  int? activeIndex;
  displaySubmenu(CategoryMenuEntity menu, int index) {
    if (activeMenu == menu.id) {
      activeMenu = '';
    } else {
      activeMenu = menu.id;
    }
    activeIndex = index;
    notifyListeners();
  }

  String get currentLanguage =>
      EasyLocalization.of(Preload.navigatorKey!.currentContext!)!
          .locale
          .languageCode
          .toLowerCase();
}
