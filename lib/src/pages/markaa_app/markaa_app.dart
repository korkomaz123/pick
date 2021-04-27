import 'dart:convert';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:markaa/src/change_notifier/global_provider.dart';
import 'package:markaa/src/change_notifier/home_change_notifier.dart';
import 'package:markaa/src/change_notifier/brand_change_notifier.dart';
import 'package:markaa/src/change_notifier/markaa_app_change_notifier.dart';
import 'package:markaa/src/change_notifier/my_cart_change_notifier.dart';
import 'package:markaa/src/change_notifier/place_change_notifier.dart';
import 'package:markaa/src/change_notifier/product_change_notifier.dart';
import 'package:markaa/src/change_notifier/product_review_change_notifier.dart';
import 'package:markaa/src/change_notifier/scroll_chagne_notifier.dart';
import 'package:markaa/src/change_notifier/suggestion_change_notifier.dart';
import 'package:markaa/src/change_notifier/category_change_notifier.dart';
import 'package:markaa/src/change_notifier/wishlist_change_notifier.dart';
import 'package:markaa/src/change_notifier/order_change_notifier.dart';
import 'package:markaa/src/change_notifier/address_change_notifier.dart';
import 'package:markaa/src/config/config.dart';
import 'package:markaa/src/data/mock/mock.dart';
import 'package:markaa/src/data/models/brand_entity.dart';
import 'package:markaa/src/data/models/category_entity.dart';
import 'package:markaa/src/data/models/product_list_arguments.dart';
import 'package:markaa/src/pages/filter/bloc/filter_bloc.dart';
import 'package:markaa/src/pages/my_account/bloc/setting_bloc.dart';
import 'package:markaa/src/pages/my_account/update_profile/bloc/profile_bloc.dart';
import 'package:markaa/src/pages/sign_in/bloc/sign_in_bloc.dart';
import 'package:markaa/src/routes/generator.dart';
import 'package:markaa/src/routes/routes.dart';
import 'package:markaa/src/theme/theme.dart';
import 'package:markaa/src/utils/repositories/brand_repository.dart';
import 'package:markaa/src/utils/repositories/category_repository.dart';
import 'package:markaa/src/utils/repositories/checkout_repository.dart';
import 'package:markaa/src/utils/repositories/filter_repository.dart';
import 'package:markaa/src/utils/repositories/firebase_repository.dart';
import 'package:markaa/src/utils/repositories/home_repository.dart';
import 'package:markaa/src/utils/repositories/local_storage_repository.dart';
import 'package:cupertino_back_gesture/cupertino_back_gesture.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:markaa/src/utils/repositories/my_cart_repository.dart';
import 'package:markaa/src/utils/repositories/order_repository.dart';
import 'package:markaa/src/utils/repositories/product_repository.dart';
import 'package:markaa/src/utils/repositories/profile_repository.dart';
import 'package:markaa/src/utils/repositories/search_repository.dart';
import 'package:markaa/src/utils/repositories/setting_repository.dart';
import 'package:markaa/src/utils/repositories/shipping_address_repository.dart';
import 'package:markaa/src/utils/repositories/sign_in_repository.dart';
import 'package:markaa/src/utils/repositories/wishlist_repository.dart';
import 'package:provider/provider.dart';

import '../../../config.dart';
import 'no_network_access_page.dart';

class MarkaaApp extends StatefulWidget {
  final String home;
  MarkaaApp({Key key, @required this.home}) : super(key: key);

  @override
  _MarkaaAppState createState() => _MarkaaAppState();
}

class _MarkaaAppState extends State<MarkaaApp> {
  final homeRepository = HomeRepository();

  final signInRepository = SignInRepository();

  final categoryRepository = CategoryRepository();

  final productRepository = ProductRepository();

  final brandRepository = BrandRepository();

  final localStorageRepository = LocalStorageRepository();

  final wishlistRepository = WishlistRepository();

  final settingRepository = SettingRepository();

  final shippingAddressRepository = ShippingAddressRepository();

