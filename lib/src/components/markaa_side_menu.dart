import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import 'package:markaa/src/change_notifier/global_provider.dart';
import 'package:markaa/src/change_notifier/home_change_notifier.dart';
import 'package:markaa/src/change_notifier/order_change_notifier.dart';
import 'package:markaa/src/data/mock/mock.dart';
import 'package:markaa/src/data/models/brand_entity.dart';
import 'package:markaa/src/data/models/category_entity.dart';
import 'package:markaa/src/data/models/category_menu_entity.dart';
import 'package:markaa/src/data/models/index.dart';
import 'package:markaa/src/data/models/product_list_arguments.dart';
import 'package:markaa/src/pages/my_account/widgets/logout_confirm_dialog.dart';
import 'package:markaa/src/pages/sign_in/bloc/sign_in_bloc.dart';
import 'package:markaa/src/routes/routes.dart';
import 'package:markaa/src/theme/icons.dart';
import 'package:markaa/src/theme/styles.dart';
import 'package:markaa/src/theme/theme.dart';
import 'package:markaa/src/utils/repositories/local_storage_repository.dart';
import 'package:markaa/src/change_notifier/my_cart_change_notifier.dart';
import 'package:markaa/src/change_notifier/wishlist_change_notifier.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:markaa/src/utils/repositories/setting_repository.dart';
import 'package:markaa/src/utils/services/flushbar_service.dart';
import 'package:markaa/src/utils/services/progress_service.dart';

import 'toggle_language.dart';

class MarkaaSideMenu extends StatefulWidget {
  @override
  _MarkaaSideMenuState createState() => _MarkaaSideMenuState();
}

class _MarkaaSideMenuState extends State<MarkaaSideMenu>
    with WidgetsBindingObserver {
  final dataKey = GlobalKey();
  int activeIndex;
  double menuWidth;

  SignInBloc signInBloc;

  ProgressService progressService;
  FlushBarService flushBarService;

  final LocalStorageRepository localRepo = LocalStorageRepository();
  final SettingRepository settingRepo = SettingRepository();

  MyCartChangeNotifier myCartChangeNotifier;
  WishlistChangeNotifier wishlistChangeNotifier;
  OrderChangeNotifier orderChangeNotifier;
  HomeChangeNotifier homeChangeNotifier;

  @override
  void initState() {
    super.initState();
    homeChangeNotifier = context.read<HomeChangeNotifier>();
    myCartChangeNotifier = context.read<MyCartChangeNotifier>();
    wishlistChangeNotifier = context.read<WishlistChangeNotifier>();
    orderChangeNotifier = context.read<OrderChangeNotifier>();
    signInBloc = context.read<SignInBloc>();
    progressService = ProgressService(context: context);
    flushBarService = FlushBarService(context: context);
  }

  @override
  Widget build(BuildContext context) {
    menuWidth = 300.w;
    return Container(
      width: menuWidth,
      height: 812.h,
      color: Colors.white,
      child: BlocConsumer<SignInBloc, SignInState>(
        listener: (context, state) {
          if (state is SignOutSubmittedInProcess) {
            progressService.showProgress();
          }
          if (state is SignOutSubmittedSuccess) {
            _logoutUser();
          }
          if (state is SignOutSubmittedFailure) {
            progressService.hideProgress();
            flushBarService.showErrorMessage(state.message);
          }
        },
        builder: (context, state) {
          return Column(
            children: [
              _buildMenuHeader(),
              Expanded(
                child: Consumer<GlobalProvider>(
                  builder: (context, _globalProvider, child) => _globalProvider
                              .sideMenus[_globalProvider.currentLanguage]
                              .length ==
                          0
                      ? Center(
                          child: CircularProgressIndicator(),
                        )
                      : SingleChildScrollView(
                          child: _buildMenuItems(_globalProvider),
                        ),
                ),
              )
            ],
          );
        },
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
        child: user != null
            ? Row(
                children: [
                  Container(
                    width: 60.w,
                    height: 60.w,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: user.profileUrl.isNotEmpty
                            ? NetworkImage(user.profileUrl)
                            : AssetImage('lib/public/images/profile.png'),
                        fit: BoxFit.cover,
                      ),
                      shape: BoxShape.circle,
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
                ],
              )
            : Padding(
                padding: EdgeInsets.only(top: 5.h),
                child: SvgPicture.asset(
                  hLogoIcon,
                  width: 95.w,
                  height: 35.h,
                ),
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

  Widget _buildMenuItems(GlobalProvider _globalProvider) {
    return Container(
      width: menuWidth,
      padding: EdgeInsets.symmetric(vertical: 20.h),
      child: Column(
        children: _globalProvider.sideMenus[_globalProvider.currentLanguage]
            .map((menu) {
          int index = _globalProvider.sideMenus[_globalProvider.currentLanguage]
              .indexOf(menu);
          return Column(
            key: _globalProvider.activeIndex == index ? dataKey : null,
            children: [
              _buildParentMenu(_globalProvider, index),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 4.h),
                child: Divider(color: Colors.grey.shade400, height: 1.h),
              ),
              _globalProvider.activeMenu == menu.id
                  ? _buildSubmenu(menu)
                  : SizedBox.shrink(),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildParentMenu(GlobalProvider _globalProvider, int index) {
    CategoryMenuEntity menu =
        _globalProvider.sideMenus[_globalProvider.currentLanguage][index];
    return InkWell(
      onTap: () => menu.subMenu.isNotEmpty
          ? _globalProvider.displaySubmenu(menu, index)
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
                if (menu.iconUrl.isNotEmpty) ...[
                  CachedNetworkImage(
                    width: 25.w,
                    height: 25.w,
                    imageUrl: menu.iconUrl,
                    fit: BoxFit.cover,
                    // progressIndicatorBuilder: (context, url, downloadProgress) =>
                    //     Center(child: CircularProgressIndicator(value: downloadProgress.progress)),
                    errorWidget: (context, url, error) =>
                        Center(child: Icon(Icons.image, size: 20)),
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
            if (menu.subMenu.isNotEmpty) ...[
              Icon(
                _globalProvider.activeMenu == menu.id
                    ? Icons.arrow_drop_down
                    : Icons.arrow_right,
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
          menu.subMenu.length,
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
                      menu.subMenu[index].title,
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
      brand: BrandEntity(),
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
    Navigator.pop(context);
  }

  void _logout() async {
    final result = await showDialog(
      context: context,
      builder: (context) {
        return LogoutConfirmDialog();
      },
    );
    if (result != null) {
      signInBloc.add(SignOutSubmitted(token: user.token));
    }
  }

  void _logoutUser() async {
    user = null;
    await settingRepo.updateFcmDeviceToken(user.token, '', '', lang, lang);
    await localRepo.setToken('');
    myCartChangeNotifier.initialize();
    orderChangeNotifier.initializeOrders();
    await myCartChangeNotifier.getCartId();
    await myCartChangeNotifier.getCartItems(lang);
    wishlistChangeNotifier.initialize();
    homeChangeNotifier.loadRecentlyViewedGuest();
    progressService.hideProgress();
    Navigator.pop(context);
    Navigator.popUntil(
      context,
      (route) => route.settings.name == Routes.home,
    );
  }
}
