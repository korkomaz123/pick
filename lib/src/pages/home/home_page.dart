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
import 'package:provider/provider.dart';

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

  final HomeChangeNotifier _homeProvider = Config.navigatorKey.currentContext.read<HomeChangeNotifier>();

  DynamicLinkService dynamicLinkService = DynamicLinkService();

  Future loadSliderImages,
      getFeaturedCategoriesList,
      loadBestDeals,
      getHomeCategories,
      loadMegaBanner,
      loadNewArrivalsBanner,
      loadNewArrivals,
      loadExculisiveBanner,
      loadOrientalProducts,
      loadBestDealsBanner,
      loadFragrancesBanner,
      loadPerfumes,
      loadBestWatches,
      loadAds,
      getViewedProducts,
      loadGrooming,
      loadSmartTech,
      getCategoriesList,
      getBrandsList;
  @override
  void initState() {
    loadSliderImages = _homeProvider.loadSliderImages();
    getFeaturedCategoriesList = _homeProvider.getFeaturedCategoriesList();
    loadBestDeals = _homeProvider.loadBestDeals();
    getHomeCategories = _homeProvider.getHomeCategories();
    loadMegaBanner = _homeProvider.loadMegaBanner();
    loadNewArrivalsBanner = _homeProvider.loadNewArrivalsBanner();
    loadNewArrivals = _homeProvider.loadNewArrivals();
    loadExculisiveBanner = _homeProvider.loadExculisiveBanner();
    loadOrientalProducts = _homeProvider.loadOrientalProducts();
    loadBestDealsBanner = _homeProvider.loadBestDealsBanner();
    loadFragrancesBanner = _homeProvider.loadFragrancesBanner();
    loadPerfumes = _homeProvider.loadPerfumes();
    loadBestWatches = _homeProvider.loadBestWatches();
    loadAds = _homeProvider.loadAds();
    loadGrooming = _homeProvider.loadGrooming();
    loadSmartTech = _homeProvider.loadSmartTech();
    getCategoriesList = _homeProvider.getCategoriesList();
    getBrandsList = _homeProvider.getBrandsList('home');
    getViewedProducts = _homeProvider.getViewedProducts();
    super.initState();
    Config.setupAdjustSDK();
    dynamicLinkService.initialDynamicLink();
    dynamicLinkService.retrieveDynamicLink();
    _onLoadHomePage();
  }

  void _onLoadHomePage() async {
    Config.navigatorKey.currentContext.read<ProductChangeNotifier>().initialize();
    await Config.navigatorKey.currentContext.read<MyCartChangeNotifier>().getCartId();
    await Config.navigatorKey.currentContext.read<MyCartChangeNotifier>().getCartItems(Config.language);
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
    Config.pageStyle = PageStyle(context, designWidth, designHeight);
    Config.pageStyle.initializePageStyles();
    Config.language = EasyLocalization.of(Config.navigatorKey.currentContext).locale.languageCode.toLowerCase();
    return Scaffold(
      key: scaffoldKey,
      appBar: MarkaaAppBar(pageStyle: Config.pageStyle, scaffoldKey: scaffoldKey),
      drawer: MarkaaSideMenu(),
      body: NotificationListener<OverscrollIndicatorNotification>(
        onNotification: (notification) {
          notification.disallowGlow();
          return true;
        },
        child: Consumer<HomeChangeNotifier>(
          builder: (context, _homeChangeNotifier, child) => SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  height: Config.pageStyle.deviceWidth * 579 / 1125,
                  child: FutureBuilder(
                    future: loadSliderImages,
                    builder: (_, snapShot) => snapShot.connectionState == ConnectionState.waiting
                        ? Center(child: CircularProgressIndicator())
                        : HomeHeaderCarousel(homeChangeNotifier: _homeChangeNotifier),
                  ),
                ),
                Container(
                  width: double.infinity,
                  child: FutureBuilder(
                    future: getFeaturedCategoriesList,
                    builder: (_, snapShot) => snapShot.connectionState == ConnectionState.waiting
                        ? Center(child: CircularProgressIndicator())
                        : HomeFeaturedCategories(homeChangeNotifier: _homeChangeNotifier),
                  ),
                ),
                FutureBuilder(
                  future: loadMegaBanner,
                  builder: (_, snapShot) => HomeMegaBanner(homeChangeNotifier: _homeChangeNotifier),
                ),
                Container(
                  height: Config.pageStyle.unitHeight * 380,
                  padding: EdgeInsets.all(Config.pageStyle.unitWidth * 8),
                  margin: EdgeInsets.only(bottom: Config.pageStyle.unitHeight * 10),
                  color: Colors.white,
                  child: FutureBuilder(
                    future: loadBestDeals,
                    builder: (_, snapShot) => snapShot.connectionState == ConnectionState.waiting
                        ? Center(child: CircularProgressIndicator())
                        : HomeBestDeals(homeChangeNotifier: _homeChangeNotifier),
                  ),
                ),
                FutureBuilder(
                  future: loadBestDealsBanner,
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
                    future: loadNewArrivals,
                    builder: (_, snapShot) => snapShot.connectionState == ConnectionState.waiting
                        ? Center(child: CircularProgressIndicator())
                        : HomeNewArrivals(homeChangeNotifier: _homeChangeNotifier),
                  ),
                ),
                FutureBuilder(
                  future: loadExculisiveBanner,
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
                    future: loadOrientalProducts,
                    builder: (_, snapShot) => snapShot.connectionState == ConnectionState.waiting
                        ? Center(child: CircularProgressIndicator())
                        : HomeOrientalFragrances(homeChangeNotifier: _homeChangeNotifier),
                  ),
                ),
                FutureBuilder(
                  future: loadNewArrivalsBanner,
                  builder: (_, snapShot) => snapShot.connectionState == ConnectionState.waiting
                      ? Center(child: CircularProgressIndicator())
                      : HomeNewArrivalsBanner(homeChangeNotifier: _homeChangeNotifier),
                ),
                FutureBuilder(
                  future: loadFragrancesBanner,
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
                    future: loadPerfumes,
                    builder: (_, snapShot) => snapShot.connectionState == ConnectionState.waiting
                        ? Center(child: CircularProgressIndicator())
                        : HomePerfumes(homeChangeNotifier: _homeChangeNotifier),
                  ),
                ),
                FutureBuilder(
                  future: loadBestWatches,
                  builder: (_, snapShot) => snapShot.connectionState == ConnectionState.waiting
                      ? Center(child: CircularProgressIndicator())
                      : HomeBestWatches(homeChangeNotifier: _homeChangeNotifier),
                ),
                FutureBuilder(
                  future: loadGrooming,
                  builder: (_, snapShot) => snapShot.connectionState == ConnectionState.waiting
                      ? Center(child: CircularProgressIndicator())
                      : HomeGrooming(homeChangeNotifier: _homeChangeNotifier),
                ),
                FutureBuilder(
                  future: loadAds,
                  builder: (_, snapShot) => snapShot.connectionState == ConnectionState.waiting
                      ? Center(child: CircularProgressIndicator())
                      : HomeAdvertise(homeChangeNotifier: _homeChangeNotifier),
                ),
                FutureBuilder(
                  future: loadSmartTech,
                  builder: (_, snapShot) => snapShot.connectionState == ConnectionState.waiting
                      ? Center(child: CircularProgressIndicator())
                      : HomeSmartTech(homeChangeNotifier: _homeChangeNotifier),
                ),
                SizedBox(height: Config.pageStyle.unitHeight * 10),
                FutureBuilder(
                  future: getCategoriesList,
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
                    future: getBrandsList,
                    builder: (_, snapShot) => snapShot.connectionState == ConnectionState.waiting
                        ? Center(child: CircularProgressIndicator())
                        : HomeDiscoverStores(homeChangeNotifier: _homeChangeNotifier),
                  ),
                ),
                SizedBox(height: Config.pageStyle.unitHeight * 10),
                FutureBuilder(
                  future: getViewedProducts,
                  builder: (_, snapShot) => snapShot.connectionState == ConnectionState.waiting
                      ? Center(child: CircularProgressIndicator())
                      : HomeRecent(homeChangeNotifier: _homeChangeNotifier),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: MarkaaBottomBar(pageStyle: Config.pageStyle, activeItem: BottomEnum.home),
    );
  }
}
