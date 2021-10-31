import 'package:markaa/env.dart';

class FirebasePath {
  static const String ENV = dev ? 'markaa/dev' : 'markaa/prod';
  static const String APP_VERSION_DOC_PATH = 'settings/app_version';

  static const String CART_ISSUE_COLL_PATH = '$ENV/issues/date/cart_issues';

  static const String ORDER_ISSUE_COLL_PATH = '$ENV/issues/date/order_issues';
  static const String ORDER_RESULT_COLL_PATH =
      '$ENV/results/date/order_results';
  static const String CANCELED_ORDER_RESULT_COLL_PATH =
      '$ENV/results/date/order_canceled_results';
  static const String PAYMENT_FAILED_ORDER_RESULT_COLL_PATH =
      '$ENV/results/date/order_payment_failed';
  static const String PAYMENT_SUCCESS_ORDER_RESULT_COLL_PATH =
      '$ENV/results/date/order_payment_success';

  static const String WALLET_ISSUE_COLL_PATH = '$ENV/issues/date/wallet_issues';
  static const String WALLET_RESULT_COLL_PATH =
      '$ENV/results/date/wallet_results';
  static const String WALLET_CANCELED_RESULT_COLL_PATH =
      '$ENV/results/date/wallet_canceled_results';
  static const String WALLET_PAYMENT_FAILED_COLL_PATH =
      '$ENV/results/date/wallet_payment_failed';
  static const String WALLET_PAYMENT_SUCCESS_COLL_PATH =
      '$ENV/results/date/wallet_payment_success';
}
