import 'dart:io';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:markaa/preload.dart';
import 'package:markaa/src/change_notifier/home_change_notifier.dart';
import 'package:markaa/src/change_notifier/my_cart_change_notifier.dart';
import 'package:markaa/src/change_notifier/product_change_notifier.dart';
import 'package:markaa/src/components/markaa_app_bar.dart';
import 'package:markaa/src/components/markaa_bottom_bar.dart';
import 'package:markaa/src/components/markaa_page_loading_kit.dart';
import 'package:markaa/src/components/markaa_side_menu.dart';
import 'package:markaa/src/config/config.dart';
import 'package:markaa/src/data/mock/mock.dart';
import 'package:markaa/src/data/models/enum.dart';
import 'package:markaa/src/data/models/slider_image_entity.dart';
import 'package:markaa/src/theme/theme.dart';
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

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  final HomeChangeNotifier _homeProvider =
      Preload.navigatorKey.currentContext.read<HomeChangeNotifier>();

  DynamicLinkService dynamicLinkService = DynamicLinkService();
  @override
  void initState() {
    super.initState();

    _loadHomePage();

    Preload.setupAdjustSDK();
    Preload.currentUser.then((data) {
      user = data;
      NotificationSetup().init();
      _onLoadHomePage();
    });

    dynamicLinkService.initialDynamicLink();
    dynamicLinkService.retrieveDynamicLink();
  }

  void _loadHomePage() {
    loadSliderImages = _homeProvider.loadSliderImages();
    getFeaturedCategoriesList = _homeProvider.getFeaturedCategoriesList();
    loadMegaBanner = _homeProvider.loadMegaBanner();
    loadBestDeals = _homeProvider.loadBestDeals();
    loadBestDealsBanner = _homeProvider.loadBestDealsBanner();
    loadNewArrivals = _homeProvider.loadNewArrivals();
    loadExculisiveBanner = _homeProvider.loadExculisiveBanner();
    loadOrientalProducts = _homeProvider.loadOrientalProducts();
    loadNewArrivalsBanner = _homeProvider.loadNewArrivalsBanner();
    loadFragrancesBanner = _homeProvider.loadFragrancesBanner();
    loadPerfumes = _homeProvider.loadPerfumes();
    loadBestWatches = _homeProvider.loadBestWatches();
    loadGrooming = _homeProvider.loadGrooming();
    loadAds = _homeProvider.loadAds();
    loadSmartTech = _homeProvider.loadSmartTech();
    getCategoriesList = _homeProvider.getCategoriesList();
    getBrandsList = _homeProvider.getBrandsList('home');
    getViewedProducts = _homeProvider.getViewedProducts();
  }

  void _initHomePageData() {
    loadSliderImages = null;
    getFeaturedCategoriesList = null;
    loadMegaBanner = null;
    loadBestDeals = null;
    loadBestDealsBanner = null;
    loadNewArrivals = null;
    loadExculisiveBanner = null;
    loadOrientalProducts = null;
    loadNewArrivalsBanner = null;
    loadFragrancesBanner = null;
    loadPerfumes = null;
    loadBestWatches = null;
    loadGrooming = null;
    loadAds = null;
    loadSmartTech = null;
    getCategoriesList = null;
    getBrandsList = null;
    getViewedProducts = null;
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
  }

  void _onShowPopup(SliderImageEntity popupItem) async {
    await showDialog(
      context: context,
      builder: (context) {
        return HomePopupDialog(item: popupItem);
      },
    );
  }

  Future loadSliderImages,
      getFeaturedCategoriesList,
      loadMegaBanner,
      loadBestDeals,
      loadBestDealsBanner,
      loadNewArrivals,
      loadExculisiveBanner,
      loadOrientalProducts,
      loadNewArrivalsBanner,
      loadFragrancesBanner,
      loadPerfumes,
      loadBestWatches,
      loadGrooming,
      loadAds,
      loadSmartTech,
      getCategoriesList,
      getBrandsList,
      getViewedProducts;

  @override
  Widget build(BuildContext context) {
    Preload.setLanguage();
    return WillPopScope(
      onWillPop: () async {
        exit(0);
      },
      child: Scaffold(
        key: scaffoldKey,
        appBar: MarkaaAppBar(scaffoldKey: scaffoldKey),
        drawer: MarkaaSideMenu(),
        backgroundColor: scaffoldBackgroundColor,
        body: NotificationListener<OverscrollIndicatorNotification>(
          onNotification: (notification) {
            notification.disallowGlow();
            return true;
          },
          child: RefreshIndicator(
            onRefresh: () async {
              _initHomePageData();
              setState(() {});
              Future.delayed(Duration(milliseconds: 500), () {
                _loadHomePage();
                setState(() {});
              });
            },
            color: primaryColor,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  FutureBuilder(
                    future: loadSliderImages,
                    builder: (_, snapShot) {
                      if (snapShot.connectionState == ConnectionState.waiting)
                        return Container(
                          width: double.infinity,
                          height: designWidth.w * 579 / 1125,
                          color: Colors.white,
                          child: Center(child: PulseLoadingSpinner()),
                        );
                      else
                        return HomeHeaderCarousel(
                          homeChangeNotifier: _homeProvider,
                        );
                    },
                  ),
                  Container(
                    width: double.infinity,
                    color: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 10.h),
                    child: FutureBuilder(
                      future: getFeaturedCategoriesList,
                      builder: (_, snapShot) =>
                          snapShot.connectionState == ConnectionState.waiting
                              ? Center(child: PulseLoadingSpinner())
                              : HomeFeaturedCategories(
                                  homeChangeNotifier: _homeProvider),
                    ),
                  ),
                  FutureBuilder(
                    future: loadMegaBanner,
                    builder: (_, snapShot) =>
                        HomeMegaBanner(homeChangeNotifier: _homeProvider),
                  ),
                  FutureBuilder(
                    future: loadBestDeals,
                    builder: (_, snapShot) =>
                        snapShot.connectionState == ConnectionState.waiting
                            ? Container(
                                height: 360.h,
                                padding: EdgeInsets.all(8.w),
                                margin: EdgeInsets.only(bottom: 10.h),
                                color: Colors.white,
                                child: Center(child: PulseLoadingSpinner()),
                              )
                            : HomeBestDeals(homeChangeNotifier: _homeProvider),
                  ),
                  FutureBuilder(
                    future: loadGrooming,
                    builder: (_, snapShot) =>
                        snapShot.connectionState == ConnectionState.waiting
                            ? Container(
                                height: 360.h,
                                padding: EdgeInsets.all(8.w),
                                margin: EdgeInsets.only(bottom: 10.h),
                                color: Colors.white,
                                child: Center(child: PulseLoadingSpinner()),
                              )
                            : HomeGrooming(homeChangeNotifier: _homeProvider),
                  ),
                  FutureBuilder(
                    future: loadBestDealsBanner,
                    builder: (_, snapShot) =>
                        snapShot.connectionState == ConnectionState.waiting
                            ? Container(
                                height: 360.h,
                                padding: EdgeInsets.all(8.w),
                                margin: EdgeInsets.only(bottom: 10.h),
                                color: Colors.white,
                                child: Center(child: PulseLoadingSpinner()),
                              )
                            : HomeBestDealsBanner(
                                homeChangeNotifier: _homeProvider),
                  ),
                  FutureBuilder(
                    future: loadNewArrivals,
                    builder: (_, snapShot) => snapShot.connectionState ==
                            ConnectionState.waiting
                        ? Container(
                            height: 360.h,
                            padding: EdgeInsets.all(8.w),
                            margin: EdgeInsets.only(bottom: 10.h),
                            color: Colors.white,
                            child: Center(child: PulseLoadingSpinner()),
                          )
                        : HomeNewArrivals(homeChangeNotifier: _homeProvider),
                  ),
                  FutureBuilder(
                    future: loadOrientalProducts,
                    builder: (_, snapShot) =>
                        snapShot.connectionState == ConnectionState.waiting
                            ? Container(
                                height: 360.h,
                                padding: EdgeInsets.all(8.w),
                                margin: EdgeInsets.only(bottom: 10.h),
                                color: Colors.white,
                                child: Center(child: PulseLoadingSpinner()),
                              )
                            : HomeOrientalFragrances(
                                homeChangeNotifier: _homeProvider),
                  ),
                  FutureBuilder(
                    future: loadNewArrivalsBanner,
                    builder: (_, snapShot) =>
                        snapShot.connectionState == ConnectionState.waiting
                            ? Container(
                                height: 360.h,
                                padding: EdgeInsets.all(8.w),
                                margin: EdgeInsets.only(bottom: 10.h),
                                color: Colors.white,
                                child: Center(child: PulseLoadingSpinner()),
                              )
                            : HomeNewArrivalsBanner(
                                homeChangeNotifier: _homeProvider),
                  ),
                  FutureBuilder(
                    future: loadFragrancesBanner,
                    builder: (_, snapShot) =>
                        snapShot.connectionState == ConnectionState.waiting
                            ? Container(
                                height: 360.h,
                                padding: EdgeInsets.all(8.w),
                                color: Colors.white,
                                child: Center(child: PulseLoadingSpinner()),
                              )
                            : HomeFragrancesBanners(
                                homeChangeNotifier: _homeProvider),
                  ),
                  FutureBuilder(
                    future: loadPerfumes,
                    builder: (_, snapShot) =>
                        snapShot.connectionState == ConnectionState.waiting
                            ? Container(
                                height: 360.h,
                                padding: EdgeInsets.all(8.w),
                                margin: EdgeInsets.only(bottom: 10.h),
                                color: Colors.white,
                                child: Center(child: PulseLoadingSpinner()),
                              )
                            : HomePerfumes(homeChangeNotifier: _homeProvider),
                  ),
                  FutureBuilder(
                    future: loadBestWatches,
                    builder: (_, snapShot) => snapShot.connectionState ==
                            ConnectionState.waiting
                        ? Container(
                            height: 360.h,
                            padding: EdgeInsets.all(8.w),
                            margin: EdgeInsets.only(bottom: 10.h),
                            color: Colors.white,
                            child: Center(child: PulseLoadingSpinner()),
                          )
                        : HomeBestWatches(homeChangeNotifier: _homeProvider),
                  ),
                  FutureBuilder(
                    future: loadAds,
                    builder: (_, snapShot) =>
                        snapShot.connectionState == ConnectionState.waiting
                            ? Container(
                                height: 360.h,
                                padding: EdgeInsets.all(8.w),
                                margin: EdgeInsets.only(bottom: 10.h),
                                color: Colors.white,
                                child: Center(child: PulseLoadingSpinner()),
                              )
                            : HomeAdvertise(homeChangeNotifier: _homeProvider),
                  ),
                  FutureBuilder(
                    future: getCategoriesList,
                    builder: (_, snapShot) =>
                        snapShot.connectionState == ConnectionState.waiting
                            ? Container(
                                height: 360.h,
                                padding: EdgeInsets.all(8.w),
                                margin: EdgeInsets.only(bottom: 10.h),
                                color: Colors.white,
                                child: Center(child: PulseLoadingSpinner()),
                              )
                            : HomeExploreCategories(
                                homeChangeNotifier: _homeProvider),
                  ),
                  FutureBuilder(
                    future: getBrandsList,
                    builder: (_, snapShot) => snapShot.connectionState ==
                            ConnectionState.waiting
                        ? Container(
                            height: 360.h,
                            padding: EdgeInsets.all(8.w),
                            margin: EdgeInsets.only(bottom: 10.h),
                            color: Colors.white,
                            child: Center(child: PulseLoadingSpinner()),
                          )
                        : HomeDiscoverStores(homeChangeNotifier: _homeProvider),
                  ),
                  FutureBuilder(
                    future: loadSmartTech,
                    builder: (_, snapShot) =>
                        snapShot.connectionState == ConnectionState.waiting
                            ? Container(
                                height: 360.h,
                                padding: EdgeInsets.all(8.w),
                                margin: EdgeInsets.only(bottom: 10.h),
                                color: Colors.white,
                                child: Center(child: PulseLoadingSpinner()),
                              )
                            : HomeSmartTech(homeChangeNotifier: _homeProvider),
                  ),
                  FutureBuilder(
                    future: getViewedProducts,
                    builder: (_, snapShot) =>
                        snapShot.connectionState == ConnectionState.waiting
                            ? Container(
                                height: 360.h,
                                padding: EdgeInsets.all(8.w),
                                margin: EdgeInsets.only(bottom: 10.h),
                                color: Colors.white,
                                child: Center(child: PulseLoadingSpinner()),
                              )
                            : HomeRecent(homeChangeNotifier: _homeProvider),
                  ),
                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar: MarkaaBottomBar(activeItem: BottomEnum.home),
      ),
    );
  }
}
