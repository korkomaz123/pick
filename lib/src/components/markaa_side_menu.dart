import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
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
import 'package:isco_custom_widgets/isco_custom_widgets.dart';
import 'package:markaa/src/utils/repositories/setting_repository.dart';
import 'package:markaa/src/utils/services/flushbar_service.dart';
import 'package:markaa/src/utils/services/progress_service.dart';

class MarkaaSideMenu extends StatefulWidget {
  final PageStyle pageStyle;

  MarkaaSideMenu({this.pageStyle});

  @override
  _MarkaaSideMenuState createState() => _MarkaaSideMenuState();
}

class _MarkaaSideMenuState extends State<MarkaaSideMenu> with WidgetsBindingObserver {
  final dataKey = GlobalKey();
  int activeIndex;
  PageStyle pageStyle;
  double menuWidth;
  String activeMenu = '';
  String language = '';

  SignInBloc signInBloc;

  ProgressService progressService;
  FlushBarService flushBarService;

  LocalStorageRepository localRepo;
  SettingRepository settingRepo;

  MyCartChangeNotifier myCartChangeNotifier;
  WishlistChangeNotifier wishlistChangeNotifier;
  OrderChangeNotifier orderChangeNotifier;
  HomeChangeNotifier homeChangeNotifier;

  @override
  void initState() {
    super.initState();
    pageStyle = widget.pageStyle;
    homeChangeNotifier = context.read<HomeChangeNotifier>();
    signInBloc = context.read<SignInBloc>();
    localRepo = context.read<LocalStorageRepository>();
    settingRepo = context.read<SettingRepository>();
    myCartChangeNotifier = context.read<MyCartChangeNotifier>();
    wishlistChangeNotifier = context.read<WishlistChangeNotifier>();
    orderChangeNotifier = context.read<OrderChangeNotifier>();
    progressService = ProgressService(context: context);
    flushBarService = FlushBarService(context: context);
  }

