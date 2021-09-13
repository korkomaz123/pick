import 'dart:async';

import 'package:connectivity/connectivity.dart';
import 'package:markaa/src/change_notifier/global_provider.dart';
import 'package:markaa/src/change_notifier/home_change_notifier.dart';
import 'package:markaa/src/change_notifier/markaa_app_change_notifier.dart';
import 'package:markaa/src/change_notifier/my_cart_change_notifier.dart';
import 'package:markaa/src/change_notifier/place_change_notifier.dart';
import 'package:markaa/src/change_notifier/product_change_notifier.dart';
import 'package:markaa/src/change_notifier/product_review_change_notifier.dart';
import 'package:markaa/src/change_notifier/scroll_chagne_notifier.dart';
import 'package:markaa/src/change_notifier/suggestion_change_notifier.dart';
import 'package:markaa/src/change_notifier/category_change_notifier.dart';
import 'package:markaa/src/change_notifier/summer_collection_notifier.dart';
import 'package:markaa/src/change_notifier/wallet_change_notifier.dart';
import 'package:markaa/src/change_notifier/wishlist_change_notifier.dart';
import 'package:markaa/src/change_notifier/order_change_notifier.dart';
import 'package:markaa/src/change_notifier/address_change_notifier.dart';
import 'package:markaa/src/config/config.dart';
import 'package:markaa/src/pages/filter/bloc/filter_bloc.dart';
import 'package:markaa/src/pages/my_account/bloc/setting_bloc.dart';
import 'package:markaa/src/pages/my_account/update_profile/bloc/profile_bloc.dart';
import 'package:markaa/src/pages/sign_in/bloc/sign_in_bloc.dart';
import 'package:markaa/src/routes/generator.dart';
import 'package:markaa/src/theme/theme.dart';
import 'package:markaa/src/utils/repositories/brand_repository.dart';
import 'package:markaa/src/utils/repositories/category_repository.dart';
import 'package:markaa/src/utils/repositories/checkout_repository.dart';
import 'package:markaa/src/utils/repositories/firebase_repository.dart';
import 'package:markaa/src/utils/repositories/local_storage_repository.dart';
import 'package:cupertino_back_gesture/cupertino_back_gesture.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:markaa/src/utils/repositories/order_repository.dart';
import 'package:markaa/src/utils/repositories/product_repository.dart';
import 'package:markaa/src/utils/repositories/profile_repository.dart';
import 'package:markaa/src/utils/repositories/search_repository.dart';
import 'package:markaa/src/utils/repositories/shipping_address_repository.dart';
import 'package:markaa/src/utils/repositories/wishlist_repository.dart';

import '../../../preload.dart';
import 'no_network_access_page.dart';

class MarkaaApp extends StatefulWidget {
  final String home;
  MarkaaApp({Key key, @required this.home}) : super(key: key);

  @override
  _MarkaaAppState createState() => _MarkaaAppState();
}

class _MarkaaAppState extends State<MarkaaApp> {
  final categoryRepository = CategoryRepository();

  final productRepository = ProductRepository();

  final brandRepository = BrandRepository();

  final localStorageRepository = LocalStorageRepository();

  final wishlistRepository = WishlistRepository();

  final shippingAddressRepository = ShippingAddressRepository();

  final orderRepository = OrderRepository();

  final profileRepository = ProfileRepository();

  final searchRepository = SearchRepository();

  final checkoutRepository = CheckoutRepository();

  final firebaseRepository = FirebaseRepository();

  _loadData() async {
    Timer(Duration(seconds: 1), () async {
      bool isExist = await LocalStorageRepository().existItem('usage');
      String token = await Preload.localRepo.getToken();
      if (isExist) {
        await Preload.appOpen();
      }
      print("token ====> $token");
    });
  }

  @override
  void initState() {
    _loadData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => GlobalProvider()),
        ChangeNotifierProvider(create: (_) => MarkaaAppChangeNotifier()),
        ChangeNotifierProvider(create: (_) => PlaceChangeNotifier()),
        ChangeNotifierProvider(create: (_) => ScrollChangeNotifier()),
        ChangeNotifierProvider(create: (_) => SuggestionChangeNotifier()),
        ChangeNotifierProvider(create: (_) => ProductChangeNotifier()),
        ChangeNotifierProvider(create: (_) => CategoryChangeNotifier()),
        ChangeNotifierProvider(create: (_) => MyCartChangeNotifier()),
        ChangeNotifierProvider(create: (_) => WishlistChangeNotifier()),
        ChangeNotifierProvider(create: (_) => ProductReviewChangeNotifier()),
        ChangeNotifierProvider(create: (_) => HomeChangeNotifier()),
        ChangeNotifierProvider(create: (_) => OrderChangeNotifier()),
        ChangeNotifierProvider(create: (_) => AddressChangeNotifier()),
        ChangeNotifierProvider(create: (_) => SummerCollectionNotifier()),
        ChangeNotifierProvider(create: (_) => WalletChangeNotifier()),
      ],
      child: _buildMultiBlocProvider(context),
    );
  }

  Widget _buildMultiBlocProvider(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => SignInBloc(),
        ),
        BlocProvider(
          create: (context) => SettingBloc(),
        ),
        BlocProvider(
          create: (context) => ProfileBloc(
            profileRepository: profileRepository,
          ),
        ),
        BlocProvider(
          create: (context) => FilterBloc(),
        ),
      ],
      child: _buildAppView(context),
    );
  }

  Widget _buildAppView(BuildContext context) {
    return BackGestureWidthTheme(
      backGestureWidth: BackGestureWidth.fraction(1 / 2),
      child: ScreenUtilInit(
        designSize: Size(designWidth, designHeight),
        builder: () => MaterialApp(
          navigatorKey: Preload.navigatorKey,
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
          initialRoute: widget.home,
          onGenerateRoute: RouteGenerator.generateRoute,
          builder: (context, child) {
            return StreamBuilder<ConnectivityResult>(
              stream: Connectivity().onConnectivityChanged,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data == ConnectivityResult.mobile ||
                      snapshot.data == ConnectivityResult.wifi) {
                    return FutureBuilder<void>(
                      future: Preload.checkAppVersion(),
                      builder: (context, snapshot) {
                        return child;
                      },
                    );
                  } else {
                    return NoNetworkAccessPage();
                  }
                }
                return child;
              },
            );
          },
        ),
      ),
    );
  }
}

class FallbackCupertinoLocalisationsDelegate
    extends LocalizationsDelegate<CupertinoLocalizations> {
  const FallbackCupertinoLocalisationsDelegate();

  @override
  bool isSupported(Locale locale) => true;

  @override
  Future<CupertinoLocalizations> load(Locale locale) =>
      DefaultCupertinoLocalizations.load(locale);

  @override
  bool shouldReload(FallbackCupertinoLocalisationsDelegate old) => false;
}
