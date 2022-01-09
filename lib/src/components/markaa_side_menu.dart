import 'package:markaa/src/apis/endpoints.dart';
import 'package:markaa/src/change_notifier/address_change_notifier.dart';
import 'package:markaa/src/change_notifier/auth_change_notifier.dart';
import 'package:markaa/src/change_notifier/home_change_notifier.dart';
import 'package:markaa/src/change_notifier/markaa_app_change_notifier.dart';
import 'package:markaa/src/change_notifier/order_change_notifier.dart';
import 'package:markaa/src/components/markaa_page_loading_kit.dart';
import 'package:markaa/src/data/mock/mock.dart';
import 'package:markaa/src/data/models/index.dart';
import 'package:markaa/src/routes/routes.dart';
import 'package:markaa/src/theme/icons.dart';
import 'package:markaa/src/theme/styles.dart';
import 'package:markaa/src/theme/theme.dart';
import 'package:markaa/src/utils/repositories/local_storage_repository.dart';
import 'package:markaa/src/change_notifier/my_cart_change_notifier.dart';
import 'package:markaa/src/change_notifier/wishlist_change_notifier.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:markaa/src/utils/repositories/setting_repository.dart';
import 'package:markaa/src/utils/services/flushbar_service.dart';
import 'package:markaa/src/utils/services/progress_service.dart';
import 'package:url_launcher/url_launcher.dart';

import 'toggle_language.dart';

class MarkaaSideMenu extends StatefulWidget {
  @override
  _MarkaaSideMenuState createState() => _MarkaaSideMenuState();
}

class _MarkaaSideMenuState extends State<MarkaaSideMenu> with WidgetsBindingObserver {
  final dataKey = GlobalKey();
  int? activeIndex;
  double? menuWidth;

  late ProgressService progressService;
  late FlushBarService flushBarService;

  final LocalStorageRepository localRepo = LocalStorageRepository();
  final SettingRepository settingRepo = SettingRepository();

  late AuthChangeNotifier authChangeNotifier;
  late MyCartChangeNotifier myCartChangeNotifier;
  late WishlistChangeNotifier wishlistChangeNotifier;
  late OrderChangeNotifier orderChangeNotifier;
  late HomeChangeNotifier homeChangeNotifier;
  late MarkaaAppChangeNotifier markaaAppChangeNotifier;
  late AddressChangeNotifier addressChangeNotifier;

  @override
  void initState() {
    super.initState();
    authChangeNotifier = context.read<AuthChangeNotifier>();
    homeChangeNotifier = context.read<HomeChangeNotifier>();
    myCartChangeNotifier = context.read<MyCartChangeNotifier>();
    wishlistChangeNotifier = context.read<WishlistChangeNotifier>();
    orderChangeNotifier = context.read<OrderChangeNotifier>();
    markaaAppChangeNotifier = context.read<MarkaaAppChangeNotifier>();
    addressChangeNotifier = context.read<AddressChangeNotifier>();

    progressService = ProgressService(context: context);
    flushBarService = FlushBarService(context: context);
  }

