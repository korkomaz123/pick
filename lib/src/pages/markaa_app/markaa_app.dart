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
import 'package:markaa/src/data/mock/mock.dart';
import 'package:markaa/src/pages/brand_list/bloc/brand_repository.dart';
import 'package:markaa/src/pages/category_list/bloc/category_repository.dart';
import 'package:markaa/src/pages/checkout/bloc/checkout_bloc.dart';
import 'package:markaa/src/pages/checkout/bloc/checkout_repository.dart';
import 'package:markaa/src/pages/filter/bloc/filter_bloc.dart';
import 'package:markaa/src/pages/filter/bloc/filter_repository.dart';
import 'package:markaa/src/pages/home/bloc/home_repository.dart';
import 'package:markaa/src/pages/my_account/bloc/setting_bloc.dart';
import 'package:markaa/src/pages/my_account/bloc/setting_repository.dart';
import 'package:markaa/src/pages/my_account/order_history/bloc/order_repository.dart';
import 'package:markaa/src/pages/my_account/shipping_address/bloc/shipping_address_bloc.dart';
import 'package:markaa/src/pages/my_account/shipping_address/bloc/shipping_address_repository.dart';
import 'package:markaa/src/pages/my_account/update_profile/bloc/profile_bloc.dart';
import 'package:markaa/src/pages/my_account/update_profile/bloc/profile_repository.dart';
import 'package:markaa/src/pages/my_cart/bloc/my_cart_repository.dart';
import 'package:markaa/src/pages/product/bloc/product_repository.dart';
import 'package:markaa/src/pages/search/bloc/search_repository.dart';
import 'package:markaa/src/pages/sign_in/bloc/sign_in_bloc.dart';
import 'package:markaa/src/pages/sign_in/bloc/sign_in_repository.dart';
import 'package:markaa/src/pages/wishlist/bloc/wishlist_repository.dart';
import 'package:markaa/src/routes/generator.dart';
import 'package:markaa/src/theme/theme.dart';
import 'package:markaa/src/utils/local_storage_repository.dart';
import 'package:cupertino_back_gesture/cupertino_back_gesture.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

class MarkaaApp extends StatelessWidget {
  MarkaaApp({Key key}) : super(key: key);

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

  @override
  Widget build(BuildContext context) {
    lang = EasyLocalization.of(context).locale.languageCode;
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
          create: (context) => MyCartChangeNotifier(
            myCartRepository: myCartRepository,
            localStorageRepository: localStorageRepository,
          ),
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
            homeRepository: homeRepository,
            productRepository: productRepository,
            localStorageRepository: localStorageRepository,
          ),
        ),
        ChangeNotifierProvider(
          create: (context) => OrderChangeNotifier(
            orderRepository: orderRepository,
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
          create: (context) => ShippingAddressBloc(
            shippingAddressRepository: shippingAddressRepository,
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
        BlocProvider(
          create: (context) => CheckoutBloc(
            checkoutRepository: checkoutRepository,
          ),
        ),
      ],
      child: MarkaaAppView(),
    );
  }
}

class MarkaaAppView extends StatelessWidget {
  final _navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return BackGestureWidthTheme(
      backGestureWidth: BackGestureWidth.fraction(1 / 2),
      child: MaterialApp(
        navigatorKey: _navigatorKey,
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
        initialRoute: '/',
        onGenerateRoute: (settings) {
          return RouteGenerator.generateRoute(settings);
        },
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
