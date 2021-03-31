import 'dart:io' show Platform;

import 'package:device_info/device_info.dart';
import 'package:markaa/src/change_notifier/brand_change_notifier.dart';
import 'package:markaa/src/change_notifier/category_change_notifier.dart';
import 'package:markaa/src/change_notifier/order_change_notifier.dart';
import 'package:markaa/src/change_notifier/address_change_notifier.dart';
import 'package:markaa/src/components/markaa_text_button.dart';
import 'package:markaa/src/config/config.dart';
import 'package:markaa/src/data/mock/mock.dart';
import 'package:markaa/src/data/models/user_entity.dart';
import 'package:markaa/src/routes/routes.dart';
import 'package:markaa/src/theme/icons.dart';
import 'package:markaa/src/theme/theme.dart';
import 'package:markaa/src/utils/repositories/category_repository.dart';
import 'package:markaa/src/utils/repositories/checkout_repository.dart';
import 'package:markaa/src/utils/repositories/local_storage_repository.dart';
import 'package:markaa/src/change_notifier/my_cart_change_notifier.dart';
import 'package:markaa/src/change_notifier/wishlist_change_notifier.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:isco_custom_widgets/styles/page_style.dart';
import 'package:markaa/src/utils/repositories/app_repository.dart';
import 'package:markaa/src/utils/repositories/my_cart_repository.dart';
import 'package:markaa/src/utils/repositories/setting_repository.dart';
import 'package:markaa/src/utils/repositories/shipping_address_repository.dart';
import 'package:markaa/src/utils/repositories/sign_in_repository.dart';
import 'package:markaa/src/utils/repositories/wishlist_repository.dart';
import 'package:url_launcher/url_launcher.dart';
import 'update_available_dialog.dart';

