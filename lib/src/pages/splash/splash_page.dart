import 'package:ciga/src/components/ciga_text_button.dart';
import 'package:ciga/src/config/config.dart';
import 'package:ciga/src/data/mock/mock.dart';
import 'package:ciga/src/data/models/address_entity.dart';
import 'package:ciga/src/data/models/cart_item_entity.dart';
import 'package:ciga/src/data/models/product_model.dart';
import 'package:ciga/src/data/models/user_entity.dart';
import 'package:ciga/src/pages/category_list/bloc/category_repository.dart';
import 'package:ciga/src/pages/checkout/bloc/checkout_repository.dart';
import 'package:ciga/src/pages/ciga_app/bloc/cart_item_count/cart_item_count_bloc.dart';
import 'package:ciga/src/pages/ciga_app/bloc/wishlist_item_count/wishlist_item_count_bloc.dart';
import 'package:ciga/src/pages/my_account/shipping_address/bloc/shipping_address_repository.dart';
import 'package:ciga/src/pages/my_cart/bloc/my_cart_repository.dart';
import 'package:ciga/src/pages/sign_in/bloc/sign_in_repository.dart';
import 'package:ciga/src/routes/routes.dart';
import 'package:ciga/src/theme/icons.dart';
import 'package:ciga/src/theme/theme.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ciga/src/utils/local_storage_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:isco_custom_widgets/styles/page_style.dart';

class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  CartItemCountBloc cartItemCountBloc;
  WishlistItemCountBloc wishlistItemCountBloc;
  LocalStorageRepository localRepo;
  PageStyle pageStyle;
  bool isFirstTime;

  @override
  void initState() {
    super.initState();
    localRepo = context.read<LocalStorageRepository>();
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

  void _loadAssets() {
    _getCurrentUser();
    _getCartItems();
    _getWishlists();
    _getShippingAddress();
    _getShippingMethod();
    _getPaymentMethod();
    _getSideMenu();
    _getRegions();
    _navigator();
  }

  void _getCurrentUser() async {
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
    String cartId = await localRepo.getCartId();
    if (cartId.isNotEmpty) {
      final result =
          await context.read<MyCartRepository>().getCartItems(cartId, lang);

      if (result['code'] == 'SUCCESS') {
        List<dynamic> cartList = result['cart'];
        int count = 0;
        for (int i = 0; i < cartList.length; i++) {
          Map<String, dynamic> cartItemJson = {};
          cartItemJson['product'] =
              ProductModel.fromJson(cartList[i]['product']);
          cartItemJson['itemCount'] = cartList[i]['itemCount'];
          cartItemJson['itemId'] = cartList[i]['itemid'];
          cartItemJson['rowPrice'] = cartList[i]['row_price'];
          cartItemJson['availableCount'] = cartList[i]['availableCount'];
          CartItemEntity cart = CartItemEntity.fromJson(cartItemJson);
          myCartItems.add(cart);
          count += cart.itemCount;
          cartTotalPrice +=
              cart.itemCount * double.parse(cart.product.price).ceil();
        }
        cartItemCount = count;
        cartItemCountBloc.add(CartItemCountSet(cartItemCount: count));
      }
    }
  }

  void _getWishlists() async {
    List<String> ids = await localRepo.getWishlistIds();
    wishlistCount = ids.isEmpty ? 0 : ids.length;
    if (ids.isNotEmpty) {
      wishlistItemCountBloc.add(WishlistItemCountSet(
        wishlistItemCount: ids.length,
      ));
    } else {
      wishlistItemCountBloc.add(WishlistItemCountSet(
        wishlistItemCount: 0,
      ));
    }
  }

  void _getShippingAddress() async {
    String token = await localRepo.getToken();
    if (token.isNotEmpty) {
      final result = await context
          .read<ShippingAddressRepository>()
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
        await context.read<CheckoutRepository>().getShippingMethod(lang);
  }

  void _getPaymentMethod() async {
    paymentMethods =
        await context.read<CheckoutRepository>().getPaymentMethod(lang);
  }

  void _getSideMenu() async {
    print(lang);
    sideMenus =
        await context.read<CategoryRepository>().getMenuCategories(lang);
  }

  void _getRegions() async {
    regions = await context.read<ShippingAddressRepository>().getRegions(lang);
  }

  void _navigator() {
    Navigator.pushNamedAndRemoveUntil(context, Routes.home, (route) => false);
  }

  void _onEnglish() async {
    EasyLocalization.of(context).locale =
        EasyLocalization.of(context).supportedLocales.first;
    lang = 'en';
    isFirstTime = false;
    await localRepo.setItem('usage', 'markaa');
    setState(() {});
    _loadAssets();
  }

  void _onArabic() async {
    EasyLocalization.of(context).locale =
        EasyLocalization.of(context).supportedLocales.last;
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
              alignment: Alignment.center,
              child: Container(
                width: pageStyle.unitWidth * 229.01,
                height: pageStyle.unitHeight * 129.45,
                child: SvgPicture.asset(vLogoIcon),
              ),
            ),
            isFirstTime != null && isFirstTime
                ? Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      padding: EdgeInsets.only(
                        bottom: pageStyle.unitHeight * 30,
                      ),
                      width: double.infinity,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: pageStyle.unitWidth * 160,
                            height: pageStyle.unitHeight * 50,
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
                          SizedBox(width: pageStyle.unitWidth * 20),
                          Container(
                            width: pageStyle.unitWidth * 160,
                            height: pageStyle.unitHeight * 50,
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
