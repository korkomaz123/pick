const double designWidth = 375;
const double designHeight = 812;
const String apiKey = 'AIzaSyAdBFtlOPsyAnZa0HMOWZ869QNGSqm-vV0';

class MarkaaReporter {
  static const String email = 'reporter@markaa.com';
  static const String password = 'markaa2021';
}

class MarkaaVersion {
  static const int androidVersion = 156000;
  static const int iOSVersion = 156000;
}

class GoSellSdk {
  static const String pAndroidSecretKey = 'sk_live_yhvSZwp2NcQIDCYW9k3EzLf6';
  static const String tAndroidSecretKey = 'sk_test_ge1wCvn8pADBXcjasGu9drNS';
  static const String pIOSSecretKey = 'sk_live_VwyhnCY6aMlUX1E7oPFQD4cL';
  static const String tIOSSecretKey = 'sk_test_DdFoY4SJHiKU9zWev8yGqg6l';
}

class AlgoliaConfig {
  static const String appId = '79CSNNDELV';
  static const String apiKey = '8ca7be02352085bd2ed725b027bf2680';
}

class AlgoliaIndexes {
  static const String enProducts = 'magento2_default_products';
  static const String enPriceDescProducts =
      'magento2_default_products_price_default_desc';
  static const String enPriceAscProducts =
      'magento2_default_products_price_default_asc';
  static const String enCreatedAtDescProducts =
      'magento2_default_products_created_at_desc';
  static const String enCreatedAtAscProducts =
      'magento2_default_products_created_at_asc';
  static const String arProducts = 'magento2_arabic_products';
  static const String arPriceDescProducts =
      'magento2_arabic_products_price_default_desc';
  static const String arPriceAscProducts =
      'magento2_arabic_products_price_default_asc';
  static const String arCreatedAtDescProducts =
      'magento2_arabic_products_created_at_desc';
  static const String arCreatedAtAscProducts =
      'magento2_arabic_products_created_at_asc';
}

class AdjustSDKConfig {
  static const String appToken = '6zku7sd3x7gg';
  static const String addToCartToken = '4gustj';
  static const String completePurchaseToken = 'mw1hfm';
  static const String initiateCheckoutToken = 'a5budz';
  static const String registerToken = 'rznvj2';
  static const String viewProduct = 'p3ode4';
}

class MarkaaNotificationChannels {
  static const String enChannel = 'markaa-all-en';
  static const String arChannel = 'markaa-all-ar';
}

class PaymentStatusUrls {
  static const String success = 'https://cigaon.com/checkout/onepage/success/';
  static const String failure = 'https://cigaon.com/checkout/cart/';
}