  final orderRepository = OrderRepository();

  final profileRepository = ProfileRepository();

  final filterRepository = FilterRepository();

  final myCartRepository = MyCartRepository();

  final searchRepository = SearchRepository();

  final checkoutRepository = CheckoutRepository();

  final firebaseRepository = FirebaseRepository();

  void _configureMessaging() async {
    FirebaseMessaging.instance.requestPermission(sound: true, badge: true, alert: true, provisional: true);

    FirebaseMessaging.onMessage.listen(_onForegroundMessage);
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage event) => _onLaunchMessage(event.data));
    // FirebaseMessaging.onBackgroundMessage(_onForegroundMessage);
    FirebaseMessaging.instance.getToken().then((String token) async {
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
    String topic = lang == 'en' ? MarkaaNotificationChannels.enChannel : MarkaaNotificationChannels.arChannel;
    await FirebaseMessaging.instance.subscribeToTopic(topic);
  }

  @override
  void initState() {
    _configureMessaging();
    _initializeLocalNotification();

    super.initState();
  }

  void _initializeLocalNotification() async {
    var initializationSettingsAndroid = AndroidInitializationSettings('launcher_icon');
    var initializationSettingsIOS = IOSInitializationSettings(
      onDidReceiveLocalNotification: onDidReceiveLocalNotification,
    );
    var initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );
    flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onSelectNotification: onSelectNotification,
    );
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
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
      context: Config.navigatorKey.currentContext,
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

  AndroidNotificationChannel channel = AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    'This channel is used for important notifications.', // description
    importance: Importance.max,
  );

  final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  Future<void> _onForegroundMessage(RemoteMessage message) async {
    await flutterLocalNotificationsPlugin.show(
      message.hashCode,
      Platform.isAndroid ? message.data['notification']['title'] : message.data['title'],
      Platform.isAndroid ? message.data['notification']['body'] : message.data['body'],
      NotificationDetails(
        android: AndroidNotificationDetails(
          channel.id,
          channel.name,
          channel.description,
        ),
        iOS: IOSNotificationDetails(),
      ),
      payload: jsonEncode(message),
    );
  }

  Future<dynamic> _onLaunchMessage(Map<String, dynamic> message) async {
    try {
      Map<dynamic, dynamic> data = Platform.isAndroid ? message['data'] : message;
      int target = int.parse(data['target']);
      if (target != 0) {
        String id = data['id'];
        if (target == 1) {
          final product = await productRepository.getProduct(id);
          Navigator.pushNamed(Config.navigatorKey.currentContext, Routes.product, arguments: product);
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
              Config.navigatorKey.currentContext,
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
              Config.navigatorKey.currentContext,
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

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
      value: localStorageRepository,
      child: RepositoryProvider.value(
        value: homeRepository,
        child: RepositoryProvider.value(
          value: signInRepository,
          child: RepositoryProvider.value(
            value: categoryRepository,
            child: RepositoryProvider.value(
              value: productRepository,
              child: RepositoryProvider.value(
                value: brandRepository,
                child: RepositoryProvider.value(
                  value: wishlistRepository,
                  child: RepositoryProvider.value(
                    value: settingRepository,
                    child: RepositoryProvider.value(
                      value: shippingAddressRepository,
                      child: RepositoryProvider.value(
                        value: orderRepository,
                        child: RepositoryProvider.value(
                          value: profileRepository,
                          child: RepositoryProvider.value(
                            value: filterRepository,
                            child: RepositoryProvider.value(
                              value: myCartRepository,
                              child: RepositoryProvider.value(
                                value: checkoutRepository,
                                child: RepositoryProvider.value(
                                  value: searchRepository,
                                  child: _buildMultiProvider(),
                                ),
                              ),
                            ),
                          ),
                        ),
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

  Widget _buildMultiProvider() {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => GlobalProvider()),
        ChangeNotifierProvider(
          create: (context) => MarkaaAppChangeNotifier(),
        ),
        ChangeNotifierProvider(
          create: (context) => PlaceChangeNotifier(),
        ),
        ChangeNotifierProvider(
          create: (context) => ScrollChangeNotifier(),
        ),
        ChangeNotifierProvider(
          create: (context) => SuggestionChangeNotifier(),
        ),
        ChangeNotifierProvider(
          create: (context) => ProductChangeNotifier(
            productRepository: productRepository,
            localStorageRepository: localStorageRepository,
          ),
        ),
        ChangeNotifierProvider(
          create: (context) => CategoryChangeNotifier(
            categoryRepository: categoryRepository,
            brandRepository: brandRepository,
            localStorageRepository: localStorageRepository,
          ),
        ),
        ChangeNotifierProvider(
          create: (context) => BrandChangeNotifier(
            brandRepository: brandRepository,
            localStorageRepository: localStorageRepository,
          ),
        ),
        ChangeNotifierProvider(
          create: (context) => MyCartChangeNotifier(),
        ),
        ChangeNotifierProvider(
          create: (context) => WishlistChangeNotifier(
            wishlistRepository: wishlistRepository,
          ),
        ),
        ChangeNotifierProvider(
          create: (context) => ProductReviewChangeNotifier(
            productRepository: productRepository,
          ),
        ),
        ChangeNotifierProvider(
          create: (context) => HomeChangeNotifier(
            productRepository: productRepository,
            localStorageRepository: localStorageRepository,
          ),
        ),
        ChangeNotifierProvider(
          create: (context) => OrderChangeNotifier(
            orderRepository: orderRepository,
            firebaseRepository: firebaseRepository,
          ),
        ),
        ChangeNotifierProvider(
          create: (context) => AddressChangeNotifier(
            addressRepository: shippingAddressRepository,
          ),
        ),
      ],
      child: _buildMultiBlocProvider(),
    );
  }

  Widget _buildMultiBlocProvider() {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => SignInBloc(
            signInRepository: signInRepository,
          ),
        ),
        BlocProvider(
          create: (context) => SettingBloc(
            settingRepository: settingRepository,
          ),
        ),
        BlocProvider(
          create: (context) => ProfileBloc(
            profileRepository: profileRepository,
          ),
        ),
        BlocProvider(
          create: (context) => FilterBloc(
            filterRepository: filterRepository,
            localStorageRepository: localStorageRepository,
          ),
        ),
      ],
      child: MarkaaAppView(home: widget.home),
    );
  }
}

class MarkaaAppView extends StatelessWidget {
  final String home;
  MarkaaAppView({@required this.home});
  @override
  Widget build(BuildContext context) {
    return BackGestureWidthTheme(
      backGestureWidth: BackGestureWidth.fraction(1 / 2),
      child: MaterialApp(
        navigatorKey: Config.navigatorKey,
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          EasyLocalization.of(context).delegate,
          const FallbackCupertinoLocalisationsDelegate(),
        ],
        supportedLocales: EasyLocalization.of(context).supportedLocales,
        locale: EasyLocalization.of(context).locale,
        debugShowCheckedModeBanner: false,
        theme: markaaAppTheme,
        title: 'Markaa',
        initialRoute: home,
        onGenerateRoute: RouteGenerator.generateRoute,
        builder: (context, child) {
          return StreamBuilder<DataConnectionStatus>(
            stream: DataConnectionChecker().onStatusChange,
            builder: (context, networkSnapshot) {
              if (networkSnapshot.data == DataConnectionStatus.connected || !networkSnapshot.hasData) {
                return child;
              } else {
                return NoNetworkAccessPage();
              }
            },
          );
        },
      ),
    );
  }
}

class FallbackCupertinoLocalisationsDelegate extends LocalizationsDelegate<CupertinoLocalizations> {
  const FallbackCupertinoLocalisationsDelegate();

  @override
  bool isSupported(Locale locale) => true;

  @override
  Future<CupertinoLocalizations> load(Locale locale) => DefaultCupertinoLocalizations.load(locale);

  @override
  bool shouldReload(FallbackCupertinoLocalisationsDelegate old) => false;
}
