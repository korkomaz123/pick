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
import 'package:ciga/src/pages/my_account/contact_us/contact_us_page.dart';
import 'package:ciga/src/pages/my_account/contact_us/contact_us_success_page.dart';
import 'package:ciga/src/pages/my_account/notification_messages/notification_message_details_page.dart';
import 'package:ciga/src/pages/my_account/notification_messages/notiifcation_messages_page.dart';
import 'package:ciga/src/pages/my_account/order_history/order_history_page.dart';
import 'package:ciga/src/pages/my_account/order_history/reorder_page.dart';
import 'package:ciga/src/pages/my_account/order_history/view_order_page.dart';
import 'package:ciga/src/pages/my_account/shipping_address/edit_address_page.dart';
import 'package:ciga/src/pages/my_account/shipping_address/shipping_address_page.dart';
import 'package:ciga/src/pages/my_account/terms/terms_page.dart';
import 'package:ciga/src/pages/my_account/update_profile/update_profile_page.dart';
import 'package:ciga/src/pages/my_cart/my_cart_page.dart';
import 'package:ciga/src/pages/product/product_image.dart';
import 'package:ciga/src/pages/product/product_page.dart';
import 'package:ciga/src/pages/product_list/product_list_page.dart';
import 'package:ciga/src/pages/search/search_page.dart';
import 'package:ciga/src/pages/sign_in/sign_in_page.dart';
import 'package:ciga/src/pages/sign_up/sign_up_page.dart';
import 'package:ciga/src/pages/splash/splash_page.dart';
import 'package:ciga/src/pages/store_list/store_list_page.dart';
import 'package:ciga/src/pages/wishlist/wishlist_page.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

