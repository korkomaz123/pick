import 'package:markaa/src/components/ciga_text_button.dart';
import 'package:markaa/src/config/config.dart';
import 'package:markaa/src/data/mock/mock.dart';
import 'package:markaa/src/data/models/address_entity.dart';
import 'package:markaa/src/data/models/cart_item_entity.dart';
import 'package:markaa/src/data/models/product_model.dart';
import 'package:markaa/src/data/models/user_entity.dart';
import 'package:markaa/src/pages/category_list/bloc/category_repository.dart';
import 'package:markaa/src/pages/checkout/bloc/checkout_repository.dart';
import 'package:markaa/src/pages/ciga_app/bloc/cart_item_count/cart_item_count_bloc.dart';
import 'package:markaa/src/pages/ciga_app/bloc/wishlist_item_count/wishlist_item_count_bloc.dart';
import 'package:markaa/src/pages/my_account/shipping_address/bloc/shipping_address_repository.dart';
import 'package:markaa/src/pages/my_cart/bloc/my_cart_repository.dart';
import 'package:markaa/src/pages/sign_in/bloc/sign_in_repository.dart';
import 'package:markaa/src/pages/wishlist/bloc/wishlist_repository.dart';
import 'package:markaa/src/routes/routes.dart';
import 'package:markaa/src/theme/icons.dart';
import 'package:markaa/src/theme/theme.dart';
import 'package:markaa/src/utils/local_storage_repository.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:isco_custom_widgets/styles/page_style.dart';

