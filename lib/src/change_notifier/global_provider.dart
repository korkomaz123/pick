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
  List<dynamic> languages = <dynamic>['EN', 'AR'];

  UserEntity currentUser;

  void updateUser(UserEntity loggedInUser) {
    currentUser = loggedInUser;
    notifyListeners();
  }

  changeLanguage(String val, {fromSplash = false}) {
    BuildContext _context = Preload.navigatorKey.currentContext;
    String _current = currentLanguage;
    if (_current != val) {
      final enLocale = EasyLocalization.of(_context).supportedLocales.first;
      final arLocale = EasyLocalization.of(_context).supportedLocales.last;

      _current == 'ar'
          ? _context.setLocale(enLocale)
          : _context.setLocale(arLocale);

      FirebaseMessaging.instance.unsubscribeFromTopic(_current == 'en'
          ? MarkaaNotificationChannels.arChannel
          : MarkaaNotificationChannels.enChannel);
      FirebaseMessaging.instance.subscribeToTopic(_current == 'ar'
          ? MarkaaNotificationChannels.arChannel
          : MarkaaNotificationChannels.enChannel);

      lang = Preload.language = _current == "ar" ? "en" : "ar";
    }
    // fetchCategories();

    // // notifyListeners();
    // // Update Details page if i am in details page
    // // if (_context.read<ProductChangeNotifier>().productDetails != null) {
    // //   _context.read<ProductChangeNotifier>().getProductDetails(_context.read<ProductChangeNotifier>().productDetails.productId);
    // //   _context.read<ProductChangeNotifier>().productDetails = null;
    // // }

    // // update cart items
    // final _cartProvider = _context.read<MyCartChangeNotifier>();
    // _cartProvider.getCartItems(lang);

    // // update homde data
    // final _homeProvider = _context.read<HomeChangeNotifier>();

    // if (!fromSplash) _homeProvider.changeLanguage();

    // NotificationSetup().updateFcmDeviceToken();
  }

  GlobalProvider() {
    fetchCategories();
  }

  fetchCategories() async {
    print("currentLanguage $currentLanguage");
    String _lang = currentLanguage;
    if (sideMenus[_lang].length == 0)
      sideMenus[_lang] = await CategoryRepository().getMenuCategories(_lang);
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

  String get currentLanguage =>
      EasyLocalization.of(Preload.navigatorKey.currentContext)
          .locale
          .languageCode
          .toLowerCase();
}
