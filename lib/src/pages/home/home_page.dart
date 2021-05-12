import 'package:markaa/config.dart';
import 'package:markaa/src/change_notifier/home_change_notifier.dart';
import 'package:markaa/src/change_notifier/my_cart_change_notifier.dart';
import 'package:markaa/src/change_notifier/product_change_notifier.dart';
import 'package:markaa/src/components/markaa_app_bar.dart';
import 'package:markaa/src/components/markaa_bottom_bar.dart';
import 'package:markaa/src/components/markaa_side_menu.dart';
import 'package:markaa/src/config/config.dart';
import 'package:markaa/src/data/models/enum.dart';
import 'package:markaa/src/data/models/slider_image_entity.dart';
import 'package:markaa/src/utils/services/dynamic_link_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

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
      Config.navigatorKey.currentContext.read<HomeChangeNotifier>();

  DynamicLinkService dynamicLinkService = DynamicLinkService();
  @override
  void initState() {
    super.initState();
    Config.setupAdjustSDK();
    dynamicLinkService.initialDynamicLink();
    dynamicLinkService.retrieveDynamicLink();
    _onLoadHomePage();
  }

  void _onLoadHomePage() async {
    Config.navigatorKey.currentContext
        .read<ProductChangeNotifier>()
        .initialize();
    await Config.navigatorKey.currentContext
        .read<MyCartChangeNotifier>()
        .getCartId();
    await Config.navigatorKey.currentContext
        .read<MyCartChangeNotifier>()
        .getCartItems(Config.language);
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

  @override
  Widget build(BuildContext context) {
    Config.setLanguage();
    return Scaffold(
      key: scaffoldKey,
      appBar: MarkaaAppBar(scaffoldKey: scaffoldKey),
      drawer: MarkaaSideMenu(),
      body: NotificationListener<OverscrollIndicatorNotification>(
        onNotification: (notification) {
          notification.disallowGlow();
          return true;
        },
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                width: double.infinity,
                height: 375.w * 579 / 1125,
                child: FutureBuilder(
                  future: _homeProvider.loadSliderImages(),
                  builder: (_, snapShot) => snapShot.connectionState ==
                          ConnectionState.waiting
                      ? Center(child: CircularProgressIndicator())
                      : HomeHeaderCarousel(homeChangeNotifier: _homeProvider),
                ),
              ),
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 10),
                child: FutureBuilder(
                  future: _homeProvider.getFeaturedCategoriesList(),
                  builder: (_, snapShot) =>
                      snapShot.connectionState == ConnectionState.waiting
                          ? Center(child: CircularProgressIndicator())
                          : HomeFeaturedCategories(
                              homeChangeNotifier: _homeProvider),
                ),
              ),
              FutureBuilder(
                future: _homeProvider.loadMegaBanner(),
                builder: (_, snapShot) =>
                    HomeMegaBanner(homeChangeNotifier: _homeProvider),
              ),
              Container(
                height: 380.h,
                padding: EdgeInsets.all(8.w),
                margin: EdgeInsets.only(bottom: 10.h),
                color: Colors.white,
                child: FutureBuilder(
                  future: _homeProvider.loadBestDeals(),
                  builder: (_, snapShot) =>
                      snapShot.connectionState == ConnectionState.waiting
                          ? Center(child: CircularProgressIndicator())
                          : HomeBestDeals(homeChangeNotifier: _homeProvider),
                ),
              ),
              FutureBuilder(
                future: _homeProvider.loadBestDealsBanner(),
                builder: (_, snapShot) =>
                    snapShot.connectionState == ConnectionState.waiting
                        ? Center(child: CircularProgressIndicator())
                        : HomeBestDealsBanner(model: _homeProvider),
              ),
              Container(
                height: 300.h,
                padding: EdgeInsets.all(8.w),
                margin: EdgeInsets.only(bottom: 10.h),
                color: Colors.white,
                child: FutureBuilder(
                  future: _homeProvider.loadNewArrivals(),
                  builder: (_, snapShot) =>
                      snapShot.connectionState == ConnectionState.waiting
                          ? Center(child: CircularProgressIndicator())
                          : HomeNewArrivals(homeChangeNotifier: _homeProvider),
                ),
              ),
              FutureBuilder(
                future: _homeProvider.loadExculisiveBanner(),
                builder: (_, snapShot) => snapShot.connectionState ==
                        ConnectionState.waiting
                    ? Center(child: CircularProgressIndicator())
                    : HomeExculisiveBanner(homeChangeNotifier: _homeProvider),
              ),
              Container(
                width: designWidth.w,
                height: 410.h,
                margin: EdgeInsets.symmetric(vertical: 10.h),
                padding: EdgeInsets.all(8.w),
                color: Colors.white,
                child: FutureBuilder(
                  future: _homeProvider.loadOrientalProducts(),
                  builder: (_, snapShot) =>
                      snapShot.connectionState == ConnectionState.waiting
                          ? Center(child: CircularProgressIndicator())
                          : HomeOrientalFragrances(
                              homeChangeNotifier: _homeProvider),
                ),
              ),
              FutureBuilder(
                future: _homeProvider.loadNewArrivalsBanner(),
                builder: (_, snapShot) => snapShot.connectionState ==
                        ConnectionState.waiting
                    ? Center(child: CircularProgressIndicator())
                    : HomeNewArrivalsBanner(homeChangeNotifier: _homeProvider),
              ),
              FutureBuilder(
                future: _homeProvider.loadFragrancesBanner(),
                builder: (_, snapShot) =>
                    snapShot.connectionState == ConnectionState.waiting
                        ? Center(child: CircularProgressIndicator())
                        : HomeFragrancesBanners(model: _homeProvider),
              ),
              Container(
                width: designWidth.w,
                padding: EdgeInsets.all(8.w),
                margin: EdgeInsets.only(bottom: 10.h),
                color: Colors.white,
                child: FutureBuilder(
                  future: _homeProvider.loadPerfumes(),
                  builder: (_, snapShot) =>
                      snapShot.connectionState == ConnectionState.waiting
                          ? Center(child: CircularProgressIndicator())
                          : HomePerfumes(homeChangeNotifier: _homeProvider),
                ),
              ),
              FutureBuilder(
                future: _homeProvider.loadBestWatches(),
                builder: (_, snapShot) =>
                    snapShot.connectionState == ConnectionState.waiting
                        ? Center(child: CircularProgressIndicator())
                        : HomeBestWatches(homeChangeNotifier: _homeProvider),
              ),
              FutureBuilder(
                future: _homeProvider.loadGrooming(),
                builder: (_, snapShot) =>
                    snapShot.connectionState == ConnectionState.waiting
                        ? Center(child: CircularProgressIndicator())
                        : HomeGrooming(model: _homeProvider),
              ),
              FutureBuilder(
                future: _homeProvider.loadAds(),
                builder: (_, snapShot) =>
                    snapShot.connectionState == ConnectionState.waiting
                        ? Center(child: CircularProgressIndicator())
                        : HomeAdvertise(model: _homeProvider),
              ),
              FutureBuilder(
                future: _homeProvider.loadSmartTech(),
                builder: (_, snapShot) =>
                    snapShot.connectionState == ConnectionState.waiting
                        ? Center(child: CircularProgressIndicator())
                        : HomeSmartTech(homeChangeNotifier: _homeProvider),
              ),
              SizedBox(height: 10.h),
              FutureBuilder(
                future: _homeProvider.getCategoriesList(),
                builder: (_, snapShot) => snapShot.connectionState ==
                        ConnectionState.waiting
                    ? Center(child: CircularProgressIndicator())
                    : HomeExploreCategories(homeChangeNotifier: _homeProvider),
              ),
              SizedBox(height: 10.h),
              Container(
                height: 395.h,
                color: Colors.white,
                padding: EdgeInsets.all(15.w),
                child: FutureBuilder(
                  future: _homeProvider.getBrandsList('home'),
                  builder: (_, snapShot) => snapShot.connectionState ==
                          ConnectionState.waiting
                      ? Center(child: CircularProgressIndicator())
                      : HomeDiscoverStores(homeChangeNotifier: _homeProvider),
                ),
              ),
              SizedBox(height: 10.h),
              FutureBuilder(
                future: _homeProvider.getViewedProducts(),
                builder: (_, snapShot) =>
                    snapShot.connectionState == ConnectionState.waiting
                        ? Center(child: CircularProgressIndicator())
                        : HomeRecent(homeChangeNotifier: _homeProvider),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: MarkaaBottomBar(activeItem: BottomEnum.home),
    );
  }
}
