import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
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
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isco_custom_widgets/isco_custom_widgets.dart';

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

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  final HomeChangeNotifier _homeChangeNotifier = Config.navigatorKey.currentContext.read<HomeChangeNotifier>();
  // ProductChangeNotifier productChangeNotifier;

  Timer timerLink;
  DynamicLinkService dynamicLinkService = DynamicLinkService();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    Config.setupAdjustSDK();
    dynamicLinkService.initialDynamicLink();
    dynamicLinkService.retrieveDynamicLink();
    _onLoadHomePage();
  }

  void _onLoadHomePage() async {
    Config.navigatorKey.currentContext.read<ProductChangeNotifier>().initialize();
    await Config.navigatorKey.currentContext.read<MyCartChangeNotifier>().getCartId();
    await Config.navigatorKey.currentContext.read<MyCartChangeNotifier>().getCartItems(Config.language);
    _homeChangeNotifier.loadPopup(_onShowPopup);
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
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    if (timerLink != null) {
      timerLink.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Config.pageStyle = PageStyle(context, designWidth, designHeight);
    Config.pageStyle.initializePageStyles();
    Config.language = EasyLocalization.of(Config.navigatorKey.currentContext).locale.languageCode.toLowerCase();
    // HomeChangeNotifier _homeChangeNotifier = context.read<HomeChangeNotifier>();
    return Scaffold(
      key: scaffoldKey,
      appBar: MarkaaAppBar(pageStyle: Config.pageStyle, scaffoldKey: scaffoldKey),
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
                height: Config.pageStyle.deviceWidth * 579 / 1125,
                child: FutureBuilder(
                  future: _homeChangeNotifier.loadSliderImages(),
                  builder: (_, snapShot) => snapShot.connectionState == ConnectionState.waiting
                      ? Center(child: CircularProgressIndicator())
                      : HomeHeaderCarousel(homeChangeNotifier: _homeChangeNotifier),
                ),
              ),
              Container(
                width: double.infinity,
                child: FutureBuilder(
                  future: _homeChangeNotifier.getFeaturedCategoriesList(),
                  builder: (_, snapShot) => snapShot.connectionState == ConnectionState.waiting
                      ? Center(child: CircularProgressIndicator())
                      : HomeFeaturedCategories(homeChangeNotifier: _homeChangeNotifier),
                ),
              ),
              FutureBuilder(
                future: _homeChangeNotifier.loadMegaBanner(),
                builder: (_, snapShot) => HomeMegaBanner(homeChangeNotifier: _homeChangeNotifier),
              ),
              Container(
                height: Config.pageStyle.unitHeight * 380,
                padding: EdgeInsets.all(Config.pageStyle.unitWidth * 8),
                margin: EdgeInsets.only(bottom: Config.pageStyle.unitHeight * 10),
                color: Colors.white,
                child: FutureBuilder(
                  future: _homeChangeNotifier.loadBestDeals(),
                  builder: (_, snapShot) => snapShot.connectionState == ConnectionState.waiting
                      ? Center(child: CircularProgressIndicator())
                      : HomeBestDeals(homeChangeNotifier: _homeChangeNotifier),
                ),
              ),
              FutureBuilder(
                future: _homeChangeNotifier.loadBestDealsBanner(),
                builder: (_, snapShot) => snapShot.connectionState == ConnectionState.waiting
                    ? Center(child: CircularProgressIndicator())
                    : HomeBestDealsBanner(homeChangeNotifier: _homeChangeNotifier),
              ),
              Container(
                width: Config.pageStyle.deviceWidth,
                height: Config.pageStyle.unitHeight * 300,
                padding: EdgeInsets.all(Config.pageStyle.unitWidth * 8),
                margin: EdgeInsets.only(bottom: Config.pageStyle.unitHeight * 10),
                color: Colors.white,
                child: FutureBuilder(
                  future: _homeChangeNotifier.loadNewArrivals(),
                  builder: (_, snapShot) => snapShot.connectionState == ConnectionState.waiting
                      ? Center(child: CircularProgressIndicator())
                      : HomeNewArrivals(homeChangeNotifier: _homeChangeNotifier),
                ),
              ),
              FutureBuilder(
                future: _homeChangeNotifier.loadExculisiveBanner(),
                builder: (_, snapShot) => snapShot.connectionState == ConnectionState.waiting
                    ? Center(child: CircularProgressIndicator())
                    : HomeExculisiveBanner(homeChangeNotifier: _homeChangeNotifier),
              ),
              Container(
                width: Config.pageStyle.deviceWidth,
                height: Config.pageStyle.unitHeight * 410,
                margin: EdgeInsets.symmetric(vertical: Config.pageStyle.unitHeight * 10),
                padding: EdgeInsets.all(Config.pageStyle.unitWidth * 8),
                color: Colors.white,
                child: FutureBuilder(
                  future: _homeChangeNotifier.loadOrientalProducts(),
                  builder: (_, snapShot) => snapShot.connectionState == ConnectionState.waiting
                      ? Center(child: CircularProgressIndicator())
                      : HomeOrientalFragrances(homeChangeNotifier: _homeChangeNotifier),
                ),
              ),
              FutureBuilder(
                future: _homeChangeNotifier.loadNewArrivalsBanner(),
                builder: (_, snapShot) => snapShot.connectionState == ConnectionState.waiting
                    ? Center(child: CircularProgressIndicator())
                    : HomeNewArrivalsBanner(homeChangeNotifier: _homeChangeNotifier),
              ),
              FutureBuilder(
                future: _homeChangeNotifier.loadFragrancesBanner(),
                builder: (_, snapShot) => snapShot.connectionState == ConnectionState.waiting
                    ? Center(child: CircularProgressIndicator())
                    : HomeFragrancesBanners(homeChangeNotifier: _homeChangeNotifier),
              ),
              Container(
                width: Config.pageStyle.deviceWidth,
                padding: EdgeInsets.all(Config.pageStyle.unitWidth * 8),
                margin: EdgeInsets.only(bottom: Config.pageStyle.unitHeight * 10),
                color: Colors.white,
                child: FutureBuilder(
                  future: _homeChangeNotifier.loadPerfumes(),
                  builder: (_, snapShot) => snapShot.connectionState == ConnectionState.waiting
                      ? Center(child: CircularProgressIndicator())
                      : HomePerfumes(homeChangeNotifier: _homeChangeNotifier),
                ),
              ),
              FutureBuilder(
                future: _homeChangeNotifier.loadBestWatches(),
                builder: (_, snapShot) => snapShot.connectionState == ConnectionState.waiting
                    ? Center(child: CircularProgressIndicator())
                    : HomeBestWatches(homeChangeNotifier: _homeChangeNotifier),
              ),
              FutureBuilder(
                future: _homeChangeNotifier.loadGrooming(),
                builder: (_, snapShot) => snapShot.connectionState == ConnectionState.waiting
                    ? Center(child: CircularProgressIndicator())
                    : HomeGrooming(homeChangeNotifier: _homeChangeNotifier),
              ),
              FutureBuilder(
                future: _homeChangeNotifier.loadAds(),
                builder: (_, snapShot) => snapShot.connectionState == ConnectionState.waiting
                    ? Center(child: CircularProgressIndicator())
                    : HomeAdvertise(homeChangeNotifier: _homeChangeNotifier),
              ),
              FutureBuilder(
                future: _homeChangeNotifier.loadSmartTech(),
                builder: (_, snapShot) => snapShot.connectionState == ConnectionState.waiting
                    ? Center(child: CircularProgressIndicator())
                    : HomeSmartTech(homeChangeNotifier: _homeChangeNotifier),
              ),
              SizedBox(height: Config.pageStyle.unitHeight * 10),
              FutureBuilder(
                future: _homeChangeNotifier.getCategoriesList(),
                builder: (_, snapShot) => snapShot.connectionState == ConnectionState.waiting
                    ? Center(child: CircularProgressIndicator())
                    : HomeExploreCategories(homeChangeNotifier: _homeChangeNotifier),
              ),
              SizedBox(height: Config.pageStyle.unitHeight * 10),
              Container(
                height: Config.pageStyle.unitHeight * 395,
                color: Colors.white,
                padding: EdgeInsets.all(Config.pageStyle.unitWidth * 15),
                child: FutureBuilder(
                  future: _homeChangeNotifier.getBrandsList('home'),
                  builder: (_, snapShot) => snapShot.connectionState == ConnectionState.waiting
                      ? Center(child: CircularProgressIndicator())
                      : HomeDiscoverStores(homeChangeNotifier: _homeChangeNotifier),
                ),
              ),
              SizedBox(height: Config.pageStyle.unitHeight * 10),
              FutureBuilder(
                future: _homeChangeNotifier.getViewedProducts(),
                builder: (_, snapShot) => snapShot.connectionState == ConnectionState.waiting
                    ? Center(child: CircularProgressIndicator())
                    : HomeRecent(homeChangeNotifier: _homeChangeNotifier),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: MarkaaBottomBar(pageStyle: Config.pageStyle, activeItem: BottomEnum.home),
    );
  }
}
