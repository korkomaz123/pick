import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:markaa/preload.dart';
import 'package:markaa/src/change_notifier/home_change_notifier.dart';
import 'package:markaa/src/change_notifier/my_cart_change_notifier.dart';
import 'package:markaa/src/change_notifier/product_change_notifier.dart';
import 'package:markaa/src/components/markaa_app_bar.dart';
import 'package:markaa/src/components/markaa_bottom_bar.dart';
import 'package:markaa/src/components/markaa_side_menu.dart';
import 'package:markaa/src/config/config.dart';
import 'package:markaa/src/data/mock/mock.dart';
import 'package:markaa/src/data/models/enum.dart';
import 'package:markaa/src/data/models/slider_image_entity.dart';
import 'package:markaa/src/utils/services/dynamic_link_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'notification_setup.dart';
import 'widgets/home_advertise.dart';
import 'widgets/home_best_deals.dart';
import 'widgets/home_best_deals_banner.dart';
import 'widgets/home_best_watches.dart';
import 'widgets/home_discover_stores.dart';
import 'widgets/home_exculisive_banner.dart';
import 'widgets/home_explore_categories.dart';
import 'widgets/home_featured_categories.dart';
import 'widgets/home_fragrances_banners.dart';
import 'widgets/home_grooming.dart';
import 'widgets/home_header_carousel.dart';
import 'widgets/home_mega_banner.dart';
import 'widgets/home_new_arrivals.dart';
import 'widgets/home_new_arrivals_banner.dart';
import 'widgets/home_oriental_fragrances.dart';
import 'widgets/home_perfumes.dart';
import 'widgets/home_popup_dialog.dart';
import 'widgets/home_recent.dart';
import 'widgets/home_smart_tech.dart';

const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'high_importance_channel', // id
  'High Importance Notifications', // title
  'This channel is used for important notifications.', // description
  importance: Importance.max,
);

final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  final HomeChangeNotifier _homeProvider =
      Preload.navigatorKey.currentContext.read<HomeChangeNotifier>();

  DynamicLinkService dynamicLinkService = DynamicLinkService();
  @override
  void initState() {
    super.initState();

    Preload.setupAdjustSDK();

    Preload.currentUser.then((data) {
      user = data;
      NotificationSetup().init();
      _onLoadHomePage();
    });

    dynamicLinkService.initialDynamicLink();
    dynamicLinkService.retrieveDynamicLink();

    _onLoadHomePage();
  }

  void _onLoadHomePage() async {
    Preload.navigatorKey.currentContext
        .read<ProductChangeNotifier>()
        .initialize();
    await Preload.navigatorKey.currentContext
        .read<MyCartChangeNotifier>()
        .getCartId();
    await Preload.navigatorKey.currentContext
        .read<MyCartChangeNotifier>()
        .getCartItems(Preload.language);

    _homeProvider.loadPopup(_onShowPopup);
    _homeProvider.loadSliderImages();
    _homeProvider.getFeaturedCategoriesList();
    _homeProvider.loadMegaBanner();
    _homeProvider.loadBestDeals();
    _homeProvider.loadBestDealsBanner();
    _homeProvider.loadNewArrivals();
    _homeProvider.loadExculisiveBanner();
    _homeProvider.loadOrientalProducts();
    _homeProvider.loadNewArrivalsBanner();
    _homeProvider.loadFragrancesBanner();
    _homeProvider.loadPerfumes();
    _homeProvider.loadBestWatches();
    _homeProvider.loadGrooming();
    _homeProvider.loadAds();
    _homeProvider.loadSmartTech();
    _homeProvider.getCategoriesList();
    _homeProvider.getBrandsList('home');
    _homeProvider.getViewedProducts();
  }

  void _onShowPopup(SliderImageEntity popupItem) async {
    await showDialog(
      context: context,
      builder: (context) {
        return HomePopupDialog(item: popupItem);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    Preload.setLanguage();
    return Scaffold(
      key: scaffoldKey,
      appBar: MarkaaAppBar(scaffoldKey: scaffoldKey),
      drawer: MarkaaSideMenu(),
      body: NotificationListener<OverscrollIndicatorNotification>(
        onNotification: (notification) {
          notification.disallowGlow();
          return true;
        },
        child: Consumer<HomeChangeNotifier>(
          builder: (_, __, ___) {
            return SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    height: designWidth.w * 579 / 1125,
                    child:
                        HomeHeaderCarousel(homeChangeNotifier: _homeProvider),
                  ),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: HomeFeaturedCategories(
                        homeChangeNotifier: _homeProvider),
                  ),
                  HomeMegaBanner(homeChangeNotifier: _homeProvider),
                  Container(
                    height: 380.h,
                    padding: EdgeInsets.all(8.w),
                    margin: EdgeInsets.only(bottom: 10.h),
                    color: Colors.white,
                    child: HomeBestDeals(homeChangeNotifier: _homeProvider),
                  ),
                  HomeBestDealsBanner(homeChangeNotifier: _homeProvider),
                  Container(
                    height: 300.h,
                    padding: EdgeInsets.all(8.w),
                    margin: EdgeInsets.only(bottom: 10.h),
                    color: Colors.white,
                    child: HomeNewArrivals(homeChangeNotifier: _homeProvider),
                  ),
                  HomeExculisiveBanner(homeChangeNotifier: _homeProvider),
                  Container(
                    width: designWidth.w,
                    height: 410.h,
                    margin: EdgeInsets.symmetric(vertical: 10.h),
                    padding: EdgeInsets.all(8.w),
                    color: Colors.white,
                    child: HomeOrientalFragrances(
                        homeChangeNotifier: _homeProvider),
                  ),
                  HomeNewArrivalsBanner(homeChangeNotifier: _homeProvider),
                  HomeFragrancesBanners(homeChangeNotifier: _homeProvider),
                  Container(
                    width: designWidth.w,
                    padding: EdgeInsets.all(8.w),
                    margin: EdgeInsets.only(bottom: 10.h),
                    color: Colors.white,
                    child: HomePerfumes(homeChangeNotifier: _homeProvider),
                  ),
                  HomeBestWatches(homeChangeNotifier: _homeProvider),
                  HomeGrooming(homeChangeNotifier: _homeProvider),
                  HomeAdvertise(homeChangeNotifier: _homeProvider),
                  HomeSmartTech(homeChangeNotifier: _homeProvider),
                  SizedBox(height: 10.h),
                  HomeExploreCategories(homeChangeNotifier: _homeProvider),
                  SizedBox(height: 10.h),
                  Container(
                    height: 395.h,
                    color: Colors.white,
                    padding: EdgeInsets.all(15.w),
                    child:
                        HomeDiscoverStores(homeChangeNotifier: _homeProvider),
                  ),
                  SizedBox(height: 10.h),
                  HomeRecent(homeChangeNotifier: _homeProvider),
                ],
              ),
            );
          },
        ),
      ),
      bottomNavigationBar: MarkaaBottomBar(activeItem: BottomEnum.home),
    );
  }
}
