import 'dart:async';
import 'dart:io';

import 'package:flutter/rendering.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:markaa/preload.dart';
import 'package:markaa/src/change_notifier/auth_change_notifier.dart';
import 'package:markaa/src/change_notifier/home_change_notifier.dart';
import 'package:markaa/src/change_notifier/markaa_app_change_notifier.dart';
import 'package:markaa/src/change_notifier/my_cart_change_notifier.dart';
import 'package:markaa/src/change_notifier/product_change_notifier.dart';
import 'package:markaa/src/components/markaa_bottom_bar.dart';
import 'package:markaa/src/components/markaa_side_menu.dart';
import 'package:markaa/src/components/markaa_simple_app_bar.dart';
import 'package:markaa/src/data/mock/mock.dart';
import 'package:markaa/src/data/models/enum.dart';
import 'package:markaa/src/data/models/slider_image_entity.dart';
import 'package:markaa/src/theme/theme.dart';
import 'package:markaa/src/utils/services/dynamic_link_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:markaa/src/utils/services/onesignal_communicator.dart';
import 'package:provider/provider.dart';

import 'notification_setup.dart';
import 'widgets/home_advertise.dart';
import 'widgets/home_best_deals.dart';
import 'widgets/home_best_deals_banner.dart';
import 'widgets/home_best_watches.dart';
import 'widgets/home_celebrity.dart';
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
import 'widgets/home_sale_brands.dart';
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

  HomeChangeNotifier? _homeProvider;
  MarkaaAppChangeNotifier? _markaaAppChangeNotifier;
  ProductChangeNotifier? _productChangeNotifier;
  MyCartChangeNotifier? _myCartChangeNotifier;
  AuthChangeNotifier? _authChangeNotifier;

  OneSignalCommunicator? _oneSignalCommunicator;
  DynamicLinkService _dynamicLinkService = DynamicLinkService();
  ScrollController _scrollController = ScrollController();
  ScrollDirection _prevDirection = ScrollDirection.forward;

  Future _loadHomePage() async {
    _homeProvider!.loadPopup(_onShowPopup);
    _homeProvider!.getSideMenu();
    Future.wait([
      _homeProvider!.loadSliderImages(),
      _homeProvider!.getFeaturedCategoriesList(),
      _homeProvider!.loadMegaBanner(),
      _homeProvider!.loadBestDeals(),
      _homeProvider!.loadFaceCare(),
      _homeProvider!.getBrandsOnSale(),
      _homeProvider!.loadNewArrivals(),
      _homeProvider!.loadExculisiveBanner(),
      _homeProvider!.loadOrientalProducts(),
      _homeProvider!.loadNewArrivalsBanner(),
      _homeProvider!.loadFragrancesBanner(),
      _homeProvider!.loadPerfumes(),
      _homeProvider!.loadBestWatches(),
      _homeProvider!.gethomecelebrity(),
      _homeProvider!.loadGrooming(),
      _homeProvider!.loadAds(),
      _homeProvider!.loadSmartTech(),
      _homeProvider!.getCategoriesList(),
      _homeProvider!.getBrandsList('home'),
      _homeProvider!.getViewedProducts(),
    ]);
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addObserver(this);
    Preload.setupAdjustSDK();

    _authChangeNotifier = context.read<AuthChangeNotifier>();
    _markaaAppChangeNotifier = context.read<MarkaaAppChangeNotifier>();
    _productChangeNotifier = context.read<ProductChangeNotifier>();
    _myCartChangeNotifier = context.read<MyCartChangeNotifier>();
    _homeProvider = context.read<HomeChangeNotifier>();
    _oneSignalCommunicator = OneSignalCommunicator(context: context);

    _oneSignalCommunicator!.subscribeToChangeNotifiers();
    _dynamicLinkService.initialDynamicLink();
    _dynamicLinkService.retrieveDynamicLink();

    _authChangeNotifier!.getCurrentUser(
      onSuccess: (data) async {
        user = data;
        NotificationSetup().init();
        Future.wait([
          _myCartChangeNotifier!.getCartId(),
          _myCartChangeNotifier!.getCartItems(Preload.language),
        ]);
      },
      onFailure: () async {
        Future.wait([
          _myCartChangeNotifier!.getCartId(),
          _myCartChangeNotifier!.getCartItems(Preload.language),
        ]);
      },
    );
    _productChangeNotifier!.initialize();
    _scrollController.addListener(_onScroll);
    _loadHomePage();
  }

  @override
  void dispose() {
    WidgetsBinding.instance!.removeObserver(this);
    super.dispose();
  }

  _onScroll() {
    if (_prevDirection != _scrollController.position.userScrollDirection) {
      if (_prevDirection == ScrollDirection.forward) {
        _markaaAppChangeNotifier!.changeSearchBarStatus(false);
      } else if (_prevDirection == ScrollDirection.reverse) {
        _markaaAppChangeNotifier!.changeSearchBarStatus(true);
      }
    }
    _prevDirection = _scrollController.position.userScrollDirection;
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
    return WillPopScope(
      onWillPop: () async {
        exit(0);
      },
      child: Scaffold(
        key: scaffoldKey,
        drawer: MarkaaSideMenu(),
        backgroundColor: scaffoldBackgroundColor,
        body: NotificationListener<OverscrollIndicatorNotification>(
          onNotification: (notification) {
            notification.disallowGlow();
            return true;
          },
          child: Consumer<HomeChangeNotifier>(
            builder: (_, __, ___) {
              return RefreshIndicator(
                onRefresh: () async {
                  _loadHomePage();
                },
                color: primaryColor,
                child: Column(
                  children: [
                    MarkaaSimpleAppBar(scaffoldKey: scaffoldKey),
                    Expanded(
                      child: SingleChildScrollView(
                        controller: _scrollController,
                        child: Column(
                          children: [
                            HomeHeaderCarousel(
                              homeChangeNotifier: _homeProvider!,
                            ),
                            HomeFeaturedCategories(
                              homeChangeNotifier: _homeProvider!,
                            ),
                            HomeMegaBanner(homeChangeNotifier: _homeProvider!),
                            HomeBestDeals(homeChangeNotifier: _homeProvider!),
                            HomeCelebrity(homeChangeNotifier: _homeProvider!),
                            HomeGrooming(homeChangeNotifier: _homeProvider!),
                            HomeBestDealsBanner(
                                homeChangeNotifier: _homeProvider!),
                            HomeSaleBrands(homeChangeNotifier: _homeProvider!),
                            HomeNewArrivals(homeChangeNotifier: _homeProvider!),
                            HomeOrientalFragrances(
                                homeChangeNotifier: _homeProvider!),
                            HomeNewArrivalsBanner(
                                homeChangeNotifier: _homeProvider!),
                            HomeFragrancesBanners(
                                homeChangeNotifier: _homeProvider!),
                            HomePerfumes(homeChangeNotifier: _homeProvider!),
                            HomeBestWatches(homeChangeNotifier: _homeProvider!),
                            HomeAdvertise(homeChangeNotifier: _homeProvider!),
                            HomeExploreCategories(
                                homeChangeNotifier: _homeProvider!),
                            HomeDiscoverStores(
                                homeChangeNotifier: _homeProvider!),
                            HomeSmartTech(homeChangeNotifier: _homeProvider!),
                            HomeRecent(homeChangeNotifier: _homeProvider!),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        bottomNavigationBar: MarkaaBottomBar(activeItem: BottomEnum.home),
      ),
    );
  }
}
