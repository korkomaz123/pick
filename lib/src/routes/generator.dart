import 'package:ciga/src/pages/brand_list/brand_list_page.dart';
import 'package:ciga/src/pages/category_list/category_list_page.dart';
import 'package:ciga/src/pages/checkout/address/checkout_address_page.dart';
import 'package:ciga/src/pages/checkout/payment/checkout_payment_page.dart';
import 'package:ciga/src/pages/checkout/review/checkout_review_page.dart';
import 'package:ciga/src/pages/checkout/shipping/checkout_shipping_page.dart';
import 'package:ciga/src/pages/checkout/confirmed/checkout_confirmed_page.dart';
import 'package:ciga/src/pages/filter/filter_page.dart';
import 'package:ciga/src/pages/forgot_password/forgot_password_page.dart';
import 'package:ciga/src/pages/home/home_page.dart';
import 'package:ciga/src/pages/my_account/account_page.dart';
import 'package:ciga/src/pages/my_account/order_history/order_history_page.dart';
import 'package:ciga/src/pages/my_account/update_profile/update_profile_page.dart';
import 'package:ciga/src/pages/my_cart/my_cart_page.dart';
import 'package:ciga/src/pages/product/product_page.dart';
import 'package:ciga/src/pages/product_list/product_list_page.dart';
import 'package:ciga/src/pages/search/search_page.dart';
import 'package:ciga/src/pages/sign_in/sign_in_page.dart';
import 'package:ciga/src/pages/sign_up/sign_up_page.dart';
import 'package:ciga/src/pages/splash/splash_page.dart';
import 'package:ciga/src/pages/store_list/store_list_page.dart';
import 'package:ciga/src/pages/wishlist/wishlist_page.dart';
import 'package:flutter/material.dart';

import 'routes.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final Object params = settings.arguments;
    switch (settings.name) {
      case Routes.start:
        return MaterialPageRoute(builder: (context) => SplashPage());
      case Routes.signIn:
        return MaterialPageRoute(builder: (context) => SignInPage());
      case Routes.signUp:
        return MaterialPageRoute(builder: (context) => SignUpPage());
      case Routes.forgotPassword:
        return MaterialPageRoute(builder: (context) => ForgotPasswordPage());
      case Routes.home:
        return MaterialPageRoute(builder: (context) => HomePage());
      case Routes.productList:
        return MaterialPageRoute(
          builder: (context) => ProductListPage(arguments: params),
        );
      case Routes.categoryList:
        return MaterialPageRoute(builder: (context) => CategoryListPage());
      case Routes.storeList:
        return MaterialPageRoute(builder: (context) => StoreListPage());
      case Routes.brandList:
        return MaterialPageRoute(builder: (context) => BrandListPage());
      case Routes.filter:
        return MaterialPageRoute(builder: (context) => FilterPage());
      case Routes.product:
        return MaterialPageRoute(
          builder: (context) => ProductPage(arguments: params),
        );
      case Routes.myCart:
        return MaterialPageRoute(builder: (context) => MyCartPage());
      case Routes.checkoutAddress:
        return MaterialPageRoute(builder: (context) => CheckoutAddressPage());
      case Routes.checkoutShipping:
        return MaterialPageRoute(builder: (context) => CheckoutShippingPage());
      case Routes.checkoutReview:
        return MaterialPageRoute(builder: (context) => CheckoutReviewPage());
      case Routes.checkoutPayment:
        return MaterialPageRoute(builder: (context) => CheckoutPaymentPage());
      case Routes.checkoutConfirmed:
        return MaterialPageRoute(builder: (context) => CheckoutConfirmedPage());
      case Routes.search:
        return MaterialPageRoute(builder: (context) => SearchPage());
      case Routes.account:
        return MaterialPageRoute(builder: (context) => AccountPage());
      case Routes.updateProfile:
        return MaterialPageRoute(builder: (context) => UpdateProfilePage());
      case Routes.wishlist:
        return MaterialPageRoute(builder: (context) => WishlistPage());
      case Routes.orderHistory:
        return MaterialPageRoute(builder: (context) => OrderHistoryPage());
      default:
        return MaterialPageRoute(builder: (context) => SplashPage());
    }
  }
}
