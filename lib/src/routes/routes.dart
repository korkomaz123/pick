class Routes {
  /// start routes
  static const String start = '/';

  /// authentication routes
  static const String signIn = '/sign-in';
  static const String signUp = '/sign-up';
  static const String forgotPassword = '/forgot-password';

  /// home routes
  static const String home = '/home';

  /// search
  static const String search = '/search';

  /// categories
  static const String categoryList = '/category-list';

  /// stores
  static const String storeList = '/store-list';

  /// brands
  static const String brandList = '/brand-list';

  /// products list from home categories, categories, stores, brands
  static const String productList = '/product-list';

  /// single product
  static const String product = '/product-single';

  /// view product reviews
  static const String productReviews = '/product-reviews';

  /// add review for the product
  static const String addProductReview = '/add-product-review';

  /// filter
  static const String filter = '/filter';

  /// my cart
  static const String myCart = '/my-cart';
  static const String viewFullImage = '/image-view-fullscreen';

  /// checkout
  static const String searchAddress = '/search-address';
  static const String checkoutAddress = '/checkout-address';
  static const String checkoutGuestAddress = '/checkout-guest-address';
  static const String checkoutShipping = '/checkout-shipping';
  static const String checkoutReview = '/checkout-review';
  static const String checkoutPayment = '/checkout-payment';
  static const String checkoutConfirmed = '/checkout-confirmed';
  static const String checkoutPaymentCard = '/checkout-payment-card';

  /// wishlist
  static const String wishlist = '/wishlist';

  /// account
  static const String account = '/my-account';
  static const String updateProfile = '/update-profile';
  static const String notificationMessages = '/notification-messages';
  static const String notificationMessageDetails =
      '/notification-message-details';
  static const String orderHistory = '/order-history';
  static const String terms = '/terms';
  static const String aboutUs = '/about-us';
  static const String contactUs = '/contact-us';
  static const String contactUsSuccess = '/contact-us-success';
  static const String shippingAddress = '/shipping-address';
  static const String editAddress = '/edit-address';
  static const String viewOrder = '/view-order';
  static const String reOrder = '/re-order';
  static const String cancelOrder = '/cancel-order';
  static const String cancelOrderInfo = '/cancel-order-info';
  static const String changePassword = 'change-password';
  static const String returnOrder = '/return-order';
  static const String returnOrderInfo = '/return-order-info';
}
