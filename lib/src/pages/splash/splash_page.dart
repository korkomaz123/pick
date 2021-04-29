import 'dart:io' show Platform;

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
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
  SignInRepository signInRepo;
  CheckoutRepository checkoutRepo;
  ShippingAddressRepository shippingAddressRepo;
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
    signInRepo = context.read<SignInRepository>();
    checkoutRepo = context.read<CheckoutRepository>();
    shippingAddressRepo = context.read<ShippingAddressRepository>();
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
      // await _loadAssets();
      Navigator.pushNamedAndRemoveUntil(context, Routes.home, (route) => false);
    } else {
      isFirstTime = true;
      setState(() {});
    }
  }

  Future<void> _loadAssets() async {
    if (signInRepo.getFirebaseUser() == null) {
      await signInRepo.loginFirebase(
        email: MarkaaReporter.email,
        password: MarkaaReporter.password,
      );
    }
    orderChangeNotifier.initializeOrders();
    brandChangeNotifier.getBrandsList(lang, 'brand');
    brandChangeNotifier.getBrandsList(lang, 'home');
    categoryChangeNotifier.getCategoriesList(lang);
    await _getCurrentUser();
    await myCartChangeNotifier.getCartId();
    await myCartChangeNotifier.getCartItems(lang);
    if (user?.token != null) {
      isNotification = await settingRepo.getNotificationSetting(user.token);
      wishlistChangeNotifier.getWishlistItems(user.token, lang);
      orderChangeNotifier.loadOrderHistories(user.token, lang);
      addressChangeNotifier.initialize();
      addressChangeNotifier.loadAddresses(user.token);
    }
    homeCategories = await categoryRepo.getHomeCategories(lang);
    _loadExtraData();
    Navigator.pushNamedAndRemoveUntil(context, Routes.home, (route) => false);
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

  void _loadExtraData() async {
    shippingMethods = await checkoutRepo.getShippingMethod(lang);
    paymentMethods = await checkoutRepo.getPaymentMethod(lang);
    regions = await shippingAddressRepo.getRegions(lang);
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
    return Scaffold(
      backgroundColor: primarySwatchColor,
      body: Container(
        width: 375.w,
        height: 812.h,
        child: Stack(
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: Container(
                width: 260.94.w,
                height: 180.h,
                margin: EdgeInsets.only(top: 262.7.h),
                child: SvgPicture.asset(vLogoIcon),
              ),
            ),
            if (isFirstTime != null && isFirstTime) ...[
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  padding: EdgeInsets.only(
                    bottom: 141.h,
                  ),
                  width: double.infinity,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 145.w,
                        height: 49.h,
                        child: MarkaaTextButton(
                          title: 'English',
                          titleSize: 20.sp,
                          titleColor: Colors.white,
                          buttonColor: Color(0xFFF7941D),
                          borderColor: Colors.transparent,
                          onPressed: () => _onEnglish(),
                          radius: 30,
                        ),
                      ),
                      SizedBox(width: 13.w),
                      Container(
                        width: 145.w,
                        height: 49.h,
                        child: MarkaaTextButton(
                          title: 'عربى',
                          titleSize: 20.sp,
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