class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  CartItemCountBloc cartItemCountBloc;
  WishlistItemCountBloc wishlistItemCountBloc;
  LocalStorageRepository localRepo;
  MyCartRepository cartRepo;
  WishlistRepository wishlistRepo;
  CategoryRepository categoryRepo;
  PageStyle pageStyle;
  bool isFirstTime;

  @override
  void initState() {
    super.initState();
    cartRepo = context.read<MyCartRepository>();
    wishlistRepo = context.read<WishlistRepository>();
    localRepo = context.read<LocalStorageRepository>();
    categoryRepo = context.read<CategoryRepository>();
    cartItemCountBloc = context.read<CartItemCountBloc>();
    wishlistItemCountBloc = context.read<WishlistItemCountBloc>();
    _checkAppUsage();
  }

  void _checkAppUsage() async {
    bool isExist = await localRepo.existItem('usage');
    if (isExist) {
      isFirstTime = false;
      _loadAssets();
    } else {
      isFirstTime = true;
      setState(() {});
    }
  }

  void _loadAssets() async {
    await _getCurrentUser();
    _getHomeCategories();
    _getCartItems();
    _getWishlists();
    _getShippingAddress();
    _getShippingMethod();
    _getPaymentMethod();
    _getSideMenu();
    _getRegions();
    _navigator();
  }

  Future<void> _getHomeCategories() async {
    homeCategories = await categoryRepo.getHomeCategories(lang);
  }

  Future<void> _getCurrentUser() async {
    String token = await localRepo.getToken();

    if (token.isNotEmpty) {
      final signInRepo = context.read<SignInRepository>();
      final result = await signInRepo.getCurrentUser(token);
      if (result['code'] == 'SUCCESS') {
        result['data']['customer']['token'] = token;
        result['data']['customer']['profileUrl'] = result['data']['profileUrl'];
        user = UserEntity.fromJson(result['data']['customer']);
      }
    }
  }

  void _getCartItems() async {
    String cartId = '';
    if (user?.token != null) {
      final result = await cartRepo.getCartId(user.token);
      if (result['code'] == 'SUCCESS') {
        cartId = result['cartId'];
      }
    } else {
      cartId = await localRepo.getCartId();
    }
    if (cartId.isNotEmpty) {
      final result = await cartRepo.getCartItems(cartId, lang);
      if (result['code'] == 'SUCCESS') {
        List<dynamic> cartList = result['cart'];
        int count = 0;
        for (int i = 0; i < cartList.length; i++) {
          Map<String, dynamic> cartItemJson = {};
          cartItemJson['product'] = ProductModel.fromJson(cartList[i]['product']);
          cartItemJson['itemCount'] = cartList[i]['itemCount'];
          cartItemJson['itemId'] = cartList[i]['itemid'];
          cartItemJson['rowPrice'] = cartList[i]['row_price'];
          cartItemJson['availableCount'] = cartList[i]['availableCount'];
          CartItemEntity cart = CartItemEntity.fromJson(cartItemJson);
          myCartItems.add(cart);
          count += cart.itemCount;
          cartTotalPrice += cart.itemCount * double.parse(cart.product.price).ceil();
        }
        cartItemCount = count;
        cartItemCountBloc.add(CartItemCountSet(cartItemCount: count));
      }
    }
  }

  void _getWishlists() async {
    if (user?.token != null) {
      final result = await wishlistRepo.getWishlists(user.token, lang);
      if (result['code'] == 'SUCCESS') {
        List<dynamic> lists = result['wishlists'];
        wishlistCount = lists.isEmpty ? 0 : lists.length;
        wishlistItemCountBloc.add(WishlistItemCountSet(
          wishlistItemCount: wishlistCount,
        ));
      }
    }
  }

  void _getShippingAddress() async {
    String token = await localRepo.getToken();
    if (token.isNotEmpty) {
      final result = await context.read<ShippingAddressRepository>().getShippingAddresses(token);
      if (result['code'] == 'SUCCESS') {
        List<dynamic> shippingAddressesList = result['addresses'];
        for (int i = 0; i < shippingAddressesList.length; i++) {
          final address = AddressEntity.fromJson(shippingAddressesList[i]);
          addresses.add(address);
          if (address.defaultShippingAddress == 1) {
            defaultAddress = address;
          }
        }
      }
    }
  }

  void _getShippingMethod() async {
    shippingMethods = await context.read<CheckoutRepository>().getShippingMethod(lang);
  }

  void _getPaymentMethod() async {
    paymentMethods = await context.read<CheckoutRepository>().getPaymentMethod(lang);
  }

  void _getSideMenu() async {
    print(lang);
    sideMenus = await context.read<CategoryRepository>().getMenuCategories(lang);
  }

  void _getRegions() async {
    regions = await context.read<ShippingAddressRepository>().getRegions(lang);
  }

  void _navigator() {
    Navigator.pushNamedAndRemoveUntil(context, Routes.home, (route) => false);
  }

  void _onEnglish() async {
    EasyLocalization.of(context).locale = EasyLocalization.of(context).supportedLocales.first;
    lang = 'en';
    isFirstTime = false;
    await localRepo.setItem('usage', 'markaa');
    setState(() {});
    _loadAssets();
  }

  void _onArabic() async {
    EasyLocalization.of(context).locale = EasyLocalization.of(context).supportedLocales.last;
    lang = 'ar';
    isFirstTime = false;
    await localRepo.setItem('usage', 'markaa');
    setState(() {});
    _loadAssets();
  }

  @override
  Widget build(BuildContext context) {
    pageStyle = PageStyle(context, designWidth, designHeight);
    pageStyle.initializePageStyles();
    return Scaffold(
      backgroundColor: primarySwatchColor,
      body: Container(
        width: pageStyle.deviceWidth,
        height: pageStyle.deviceHeight,
        child: Stack(
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: Container(
                width: pageStyle.unitWidth * 260.94,
                height: pageStyle.unitHeight * 180,
                margin: EdgeInsets.only(top: pageStyle.unitHeight * 262.7),
                child: SvgPicture.asset(vLogoIcon),
              ),
            ),
            isFirstTime != null && isFirstTime
                ? Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      padding: EdgeInsets.only(
                        bottom: pageStyle.unitHeight * 141,
                      ),
                      width: double.infinity,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: pageStyle.unitWidth * 145,
                            height: pageStyle.unitHeight * 49,
                            child: CigaTextButton(
                              title: 'English',
                              titleSize: pageStyle.unitFontSize * 20,
                              titleColor: Colors.white,
                              buttonColor: Color(0xFFF7941D),
                              borderColor: Colors.transparent,
                              onPressed: () => _onEnglish(),
                              radius: 30,
                            ),
                          ),
                          SizedBox(width: pageStyle.unitWidth * 13),
                          Container(
                            width: pageStyle.unitWidth * 145,
                            height: pageStyle.unitHeight * 49,
                            child: CigaTextButton(
                              title: 'عربى',
                              titleSize: pageStyle.unitFontSize * 20,
                              titleColor: Colors.white,
                              buttonColor: Color(0xFFF7941D),
                              borderColor: Colors.transparent,
                              onPressed: () => _onArabic(),
                              radius: 30,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                : SizedBox.shrink(),
          ],
        ),
      ),
    );
  }
}
