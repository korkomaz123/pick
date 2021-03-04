import 'dart:async';
import 'dart:io' show Platform;

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:markaa/src/change_notifier/brand_change_notifier.dart';
import 'package:markaa/src/change_notifier/category_change_notifier.dart';
import 'package:markaa/src/change_notifier/product_change_notifier.dart';
import 'package:markaa/src/components/markaa_app_bar.dart';
import 'package:markaa/src/components/markaa_bottom_bar.dart';
import 'package:markaa/src/components/markaa_side_menu.dart';
import 'package:markaa/src/config/config.dart';
import 'package:markaa/src/data/mock/mock.dart';
import 'package:markaa/src/data/models/enum.dart';
import 'package:markaa/src/pages/home/widgets/home_explore_categories.dart';
import 'package:markaa/src/pages/my_account/bloc/setting_repository.dart';
import 'package:markaa/src/theme/theme.dart';
import 'package:markaa/src/utils/dynamic_link_service.dart';
import 'package:markaa/src/utils/local_storage_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isco_custom_widgets/isco_custom_widgets.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'bloc/home_bloc.dart';
import 'widgets/home_advertise.dart';
import 'widgets/home_best_deals.dart';
import 'widgets/home_best_deals_banner.dart';
import 'widgets/home_new_arrivals_banner.dart';
import 'widgets/home_discover_stores.dart';
import 'widgets/home_header_carousel.dart';
import 'widgets/home_new_arrivals.dart';
import 'widgets/home_perfumes.dart';
import 'widgets/home_recent.dart';

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
  HomeBloc homeBloc;
  BrandChangeNotifier brandChangeNotifier;
  CategoryChangeNotifier categoryChangeNotifier;
  PageStyle pageStyle;
  LocalStorageRepository localStorageRepository;
  SettingRepository settingRepository;
  DynamicLinkService dynamicLinkService = DynamicLinkService();
  Timer timerLink;
  FirebaseMessaging firebaseMessaging = FirebaseMessaging();
  ProductChangeNotifier productChangeNotifier;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    homeBloc = context.read<HomeBloc>();
    brandChangeNotifier = context.read<BrandChangeNotifier>();
    categoryChangeNotifier = context.read<CategoryChangeNotifier>();
    productChangeNotifier = context.read<ProductChangeNotifier>();
    localStorageRepository = context.read<LocalStorageRepository>();
    settingRepository = context.read<SettingRepository>();
    productChangeNotifier.initialize();
    _initializeLocalNotification();
    _configureMessaging();
    _subscribeToTopic();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      dynamicLinkService.initialDynamicLink(context);
    });
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
            child: Text('Ok'),
            onPressed: () async {},
          )
        ],
      ),
    );
  }

  void _configureMessaging() {
    firebaseMessaging.configure(
      onMessage: _onForegroundMessage,
      onResume: (Map<String, dynamic> message) async {
        print('on resume');
      },
      onLaunch: (Map<String, dynamic> message) async {
        print('on launch');
      },
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
        );
      }
    });
  }

  static Future<void> _onBackgroundMessageHandler(
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
    );
  }

  Future<dynamic> _onForegroundMessage(Map<String, dynamic> message) async {
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
    );
  }

  void _subscribeToTopic() {
    if (isNotification == null) {
      firebaseMessaging.subscribeToTopic('guest').then((_) {
        print('subscribed to guest channel');
      });
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      timerLink = new Timer(
        const Duration(milliseconds: 1000),
        () {
          dynamicLinkService.retrieveDynamicLink(context);
        },
      );
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
    homeBloc.add(HomeSliderImagesLoaded(lang: lang));
    homeBloc.add(HomeBestDealsLoaded(lang: lang));
    homeBloc.add(HomeNewArrivalsLoaded(lang: lang));
    homeBloc.add(HomeBestDealsLoaded(lang: lang));
    homeBloc.add(HomeNewArrivalsLoaded(lang: lang));
    homeBloc.add(HomePerfumesLoaded(lang: lang));
    categoryChangeNotifier.getCategoriesList(lang);
    brandChangeNotifier.getBrandsList(lang, 'home');
    homeBloc.add(HomeAdsLoaded(lang: lang));
    if (user?.token != null) {
      homeBloc.add(HomeRecentlyViewedCustomerLoaded(
        token: user.token,
        lang: lang,
      ));
    } else {
      _loadGuestViewed();
    }
    await Future.delayed(Duration(milliseconds: 1000));
    _refreshController.refreshCompleted();
  }

  void _loadGuestViewed() async {
    List<String> ids = await localStorageRepository.getRecentlyViewedIds();
    homeBloc.add(HomeRecentlyViewedGuestLoaded(ids: ids, lang: lang));
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
                HomeBestDeals(pageStyle: pageStyle),
                HomeBestDealsBanner(pageStyle: pageStyle),
                HomeNewArrivals(pageStyle: pageStyle),
                HomeNewArrivalsBanner(pageStyle: pageStyle),
                HomePerfumes(pageStyle: pageStyle),
                HomeExploreCategories(pageStyle: pageStyle),
                SizedBox(height: pageStyle.unitHeight * 10),
                HomeDiscoverStores(pageStyle: pageStyle),
                SizedBox(height: pageStyle.unitHeight * 10),
                HomeAdvertise(pageStyle: pageStyle),
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
