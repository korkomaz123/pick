import 'package:markaa/src/data/models/index.dart';
import 'package:markaa/src/pages/brand_list/brand_list_page.dart';
import 'package:markaa/src/pages/category_list/category_list_page.dart';
import 'package:markaa/src/pages/celeberities_list/celeberities_list.dart';
import 'package:markaa/src/pages/checkout/confirmed/checkout_confirmed_page.dart';
import 'package:markaa/src/pages/checkout/confirmed/payment_failed_page.dart';
import 'package:markaa/src/pages/checkout/payment/checkout_page.dart';
import 'package:markaa/src/pages/checkout/payment/checkout_payment_page.dart';
import 'package:markaa/src/pages/checkout/payment/widgets/payment_card_form.dart';
import 'package:markaa/src/pages/checkout/search_address/search_address_screen.dart';
import 'package:markaa/src/pages/filter/filter_page.dart';
import 'package:markaa/src/pages/forgot_password/forgot_password_page.dart';
import 'package:markaa/src/pages/home/home_page.dart';
import 'package:markaa/src/pages/infollowencer_products/infollowencer_products.dart';
import 'package:markaa/src/pages/my_account/about_us/about_us_page.dart';
import 'package:markaa/src/pages/my_account/account_page.dart';
import 'package:markaa/src/pages/my_account/alarm_list/alarm_list_page.dart';
import 'package:markaa/src/pages/my_account/change_password/change_password_page.dart';
import 'package:markaa/src/pages/my_account/contact_us/contact_us_page.dart';
import 'package:markaa/src/pages/my_account/contact_us/contact_us_success_page.dart';
import 'package:markaa/src/pages/my_account/notification_messages/notification_message_details_page.dart';
import 'package:markaa/src/pages/my_account/notification_messages/notiifcation_messages_page.dart';
import 'package:markaa/src/pages/my_account/order_history/pages/cancel_order/cancel_order_info_page.dart';
import 'package:markaa/src/pages/my_account/order_history/pages/cancel_order/cancel_order_page.dart';
import 'package:markaa/src/pages/my_account/order_history/pages/order_history/order_history_page.dart';
import 'package:markaa/src/pages/my_account/order_history/pages/reorder/reorder_page.dart';
import 'package:markaa/src/pages/my_account/order_history/pages/return_order/return_order_info_page.dart';
import 'package:markaa/src/pages/my_account/order_history/pages/return_order/return_order_page.dart';
import 'package:markaa/src/pages/my_account/order_history/pages/view_order/view_order_page.dart';
import 'package:markaa/src/pages/my_account/shipping_address/edit_address_page.dart';
import 'package:markaa/src/pages/my_account/shipping_address/shipping_address_page.dart';
import 'package:markaa/src/pages/my_account/terms/terms_page.dart';
import 'package:markaa/src/pages/my_account/update_profile/update_profile_page.dart';
import 'package:markaa/src/pages/my_cart/my_cart_page.dart';
import 'package:markaa/src/pages/my_wallet/checkout/my_wallet_checkout_page.dart';
import 'package:markaa/src/pages/my_wallet/checkout/my_wallet_payment_failed_page.dart';
import 'package:markaa/src/pages/my_wallet/checkout/my_wallet_payment_page.dart';
import 'package:markaa/src/pages/my_wallet/checkout/my_wallet_payment_success_page.dart';
import 'package:markaa/src/pages/my_wallet/gift/sent_gift_success_page.dart';
import 'package:markaa/src/pages/my_wallet/my_wallet_details/my_wallet_details_page.dart';
import 'package:markaa/src/pages/product/product_image.dart';
import 'package:markaa/src/pages/product/product_page.dart';
import 'package:markaa/src/pages/product_list/product_list_page.dart';
import 'package:markaa/src/pages/product_review/add_product_review_page.dart';
import 'package:markaa/src/pages/product_review/product_review_page.dart';
import 'package:markaa/src/pages/search/search_page.dart';
import 'package:markaa/src/pages/sign_in/sign_in_page.dart';
import 'package:markaa/src/pages/sign_up/sign_up_page.dart';
import 'package:markaa/src/pages/splash/splash_page.dart';
import 'package:markaa/src/pages/splash/update_page.dart';
import 'package:markaa/src/pages/summer_collection/summer_collection_page.dart';
import 'package:markaa/src/pages/wishlist/wishlist_page.dart';
import 'package:flutter/cupertino.dart';

