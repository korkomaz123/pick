import 'dart:async';
import 'dart:convert';
import 'dart:io' show Platform;

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:markaa/src/change_notifier/brand_change_notifier.dart';
import 'package:markaa/src/change_notifier/category_change_notifier.dart';
import 'package:markaa/src/change_notifier/home_change_notifier.dart';
import 'package:markaa/src/change_notifier/product_change_notifier.dart';
import 'package:markaa/src/components/markaa_app_bar.dart';
import 'package:markaa/src/components/markaa_bottom_bar.dart';
import 'package:markaa/src/components/markaa_side_menu.dart';
import 'package:markaa/src/config/config.dart';
import 'package:markaa/src/data/mock/mock.dart';
import 'package:markaa/src/data/models/brand_entity.dart';
import 'package:markaa/src/data/models/category_entity.dart';
import 'package:markaa/src/data/models/enum.dart';
import 'package:markaa/src/data/models/product_list_arguments.dart';
import 'package:markaa/src/data/models/slider_image_entity.dart';
import 'package:markaa/src/pages/home/widgets/home_explore_categories.dart';
import 'package:markaa/src/routes/routes.dart';
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
import 'package:pull_to_refresh/pull_to_refresh.dart';
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

const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'high_importance_channel', // id
  'High Importance Notifications', // title
  'This channel is used for important notifications.', // description
  importance: Importance.Max,
);

