import 'dart:async';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:markaa/src/change_notifier/brand_change_notifier.dart';
import 'package:markaa/src/change_notifier/category_change_notifier.dart';
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
import 'package:markaa/src/pages/home/widgets/home_explore_categories.dart';
import 'package:markaa/src/theme/theme.dart';
import 'package:markaa/src/utils/repositories/brand_repository.dart';
import 'package:markaa/src/utils/repositories/category_repository.dart';
import 'package:markaa/src/utils/repositories/local_storage_repository.dart';
import 'package:markaa/src/utils/repositories/product_repository.dart';
import 'package:markaa/src/utils/repositories/setting_repository.dart';
import 'package:markaa/src/utils/services/dynamic_link_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isco_custom_widgets/isco_custom_widgets.dart';

import 'package:adjust_sdk/adjust.dart';
import 'package:adjust_sdk/adjust_config.dart';
import 'package:adjust_sdk/adjust_attribution.dart';
import 'package:adjust_sdk/adjust_event_failure.dart';
import 'package:adjust_sdk/adjust_event_success.dart';
import 'package:adjust_sdk/adjust_session_failure.dart';
import 'package:adjust_sdk/adjust_session_success.dart';

import 'widgets/home_featured_categories.dart';
import 'widgets/home_advertise.dart';
import 'widgets/home_best_deals.dart';
import 'widgets/home_best_deals_banner.dart';
import 'widgets/home_new_arrivals_banner.dart';
import 'widgets/home_discover_stores.dart';
import 'widgets/home_header_carousel.dart';
import 'widgets/home_new_arrivals.dart';
import 'widgets/home_perfumes.dart';
import 'widgets/home_recent.dart';
import 'widgets/home_popup_dialog.dart';
import 'widgets/home_mega_banner.dart';
import 'widgets/home_exculisive_banner.dart';
import 'widgets/home_oriental_fragrances.dart';
import 'widgets/home_fragrances_banners.dart';
import 'widgets/home_best_watches.dart';
import 'widgets/home_grooming.dart';
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
  final scaffoldKey = GlobalKey<ScaffoldState>();

  PageStyle pageStyle;

  HomeChangeNotifier homeChangeNotifier;
  BrandChangeNotifier brandChangeNotifier;
  CategoryChangeNotifier categoryChangeNotifier;
  ProductChangeNotifier productChangeNotifier;
  MyCartChangeNotifier myCartChangeNotifier;

  LocalStorageRepository localStorageRepository;
  SettingRepository settingRepository;
  ProductRepository productRepository;
  CategoryRepository categoryRepository;
  BrandRepository brandRepository;

  Timer timerLink;
  DynamicLinkService dynamicLinkService = DynamicLinkService();

  int loadingIndex = 0;
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _setupAdjustSDK();
    homeChangeNotifier = context.read<HomeChangeNotifier>();
    brandChangeNotifier = context.read<BrandChangeNotifier>();
    categoryChangeNotifier = context.read<CategoryChangeNotifier>();
    productChangeNotifier = context.read<ProductChangeNotifier>();
    myCartChangeNotifier = context.read<MyCartChangeNotifier>();
    localStorageRepository = context.read<LocalStorageRepository>();
    settingRepository = context.read<SettingRepository>();
    productRepository = context.read<ProductRepository>();
    categoryRepository = context.read<CategoryRepository>();
    brandRepository = context.read<BrandRepository>();
    productChangeNotifier.initialize();
    homeChangeNotifier.loadPopup(lang, _onShowPopup);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      dynamicLinkService.initialDynamicLink(context);
    });
    _onLoadHomePage();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (loadingIndex < 2) {
      double maxScroll = _scrollController.position.maxScrollExtent;
      double currentScroll = _scrollController.position.pixels;
      if (maxScroll - currentScroll <= 300) {
        loadingIndex += 1;
        _onLoadHomePage();
      }
    }
  }

  void _setupAdjustSDK() async {
    AdjustConfig config = new AdjustConfig(
      AdjustSDKConfig.appToken,
      AdjustEnvironment.production,
    );
    config.logLevel = AdjustLogLevel.verbose;

    config.attributionCallback = (AdjustAttribution attributionChangedData) {
      print('[Adjust]: Attribution changed!');

      if (attributionChangedData.trackerToken != null) {
        print('[Adjust]: Tracker token: ' + attributionChangedData.trackerToken);
      }
      if (attributionChangedData.trackerName != null) {
        print('[Adjust]: Tracker name: ' + attributionChangedData.trackerName);
      }
      if (attributionChangedData.campaign != null) {
        print('[Adjust]: Campaign: ' + attributionChangedData.campaign);
      }
      if (attributionChangedData.network != null) {
        print('[Adjust]: Network: ' + attributionChangedData.network);
      }
      if (attributionChangedData.creative != null) {
        print('[Adjust]: Creative: ' + attributionChangedData.creative);
      }
      if (attributionChangedData.adgroup != null) {
        print('[Adjust]: Adgroup: ' + attributionChangedData.adgroup);
      }
      if (attributionChangedData.clickLabel != null) {
        print('[Adjust]: Click label: ' + attributionChangedData.clickLabel);
      }
      if (attributionChangedData.adid != null) {
        print('[Adjust]: Adid: ' + attributionChangedData.adid);
      }
    };

    config.sessionSuccessCallback = (AdjustSessionSuccess sessionSuccessData) {
      print('[Adjust]: Session tracking success!');

      if (sessionSuccessData.message != null) {
        print('[Adjust]: Message: ' + sessionSuccessData.message);
      }
      if (sessionSuccessData.timestamp != null) {
        print('[Adjust]: Timestamp: ' + sessionSuccessData.timestamp);
      }
      if (sessionSuccessData.adid != null) {
        print('[Adjust]: Adid: ' + sessionSuccessData.adid);
      }
      if (sessionSuccessData.jsonResponse != null) {
        print('[Adjust]: JSON response: ' + sessionSuccessData.jsonResponse);
      }
    };

    config.sessionFailureCallback = (AdjustSessionFailure sessionFailureData) {
      print('[Adjust]: Session tracking failure!');

      if (sessionFailureData.message != null) {
        print('[Adjust]: Message: ' + sessionFailureData.message);
      }
      if (sessionFailureData.timestamp != null) {
        print('[Adjust]: Timestamp: ' + sessionFailureData.timestamp);
      }
      if (sessionFailureData.adid != null) {
        print('[Adjust]: Adid: ' + sessionFailureData.adid);
      }
      if (sessionFailureData.willRetry != null) {
        print('[Adjust]: Will retry: ' + sessionFailureData.willRetry.toString());
      }
      if (sessionFailureData.jsonResponse != null) {
        print('[Adjust]: JSON response: ' + sessionFailureData.jsonResponse);
      }
    };

    config.eventSuccessCallback = (AdjustEventSuccess eventSuccessData) {
      print('[Adjust]: Event tracking success!');

      if (eventSuccessData.eventToken != null) {
        print('[Adjust]: Event token: ' + eventSuccessData.eventToken);
      }
      if (eventSuccessData.message != null) {
        print('[Adjust]: Message: ' + eventSuccessData.message);
      }
      if (eventSuccessData.timestamp != null) {
        print('[Adjust]: Timestamp: ' + eventSuccessData.timestamp);
      }
      if (eventSuccessData.adid != null) {
        print('[Adjust]: Adid: ' + eventSuccessData.adid);
      }
      if (eventSuccessData.callbackId != null) {
        print('[Adjust]: Callback ID: ' + eventSuccessData.callbackId);
      }
      if (eventSuccessData.jsonResponse != null) {
        print('[Adjust]: JSON response: ' + eventSuccessData.jsonResponse);
      }
    };

    config.eventFailureCallback = (AdjustEventFailure eventFailureData) {
      print('[Adjust]: Event tracking failure!');

      if (eventFailureData.eventToken != null) {
        print('[Adjust]: Event token: ' + eventFailureData.eventToken);
      }
      if (eventFailureData.message != null) {
        print('[Adjust]: Message: ' + eventFailureData.message);
      }
      if (eventFailureData.timestamp != null) {
        print('[Adjust]: Timestamp: ' + eventFailureData.timestamp);
      }
      if (eventFailureData.adid != null) {
        print('[Adjust]: Adid: ' + eventFailureData.adid);
      }
      if (eventFailureData.callbackId != null) {
        print('[Adjust]: Callback ID: ' + eventFailureData.callbackId);
      }
      if (eventFailureData.willRetry != null) {
        print('[Adjust]: Will retry: ' + eventFailureData.willRetry.toString());
      }
      if (eventFailureData.jsonResponse != null) {
        print('[Adjust]: JSON response: ' + eventFailureData.jsonResponse);
      }
    };

    config.launchDeferredDeeplink = true;
    config.deferredDeeplinkCallback = (String uri) {
      print('[Adjust]: Received deferred deeplink: ' + uri);
    };

    // Add session callback parameters.
    Adjust.addSessionCallbackParameter('scp_foo_1', 'scp_bar');
    Adjust.addSessionCallbackParameter('scp_foo_2', 'scp_value');

    // Add session Partner parameters.
    Adjust.addSessionPartnerParameter('spp_foo_1', 'spp_bar');
    Adjust.addSessionPartnerParameter('spp_foo_2', 'spp_value');

    // Remove session callback parameters.
    Adjust.removeSessionCallbackParameter('scp_foo_1');
    Adjust.removeSessionPartnerParameter('spp_foo_1');

    // Clear all session callback parameters.
    Adjust.resetSessionCallbackParameters();

    // Clear all session partner parameters.
    Adjust.resetSessionPartnerParameters();

    // Start SDK.
    Adjust.start(config);
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
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.inactive:
        break;
      case AppLifecycleState.resumed:
        Adjust.onResume();
        timerLink = new Timer(
          const Duration(milliseconds: 1000),
          () {
            dynamicLinkService.retrieveDynamicLink(context);
          },
        );
        break;
      case AppLifecycleState.paused:
        Adjust.onPause();
        break;
      case AppLifecycleState.detached:
        break;
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    if (timerLink != null) {
      timerLink.cancel();
    }
    super.dispose();
  }

  Future<void> _onRefresh() async {
    loadingIndex = 1;
    _onLoadHomePage();
  }

  void _onLoadHomePage() async {
    homeChangeNotifier.loadSliderImages(lang);
    categoryChangeNotifier.getFeaturedCategoriesList(lang);
    homeChangeNotifier.loadMegaBanner(lang);
    homeChangeNotifier.loadBestDeals(lang);
    homeChangeNotifier.loadBestDealsBanner(lang);
    homeChangeNotifier.loadNewArrivals(lang);
    homeChangeNotifier.loadExculisiveBanner(lang);
    homeChangeNotifier.loadOrientalProducts(lang);
    homeChangeNotifier.loadNewArrivalsBanner(lang);
    homeChangeNotifier.loadFragrancesBanner(lang);
    homeChangeNotifier.loadPerfumes(lang);
    homeChangeNotifier.loadBestWatches(lang);
    homeChangeNotifier.loadGrooming(lang);
    homeChangeNotifier.loadAds(lang);
    homeChangeNotifier.loadSmartTech(lang);
    categoryChangeNotifier.getCategoriesList(lang);
    brandChangeNotifier.getBrandsList(lang, 'home');
    if (user?.token != null) {
      homeChangeNotifier.loadRecentlyViewedCustomer(user.token, lang);
    } else {
      List<String> ids = await localStorageRepository.getRecentlyViewedIds();
      homeChangeNotifier.loadRecentlyViewedGuest(ids, lang);
    }
  }

  @override
  Widget build(BuildContext context) {
    pageStyle = PageStyle(context, designWidth, designHeight);
    pageStyle.initializePageStyles();
    return Scaffold(
      key: scaffoldKey,
      appBar: MarkaaAppBar(pageStyle: pageStyle, scaffoldKey: scaffoldKey),
      drawer: MarkaaSideMenu(pageStyle: pageStyle),
      body: RefreshIndicator(
        onRefresh: _onRefresh,
        backgroundColor: Colors.white,
        color: primaryColor,
        child: NotificationListener<OverscrollIndicatorNotification>(
          onNotification: (notification) {
            notification.disallowGlow();
            return true;
          },
          child: ListView.builder(
            itemCount: 1,
            itemBuilder: (ctx, index) {
              return Column(
                children: [
                  HomeHeaderCarousel(pageStyle: pageStyle),
                  HomeFeaturedCategories(pageStyle: pageStyle),
                  HomeMegaBanner(pageStyle: pageStyle),
                  HomeBestDeals(pageStyle: pageStyle),
                  HomeBestDealsBanner(pageStyle: pageStyle),
                  HomeNewArrivals(pageStyle: pageStyle),
                  HomeExculisiveBanner(pageStyle: pageStyle),
                  HomeOrientalFragrances(pageStyle: pageStyle),
                  HomeNewArrivalsBanner(pageStyle: pageStyle),
                  HomeFragrancesBanners(pageStyle: pageStyle),
                  HomePerfumes(pageStyle: pageStyle),
                  HomeBestWatches(pageStyle: pageStyle),
                  HomeGrooming(pageStyle: pageStyle),
                  HomeAdvertise(pageStyle: pageStyle),
                  HomeSmartTech(pageStyle: pageStyle),
                  SizedBox(height: pageStyle.unitHeight * 10),
                  HomeExploreCategories(pageStyle: pageStyle),
                  SizedBox(height: pageStyle.unitHeight * 10),
                  HomeDiscoverStores(pageStyle: pageStyle),
                  SizedBox(height: pageStyle.unitHeight * 10),
                  HomeRecent(pageStyle: pageStyle),
                ],
              );
            },
          ),
        ),
      ),
      bottomNavigationBar: MarkaaBottomBar(
        pageStyle: pageStyle,
        activeItem: BottomEnum.home,
      ),
    );
  }
}
