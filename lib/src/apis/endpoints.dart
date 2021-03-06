import 'package:markaa/env.dart';

class EndPoints {
  static const String mainDomain = dev ? 'https://markaa.cigaon.com' : 'https://markaa.com';
  static const String baseUrl = '$mainDomain/customapi/v1';
  static const String gatewayform = '$mainDomain/gatewayform.php';
  static const String privacyAndPolicy = '$mainDomain/privacy-policy';
  static const String login = '$baseUrl/Login';
  static const String logout = '$baseUrl/Logout';
  static const String socialLogin = '$baseUrl/LoginWithSocial';
  static const String register = '$baseUrl/Register';
  static const String getCurrentUser = '$baseUrl/GetCurrentUser';
  static const String getAppAsset = '$baseUrl/GetAppAsset';
  static const String getSubCategories = '$baseUrl/GetSubCategories';
  static const String getMenuCategories = '$baseUrl/GetMenuCategories';
  static const String getCategoryProducts = '$baseUrl/GetCategoryProducts';
  static const String getBrandsOnSale = '$baseUrl/GetHomePageBrands';
  static const String getAllStores = '$baseUrl/GetAllStores';
  static const String getAllCategories = '$baseUrl/GetAllCategories';
  static const String getPerfumes = '$baseUrl/GetPerfumes';
  static const String getNewArrivals = '$baseUrl/GetNewArrivals';
  static const String getBestDeals = '$baseUrl/GetBestDeals';
  static const String refreshToken = '$baseUrl/RefreshToken';
  static const String getProductDetails = '$baseUrl/GetProductDetails';
  static const String getRelatedItems = '$baseUrl/GetRelatedItems';
  static const String getSameBrandProducts = '$baseUrl/GetSameBrandProducts';
  static const String getSortedProducts = '$baseUrl/SortProducts';
  static const String getHomeAds = '$baseUrl/GetAds';
  static const String getSearchedProducts = '$baseUrl/SearchProducts';
  static const String getWishlist = '$baseUrl/GetWishlists';
  static const String addWishlist = '$baseUrl/AddWishlistItem';
  static const String getPopup = '$baseUrl/GetPopup';
  static const String getFeaturedCategories = '$baseUrl/GetFeaturedCategories';
  static const String getHomeSliders = '$baseUrl/GetHomeSliders';
  static const String getPaymentMethod = '$baseUrl/GetPaymentMethod';
  static const String getShippingMethod = '$baseUrl/GetShippingMethod';
  static const String getMyShippingAddresses = '$baseUrl/GetMyShippingAddresses';
  static const String addShippingAddress = '$baseUrl/AddShippingAddress';
  static const String deleteShippingAddress = '$baseUrl/DeleteShippingAddress';
  static const String updateShippingAddress = '$baseUrl/UpdateShippingAddress';
  static const String addShippingMethod = '$baseUrl/AddShippingMethod';
  static const String placeOrder = '$baseUrl/PlaceOrder';
  static const String getAllBrands = '$baseUrl/GetAllBrands';
  static const String getBrandProducts = '$baseUrl/GetBrandProducts';
  static const String getAboutus = '$baseUrl/GetAboutUs';
  static const String getNotificationSetting = '$baseUrl/GetNotificationSetting';
  static const String changeNotificationSetting = '$baseUrl/ChangeNotificationSetting';
  static const String getTerms = '$baseUrl/GetTerms';
  static const String submitContactUs = '$baseUrl/SubmitContactus';
  static const String getOrderHistory = '$baseUrl/GetOrderHistories';
  static const String updateProfileImage = '$baseUrl/UpdateProfileImage';
  static const String updateProfile = '$baseUrl/UpdateProfile';
  static const String updatePassword = '$baseUrl/UpdatePassword';
  static const String getFilterAttributes = '$baseUrl/GetFilterAttributes';
  static const String filterProducts = '$baseUrl/FilterProducts';
  static const String createCart = '$baseUrl/CreateCart';
  static const String getCartItems = '$baseUrl/GetCartItems';
  static const String updateCartItem = '$baseUrl/UpdateCartItem';
  static const String deleteCartItem = '$baseUrl/DeleteCartItem';
  static const String addCartItem = '$baseUrl/AddItemToCart';
  static const String clearMyCartItems = '$baseUrl/ClearMyCartItems';
  static const String getSearchAttrOptions = '$baseUrl/GetAttributeOptions';
  static const String getBrandCategories = '$baseUrl/GetBrandCategories';
  static const String getSideMenus = '$baseUrl/SideMenu';
  static const String getCategories = '$baseUrl/getCategories';
  static const String getNewPassword = '$baseUrl/getNewPassword';
  static const String applyCouponCode = '$baseUrl/ApplyCouponCode';
  static const String getSearchSuggestion = '$baseUrl/GetSearchSuggetion';
  static const String getReorderCartId = '$baseUrl/GetReorderCartId';
  static const String getProductAvailableCount = '$baseUrl/GetAvailableProductsCount';
  static const String getRegions = '$baseUrl/GetRegions';
  static const String getProductReviews = '$baseUrl/GetProductReviews';
  static const String addProductReview = '$baseUrl/AddProductReview';
  static const String cancelOrder = '$baseUrl/CancelOrder';
  static const String cancelOrderById = '$baseUrl/CancelOrderById';
  static const String returnOrder = '$baseUrl/ReturnOrder';
  static const String getViewedProducts = '$baseUrl/GetCustomerViewedProducts';
  static const String sendProductViewed = '$baseUrl/SendProductViewed';
  static const String getViewedGuestProducts = '$baseUrl/GetGuestViewedProducts';
  static const String checkWishlistStatus = '$baseUrl/CheckWishlistStatus';
  static const String transferCart = '$baseUrl/TransferCart';
  static const String getBestdealsBanner = '$baseUrl/GetBestDealsBanner';
  static const String getFaceCareSection = '$baseUrl/GetHomePageSection1';
  static const String getNewarrivalBanner = '$baseUrl/GetNewArrivalBanner';
  static const String getHomeCategories = '$baseUrl/GetHomeCategories';
  static const String getSaveForLaterItems = '$baseUrl/GetSaveForLater';
  static const String changeSaveForLaterItem = '$baseUrl/AddSaveForLaterItem';
  static const String getProduct = '$baseUrl/GetProductById';
  static const String updateDeviceToken = '$baseUrl/UpdateDeviceToken';
  static const String updateGuestFcmToken = '$baseUrl/RegisterGuestFCMToken';
  static const String getCategory = '$baseUrl/GetCategoryById';
  static const String getBrand = '$baseUrl/GetBrandById';
  static const String getMegaBanner = '$baseUrl/GetMegaBanner';
  static const String getOrientalFragrances = '$baseUrl/GetOrientalFragrances';
  static const String getExculisiveBanner = '$baseUrl/GetExculisiveBanner';
  static const String getFragrancesBanner = '$baseUrl/GetFragrancesBanner';
  static const String getWatchesSection = '$baseUrl/GetWatchesbanner';
  static const String getGroomingSection = '$baseUrl/GetGroomingBanner';
  static const String getSmartTechSection = '$baseUrl/GetSmarttechBanner';
  static const String activateCart = '$baseUrl/ActiveCart';
  static const String getsummercollection = '$baseUrl/GetSummerCollection';
  static const String addMoney = '$baseUrl/AddMoney';
  static const String transferMoney = '$baseUrl/TransferMoney';
  static const String getRecord = '$baseUrl/GetWalletRecord';
  static const String createWalletCart = '$baseUrl/CreateWalletCart';
  static const String getTopBrandsByCategory = '$baseUrl/GetTopBrandsByCategory';
  static const String requestPriceAlarm = '$baseUrl/RequestPriceAlarm';
  static const String getAlarmItems = '$baseUrl/GetAlarmItems';
  static const String sendAsGift = '$baseUrl/SendAsGift';
  static const String getProductInfoBrand = '$baseUrl/GetProductInfoBrand';
  static const String getProductInfo = '$baseUrl/GetProductInfo';

  /// new home section endpoints
  static const String gethomecelebrity = '$baseUrl/GetHomeCelebrity';
  static const String homeSection1 = '$baseUrl/GetHomePageSection1';
  static const String homeSection2 = '$baseUrl/GetHomePageSection2';
  static const String homeSection3 = '$baseUrl/GetHomePageSection3';
  static const String homeSection4 = '$baseUrl/GetHomePageSection4';

  static const String getAllCelebrities = '$baseUrl/GetAllCelebrities';
  static const String celebrityProducts = '$baseUrl/GetCelebrityPage';
  static const String getDeliveryRules = '$baseUrl/GetDeliveryRules';
}