  @override
  Widget build(BuildContext context) {
    language = EasyLocalization.of(context).locale.languageCode.toUpperCase();
    menuWidth = pageStyle.unitWidth * 300;
    return Container(
      width: menuWidth,
      height: pageStyle.deviceHeight,
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
            flushBarService.showErrorMessage(pageStyle, state.message);
          }
        },
        builder: (context, state) {
          return SingleChildScrollView(
            child: Column(
              children: [
                _buildMenuHeader(),
                _buildMenuItems(),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildMenuHeader() {
    return Container(
      width: menuWidth,
      height: pageStyle.unitHeight * 160,
      color: primarySwatchColor,
      child: Stack(
        children: [
          _buildHeaderLogo(),
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
          top: pageStyle.unitHeight * 40,
          left: lang == 'en' ? pageStyle.unitWidth * 15 : 0,
          right: lang == 'ar' ? pageStyle.unitWidth * 15 : 0,
        ),
        child: user != null
            ? Row(
                children: [
                  Container(
                    width: pageStyle.unitWidth * 60,
                    height: pageStyle.unitWidth * 60,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: user.profileUrl.isNotEmpty ? NetworkImage(user.profileUrl) : AssetImage('lib/public/images/profile.png'),
                        fit: BoxFit.cover,
                      ),
                      shape: BoxShape.circle,
                    ),
                  ),
                  SizedBox(width: pageStyle.unitWidth * 10),
                  Text(
                    'Hello, ' + (user?.firstName ?? user?.lastName ?? ''),
                    style: mediumTextStyle.copyWith(
                      fontSize: pageStyle.unitFontSize * 18,
                      color: Colors.white,
                    ),
                  ),
                ],
              )
            : Padding(
                padding: EdgeInsets.only(top: pageStyle.unitHeight * 5),
                child: SvgPicture.asset(
                  hLogoIcon,
                  width: pageStyle.unitWidth * 95,
                  height: pageStyle.unitHeight * 35,
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
            left: pageStyle.unitWidth * 15,
            right: pageStyle.unitWidth * 15,
            bottom: pageStyle.unitHeight * 10,
          ),
          width: double.infinity,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  SvgPicture.asset(
                    sideLoginIcon,
                    height: pageStyle.unitHeight * 15,
                  ),
                  SizedBox(width: pageStyle.unitWidth * 4),
                  Text(
                    user != null ? 'logout'.tr() : 'login'.tr(),
                    style: mediumTextStyle.copyWith(
                      color: Colors.white,
                      fontSize: pageStyle.unitFontSize * 14,
                    ),
                  ),
                ],
              ),
              Container(
                width: pageStyle.unitWidth * 100,
                height: pageStyle.unitHeight * 20,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.grey.shade300,
                ),
                child: SelectOptionCustom(
                  items: ['EN', 'AR'],
                  value: language,
                  itemWidth: pageStyle.unitWidth * 50,
                  itemHeight: pageStyle.unitHeight * 20,
                  itemSpace: 0,
                  titleSize: pageStyle.unitFontSize * 10,
                  radius: 8,
                  selectedColor: primaryColor,
                  selectedTitleColor: Colors.white,
                  selectedBorderColor: Colors.transparent,
                  unSelectedColor: Colors.grey.shade300,
                  unSelectedTitleColor: greyColor,
                  unSelectedBorderColor: Colors.transparent,
                  isVertical: false,
                  listStyle: true,
                  onTap: (value) => _onChangeLanguage(value),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuItems() {
    return Container(
      width: menuWidth,
      padding: EdgeInsets.symmetric(vertical: pageStyle.unitHeight * 20),
      child: Column(
        children: sideMenus.map((menu) {
          int index = sideMenus.indexOf(menu);
          return Column(
            key: activeIndex == index ? dataKey : null,
            children: [
              _buildParentMenu(menu, index),
              Padding(
                padding: EdgeInsets.symmetric(
                  vertical: pageStyle.unitHeight * 4,
                ),
                child: Divider(
                  color: Colors.grey.shade400,
                  height: pageStyle.unitHeight * 1,
                ),
              ),
              activeMenu == menu.id ? _buildSubmenu(menu) : SizedBox.shrink(),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildParentMenu(CategoryMenuEntity menu, int index) {
    return InkWell(
      onTap: () => menu.subMenu.isNotEmpty ? _displaySubmenu(menu, index) : _viewCategory(menu, 0),
      child: Container(
        width: double.infinity,
        margin: EdgeInsets.only(top: pageStyle.unitHeight * 15),
        padding: EdgeInsets.symmetric(
          horizontal: pageStyle.unitWidth * 20,
          vertical: pageStyle.unitHeight * 4,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                if (menu.iconUrl.isNotEmpty) ...[
                  Row(children: [
                    Image.network(menu.iconUrl, width: 25, height: 25),
                    SizedBox(width: 6),
                  ])
                ],
                Text(
                  menu.title.toUpperCase(),
                  style: mediumTextStyle.copyWith(
                    fontSize: pageStyle.unitFontSize * 14,
                    color: darkColor,
                  ),
                ),
              ],
            ),
            if (menu.subMenu.isNotEmpty) ...[
              Icon(
                activeMenu == menu.id ? Icons.arrow_drop_down : Icons.arrow_right,
                size: pageStyle.unitFontSize * 25,
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
                      horizontal: pageStyle.unitWidth * 40,
                      vertical: pageStyle.unitHeight * 10,
                    ),
                    child: Text(
                      menu.subMenu[index].title,
                      style: mediumTextStyle.copyWith(
                        fontSize: pageStyle.unitFontSize * 14,
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

  void _displaySubmenu(CategoryMenuEntity menu, int index) {
    if (activeMenu == menu.id) {
      activeMenu = '';
    } else {
      activeMenu = menu.id;
    }
    activeIndex = index;
    setState(() {});
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Scrollable.ensureVisible(dataKey.currentContext);
    });
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
        return LogoutConfirmDialog(pageStyle: pageStyle);
      },
    );
    if (result != null) {
      signInBloc.add(SignOutSubmitted(token: user.token));
    }
  }

  void _logoutUser() async {
    await settingRepo.updateFcmDeviceToken(user.token, '', '', lang, lang);
    await localRepo.setToken('');
    user = null;
    myCartChangeNotifier.initialize();
    orderChangeNotifier.initializeOrders();
    await myCartChangeNotifier.getCartId();
    await myCartChangeNotifier.getCartItems(lang);
    List<String> ids = await localRepo.getRecentlyViewedIds();
    wishlistChangeNotifier.initialize();
    homeChangeNotifier.loadRecentlyViewedGuest(ids, lang);
    progressService.hideProgress();
    Navigator.pop(context);
    Navigator.popUntil(
      context,
      (route) => route.settings.name == Routes.home,
    );
  }

  void _onChangeLanguage(String value) async {
    if (language != value) {
      language = value;
      if (language == 'EN') {
        context.setLocale(EasyLocalization.of(context).supportedLocales.first);
        lang = 'en';
      } else {
        context.setLocale(EasyLocalization.of(context).supportedLocales.last);
        lang = 'ar';
      }
    }
  }
}
