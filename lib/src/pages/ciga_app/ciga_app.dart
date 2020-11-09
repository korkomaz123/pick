import 'package:ciga/src/data/mock/mock.dart';
import 'package:ciga/src/data/models/address_entity.dart';
import 'package:ciga/src/data/models/cart_item_entity.dart';
import 'package:ciga/src/data/models/product_model.dart';
import 'package:ciga/src/data/models/user_entity.dart';
import 'package:ciga/src/pages/brand_list/bloc/brand_bloc.dart';
import 'package:ciga/src/pages/brand_list/bloc/brand_repository.dart';
import 'package:ciga/src/pages/category_list/bloc/category_bloc.dart';
import 'package:ciga/src/pages/category_list/bloc/category_repository.dart';
import 'package:ciga/src/pages/checkout/bloc/checkout_bloc.dart';
import 'package:ciga/src/pages/checkout/bloc/checkout_repository.dart';
import 'package:ciga/src/pages/filter/bloc/filter_bloc.dart';
import 'package:ciga/src/pages/filter/bloc/filter_repository.dart';
import 'package:ciga/src/pages/home/bloc/home_bloc.dart';
import 'package:ciga/src/pages/home/bloc/home_repository.dart';
import 'package:ciga/src/pages/my_account/bloc/setting_bloc.dart';
import 'package:ciga/src/pages/my_account/bloc/setting_repository.dart';
import 'package:ciga/src/pages/my_account/order_history/bloc/order_bloc.dart';
import 'package:ciga/src/pages/my_account/order_history/bloc/order_repository.dart';
import 'package:ciga/src/pages/my_account/shipping_address/bloc/shipping_address_bloc.dart';
import 'package:ciga/src/pages/my_account/shipping_address/bloc/shipping_address_repository.dart';
import 'package:ciga/src/pages/my_account/update_profile/bloc/profile_bloc.dart';
import 'package:ciga/src/pages/my_account/update_profile/bloc/profile_repository.dart';
import 'package:ciga/src/pages/my_cart/bloc/my_cart_bloc.dart';
import 'package:ciga/src/pages/my_cart/bloc/my_cart_repository.dart';
import 'package:ciga/src/pages/product/bloc/product_bloc.dart';
import 'package:ciga/src/pages/product/bloc/product_repository.dart';
import 'package:ciga/src/pages/product_list/bloc/product_list_bloc.dart';
import 'package:ciga/src/pages/search/bloc/search_bloc.dart';
import 'package:ciga/src/pages/search/bloc/search_repository.dart';
import 'package:ciga/src/pages/sign_in/bloc/sign_in_bloc.dart';
import 'package:ciga/src/pages/sign_in/bloc/sign_in_repository.dart';
import 'package:ciga/src/pages/wishlist/bloc/wishlist_bloc.dart';
import 'package:ciga/src/pages/wishlist/bloc/wishlist_repository.dart';
import 'package:ciga/src/utils/local_storage_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:ciga/src/change_notifier/place_change_notifier.dart';
import 'package:ciga/src/routes/generator.dart';
import 'package:ciga/src/theme/theme.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cupertino_back_gesture/cupertino_back_gesture.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'bloc/ciga_app_bloc.dart';

