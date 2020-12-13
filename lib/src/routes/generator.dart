import 'package:ciga/src/pages/brand_list/brand_list_page.dart';
import 'package:ciga/src/pages/category_list/category_list_page.dart';
import 'package:ciga/src/pages/checkout/address/checkout_address_page.dart';
import 'package:ciga/src/pages/checkout/payment/checkout_payment_page.dart';
import 'package:ciga/src/pages/checkout/review/checkout_review_page.dart';
import 'package:ciga/src/pages/checkout/search_address/search_address_screen.dart';
import 'package:ciga/src/pages/checkout/shipping/checkout_shipping_page.dart';
import 'package:ciga/src/pages/checkout/confirmed/checkout_confirmed_page.dart';
import 'package:ciga/src/pages/filter/filter_page.dart';
import 'package:ciga/src/pages/forgot_password/forgot_password_page.dart';
import 'package:ciga/src/pages/home/home_page.dart';
import 'package:ciga/src/pages/my_account/about_us/about_us_page.dart';
import 'package:ciga/src/pages/my_account/account_page.dart';
import 'package:ciga/src/pages/my_account/change_password/change_password_page.dart';
import 'package:ciga/src/pages/my_account/contact_us/contact_us_page.dart';
import 'package:ciga/src/pages/my_account/contact_us/contact_us_success_page.dart';
import 'package:ciga/src/pages/my_account/notification_messages/notification_message_details_page.dart';
import 'package:ciga/src/pages/my_account/notification_messages/notiifcation_messages_page.dart';
import 'package:ciga/src/pages/my_account/order_history/order_history_page.dart';
import 'package:ciga/src/pages/my_account/order_history/reorder_page.dart';
import 'package:ciga/src/pages/my_account/order_history/view_order_page.dart';
import 'package:ciga/src/pages/my_account/order_history/cancel_order_page.dart';
import 'package:ciga/src/pages/my_account/shipping_address/edit_address_page.dart';
import 'package:ciga/src/pages/my_account/shipping_address/shipping_address_page.dart';
import 'package:ciga/src/pages/my_account/terms/terms_page.dart';
import 'package:ciga/src/pages/my_account/update_profile/update_profile_page.dart';
import 'package:ciga/src/pages/my_cart/my_cart_page.dart';
import 'package:ciga/src/pages/product/product_image.dart';
import 'package:ciga/src/pages/product/product_page.dart';
import 'package:ciga/src/pages/product_list/product_list_page.dart';
import 'package:ciga/src/pages/product_review/product_review_page.dart';
import 'package:ciga/src/pages/product_review/add_product_review_page.dart';
import 'package:ciga/src/pages/search/search_page.dart';
import 'package:ciga/src/pages/sign_in/sign_in_page.dart';
import 'package:ciga/src/pages/sign_up/sign_up_page.dart';
import 'package:ciga/src/pages/splash/splash_page.dart';
import 'package:ciga/src/pages/wishlist/wishlist_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'routes.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final Object params = settings.arguments;
    switch (settings.name) {
      case Routes.start:
        return CupertinoPageRoute(
          builder: (context) => SplashPage(),
        );
      case Routes.signIn:
        return CupertinoPageRoute(
          builder: (context) => SignInPage(),
        );
      case Routes.signUp:
        return CupertinoPageRoute(
          builder: (context) => SignUpPage(),
        );
      case Routes.forgotPassword:
        return CupertinoPageRoute(
          builder: (context) => ForgotPasswordPage(),
        );
      case Routes.home:
        return CupertinoPageRoute(
          builder: (context) => HomePage(),
        );
      case Routes.productList:
        return CupertinoPageRoute(
          builder: (context) => ProductListPage(arguments: params),
        );
      case Routes.categoryList:
        return CupertinoPageRoute(
          builder: (context) => CategoryListPage(),
        );
      case Routes.brandList:
        return CupertinoPageRoute(
          builder: (context) => BrandListPage(),
        );
      case Routes.filter:
        return CupertinoPageRoute(
          builder: (context) => FilterPage(categoryId: params),
        );
      case Routes.product:
        return CupertinoPageRoute(
          builder: (context) => ProductPage(arguments: params),
        );
      case Routes.myCart:
        return CupertinoPageRoute(
          builder: (context) => MyCartPage(),
        );
      case Routes.viewFullImage:
        return CupertinoPageRoute(
          builder: (context) => ProductImage(images: params),
        );
      case Routes.searchAddress:
        return CupertinoPageRoute(
          builder: (context) => SearchAddressScreen(),
        );
      case Routes.checkoutAddress:
        return CupertinoPageRoute(
          builder: (context) => CheckoutAddressPage(reorder: params),
        );
      case Routes.checkoutShipping:
        return CupertinoPageRoute(
          builder: (context) => CheckoutShippingPage(reorder: params),
        );
      case Routes.checkoutReview:
        return CupertinoPageRoute(
          builder: (context) => CheckoutReviewPage(reorder: params),
        );
      case Routes.checkoutPayment:
        return CupertinoPageRoute(
          builder: (context) => CheckoutPaymentPage(reorder: params),
        );
      case Routes.checkoutConfirmed:
        return CupertinoPageRoute(
          builder: (context) => CheckoutConfirmedPage(orderNo: params),
        );
      case Routes.search:
        return CupertinoPageRoute(
          builder: (context) => SearchPage(),
        );
      case Routes.account:
        return CupertinoPageRoute(
          builder: (context) => AccountPage(),
        );
      case Routes.updateProfile:
        return CupertinoPageRoute(
          builder: (context) => UpdateProfilePage(),
        );
      case Routes.wishlist:
        return CupertinoPageRoute(
          builder: (context) => WishlistPage(),
        );
      case Routes.orderHistory:
        return CupertinoPageRoute(
          builder: (context) => OrderHistoryPage(),
        );
      case Routes.aboutUs:
        return CupertinoPageRoute(
          builder: (context) => AboutUsPage(),
        );
      case Routes.terms:
        return CupertinoPageRoute(
          builder: (context) => TermsPage(),
        );
      case Routes.contactUs:
        return CupertinoPageRoute(
          builder: (context) => ContactUsPage(),
        );
      case Routes.contactUsSuccess:
        return CupertinoPageRoute(
          builder: (context) => ContactUsSuccessPage(),
        );
      case Routes.notificationMessages:
        return CupertinoPageRoute(
          builder: (context) => NotificationMessagesPage(),
        );
      case Routes.notificationMessageDetails:
        return CupertinoPageRoute(
          builder: (context) => NotificationMessageDetailsPage(message: params),
        );
      case Routes.shippingAddress:
        return CupertinoPageRoute(
          builder: (context) => ShippingAddressPage(isCheckout: params),
        );
      case Routes.editAddress:
        return CupertinoPageRoute(
          builder: (context) => EditAddressPage(address: params),
        );
      case Routes.viewOrder:
        return CupertinoPageRoute(
          builder: (context) => ViewOrderPage(order: params),
        );
      case Routes.reOrder:
        return CupertinoPageRoute(
          builder: (context) => ReOrderPage(order: params),
        );
      case Routes.cancelOrder:
        return CupertinoPageRoute(
          builder: (context) => CancelOrderPage(order: params),
        );
      case Routes.changePassword:
        return CupertinoPageRoute(
          builder: (context) => ChangePasswordPage(),
        );
      case Routes.productReviews:
        return CupertinoPageRoute(
          builder: (context) => ProductReviewPage(product: params),
        );
      case Routes.addProductReview:
        return CupertinoPageRoute(
          builder: (context) => AddProductReviewPage(product: params),
        );
      default:
        return CupertinoPageRoute(
          builder: (context) => SplashPage(),
        );
    }
  }
}