import 'routes.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final Object params = settings.arguments;
    switch (settings.name) {
      case Routes.start:
        return PageTransition(
          child: SplashPage(),
          type: PageTransitionType.fade,
          duration: Duration(milliseconds: 550),
        );
      case Routes.signIn:
        return PageTransition(
          child: SignInPage(),
          type: PageTransitionType.fade,
          duration: Duration(milliseconds: 550),
        );
      case Routes.signUp:
        return PageTransition(
          child: SignUpPage(),
          type: PageTransitionType.fade,
          duration: Duration(milliseconds: 550),
        );
      case Routes.forgotPassword:
        return PageTransition(
          child: ForgotPasswordPage(),
          type: PageTransitionType.fade,
          duration: Duration(milliseconds: 550),
        );
      case Routes.home:
        return PageTransition(
          child: HomePage(),
          type: PageTransitionType.scale,
          alignment: Alignment.center,
          duration: Duration(milliseconds: 550),
        );
      case Routes.productList:
        return PageTransition(
          child: ProductListPage(arguments: params),
          type: PageTransitionType.fade,
          duration: Duration(milliseconds: 550),
        );
      case Routes.categoryList:
        return PageTransition(
          child: CategoryListPage(),
          type: PageTransitionType.scale,
          alignment: Alignment.center,
          duration: Duration(milliseconds: 550),
        );
      case Routes.storeList:
        return PageTransition(
          child: StoreListPage(),
          type: PageTransitionType.scale,
          alignment: Alignment.center,
          duration: Duration(milliseconds: 550),
        );
      case Routes.brandList:
        return PageTransition(
          child: BrandListPage(),
          type: PageTransitionType.scale,
          alignment: Alignment.center,
          duration: Duration(milliseconds: 550),
        );
      case Routes.filter:
        return PageTransition(
          child: FilterPage(),
          type: PageTransitionType.leftToRight,
          duration: Duration(milliseconds: 550),
        );
      case Routes.product:
        return PageTransition(
          child: ProductPage(arguments: params),
          type: PageTransitionType.fade,
          duration: Duration(milliseconds: 550),
        );
      case Routes.myCart:
        return PageTransition(
          child: MyCartPage(),
          type: PageTransitionType.fade,
          duration: Duration(milliseconds: 550),
        );
      case Routes.viewFullImage:
        return PageTransition(
          child: ProductImage(arguments: params),
          type: PageTransitionType.scale,
          alignment: Alignment.center,
          duration: Duration(milliseconds: 550),
        );
      case Routes.searchAddress:
        return PageTransition(
          child: SearchAddressScreen(),
          type: PageTransitionType.upToDown,
          duration: Duration(milliseconds: 550),
        );
      case Routes.checkoutAddress:
        return PageTransition(
          child: CheckoutAddressPage(),
          type: PageTransitionType.rotate,
          duration: Duration(milliseconds: 550),
        );
      case Routes.checkoutShipping:
        return PageTransition(
          child: CheckoutShippingPage(),
          type: PageTransitionType.rightToLeft,
          duration: Duration(milliseconds: 550),
        );
      case Routes.checkoutReview:
        return PageTransition(
          child: CheckoutReviewPage(),
          type: PageTransitionType.rightToLeft,
          duration: Duration(milliseconds: 550),
        );
      case Routes.checkoutPayment:
        return PageTransition(
          child: CheckoutPaymentPage(),
          type: PageTransitionType.rightToLeft,
          duration: Duration(milliseconds: 550),
        );
      case Routes.checkoutConfirmed:
        return PageTransition(
          child: CheckoutConfirmedPage(),
          type: PageTransitionType.scale,
          alignment: Alignment.center,
          duration: Duration(milliseconds: 550),
        );
      case Routes.search:
        return PageTransition(
          child: SearchPage(),
          type: PageTransitionType.fade,
          duration: Duration(milliseconds: 550),
        );
      case Routes.account:
        return PageTransition(
          child: AccountPage(),
          type: PageTransitionType.scale,
          alignment: Alignment.center,
          duration: Duration(milliseconds: 550),
        );
      case Routes.updateProfile:
        return PageTransition(
          child: UpdateProfilePage(),
          type: PageTransitionType.fade,
          duration: Duration(milliseconds: 750),
        );
      case Routes.wishlist:
        return PageTransition(
          child: WishlistPage(),
          type: PageTransitionType.scale,
          alignment: Alignment.center,
          duration: Duration(milliseconds: 750),
        );
      case Routes.orderHistory:
        return PageTransition(
          child: OrderHistoryPage(),
          type: PageTransitionType.downToUp,
          duration: Duration(milliseconds: 750),
        );
      case Routes.aboutUs:
        return PageTransition(
          child: AboutUsPage(),
          type: PageTransitionType.fade,
          duration: Duration(milliseconds: 750),
        );
      case Routes.terms:
        return PageTransition(
          child: TermsPage(),
          type: PageTransitionType.fade,
          duration: Duration(milliseconds: 750),
        );
      case Routes.contactUs:
        return PageTransition(
          child: ContactUsPage(),
          type: PageTransitionType.fade,
          duration: Duration(milliseconds: 750),
        );
      case Routes.contactUsSuccess:
        return PageTransition(
          child: ContactUsSuccessPage(),
          type: PageTransitionType.rotate,
          duration: Duration(milliseconds: 750),
        );
      case Routes.notificationMessages:
        return PageTransition(
          child: NotificationMessagesPage(),
          type: PageTransitionType.fade,
          duration: Duration(milliseconds: 750),
        );
      case Routes.notificationMessageDetails:
        return PageTransition(
          child: NotificationMessageDetailsPage(message: params),
          type: PageTransitionType.fade,
          duration: Duration(milliseconds: 750),
        );
      case Routes.shippingAddress:
        return PageTransition(
          child: ShippingAddressPage(),
          type: PageTransitionType.fade,
          duration: Duration(milliseconds: 750),
        );
      case Routes.editAddress:
        return PageTransition(
          child: EditAddressPage(address: params),
          type: PageTransitionType.fade,
          duration: Duration(milliseconds: 750),
        );
      case Routes.viewOrder:
        return PageTransition(
          child: ViewOrderPage(order: params),
          type: PageTransitionType.fade,
          duration: Duration(milliseconds: 750),
        );
      case Routes.reOrder:
        return PageTransition(
          child: ReOrderPage(order: params),
          type: PageTransitionType.fade,
          duration: Duration(milliseconds: 750),
        );

      default:
        return PageTransition(
          child: SplashPage(),
          type: PageTransitionType.fade,
          duration: Duration(milliseconds: 750),
        );
    }
  }
}