class CigaApp extends StatelessWidget {
  CigaApp({Key key}) : super(key: key);

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
                                  child: ChangeNotifierProvider(
                                    create: (context) => PlaceChangeNotifier(),
                                    child: _buildMultiBlocProvider(),
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
      ),
    );
  }

  Widget _buildMultiBlocProvider() {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => HomeBloc(
            homeRepository: homeRepository,
            categoryRepository: categoryRepository,
            productRepository: productRepository,
            brandRepository: brandRepository,
          ),
        ),
        BlocProvider(
          create: (context) => SignInBloc(
            signInRepository: signInRepository,
          ),
        ),
        BlocProvider(
          create: (context) => CategoryBloc(
            categoryRepository: categoryRepository,
            brandRepository: brandRepository,
          ),
        ),
        BlocProvider(
          create: (context) => ProductBloc(
            productRepository: productRepository,
          ),
        ),
        BlocProvider(
          create: (context) => BrandBloc(
            brandRepository: brandRepository,
          ),
        ),
        BlocProvider(
          create: (context) => ProductListBloc(
            productRepository: productRepository,
          ),
        ),
        BlocProvider(
          create: (context) => WishlistBloc(
            wishlistRepository: wishlistRepository,
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
          create: (context) => OrderBloc(
            orderRepository: orderRepository,
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
          ),
        ),
        BlocProvider(
          create: (context) => MyCartBloc(
            myCartRepository: myCartRepository,
          ),
        ),
        BlocProvider(
          create: (context) => SearchBloc(
            searchRepository: searchRepository,
          ),
        ),
        BlocProvider(
          create: (context) => CigaAppBloc(),
        ),
        BlocProvider(
          create: (context) => CheckoutBloc(
            checkoutRepository: checkoutRepository,
          ),
        ),
      ],
      child: CigaAppView(),
    );
  }
}

class CigaAppView extends StatefulWidget {
  @override
  _CigaAppViewState createState() => _CigaAppViewState();
}

class _CigaAppViewState extends State<CigaAppView> {
  final _navigatorKey = GlobalKey<NavigatorState>();
  CigaAppBloc cigaAppBloc;

  @override
  void initState() {
    super.initState();
    _getCurrentUser();
    _getCartItems();
    _getShippingAddress();
    _getShippingMethod();
    _getPaymentMethod();
    cigaAppBloc = context.bloc<CigaAppBloc>();
  }

  void _getCurrentUser() async {
    String token =
        await context.repository<LocalStorageRepository>().getToken();
    if (token.isNotEmpty) {
      final signInRepo = context.repository<SignInRepository>();
      final result = await signInRepo.getCurrentUser(token);
      if (result['code'] == 'SUCCESS') {
        result['data']['customer']['token'] = token;
        result['data']['customer']['profileUrl'] = result['data']['profileUrl'];
        user = UserEntity.fromJson(result['data']['customer']);
      }
    }
  }

  void _getCartItems() async {
    String cartId =
        await context.repository<LocalStorageRepository>().getCartId();
    if (cartId.isNotEmpty) {
      final result =
          await context.repository<MyCartRepository>().getCartItems(cartId);

      if (result['code'] == 'SUCCESS') {
        List<dynamic> cartList = result['cart'];
        int count = 0;
        for (int i = 0; i < cartList.length; i++) {
          Map<String, dynamic> cartItemJson = {};
          cartItemJson['product'] =
              ProductModel.fromJson(cartList[i]['product']);
          cartItemJson['qty'] = cartList[i]['qty'];
          CartItemEntity cart = CartItemEntity.fromJson(cartItemJson);
          myCartItems.add(cart);
          count += cart.itemCount;
        }
        cartItemCount = count;
        cigaAppBloc.add(CartItemCountSet(cartItemCount: count));
      }
    }
  }

  void _getShippingAddress() async {
    String token =
        await context.repository<LocalStorageRepository>().getToken();
    if (token.isNotEmpty) {
      final result = await context
          .repository<ShippingAddressRepository>()
          .getShippingAddresses(token);
      if (result['code'] == 'SUCCESS') {
        List<dynamic> shippingAddressesList = result['addresses'];
        for (int i = 0; i < shippingAddressesList.length; i++) {
          addresses.add(AddressEntity.fromJson(shippingAddressesList[i]));
        }
      }
    }
  }

  void _getShippingMethod() async {
    shippingMethods =
        await context.repository<CheckoutRepository>().getShippingMethod();
  }

  void _getPaymentMethod() async {
    paymentMethods =
        await context.repository<CheckoutRepository>().getPaymentMethod();
  }

  @override
  Widget build(BuildContext context) {
    lang = EasyLocalization.of(context).locale.languageCode;
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
        theme: cigaAppTheme,
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