final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final _refreshController = RefreshController(initialRefresh: false);

  PageStyle pageStyle;
  FirebaseMessaging firebaseMessaging = FirebaseMessaging();

  HomeChangeNotifier homeChangeNotifier;
  BrandChangeNotifier brandChangeNotifier;
  CategoryChangeNotifier categoryChangeNotifier;
  ProductChangeNotifier productChangeNotifier;

  LocalStorageRepository localStorageRepository;
  SettingRepository settingRepository;
  ProductRepository productRepository;
  CategoryRepository categoryRepository;
  BrandRepository brandRepository;

  Timer timerLink;
  DynamicLinkService dynamicLinkService = DynamicLinkService();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _setupAdjustSDK();
    homeChangeNotifier = context.read<HomeChangeNotifier>();
    brandChangeNotifier = context.read<BrandChangeNotifier>();
    categoryChangeNotifier = context.read<CategoryChangeNotifier>();
    productChangeNotifier = context.read<ProductChangeNotifier>();
    localStorageRepository = context.read<LocalStorageRepository>();
    settingRepository = context.read<SettingRepository>();
    productRepository = context.read<ProductRepository>();
    categoryRepository = context.read<CategoryRepository>();
    brandRepository = context.read<BrandRepository>();
    productChangeNotifier.initialize();
    _initializeLocalNotification();
    _configureMessaging();
    homeChangeNotifier.loadPopup(lang, _onShowPopup);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      dynamicLinkService.initialDynamicLink(context);
    });
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
        print(
            '[Adjust]: Tracker token: ' + attributionChangedData.trackerToken);
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
        print(
            '[Adjust]: Will retry: ' + sessionFailureData.willRetry.toString());
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

  void _initializeLocalNotification() async {
    var initializationSettingsAndroid =
        AndroidInitializationSettings('launcher_icon');
    var initializationSettingsIOS = IOSInitializationSettings(
      onDidReceiveLocalNotification: onDidReceiveLocalNotification,
    );
    var initializationSettings = InitializationSettings(
      initializationSettingsAndroid,
      initializationSettingsIOS,
    );
    flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onSelectNotification: onSelectNotification,
    );
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }

  Future onSelectNotification(String payload) async {
    if (payload != null) {
      debugPrint('notification payload: ' + payload);
      await _onLaunchMessage(jsonDecode(payload));
    }
  }

  Future onDidReceiveLocalNotification(
    int id,
    String title,
    String body,
    String payload,
  ) async {
    showDialog(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: Text(title),
        content: Text(body),
        actions: [
          CupertinoDialogAction(
            isDefaultAction: true,
            child: Text('Ok okay okay'),
            onPressed: () {
              Navigator.pushNamed(context, Routes.categoryList);
            },
          )
        ],
      ),
    );
  }

  void _configureMessaging() async {
    firebaseMessaging.configure(
      onMessage: _onForegroundMessage,
      onResume: _onLaunchMessage,
      onLaunch: _onLaunchMessage,
      onBackgroundMessage: _onBackgroundMessageHandler,
    );
    firebaseMessaging.requestNotificationPermissions(IosNotificationSettings(
      sound: true,
      badge: true,
      alert: true,
      provisional: true,
    ));
    firebaseMessaging.onIosSettingsRegistered.listen(
      (IosNotificationSettings settings) {
        print("Settings registered: $settings");
      },
    );
    firebaseMessaging.getToken().then((String token) async {
      deviceToken = token;
      if (user?.token != null) {
        await settingRepository.updateFcmDeviceToken(
          user.token,
          Platform.isAndroid ? token : '',
          Platform.isIOS ? token : '',
          Platform.isAndroid ? lang : '',
          Platform.isIOS ? lang : '',
        );
      }
    });
    String topic = lang == 'en'
        ? MarkaaNotificationChannels.enChannel
        : MarkaaNotificationChannels.arChannel;
    await firebaseMessaging.subscribeToTopic(topic);
  }

  static Future<dynamic> _onBackgroundMessageHandler(
    Map<String, dynamic> message,
  ) async {
    await flutterLocalNotificationsPlugin.show(
      message.hashCode,
      message['notification']['title'],
      message['notification']['body'],
      NotificationDetails(
        AndroidNotificationDetails(
          channel.id,
          channel.name,
          channel.description,
        ),
        IOSNotificationDetails(),
      ),
      payload: jsonEncode(message),
    );
  }

  Future<dynamic> _onForegroundMessage(Map<String, dynamic> message) async {
    await flutterLocalNotificationsPlugin.show(
      message.hashCode,
      Platform.isAndroid ? message['notification']['title'] : message['title'],
      Platform.isAndroid ? message['notification']['body'] : message['body'],
      NotificationDetails(
        AndroidNotificationDetails(
          channel.id,
          channel.name,
          channel.description,
        ),
        IOSNotificationDetails(),
      ),
      payload: jsonEncode(message),
    );
  }

  Future<dynamic> _onLaunchMessage(Map<String, dynamic> message) async {
    try {
      Map<dynamic, dynamic> data =
          Platform.isAndroid ? message['data'] : message;
      int target = int.parse(data['target']);
      if (target != 0) {
        String id = data['id'];
        if (target == 1) {
          final product = await productRepository.getProduct(id, lang);
          Navigator.pushNamed(context, Routes.product, arguments: product);
        } else if (target == 2) {
          final category = await categoryRepository.getCategory(id, lang);
          if (category != null) {
            ProductListArguments arguments = ProductListArguments(
              category: category,
              subCategory: [],
              brand: BrandEntity(),
              selectedSubCategoryIndex: 0,
              isFromBrand: false,
            );
            Navigator.pushNamed(
              context,
              Routes.productList,
              arguments: arguments,
            );
          }
        } else if (target == 3) {
          final brand = await brandRepository.getBrand(id, lang);
          if (brand != null) {
            ProductListArguments arguments = ProductListArguments(
              category: CategoryEntity(),
              subCategory: [],
              brand: brand,
              selectedSubCategoryIndex: 0,
              isFromBrand: true,
            );
            Navigator.pushNamed(
              context,
              Routes.productList,
              arguments: arguments,
            );
          }
        }
      }
    } catch (e) {
      print('catch error $e');
    }
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

  void _onRefresh() async {
    homeChangeNotifier.loadMegaBanner(lang);
    homeChangeNotifier.loadSliderImages(lang);
    homeChangeNotifier.loadBestDeals(lang);
    homeChangeNotifier.loadBestDealsBanner(lang);
    homeChangeNotifier.loadNewArrivals(lang);
    homeChangeNotifier.loadNewArrivalsBanner(lang);
    homeChangeNotifier.loadExculisiveBanner(lang);
    homeChangeNotifier.loadOrientalProducts(lang);
    homeChangeNotifier.loadPerfumes(lang);
    categoryChangeNotifier.getCategoriesList(lang);
    categoryChangeNotifier.getFeaturedCategoriesList(lang);
    brandChangeNotifier.getBrandsList(lang, 'home');
    homeChangeNotifier.loadAds(lang);
    if (user?.token != null) {
      homeChangeNotifier.loadRecentlyViewedCustomer(user.token, lang);
    } else {
      List<String> ids = await localStorageRepository.getRecentlyViewedIds();
      homeChangeNotifier.loadRecentlyViewedGuest(ids, lang);
    }
    await Future.delayed(Duration(milliseconds: 1000));
    _refreshController.refreshCompleted();
  }

  @override
  Widget build(BuildContext context) {
    pageStyle = PageStyle(context, designWidth, designHeight);
    pageStyle.initializePageStyles();
    return Scaffold(
      key: scaffoldKey,
      appBar: MarkaaAppBar(pageStyle: pageStyle, scaffoldKey: scaffoldKey),
      drawer: MarkaaSideMenu(pageStyle: pageStyle),
      body: SmartRefresher(
        enablePullDown: true,
        enablePullUp: false,
        header: MaterialClassicHeader(color: primaryColor),
        controller: _refreshController,
        onRefresh: _onRefresh,
        onLoading: () => null,
        child: NotificationListener<OverscrollIndicatorNotification>(
          onNotification: (notification) {
            notification.disallowGlow();
            return true;
          },
          child: SingleChildScrollView(
            child: Column(
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
                HomePerfumes(pageStyle: pageStyle),
                HomeAdvertise(pageStyle: pageStyle),
                SizedBox(height: pageStyle.unitHeight * 10),
                HomeExploreCategories(pageStyle: pageStyle),
                SizedBox(height: pageStyle.unitHeight * 10),
                HomeDiscoverStores(pageStyle: pageStyle),
                SizedBox(height: pageStyle.unitHeight * 10),
                HomeRecent(pageStyle: pageStyle),
              ],
            ),
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
