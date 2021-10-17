import 'package:markaa/env.dart';

class FirebasePath {
  static const String ENV = dev ? 'markaa/dev' : 'markaa/prod';
  static const String SETTINGS_COLL_PATH = 'settings';
  static const String APP_VERSION_DOC_PATH = 'settings/app_version';
  static const String ISSUE_COLL_PATH = '$ENV/issues';
  static const String PAYMENT_ISSUE_COLL_PATH =
      '$ENV/issues/date/payment_issues';
  static const String ORDER_ISSUE_COLL_PATH = '$ENV/issues/date/order_issues';
  static const String CART_ISSUE_COLL_PATH = '$ENV/issues/date/cart_issues';
  static const String PAYMENT_RESULT_COLL_PATH =
      '$ENV/results/date/payment_results';
  static const String ORDER_RESULT_COLL_PATH =
      '$ENV/results/date/order_results';
  static const String CANCELED_ORDER_RESULT_COLL_PATH =
      '$ENV/results/date/canceled_order_results';
  static const String PAYMENT_FAILED_ORDER_RESULT_COLL_PATH =
      '$ENV/results/date/payment_failed_order_results';
  static const String PAYMENT_SUCCESS_ORDER_RESULT_COLL_PATH =
      '$ENV/results/date/payment_success_order_results';
}
