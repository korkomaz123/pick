import 'package:markaa/env.dart';

const double designWidth = 375;
const double designHeight = 812;
const String apiKey = 'AIzaSyAdBFtlOPsyAnZa0HMOWZ869QNGSqm-vV0';

class ChatSupport {
  static const String appKey = '9be222f98ce7dc12af142e27097a8a8c';
}

class MarkaaReporter {
  static const String email = 'user@markaa.com';
  static const String password = 'markaa2021';
}

class MarkaaVersion {
  static const int androidVersion = 193600;
  static const int iOSVersion = 193500;
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
  static const String enPriceDescProducts = 'magento2_default_products_price_default_desc';
  static const String enPriceAscProducts = 'magento2_default_products_price_default_asc';
  static const String enCreatedAtDescProducts = 'magento2_default_products_created_at_desc';
  static const String enCreatedAtAscProducts = 'magento2_default_products_created_at_asc';
  static const String arProducts = 'magento2_arabic_products';
  static const String arPriceDescProducts = 'magento2_arabic_products_price_default_desc';
  static const String arPriceAscProducts = 'magento2_arabic_products_price_default_asc';
  static const String arCreatedAtDescProducts = 'magento2_arabic_products_created_at_desc';
  static const String arCreatedAtAscProducts = 'magento2_arabic_products_created_at_asc';
}

class AdjustSDKConfig {
  static const String app = '6zku7sd3x7gg';
  static const String addToCart = '4gustj';
  static const String completePurchase = 'mw1hfm';
  static const String initiateCheckout = 'a5budz';
  static const String register = 'rznvj2';
  static const String viewProduct = 'p3ode4';
  static const String checkout = 'wwl5ro';
  static const String continuePayment = 'bisvvh';
  static const String placePayment = 'f97jdc';
  static const String successPayment = 'e92lnv';
  static const String failedPayment = 'kchj5x';
}

class MarkaaNotificationChannels {
  static const String enChannel = dev ? 'markaa-all-en-dev' : 'markaa-all-en';
  static const String arChannel = dev ? 'markaa-all-ar-dev' : 'markaa-all-ar';
}

class SmartLookConfig {
  static const String key = 'be238addb42844bb6668c56c0e5c2612903c8077';
}
