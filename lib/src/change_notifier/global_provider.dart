import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:markaa/config.dart';
import 'package:markaa/src/config/config.dart';
import 'package:markaa/src/data/mock/mock.dart';
import 'package:markaa/src/data/models/category_menu_entity.dart';
import 'package:markaa/src/utils/repositories/category_repository.dart';

import 'home_change_notifier.dart';
import 'package:provider/provider.dart';

class GlobalProvider extends ChangeNotifier {
  Map<String, List<CategoryMenuEntity>> sideMenus = {"ar": [], "en": []};
  List<dynamic> languages = <dynamic>['EN', 'AR'];
  Future<void> changeLanguage(String val, {fromSplash = false}) async {
    BuildContext _context = Config.navigatorKey.currentContext;
    String _current = currentLanguage;
    if (_current != val) {
      _current == 'ar'
          ? _context.setLocale(EasyLocalization.of(_context).supportedLocales.first)
          : _context.setLocale(EasyLocalization.of(_context).supportedLocales.last);
      FirebaseMessaging.instance.unsubscribeFromTopic(_current == 'en' ? MarkaaNotificationChannels.arChannel : MarkaaNotificationChannels.enChannel);
      FirebaseMessaging.instance.subscribeToTopic(_current == 'ar' ? MarkaaNotificationChannels.arChannel : MarkaaNotificationChannels.enChannel);

      lang = Config.language = _current == "ar" ? "en" : "ar";
    }
    fetchCategories();
    // notifyListeners();
    // Update Details page if i am in details page
    // if (_context.read<ProductChangeNotifier>().productDetails != null) {
    //   _context.read<ProductChangeNotifier>().getProductDetails(_context.read<ProductChangeNotifier>().productDetails.productId);
    //   _context.read<ProductChangeNotifier>().productDetails = null;
    // }
    // update homde data
    if (!fromSplash) _context.read<HomeChangeNotifier>().changeLanguage();
  }

  GlobalProvider() {
    fetchCategories();
  }
  fetchCategories() async {
    print("currentLanguage $currentLanguage");
    String _lang = currentLanguage;
    if (sideMenus[_lang].length == 0) sideMenus[_lang] = await CategoryRepository().getMenuCategories(_lang);
    notifyListeners();
  }

  String activeMenu = '';
  int activeIndex;
  displaySubmenu(CategoryMenuEntity menu, int index) {
    if (activeMenu == menu.id) {
      activeMenu = '';
    } else {
      activeMenu = menu.id;
    }
    activeIndex = index;
    notifyListeners();
  }

  String get currentLanguage => EasyLocalization.of(Config.navigatorKey.currentContext).locale.languageCode.toLowerCase();
}