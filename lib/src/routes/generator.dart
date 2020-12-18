import 'package:ciga/src/pages/brand_list/brand_list_page.dart';
import 'package:ciga/src/pages/category_list/category_list_page.dart';
import 'package:ciga/src/pages/checkout/address/checkout_address_page.dart';
import 'package:ciga/src/pages/checkout/confirmed/checkout_confirmed_page.dart';
import 'package:ciga/src/pages/checkout/payment/checkout_payment_page.dart';
import 'package:ciga/src/pages/checkout/review/checkout_review_page.dart';
import 'package:ciga/src/pages/checkout/search_address/search_address_screen.dart';
import 'package:ciga/src/pages/checkout/shipping/checkout_shipping_page.dart';
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
import 'package:ciga/src/pages/my_account/order_history/pages/cancel_order/cancel_order_info_page.dart';
import 'package:ciga/src/pages/my_account/order_history/pages/cancel_order/cancel_order_page.dart';
import 'package:ciga/src/pages/my_account/order_history/pages/order_history/order_history_page.dart';
import 'package:ciga/src/pages/my_account/order_history/pages/reorder/reorder_page.dart';
import 'package:ciga/src/pages/my_account/order_history/pages/view_order/view_order_page.dart';
import 'package:ciga/src/pages/my_account/shipping_address/edit_address_page.dart';
import 'package:ciga/src/pages/my_account/shipping_address/shipping_address_page.dart';
import 'package:ciga/src/pages/my_account/terms/terms_page.dart';
import 'package:ciga/src/pages/my_account/update_profile/update_profile_page.dart';
import 'package:ciga/src/pages/my_cart/my_cart_page.dart';
import 'package:ciga/src/pages/product/product_image.dart';
import 'package:ciga/src/pages/product/product_page.dart';
import 'package:ciga/src/pages/product_list/product_list_page.dart';
import 'package:ciga/src/pages/product_review/add_product_review_page.dart';
import 'package:ciga/src/pages/product_review/product_review_page.dart';
import 'package:ciga/src/pages/search/search_page.dart';
import 'package:ciga/src/pages/sign_in/sign_in_page.dart';
import 'package:ciga/src/pages/sign_up/sign_up_page.dart';
import 'package:ciga/src/pages/splash/splash_page.dart';
import 'package:ciga/src/pages/wishlist/wishlist_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'routes.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final Object params = settings.arguments;
    switch (settings.name) {
      case Routes.start:
        return CupertinoPageRoute(
          builder: (context) => SplashPage(),
          settings: RouteSettings(name: Routes.start),
        );
      case Routes.signIn:
        return CupertinoPageRoute(
          builder: (context) => SignInPage(),
          settings: RouteSettings(name: Routes.signIn),
        );
      case Routes.signUp:
        return CupertinoPageRoute(
          builder: (context) => SignUpPage(),
          settings: RouteSettings(name: Routes.signUp),
        );
      case Routes.forgotPassword:
        return CupertinoPageRoute(
          builder: (context) => ForgotPasswordPage(),
          settings: RouteSettings(name: Routes.forgotPassword),
        );
      case Routes.home:
        return CupertinoPageRoute(
          builder: (context) => HomePage(),
          settings: RouteSettings(name: Routes.home),
        );
      case Routes.productList:
        return CupertinoPageRoute(
          builder: (context) => ProductListPage(arguments: params),
          settings: RouteSettings(name: Routes.productList),
        );
      case Routes.categoryList:
        return CupertinoPageRoute(
          builder: (context) => CategoryListPage(),
          settings: RouteSettings(name: Routes.categoryList),
        );
      case Routes.brandList:
        return CupertinoPageRoute(
          builder: (context) => BrandListPage(),
          settings: RouteSettings(name: Routes.brandList),
        );
      case Routes.filter:
        return CupertinoPageRoute(
          builder: (context) => FilterPage(categoryId: params),
          settings: RouteSettings(name: Routes.filter),
        );
      case Routes.product:
        return CupertinoPageRoute(
          builder: (context) => ProductPage(arguments: params),
          settings: RouteSettings(name: Routes.product),
        );
      case Routes.myCart:
        return CupertinoPageRoute(
          builder: (context) => MyCartPage(),
          settings: RouteSettings(name: Routes.myCart),
        );
      case Routes.viewFullImage:
        return CupertinoPageRoute(
          builder: (context) => ProductImage(images: params),
          settings: RouteSettings(name: Routes.viewFullImage),
        );
      case Routes.searchAddress:
        return CupertinoPageRoute(
          builder: (context) => SearchAddressScreen(),
          settings: RouteSettings(name: Routes.searchAddress),
        );
      case Routes.checkoutAddress:
        return CupertinoPageRoute(
          builder: (context) => CheckoutAddressPage(reorder: params),
          settings: RouteSettings(name: Routes.checkoutAddress),
        );
      case Routes.checkoutShipping:
        return CupertinoPageRoute(
          builder: (context) => CheckoutShippingPage(reorder: params),
          settings: RouteSettings(name: Routes.checkoutShipping),
        );
      case Routes.checkoutReview:
        return CupertinoPageRoute(
          builder: (context) => CheckoutReviewPage(reorder: params),
          settings: RouteSettings(name: Routes.checkoutReview),
        );
      case Routes.checkoutPayment:
        return CupertinoPageRoute(
          builder: (context) => CheckoutPaymentPage(reorder: params),
          settings: RouteSettings(name: Routes.checkoutPayment),
        );
      case Routes.checkoutConfirmed:
        return CupertinoPageRoute(
          builder: (context) => CheckoutConfirmedPage(orderNo: params),
          settings: RouteSettings(name: Routes.checkoutConfirmed),
        );
      case Routes.search:
        return CupertinoPageRoute(
          builder: (context) => SearchPage(),
          settings: RouteSettings(name: Routes.search),
        );
      case Routes.account:
        return CupertinoPageRoute(
          builder: (context) => AccountPage(),
          settings: RouteSettings(name: Routes.account),
        );
      case Routes.updateProfile:
        return CupertinoPageRoute(
          builder: (context) => UpdateProfilePage(),
          settings: RouteSettings(name: Routes.updateProfile),
        );
      case Routes.wishlist:
        return CupertinoPageRoute(
          builder: (context) => WishlistPage(),
          settings: RouteSettings(name: Routes.wishlist),
        );
      case Routes.orderHistory:
        return CupertinoPageRoute(
          builder: (context) => OrderHistoryPage(),
          settings: RouteSettings(name: Routes.orderHistory),
        );
      case Routes.aboutUs:
        return CupertinoPageRoute(
          builder: (context) => AboutUsPage(),
          settings: RouteSettings(name: Routes.aboutUs),
        );
      case Routes.terms:
        return CupertinoPageRoute(
          builder: (context) => TermsPage(),
          settings: RouteSettings(name: Routes.terms),
        );
      case Routes.contactUs:
        return CupertinoPageRoute(
          builder: (context) => ContactUsPage(),
          settings: RouteSettings(name: Routes.contactUs),
        );
      case Routes.contactUsSuccess:
        return CupertinoPageRoute(
          builder: (context) => ContactUsSuccessPage(),
          settings: RouteSettings(name: Routes.contactUsSuccess),
        );
      case Routes.notificationMessages:
        return CupertinoPageRoute(
          builder: (context) => NotificationMessagesPage(),
          settings: RouteSettings(name: Routes.notificationMessages),
        );
      case Routes.notificationMessageDetails:
        return CupertinoPageRoute(
          builder: (context) => NotificationMessageDetailsPage(message: params),
          settings: RouteSettings(name: Routes.notificationMessageDetails),
        );
      case Routes.shippingAddress:
        return CupertinoPageRoute(
          builder: (context) => ShippingAddressPage(isCheckout: params),
          settings: RouteSettings(name: Routes.shippingAddress),
        );
      case Routes.editAddress:
        return CupertinoPageRoute(
          builder: (context) => EditAddressPage(address: params),
          settings: RouteSettings(name: Routes.editAddress),
        );
      case Routes.viewOrder:
        return CupertinoPageRoute(
          builder: (context) => ViewOrderPage(order: params),
          settings: RouteSettings(name: Routes.viewOrder),
        );
      case Routes.reOrder:
        return CupertinoPageRoute(
          builder: (context) => ReOrderPage(order: params),
          settings: RouteSettings(name: Routes.reOrder),
        );
      case Routes.cancelOrder:
        return CupertinoPageRoute(
          builder: (context) => CancelOrderPage(order: params),
          settings: RouteSettings(name: Routes.cancelOrder),
        );
      case Routes.cancelOrderInfo:
        return CupertinoPageRoute(
          builder: (context) => CancelOrderInfoPage(params: params),
          settings: RouteSettings(name: Routes.cancelOrderInfo),
        );
      case Routes.changePassword:
        return CupertinoPageRoute(
          builder: (context) => ChangePasswordPage(),
          settings: RouteSettings(name: Routes.changePassword),
        );
      case Routes.productReviews:
        return CupertinoPageRoute(
          builder: (context) => ProductReviewPage(product: params),
          settings: RouteSettings(name: Routes.productReviews),
        );
      case Routes.addProductReview:
        return CupertinoPageRoute(
          builder: (context) => AddProductReviewPage(product: params),
          settings: RouteSettings(name: Routes.addProductReview),
        );
      default:
        return CupertinoPageRoute(
          builder: (context) => SplashPage(),
          settings: RouteSettings(name: Routes.start),
        );
    }
  }
}
