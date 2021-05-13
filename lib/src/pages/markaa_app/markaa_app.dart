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
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:markaa/src/utils/repositories/order_repository.dart';
import 'package:markaa/src/utils/repositories/product_repository.dart';
import 'package:markaa/src/utils/repositories/profile_repository.dart';
import 'package:markaa/src/utils/repositories/search_repository.dart';
import 'package:markaa/src/utils/repositories/shipping_address_repository.dart';
import 'package:markaa/src/utils/repositories/wishlist_repository.dart';
import 'package:provider/provider.dart';

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

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _buildMultiProvider();
  }

  Widget _buildMultiProvider() {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => GlobalProvider()),
        ChangeNotifierProvider(create: (context) => MarkaaAppChangeNotifier()),
        ChangeNotifierProvider(create: (context) => PlaceChangeNotifier()),
        ChangeNotifierProvider(create: (context) => ScrollChangeNotifier()),
        ChangeNotifierProvider(create: (context) => SuggestionChangeNotifier()),
        ChangeNotifierProvider(create: (context) => ProductChangeNotifier()),
        ChangeNotifierProvider(create: (context) => CategoryChangeNotifier()),
        ChangeNotifierProvider(create: (context) => MyCartChangeNotifier()),
        ChangeNotifierProvider(create: (context) => WishlistChangeNotifier()),
        ChangeNotifierProvider(
            create: (context) => ProductReviewChangeNotifier()),
        ChangeNotifierProvider(create: (context) => HomeChangeNotifier()),
        ChangeNotifierProvider(create: (context) => OrderChangeNotifier()),
        ChangeNotifierProvider(create: (context) => AddressChangeNotifier()),
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
            return StreamBuilder<DataConnectionStatus>(
              stream: DataConnectionChecker().onStatusChange,
              builder: (context, networkSnapshot) {
                if (networkSnapshot.data == DataConnectionStatus.connected ||
                    !networkSnapshot.hasData) {
                  return child;
                } else {
                  return NoNetworkAccessPage();
                }
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
