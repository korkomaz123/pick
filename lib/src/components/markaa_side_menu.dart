import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:markaa/src/change_notifier/home_change_notifier.dart';
import 'package:markaa/src/change_notifier/order_change_notifier.dart';
import 'package:markaa/src/components/markaa_select_option.dart';
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
import 'package:markaa/src/utils/repositories/category_repository.dart';
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

class MarkaaSideMenu extends StatefulWidget {
  @override
  _MarkaaSideMenuState createState() => _MarkaaSideMenuState();
}

class _MarkaaSideMenuState extends State<MarkaaSideMenu>
    with WidgetsBindingObserver {
  final dataKey = GlobalKey();
  int activeIndex;
  double menuWidth;
  String activeMenu = '';
  String language = '';

  SignInBloc signInBloc;

  ProgressService progressService;
  FlushBarService flushBarService;
  FirebaseMessaging firebaseMessaging = FirebaseMessaging();

  LocalStorageRepository localRepo;
  SettingRepository settingRepo;
  CategoryRepository categoryRepo;

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
    localRepo = context.read<LocalStorageRepository>();
    settingRepo = context.read<SettingRepository>();
    categoryRepo = context.read<CategoryRepository>();
    progressService = ProgressService(context: context);
    flushBarService = FlushBarService(context: context);
  }

  @override
  Widget build(BuildContext context) {
    language = EasyLocalization.of(context).locale.languageCode.toUpperCase();
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
      height: 160.h,
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
              Row(
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
              Container(
                width: 100.w,
                height: 20.h,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.grey.shade300,
                ),
                child: MarkaaSelectOption(
                  items: ['EN', 'AR'],
                  value: language,
                  itemWidth: 50.w,
                  itemHeight: 20.h,
                  itemSpace: 0,
                  titleSize: 10.sp,
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
      padding: EdgeInsets.symmetric(vertical: 20.h),
      child: FutureBuilder(
        future: categoryRepo.getMenuCategories(lang),
        initialData: sideMenus,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            sideMenus = snapshot.data;
            return Column(
              children: sideMenus.map((menu) {
                int index = sideMenus.indexOf(menu);
                return Column(
                  key: activeIndex == index ? dataKey : null,
                  children: [
                    _buildParentMenu(menu, index),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: 4.h,
                      ),
                      child: Divider(
                        color: Colors.grey.shade400,
                        height: 1.h,
                      ),
                    ),
                    activeMenu == menu.id
                        ? _buildSubmenu(menu)
                        : SizedBox.shrink(),
                  ],
                );
              }).toList(),
            );
          } else {
            return Container();
          }
        },
      ),
    );
  }

  Widget _buildParentMenu(CategoryMenuEntity menu, int index) {
    return InkWell(
      onTap: () => menu.subMenu.isNotEmpty
          ? _displaySubmenu(menu, index)
          : _viewCategory(menu, 0),
      child: Container(
        width: double.infinity,
        margin: EdgeInsets.only(top: 15.h),
        padding: EdgeInsets.symmetric(
          horizontal: 20.w,
          vertical: 4.h,
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
                    fontSize: 14.sp,
                    color: darkColor,
                  ),
                ),
              ],
            ),
            if (menu.subMenu.isNotEmpty) ...[
              Icon(
                activeMenu == menu.id
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
        return LogoutConfirmDialog();
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
      progressService.showProgress();
      language = value;
      if (language == 'EN') {
        EasyLocalization.of(context).locale =
            EasyLocalization.of(context).supportedLocales.first;
        lang = 'en';
      } else {
        EasyLocalization.of(context).locale =
            EasyLocalization.of(context).supportedLocales.last;
        lang = 'ar';
      }
      firebaseMessaging.getToken().then((String token) async {
        deviceToken = token;
        if (user?.token != null) {
          await settingRepo.updateFcmDeviceToken(
            user.token,
            Platform.isAndroid ? token : '',
            Platform.isIOS ? token : '',
            Platform.isAndroid ? lang : '',
            Platform.isIOS ? lang : '',
          );
        }
        progressService.hideProgress();
        Phoenix.rebirth(context);
      });
    }
  }
}