  void _onPrivacyPolicy() async {
    String url = EndPoints.privacyAndPolicy;
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      flushBarService.showErrorDialog('can_not_launch_url'.tr());
    }
  }

  @override
  Widget build(BuildContext context) {
    menuWidth = 300.w;
    return Container(
      width: menuWidth,
      height: 812.h,
      color: Colors.white,
      child: Column(
        children: [
          _buildMenuHeader(),
          Expanded(
            child: Consumer<HomeChangeNotifier>(
              builder: (_, model, __) {
                if (model.sideMenus[lang]!.length == 0) {
                  return Center(child: PulseLoadingSpinner());
                } else {
                  return SingleChildScrollView(child: _buildMenuItems());
                }
              },
            ),
          ),
          ListTile(
            leading: Icon(Icons.privacy_tip),
            onTap: _onPrivacyPolicy,
            title: Text(
              'suffix_agree_terms'.tr(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuHeader() {
    return DrawerHeader(
      padding: EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(color: primarySwatchColor),
      child: Column(
        children: [
          Expanded(child: _buildHeaderLogo()),
          _buildHeaderAuth(),
        ],
      ),
    );
  }

  Widget _buildHeaderLogo() {
    return Align(
      alignment: lang == 'en' ? Alignment.topLeft : Alignment.topRight,
      child: Padding(
        padding: EdgeInsets.only(
          top: 40.h,
          left: lang == 'en' ? 15.w : 0,
          right: lang == 'ar' ? 15.w : 0,
        ),
        child: Row(
          children: [
            if (user?.token != null) ...[
              Container(
                width: 60.w,
                height: 60.w,
                child: CachedNetworkImage(
                  imageUrl: user?.profileUrl ?? '',
                  imageBuilder: (_, _imageProvider) {
                    return Container(
                      width: 60.w,
                      height: 60.w,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: _imageProvider,
                          fit: BoxFit.cover,
                        ),
                        shape: BoxShape.circle,
                      ),
                    );
                  },
                  errorWidget: (_, __, ___) {
                    return Container(
                      width: 60.w,
                      height: 60.w,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('lib/public/images/profile.png'),
                          fit: BoxFit.cover,
                        ),
                        shape: BoxShape.circle,
                      ),
                    );
                  },
                ),
              ),
              SizedBox(width: 10.w),
              Text(
                'Hello, ' + (user?.firstName ?? user?.lastName ?? ''),
                style: mediumTextStyle.copyWith(
                  fontSize: 18.sp,
                  color: Colors.white,
                ),
              ),
            ] else ...[
              Padding(
                padding: EdgeInsets.only(top: 5.h),
                child: SvgPicture.asset(
                  hLogoIcon,
                  width: 95.w,
                  height: 35.h,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderAuth() {
    return Align(
      alignment: Alignment.bottomLeft,
      child: InkWell(
        onTap: () => user != null ? _logout() : _login(),
        child: Container(
          padding: EdgeInsets.only(
            left: 15.w,
            right: 15.w,
            bottom: 10.h,
          ),
          width: double.infinity,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    SvgPicture.asset(
                      sideLoginIcon,
                      height: 15.h,
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      user != null ? 'logout'.tr() : 'login'.tr(),
                      style: mediumTextStyle.copyWith(
                        color: Colors.white,
                        fontSize: 14.sp,
                      ),
                    ),
                  ],
                ),
              ),
              ToggleLanguageWidget(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuItems() {
    return Container(
      width: menuWidth,
      padding: EdgeInsets.symmetric(vertical: 20.h),
      child: Column(
        children: homeChangeNotifier.sideMenus[lang]!.map((menu) {
          int index = homeChangeNotifier.sideMenus[lang]!.indexOf(menu);
          return Column(
            key: activeIndex == index ? dataKey : null,
            children: [
              _buildParentMenu(menu, activeIndex == index, index),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 4.h),
                child: Divider(color: Colors.grey.shade400, height: 1.h),
              ),
              if (activeIndex == index) ...[_buildSubmenu(menu)],
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildParentMenu(CategoryMenuEntity menu, bool isActive, int index) {
    return InkWell(
      onTap: () => menu.subMenu!.isNotEmpty && !isActive
          ? setState(() {
              activeIndex = index;
            })
          : _viewCategory(menu, 0),
      child: Container(
        width: double.infinity,
        margin: EdgeInsets.only(top: 15.h),
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 4.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                if (menu.iconUrl!.isNotEmpty) ...[
                  CachedNetworkImage(
                    width: 25.w,
                    height: 25.w,
                    imageUrl: menu.iconUrl ?? '',
                    fit: BoxFit.cover,
                    errorWidget: (_, __, ___) => Center(child: Icon(Icons.image, size: 20)),
                  ),
                ],
                SizedBox(width: 10.w),
                Text(
                  menu.title.toUpperCase(),
                  style: mediumTextStyle.copyWith(
                    fontSize: 14.sp,
                    color: darkColor,
                  ),
                ),
              ],
            ),
            if (menu.subMenu!.isNotEmpty) ...[
              Icon(
                isActive ? Icons.arrow_drop_down : Icons.arrow_right,
                size: 25.sp,
                color: greyDarkColor,
              )
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildSubmenu(CategoryMenuEntity menu) {
    return AnimationLimiter(
      child: Column(
        children: List.generate(
          menu.subMenu!.length,
          (index) => AnimationConfiguration.staggeredList(
            position: index,
            duration: Duration(milliseconds: 200),
            child: SlideAnimation(
              verticalOffset: 50.0,
              child: FadeInAnimation(
                child: InkWell(
                  onTap: () => _viewCategory(menu, index + 1),
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(
                      horizontal: 40.w,
                      vertical: 10.h,
                    ),
                    child: Text(
                      menu.subMenu![index].title,
                      style: mediumTextStyle.copyWith(
                        fontSize: 14.sp,
                        color: darkColor,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _viewCategory(CategoryMenuEntity parentMenu, int index) {
    ProductListArguments arguments = ProductListArguments(
      category: CategoryEntity(id: parentMenu.id, name: parentMenu.title),
      brand: null,
      subCategory: [],
      selectedSubCategoryIndex: index,
      isFromBrand: false,
    );
    Navigator.pop(context);
    Navigator.popUntil(
      context,
      (route) => route.settings.name == Routes.home,
    );
    Navigator.pushNamed(context, Routes.productList, arguments: arguments);
  }

  void _login() async {
    await Navigator.pushNamed(context, Routes.signIn);
    markaaAppChangeNotifier.rebuild();
    Navigator.pop(context);
  }

  void _logout() async {
    final result = await flushBarService.showConfirmDialog(message: 'logout_confirm_dialog_text');
    if (result != null) {
      authChangeNotifier.logout(
        onProcess: () => progressService.showProgress(),
        onSuccess: _logoutUser,
        onFailure: (message) {
          progressService.hideProgress();
          flushBarService.showErrorDialog(message);
        },
      );
    }
  }

  void _logoutUser() async {
    await settingRepo.updateFcmDeviceToken(user!.token, '', '', lang, lang);
    await localRepo.setToken('');
    user = null;

    addressChangeNotifier.initialize();
    orderChangeNotifier.initializeOrders();
    wishlistChangeNotifier.initialize();
    myCartChangeNotifier.initialize();

    await myCartChangeNotifier.getCartId();
    await myCartChangeNotifier.getCartItems(lang);
    await addressChangeNotifier.loadGuestAddresses();
    await homeChangeNotifier.loadRecentlyViewedGuest();

    progressService.hideProgress();
    Navigator.pop(context);
    Navigator.popUntil(
      context,
      (route) => route.settings.name == Routes.home,
    );
  }
}