import 'routes.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final params = settings.arguments;
    switch (settings.name) {
      case Routes.start:
        return PageRouteBuilder(
          settings: settings,
          transitionDuration: Duration.zero,
          pageBuilder: (_, __, ___) => SplashPage(),
        );
      case Routes.update:
        return CupertinoPageRoute(
          builder: (context) => UpdatePage(storeLink: params as String),
          settings: RouteSettings(name: Routes.update),
        );
      case Routes.signIn:
        return CupertinoPageRoute(
          builder: (context) => SignInPage(isFromCheckout: (params ?? false) as bool),
          settings: RouteSettings(name: Routes.signIn),
        );
      case Routes.signUp:
        return CupertinoPageRoute(
          builder: (context) => SignUpPage(isFromCheckout: (params ?? false) as bool),
          settings: RouteSettings(name: Routes.signUp),
        );
      case Routes.forgotPassword:
        return CupertinoPageRoute(
          builder: (context) => ForgotPasswordPage(
            isFromCheckout: (params ?? false) as bool,
          ),
          settings: RouteSettings(name: Routes.forgotPassword),
        );
      case Routes.home:
        return PageRouteBuilder(
          settings: RouteSettings(name: Routes.home),
          pageBuilder: (_, __, ___) => HomePage(),
          transitionDuration: Duration.zero,
        );
      case Routes.productList:
        return CupertinoPageRoute(
          builder: (context) => ProductListPage(arguments: params as ProductListArguments),
          settings: RouteSettings(name: Routes.productList),
        );
      case Routes.summerCollection:
        return CupertinoPageRoute(
          builder: (context) => SummerCollectionPage(arguments: params as ProductListArguments),
          settings: RouteSettings(name: Routes.summerCollection),
        );
      case Routes.categoryList:
        return PageRouteBuilder(
          settings: RouteSettings(name: Routes.categoryList),
          pageBuilder: (_, __, ___) => CategoryListPage(),
          transitionDuration: Duration.zero,
        );
      case Routes.brandList:
        return PageRouteBuilder(
          settings: RouteSettings(name: Routes.brandList),
          pageBuilder: (_, __, ___) => BrandListPage(),
          transitionDuration: Duration.zero,
        );
      case Routes.filter:
        return CupertinoPageRoute(
          builder: (context) => FilterPage(
            categoryId: params as String,
            brandId: params,
          ),
          settings: RouteSettings(name: Routes.filter),
        );
      case Routes.product:
        return CupertinoPageRoute(
          builder: (context) => ProductPage(product: params! as ProductModel),
          settings: RouteSettings(name: Routes.product),
        );
      case Routes.myCart:
        return CupertinoPageRoute(
          builder: (context) => MyCartPage(),
          settings: RouteSettings(name: Routes.myCart),
        );
      case Routes.viewFullImage:
        return CupertinoPageRoute(
          builder: (context) => ProductImage(images: params as List<dynamic>),
          settings: RouteSettings(name: Routes.viewFullImage),
        );
      case Routes.searchAddress:
        return CupertinoPageRoute(
          builder: (context) => SearchAddressScreen(),
          settings: RouteSettings(name: Routes.searchAddress),
        );

      case Routes.checkout:
        return CupertinoPageRoute(
          builder: (context) => CheckoutPage(reorder: params as OrderEntity?),
          settings: RouteSettings(name: Routes.checkout),
        );
      case Routes.checkoutPayment:
        return CupertinoPageRoute(
          builder: (context) => CheckoutPaymentPage(params: params as Map<String, dynamic>),
          settings: RouteSettings(name: Routes.checkoutPayment),
        );
      case Routes.creditCard:
        return CupertinoPageRoute(
          builder: (context) => PaymentCardForm(),
          settings: RouteSettings(name: Routes.creditCard),
        );
      case Routes.checkoutConfirmed:
        return CupertinoPageRoute(
          builder: (context) => CheckoutConfirmedPage(order: params as OrderEntity),
          settings: RouteSettings(name: Routes.checkoutConfirmed),
        );
      case Routes.paymentFailed:
        return CupertinoPageRoute(
          builder: (context) => PaymentFailedPage(isReorder: params as bool),
          settings: RouteSettings(name: Routes.paymentFailed),
        );
      case Routes.search:
        return CupertinoPageRoute(
          builder: (context) => SearchPage(),
          settings: RouteSettings(name: Routes.search),
        );
      case Routes.account:
        return PageRouteBuilder(
          settings: RouteSettings(name: Routes.account),
          pageBuilder: (_, __, ___) => AccountPage(),
          transitionDuration: Duration.zero,
        );
      case Routes.updateProfile:
        return CupertinoPageRoute(
          builder: (context) => UpdateProfilePage(),
          settings: RouteSettings(name: Routes.updateProfile),
        );
      case Routes.wishlist:
        return PageRouteBuilder(
          settings: RouteSettings(name: Routes.wishlist),
          pageBuilder: (_, __, ___) => WishlistPage(),
          transitionDuration: Duration.zero,
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
          builder: (context) => NotificationMessageDetailsPage(message: params as MessageEntity),
          settings: RouteSettings(name: Routes.notificationMessageDetails),
        );
      case Routes.shippingAddress:
        return CupertinoPageRoute(
          builder: (context) => ShippingAddressPage(isCheckout: (params ?? false) as bool),
          settings: RouteSettings(name: Routes.shippingAddress),
        );
      case Routes.editAddress:
        return CupertinoPageRoute(
          builder: (context) => EditAddressPage(params: params as Map<String, dynamic>?),
          settings: RouteSettings(name: Routes.editAddress),
        );
      case Routes.viewOrder:
        return CupertinoPageRoute(
          builder: (context) => ViewOrderPage(order: params as OrderEntity),
          settings: RouteSettings(name: Routes.viewOrder),
        );
      case Routes.reOrder:
        return CupertinoPageRoute(
          builder: (context) => ReOrderPage(order: params as OrderEntity),
          settings: RouteSettings(name: Routes.reOrder),
        );
      case Routes.cancelOrder:
        return CupertinoPageRoute(
          builder: (context) => CancelOrderPage(order: params as OrderEntity),
          settings: RouteSettings(name: Routes.cancelOrder),
        );
      case Routes.cancelOrderInfo:
        return CupertinoPageRoute(
          builder: (context) => CancelOrderInfoPage(params: params as Map<String, dynamic>),
          settings: RouteSettings(name: Routes.cancelOrderInfo),
        );
      case Routes.returnOrder:
        return CupertinoPageRoute(
          builder: (context) => ReturnOrderPage(order: params as OrderEntity),
          settings: RouteSettings(name: Routes.returnOrder),
        );
      case Routes.returnOrderInfo:
        return CupertinoPageRoute(
          builder: (context) => ReturnOrderInfoPage(params: params as Map<String, dynamic>),
          settings: RouteSettings(name: Routes.returnOrderInfo),
        );
      case Routes.changePassword:
        return CupertinoPageRoute(
          builder: (context) => ChangePasswordPage(),
          settings: RouteSettings(name: Routes.changePassword),
        );
      case Routes.productReviews:
        return CupertinoPageRoute(
          builder: (context) => ProductReviewPage(product: params as ProductEntity),
          settings: RouteSettings(name: Routes.productReviews),
        );
      case Routes.addProductReview:
        return CupertinoPageRoute(
          builder: (context) => AddProductReviewPage(product: params as ProductEntity),
          settings: RouteSettings(name: Routes.addProductReview),
        );
      case Routes.myWallet:
        return CupertinoPageRoute(
          builder: (_) => MyWalletDetailsPage(amount: params as double?),
          settings: RouteSettings(name: Routes.myWallet),
        );
      case Routes.myWalletCheckout:
        return CupertinoPageRoute(
          builder: (_) => MyWalletCheckoutPage(fromCheckout: (params ?? false) as bool),
          settings: settings,
        );
      case Routes.myWalletPayment:
        return CupertinoPageRoute(
          builder: (_) => MyWalletPaymentPage(params: params as Map<String, dynamic>),
          settings: settings,
        );
      case Routes.myWalletSuccess:
        return CupertinoPageRoute(
          builder: (_) => MyWalletPaymentSuccessPage(),
          settings: settings,
        );
      case Routes.myWalletFailed:
        return CupertinoPageRoute(
          builder: (_) => MyWalletPaymentFailedPage(),
          settings: settings,
        );
      case Routes.sentGiftSuccess:
        return CupertinoPageRoute(
          builder: (_) => SentGiftSuccessPage(amount: params as String),
          settings: settings,
        );
      case Routes.alarmList:
        return CupertinoPageRoute(
          builder: (_) => AlarmListPage(),
          settings: settings,
        );
      case Routes.celebritiesList:
        return CupertinoPageRoute(
          builder: (context) => CelebritiesListPage(arguments: params),
          settings: settings,
        );
      case Routes.infollowencerProductsPage:
        return CupertinoPageRoute(
          builder: (context) => InfollowencerProductsPage(arguments: params),
          settings: settings,
        );
      default:
        return CupertinoPageRoute(
          builder: (context) => SplashPage(),
          settings: settings,
        );
    }
  }
}
