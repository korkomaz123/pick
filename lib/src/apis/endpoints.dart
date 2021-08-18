class EndPoints {
  static const String mainDomain = 'https://markaa.com';
  // static const String mainDomain = 'https://cigaon.com';
  // static const String mainDomain = 'https://staging.markaa.com';
  // static const String mainDomain =
  //     'https://magento-627030-2077233.cloudwaysapps.com';
  static const String baseUrl = '$mainDomain/customapi/api';
  static const String gatewayform = '$mainDomain/gatewayform.php';
  static const String privacyAndPolicy = '$mainDomain/privacy-policy';
  static const String login = '$baseUrl/login';
  static const String logout = '$baseUrl/Logout';
  static const String socialLogin = '$baseUrl/socialLogin';
  static const String register = '$baseUrl/register';
  static const String getCurrentUser = '$baseUrl/getcurrentuser';
  static const String getSubCategories = '$baseUrl/getSubCategories';
  static const String getMenuCategories = '$baseUrl/getmenucategories';
  static const String getCategoryProducts = '$baseUrl/getcategoryproducts';
  static const String getBrandsOnSale = '$baseUrl/getHomepageBrands';
  static const String getAllStores = '$baseUrl/getallstores';
  static const String getAllCategories = '$baseUrl/getallcategories';
  static const String getPerfumes = '$baseUrl/getperfumes';
  static const String getNewArrivals = '$baseUrl/getvewarrivals';
  static const String getBestDeals = '$baseUrl/getbestdeals';
  static const String refreshToken = '$baseUrl/refreshtoken';
  static const String getProductDetails = '$baseUrl/getproductdetails';
  static const String getRelatedItems = '$baseUrl/getrelateditems';
  static const String getSameBrandProducts = '$baseUrl/getsamebrandproducts';
  static const String getSortedProducts = '$baseUrl/getsortedproducts';
  static const String getHomeAds = '$baseUrl/getAds';
  static const String getSearchedProducts = '$baseUrl/getSearchedProducts';
  static const String getWishlist = '$baseUrl/getwishlists';
  static const String addWishlist = '$baseUrl/addWishlistItem';
  static const String getPopup = '$baseUrl/getPopup';
  static const String getFeaturedCategories = '$baseUrl/getFeaturedCategories';
  static const String getHomeSliders = '$baseUrl/getHomeSliders';
  static const String getPaymentMethod = '$baseUrl/getPaymentMethod';
  static const String getShippingMethod = '$baseUrl/getShippingMethod';
  static const String getMyShippingAddresses =
      '$baseUrl/getMyShippingAddresses';
  static const String addShippingAddress = '$baseUrl/addShippingAddress';
  static const String deleteShippingAddress = '$baseUrl/deleteShippingAddress';
  static const String updateShippingAddress = '$baseUrl/updateShippingAddress';
  // static const String submitOrder = '$baseUrl/SubmitOrder';
  static const String submitOrder = '$baseUrl/PlaceOrder';
  static const String getAllBrands = '$baseUrl/getAllBrands';
  static const String getBrandProducts = '$baseUrl/getBrandProducts';
  static const String getAboutus = '$baseUrl/getaboutus';
  static const String getNotificationSetting =
      '$baseUrl/getNotificationSetting';
  static const String changeNotificationSetting =
      '$baseUrl/changeNotificationSetting';
  static const String getTerms = '$baseUrl/getterms';
  static const String submitContactUs = '$baseUrl/submitContactus';
  static const String getOrderHistory = '$baseUrl/getOrderHistories';
  static const String updateProfileImage = '$baseUrl/updateProfileImage';
  static const String updateProfile = '$baseUrl/updateProfile';
  static const String updatePassword = '$baseUrl/updatePassword';
  static const String getFilterAttributes = '$baseUrl/Filter';
  static const String filterProducts = '$baseUrl/Filterproducts';
  static const String createCart = '$baseUrl/CreateCart';
  static const String getCartItems = '$baseUrl/getMyCartItems';
  static const String addCartItem = '$baseUrl/AddItemToCart';
  static const String clearMyCartItems = '$baseUrl/clearMyCartItems';
  static const String getSearchAttrOptions = '$baseUrl/getAttributeOptions';
  static const String getBrandCategories = '$baseUrl/getBrandCategories';
  static const String getSideMenus = '$baseUrl/SideMenu';
  static const String getCategories = '$baseUrl/getCategories';
  static const String getNewPassword = '$baseUrl/getNewPassword';
  static const String applyCouponCode = '$baseUrl/applyCouponCode';
  static const String getSearchSuggestion = '$baseUrl/getSearchSuggetion';
  static const String getReorderCartId = '$baseUrl/getReorderCartId';
  static const String getProductAvailableCount =
      '$baseUrl/getAvailableProductsCount';
  static const String getRegions = '$baseUrl/getRegions';
  static const String getProductReviews = '$baseUrl/getProductReviews';
  static const String addProductReview = '$baseUrl/addProductReview';
  static const String cancelOrder = '$baseUrl/cancelOrder';
  static const String cancelOrderById = '$baseUrl/cancelOrderById';
  static const String returnOrder = '$baseUrl/returnOrder';
  static const String getViewedProducts = '$baseUrl/getViewedProducts';
  static const String sendProductViewed = '$baseUrl/sendProductViewed';
  static const String getViewedGuestProducts = '$baseUrl/getRecentView';
  static const String checkWishlistStatus = '$baseUrl/checkWishlistStatus';
  static const String transferCart = '$baseUrl/transferCart';
  static const String getBestdealsBanner = '$baseUrl/getBestdealsBanner';
  static const String getNewarrivalBanner = '$baseUrl/getNewarrivalBanner';
  static const String getHomeCategories = '$baseUrl/getHomeCategories';
  static const String getSaveForLaterItems = '$baseUrl/getSaveforlater';
  static const String changeSaveForLaterItem = '$baseUrl/addSaveforlateritem';
  static const String getProduct = '$baseUrl/getProduct';
  static const String updateDeviceToken = '$baseUrl/updateDeviceToken';
  static const String updateGuestFcmToken = '$baseUrl/registerGuestFCMToken';
  static const String getCategory = '$baseUrl/getCategoryById';
  static const String getBrand = '$baseUrl/getBrandById';
  static const String getMegaBanner = '$baseUrl/getMegaBanner';
  static const String getOrientalFragrances = '$baseUrl/getOrientalFragrances';
  static const String getExculisiveBanner = '$baseUrl/getExculisiveBanner';
  static const String getFragrancesBanner = '$baseUrl/getFragrancesBanner';
  static const String getWatchesSection = '$baseUrl/getWatchesbanner';
  static const String getGroomingSection = '$baseUrl/getGroomingBanner';
  static const String getSmartTechSection = '$baseUrl/getSmarttechBanner';
  static const String activateCart = '$baseUrl/ActiveCart';
  static const String getsummercollection = '$baseUrl/getsummercollection';
  static const String addMoney = '$baseUrl/addMoney';
  static const String transferMoney = '$baseUrl/Transfermoney';
  static const String getRecord = '$baseUrl/getwalletrecord';
  static const String createWalletCart = '$baseUrl/createwalletcart';
  static const String getTopBrandsByCategory =
      '$baseUrl/getTopBrandsByCategory';
  static const String requestPriceAlarm = '$baseUrl/RequestPriceAlarm';
  static const String getAlarmItems = '$baseUrl/GetAlarmItems';
  static const String sendAsGift = '$baseUrl/SendAsGift';
  static const String getProductInfoBrand = '$baseUrl/GetProductInfoBrand';
  static const String getProductInfo = '$baseUrl/GetProductInfo';
}