class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  LocalStorageRepository localRepo;
  MyCartRepository cartRepo;
  WishlistRepository wishlistRepo;
  CategoryRepository categoryRepo;
  SettingRepository settingRepo;
  PageStyle pageStyle;
  bool isFirstTime;
  MyCartChangeNotifier myCartChangeNotifier;
  WishlistChangeNotifier wishlistChangeNotifier;
  BrandChangeNotifier brandChangeNotifier;
  CategoryChangeNotifier categoryChangeNotifier;
  OrderChangeNotifier orderChangeNotifier;
  AddressChangeNotifier addressChangeNotifier;
  AppRepository appRepository;

  @override
  void initState() {
    super.initState();
    appRepository = context.read<AppRepository>();
    cartRepo = context.read<MyCartRepository>();
    wishlistRepo = context.read<WishlistRepository>();
    localRepo = context.read<LocalStorageRepository>();
    categoryRepo = context.read<CategoryRepository>();
    settingRepo = context.read<SettingRepository>();
    myCartChangeNotifier = context.read<MyCartChangeNotifier>();
    wishlistChangeNotifier = context.read<WishlistChangeNotifier>();
    brandChangeNotifier = context.read<BrandChangeNotifier>();
    categoryChangeNotifier = context.read<CategoryChangeNotifier>();
    orderChangeNotifier = context.read<OrderChangeNotifier>();
    addressChangeNotifier = context.read<AddressChangeNotifier>();
    _checkAppUsage();
  }

  void _checkAppUsage() async {
    await checkAppVersion();
    bool isExist = await localRepo.existItem('usage');
    if (isExist) {
      isFirstTime = false;
      _loadAssets();
    } else {
      isFirstTime = true;
      setState(() {});
    }
  }

  void _loadAssets() async {
    orderChangeNotifier.initializeOrders();
    brandChangeNotifier.getBrandsList(lang, 'brand');
    brandChangeNotifier.getBrandsList(lang, 'home');
    categoryChangeNotifier.getCategoriesList(lang);
    await _getDeviceId();
    await _getCurrentUser();
    await _getHomeCategories();
    if (user?.token != null) {
      isNotification = await settingRepo.getNotificationSetting(user.token);
      wishlistChangeNotifier.getWishlistItems(user.token, lang);
      orderChangeNotifier.loadOrderHistories(user.token, lang);
      addressChangeNotifier.initialize();
      addressChangeNotifier.loadAddresses(user.token);
    }
    _getCartItems();
    _getShippingMethod();
    _getPaymentMethod();
    _getSideMenu();
    _getRegions();
    _navigator();
  }

  Future<void> _getDeviceId() async {
    final deviceInfoPlugin = new DeviceInfoPlugin();
    if (Platform.isAndroid) {
      var build = await deviceInfoPlugin.androidInfo;
      deviceId = build.androidId; //UUID for Android
    } else if (Platform.isIOS) {
      var data = await deviceInfoPlugin.iosInfo;
      deviceId = data.identifierForVendor; //UUID for iOS
    }
  }

  Future<void> _getCurrentUser() async {
    String token = await localRepo.getToken();
    if (token.isNotEmpty) {
      final signInRepo = context.read<SignInRepository>();
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

  Future<void> checkAppVersion() async {
    final versionEntity =
        await appRepository.checkAppVersion(Platform.isAndroid, lang);
    if (versionEntity.updateMandatory) {
      Navigator.pushReplacementNamed(
        context,
        Routes.update,
        arguments: versionEntity.storeLink,
      );
    } else if (versionEntity.canUpdate) {
      final result = await showDialog(
        context: context,
        builder: (context) {
          return UpdateAvailableDialog(
            title: versionEntity.dialogTitle,
            content: versionEntity.dialogContent,
          );
        },
      );
      if (result != null) {
        if (await canLaunch(versionEntity.storeLink)) {
          await launch(versionEntity.storeLink);
        }
      }
    }
  }

  Future<void> _getHomeCategories() async {
    homeCategories = await categoryRepo.getHomeCategories(lang);
  }

  void _getCartItems() async {
    await myCartChangeNotifier.getCartId();
    await myCartChangeNotifier.getCartItems(lang);
  }

  void _getShippingMethod() async {
    shippingMethods =
        await context.read<CheckoutRepository>().getShippingMethod(lang);
  }

  void _getPaymentMethod() async {
    paymentMethods =
        await context.read<CheckoutRepository>().getPaymentMethod(lang);
  }

  void _getSideMenu() async {
    print(lang);
    sideMenus =
        await context.read<CategoryRepository>().getMenuCategories(lang);
  }

  void _getRegions() async {
    regions = await context.read<ShippingAddressRepository>().getRegions(lang);
  }

  void _navigator() {
    Navigator.pushNamedAndRemoveUntil(context, Routes.home, (route) => false);
  }

  void _onEnglish() async {
    EasyLocalization.of(context).locale =
        EasyLocalization.of(context).supportedLocales.first;
    lang = 'en';
    isFirstTime = false;
    await localRepo.setItem('usage', 'markaa');
    setState(() {});
    _loadAssets();
  }

  void _onArabic() async {
    EasyLocalization.of(context).locale =
        EasyLocalization.of(context).supportedLocales.last;
    lang = 'ar';
    isFirstTime = false;
    await localRepo.setItem('usage', 'markaa');
    setState(() {});
    _loadAssets();
  }

  @override
  Widget build(BuildContext context) {
    pageStyle = PageStyle(context, designWidth, designHeight);
    pageStyle.initializePageStyles();
    return Scaffold(
      backgroundColor: primarySwatchColor,
      body: Container(
        width: pageStyle.deviceWidth,
        height: pageStyle.deviceHeight,
        child: Stack(
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: Container(
                width: pageStyle.unitWidth * 260.94,
                height: pageStyle.unitHeight * 180,
                margin: EdgeInsets.only(top: pageStyle.unitHeight * 262.7),
                child: SvgPicture.asset(vLogoIcon),
              ),
            ),
            if (isFirstTime != null && isFirstTime) ...[
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  padding: EdgeInsets.only(
                    bottom: pageStyle.unitHeight * 141,
                  ),
                  width: double.infinity,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: pageStyle.unitWidth * 145,
                        height: pageStyle.unitHeight * 49,
                        child: MarkaaTextButton(
                          title: 'English',
                          titleSize: pageStyle.unitFontSize * 20,
                          titleColor: Colors.white,
                          buttonColor: Color(0xFFF7941D),
                          borderColor: Colors.transparent,
                          onPressed: () => _onEnglish(),
                          radius: 30,
                        ),
                      ),
                      SizedBox(width: pageStyle.unitWidth * 13),
                      Container(
                        width: pageStyle.unitWidth * 145,
                        height: pageStyle.unitHeight * 49,
                        child: MarkaaTextButton(
                          title: 'عربى',
                          titleSize: pageStyle.unitFontSize * 20,
                          titleColor: Colors.white,
                          buttonColor: Color(0xFFF7941D),
                          borderColor: Colors.transparent,
                          onPressed: () => _onArabic(),
                          radius: 30,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ],
        ),
      ),
    );
  }
}
