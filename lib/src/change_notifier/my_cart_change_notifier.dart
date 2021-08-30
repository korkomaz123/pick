import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:markaa/src/apis/firebase_path.dart';
import 'package:markaa/src/config/config.dart';
import 'package:markaa/src/config/constants.dart';
import 'package:markaa/src/data/mock/mock.dart';
import 'package:markaa/src/data/models/condition_entity.dart';
import 'package:markaa/src/data/models/index.dart';
import 'package:markaa/src/data/models/product_model.dart';
import 'package:markaa/src/utils/repositories/checkout_repository.dart';
import 'package:markaa/src/utils/repositories/firebase_repository.dart';
import 'package:markaa/src/utils/repositories/local_storage_repository.dart';
import 'package:markaa/src/utils/repositories/my_cart_repository.dart';
import 'package:markaa/src/utils/services/flushbar_service.dart';
import 'package:markaa/src/utils/services/numeric_service.dart';
import 'package:markaa/src/utils/services/string_service.dart';

class MyCartChangeNotifier extends ChangeNotifier {
  final myCartRepository = MyCartRepository();
  final localStorageRepository = LocalStorageRepository();
  final checkoutRepository = CheckoutRepository();
  final firebaseRepository = FirebaseRepository();

  /// cart loading status
  ProcessStatus processStatus = ProcessStatus.none;

  /// shopping cart id
  String cartId = '';

  /// total price of the cart items without discount
  double cartTotalPrice = .0;

  /// cart total price with discount
  double cartDiscountedTotalPrice = .0;

  /// the number of cart items
  int cartItemCount = 0;

  /// the total count of cart items
  int cartTotalCount = 0;

  /// applied coupon code
  String couponCode = '';

  /// discount value when apply the coupon code
  double discount = .0;

  /// conditions list to apply the coupon code
  List<ConditionEntity> cartConditions = [];
  List<ConditionEntity> productConditions = [];
  bool isOkayCartCondition = true;
  bool isOkayProductCondition = true;

  /// cart items map data
  Map<String, CartItemEntity> cartItemsMap = {};

  /// shopping cart id for reorder
  String reorderCartId = '';

  /// cart total price of reorder
  double reorderCartTotalPrice = .0;

  /// the number of cart items of reorder
  int reorderCartItemCount = 0;

  /// the total count of cart items of reorder
  int reorderCartTotalCount = 0;

  /// reorder cart items map data
  Map<String, CartItemEntity> reorderCartItemsMap = {};

  /// the type of coupon code
  String type;

  /// coupon apply status
  bool isApplying = false;

  double getDiscountedPrice(CartItemEntity item, {bool isRowPrice = true}) {
    double price = .0;
    bool cartConditionMatched = true;
    for (var condition in cartConditions) {
      if (condition.attribute == 'price' ||
          condition.attribute == 'special_price') {
        if (condition.attribute == 'price') {
          price = StringService.roundDouble(item.product.beforePrice, 3);
        } else if (condition.attribute == 'special_price') {
          if (item.product.price == item.product.beforePrice)
            price = 0;
          else
            price = StringService.roundDouble(item.product.price, 3);
        }
        cartConditionMatched = condition.operator == '>='
            ? price >= double.parse(condition.value)
            : condition.operator == '>'
                ? price > double.parse(condition.value)
                : condition.operator == '<='
                    ? price <= double.parse(condition.value)
                    : price < double.parse(condition.value);
      } else if (condition.attribute == 'sku') {
        cartConditionMatched = condition.operator == '=='
            ? item.product.sku == condition.value
            : item.product.sku != condition.value;
      } else if (condition.attribute == 'brand') {
        cartConditionMatched = condition.operator == '=='
            ? item.product.brandEntity.optionId == condition.value
            : item.product.brandEntity.optionId != condition.value;
      } else if (condition.attribute == 'category_ids') {
        List<String> values = condition.value.split(', ');
        cartConditionMatched = condition.operator == '=='
            ? values.any((value) =>
                item.product.categories.contains(value) ||
                item.product.parentCategories.contains(value))
            : !values.any((value) =>
                item.product.categories.contains(value) ||
                item.product.parentCategories.contains(value));
      }
    }
    bool productConditionMatched = true;
    for (var condition in productConditions) {
      if (condition.attribute == 'price' ||
          condition.attribute == 'special_price') {
        if (condition.attribute == 'price') {
          price = StringService.roundDouble(item.product.beforePrice, 3);
        } else if (condition.attribute == 'special_price') {
          if (item.product.price == item.product.beforePrice)
            price = 0;
          else
            price = StringService.roundDouble(item.product.price, 3);
        }
        productConditionMatched = condition.operator == '>='
            ? price >= double.parse(condition.value)
            : condition.operator == '>'
                ? price > double.parse(condition.value)
                : condition.operator == '<='
                    ? price <= double.parse(condition.value)
                    : price < double.parse(condition.value);
      } else if (condition.attribute == 'sku') {
        productConditionMatched = condition.operator == '=='
            ? item.product.sku == condition.value
            : item.product.sku != condition.value;
      } else if (condition.attribute == 'brand') {
        productConditionMatched = condition.operator == '=='
            ? item.product.brandEntity.optionId == condition.value
            : item.product.brandEntity.optionId != condition.value;
      } else if (condition.attribute == 'category_ids') {
        List<String> values = condition.value.split(', ');
        productConditionMatched = condition.operator == '=='
            ? values.any((value) =>
                item.product.categories.contains(value) ||
                item.product.parentCategories.contains(value))
            : !values.any((value) =>
                item.product.categories.contains(value) ||
                item.product.parentCategories.contains(value));
      }
    }
    bool isOkay =
        (cartConditionMatched && isOkayCartCondition == isOkayCartCondition) &&
            (productConditionMatched &&
                isOkayProductCondition == isOkayProductCondition);
    if (isRowPrice) {
      return isOkay
          ? NumericService.roundDouble(
              item.rowPrice * (100 - discount) / 100, 3)
          : item.rowPrice;
    } else {
      return isOkay
          ? NumericService.roundDouble(
              double.parse(item.product.price) * (100 - discount) / 100, 3)
          : StringService.roundDouble(item.product.price, 3);
    }
  }

  void initialize() {
    cartId = '';
    cartItemCount = 0;
    cartTotalPrice = .0;
    cartTotalCount = 0;
    cartDiscountedTotalPrice = 0;
    cartItemsMap = {};
    reorderCartId = '';
    reorderCartItemCount = 0;
    reorderCartTotalCount = 0;
    reorderCartTotalPrice = .0;
    reorderCartItemsMap = {};
    type = '';
    couponCode = '';
    discount = .0;
    isOkayCartCondition = true;
    isOkayProductCondition = true;
    cartConditions = [];
    productConditions = [];
    notifyListeners();
  }

  Future<void> getCartItems(
    String lang, [
    Function onProcess,
    Function onSuccess,
    Function onFailure,
  ]) async {
    final data = {'action': 'getCartItems'};
    cartItemCount = 0;
    cartTotalPrice = .0;
    cartDiscountedTotalPrice = 0;
    cartTotalCount = 0;
    cartItemsMap = {};
    discount = 0;
    couponCode = '';
    type = '';
    isOkayCartCondition = true;
    isOkayProductCondition = true;
    cartConditions = [];
    productConditions = [];
    processStatus = ProcessStatus.process;
    if (onProcess != null) {
      onProcess();
    }
    // try {
    final result = await myCartRepository.getCartItems(cartId, lang);
    if (result['code'] == 'SUCCESS') {
      couponCode = result['couponCode'];
      discount = result['discount'] + .0;
      type = result['type'];
      cartConditions = result['cartCondition'];
      productConditions = result['productCondition'];
      isOkayCartCondition = result['isCartConditionOkay'];
      isOkayProductCondition = result['isProductConditionOkay'];
      cartItemCount = result['items'].length;
      for (var item in result['items']) {
        cartItemsMap[item.itemId] = item;
        cartTotalPrice += item.rowPrice;
        cartTotalCount += item.itemCount;
        cartDiscountedTotalPrice += getDiscountedPrice(item);
      }

      processStatus = ProcessStatus.done;
      if (onSuccess != null) {
        onSuccess();
      }
    } else {
      processStatus = ProcessStatus.failed;
      if (onFailure != null) {
        onFailure(result['errorMessage']);
        reportCartIssue(result, data);
      }
    }
    notifyListeners();
    // } catch (e) {
    //   print(e.toString());
    //   if (onFailure != null) onFailure('Network connection is bad');
    //   reportCartIssue(e.toString(), data);
    //   notifyListeners();
    // }
  }

  // Future<void> clearCart(
  //   Function onProcess,
  //   Function onSuccess,
  //   Function onFailure,
  // ) async {
  //   final data = {'action': 'clearCart'};
  //   onProcess();
  //   try {
  //     String clearCartId = cartId;
  //     String clearType = type;
  //     String clearCouponCode = couponCode;
  //     double clearDiscount = discount;
  //     final result = await myCartRepository.clearCartItems(clearCartId);
  //     if (result['code'] != 'SUCCESS') {
  //       onFailure(result['errorMessage']);

  //       reportCartIssue(result, data);
  //     } else {
  //       initialize();
  //       notifyListeners();
  //       cartId = clearCartId;
  //       type = clearType;
  //       couponCode = clearCouponCode;
  //       discount = clearDiscount;
  //       onSuccess();
  //     }
  //   } catch (e) {
  //     onFailure('Network connection is bad');
  //     reportCartIssue(e.toString(), data);
  //   }
  // }

  Future<void> removeCartItem(String key, Function onFailure) async {
    final data = {'action': 'removeCartItem', 'productId': key};
    final item = cartItemsMap[key];
    cartTotalPrice -= cartItemsMap[key].rowPrice;
    cartDiscountedTotalPrice -= getDiscountedPrice(item);
    cartItemCount -= 1;
    cartTotalCount -= cartItemsMap[key].itemCount;
    cartItemsMap.remove(key);
    notifyListeners();

    try {
      final result = await myCartRepository.deleteCartItem(cartId, key);
      if (result['code'] != 'SUCCESS') {
        onFailure(result['errorMessage']);
        cartTotalPrice += item.rowPrice;
        cartDiscountedTotalPrice += getDiscountedPrice(item);
        cartItemCount += 1;
        cartTotalCount += item.itemCount;
        cartItemsMap[key] = item;
        notifyListeners();

        if (processStatus != ProcessStatus.process) {
          await getCartItems(lang);
        }
        reportCartIssue(result, data);
      }
    } catch (e) {
      onFailure('Network connection is bad');
      cartTotalPrice += item.rowPrice;
      cartDiscountedTotalPrice += getDiscountedPrice(item);
      cartItemCount += 1;
      cartTotalCount += item.itemCount;
      cartItemsMap[key] = item;
      notifyListeners();

      if (processStatus != ProcessStatus.process) {
        await getCartItems(lang);
      }
      reportCartIssue(e.toString(), data);
    }
  }

  Future<void> addProductToCart(
    ProductModel product,
    int qty,
    String lang,
    Map<String, dynamic> options, {
    Function onProcess,
    Function onSuccess,
    Function onFailure,
  }) async {
    if (onProcess != null) onProcess();
    final data = {
      'action': 'addProductToCart',
      'productId': product.productId,
      'qty': qty,
      'options': options
    };

    try {
      final result = await myCartRepository.addCartItem(
          cartId, product.productId, '$qty', lang, options);

      if (result['code'] == 'SUCCESS') {
        CartItemEntity newItem = result['item'];
        CartItemEntity oldItem = cartItemsMap[newItem.itemId];
        if (cartItemsMap.containsKey(newItem.itemId)) {
          cartTotalPrice -= oldItem.rowPrice;
          cartDiscountedTotalPrice -= getDiscountedPrice(oldItem);
        } else {
          cartItemCount += 1;
        }
        cartTotalCount += qty;
        cartTotalPrice += newItem.rowPrice;
        cartDiscountedTotalPrice += getDiscountedPrice(newItem);
        cartItemsMap[newItem.itemId] = newItem;
        if (onSuccess != null) onSuccess();
        notifyListeners();
      } else {
        onFailure(result['errorMessage']);
        reportCartIssue(result, data);
      }
    } catch (e) {
      print(e.toString());
      onFailure('Network connection is bad');
      reportCartIssue(e.toString(), data);

      // if (processStatus != ProcessStatus.process) await getCartItems(lang);
    }
  }

  Future<void> updateCartItem(
    CartItemEntity item,
    int qty,
    Function onFailure,
  ) async {
    final data = {
      'action': 'updateCartItem',
      'itemid': item.itemId,
      'qty': qty
    };
    int updatedQty = qty - item.itemCount;
    double updatedPrice =
        StringService.roundDouble(item.product.price, 3) * updatedQty;
    cartTotalCount += updatedQty;
    cartTotalPrice += updatedPrice;
    cartDiscountedTotalPrice -= getDiscountedPrice(cartItemsMap[item.itemId]);
    cartItemsMap[item.itemId].itemCount = qty;
    cartItemsMap[item.itemId].rowPrice =
        StringService.roundDouble(item.product.price, 3) * qty;
    cartDiscountedTotalPrice += getDiscountedPrice(cartItemsMap[item.itemId]);
    notifyListeners();

    try {
      final result = await myCartRepository.updateCartItem(
          cartId, item.itemId, qty.toString());
      if (result['code'] != 'SUCCESS') {
        onFailure(result['errorMessage']);
        cartTotalCount -= updatedQty;
        cartTotalPrice -= updatedPrice;
        cartDiscountedTotalPrice -=
            getDiscountedPrice(cartItemsMap[item.itemId]);
        cartItemsMap[item.itemId].itemCount = item.itemCount;
        cartItemsMap[item.itemId].rowPrice =
            StringService.roundDouble(item.product.price, 3) * item.itemCount;
        cartDiscountedTotalPrice +=
            getDiscountedPrice(cartItemsMap[item.itemId]);
        notifyListeners();

        if (processStatus != ProcessStatus.process) {
          await getCartItems(lang);
        }
        reportCartIssue(result, data);
      }
    } catch (e) {
      onFailure('Network connection is bad');
      cartTotalCount -= updatedQty;
      cartTotalPrice -= updatedPrice;
      cartDiscountedTotalPrice -= getDiscountedPrice(cartItemsMap[item.itemId]);
      cartItemsMap[item.itemId].itemCount = item.itemCount;
      cartItemsMap[item.itemId].rowPrice =
          StringService.roundDouble(item.product.price, 3) * item.itemCount;
      cartDiscountedTotalPrice += getDiscountedPrice(cartItemsMap[item.itemId]);
      notifyListeners();
      if (processStatus != ProcessStatus.process) {
        await getCartItems(lang);
      }
      reportCartIssue(e.toString(), data);
    }
  }

  Future<void> getCartId() async {
    try {
      if (user?.token != null) {
        final result = await myCartRepository.getCartId(user.token);
        if (result['code'] == 'SUCCESS') {
          cartId = result['cartId'];
        }
      } else {
        if (await localStorageRepository.existItem('cartId')) {
          cartId = await localStorageRepository.getCartId();
        } else {
          final result = await myCartRepository.createCart();
          if (result['code'] == 'SUCCESS') {
            cartId = result['cartId'];
            await localStorageRepository.setCartId(cartId);
          }
        }
      }
      notifyListeners();
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> activateCart() async {
    try {
      final result = await myCartRepository.activateCart(cartId);
      if (result['code'] == 'SUCCESS') {
        print('activated your cart success');
      } else {
        print('activated failure: ${result['errorMessage']}');
      }
    } catch (e) {
      print('activated catch failure:  $e');
    }
  }

  Future<void> getReorderCartItems(
    String lang, {
    Function onProcess,
    Function onSuccess,
    Function onFailure,
  }) async {
    if (onProcess != null) onProcess();

    final result = await myCartRepository.getCartItems(reorderCartId, lang);

    if (result['code'] == 'SUCCESS') {
      reorderCartItemCount = result['items'].length;
      for (var item in result['items']) {
        reorderCartItemsMap[item.itemId] = item;
        reorderCartTotalPrice += item.rowPrice;
        reorderCartTotalCount += item.itemCount;
      }

      if (onSuccess != null) onSuccess();
    } else {
      processStatus = ProcessStatus.failed;

      if (onFailure != null) onFailure();
    }
    notifyListeners();
  }

  Future<void> removeReorderCartItem(String key) async {
    reorderCartTotalPrice -= reorderCartItemsMap[key].rowPrice;
    reorderCartItemCount -= 1;
    reorderCartTotalCount -= reorderCartItemsMap[key].itemCount;
    reorderCartItemsMap.remove(key);
    notifyListeners();
    await myCartRepository.deleteCartItem(reorderCartId, key);
  }

  Future<void> getReorderCartId(
    String orderId,
    String lang, {
    Function onProcess,
    Function onSuccess,
    Function onFailure,
  }) async {
    if (onProcess != null) onProcess();

    try {
      reorderCartId = await myCartRepository.getReorderCartId(orderId, lang);

      if (onSuccess != null) onSuccess();
    } catch (e) {
      if (onFailure != null) onFailure();
    }
  }

  void initializeReorderCart() {
    reorderCartId = '';
    reorderCartItemCount = 0;
    reorderCartTotalCount = 0;
    reorderCartTotalPrice = .0;
    reorderCartItemsMap = {};
    notifyListeners();
  }

  Future<void> applyCouponCode(
    String code,
    FlushBarService flushBarService,
  ) async {
    isApplying = true;
    notifyListeners();
    final result = await myCartRepository.couponCode(cartId, code, '0');
    if (result['code'] == 'SUCCESS') {
      couponCode = code;
      discount = result['discount'] + .0;
      type = result['type'];
      isApplying = false;
      cartConditions = result['cartCondition'];
      productConditions = result['productCondition'];
      isOkayCartCondition = result['isCartConditionOkay'];
      isOkayProductCondition = result['isProductConditionOkay'];
      resetDiscountPrice();
    } else {
      flushBarService.showErrorDialog(result['errorMessage']);
      isApplying = false;
    }
    notifyListeners();
  }

  void resetDiscountPrice() {
    cartDiscountedTotalPrice = 0;
    for (var key in cartItemsMap.keys.toList()) {
      final item = cartItemsMap[key];
      cartDiscountedTotalPrice += getDiscountedPrice(item);
    }
  }

  Future<void> cancelCouponCode(
    FlushBarService flushBarService,
  ) async {
    isApplying = true;
    notifyListeners();
    final result = await myCartRepository.couponCode(cartId, couponCode, '1');
    if (result['code'] == 'SUCCESS') {
      couponCode = '';
      discount = .0;
      type = '';
      isApplying = false;
      cartDiscountedTotalPrice = cartTotalPrice;
      cartConditions.clear();
      productConditions.clear();
      isOkayCartCondition = true;
      isOkayProductCondition = true;
    } else {
      flushBarService.showErrorDialog(result['errorMessage']);
      isApplying = false;
    }
    notifyListeners();
  }

  Future<void> transferCartItems() async {
    final viewerCartId = await localStorageRepository.getCartId();
    await myCartRepository.transferCart(viewerCartId, cartId);
  }

  Future<void> generatePaymentUrl(
    Map<String, dynamic> data,
    String lang,
    Function onProcess,
    Function onSuccess,
    Function onFailure,
  ) async {
    onProcess();
    try {
      final result = await checkoutRepository.tapPaymentCheckout(data, lang);
      print(result);
      onSuccess(result['transaction']['url'], result['id']);
    } catch (e) {
      onFailure(e.toString());
    }
  }

  Future<void> checkChargeStatus(
    String chargeId,
    Function onProcess,
    Function onSuccess,
    Function onFailure,
  ) async {
    onProcess();
    try {
      final result = await checkoutRepository.checkPaymentStatus(chargeId);
      submitPaymentResult(result, chargeId);
      if (result['status'] == 'CAPTURED') {
        onSuccess();
      } else {
        onFailure(result['response']['message']);
      }
    } catch (e) {
      onFailure(e.toString());
    }
  }

  Future<void> refundPayment(
    Map<String, dynamic> data,
    Function onSuccess,
    Function onFailure,
  ) async {
    try {
      final result = await checkoutRepository.refundPayment(data);
      if (result['status'] == REFUND_PENDING ||
          result['status'] == REFUND_REFUNDED) {
        onSuccess();
      } else if (result['status'] == REFUND_IN_PROGRESS) {
        final result1 =
            await checkoutRepository.checkRefundStatus(result['id']);
        if (result1['status'] == REFUND_PENDING ||
            result1['status'] == REFUND_REFUNDED) {
          onSuccess();
        } else {
          onFailure(result1['response']['message']);
        }
      } else {
        onFailure(result['response']['message']);
      }
    } catch (e) {
      onFailure(e.toString());
    }
  }

  void reportCartIssue(dynamic result, dynamic data) async {
    data['cartId'] = cartId;
    final date = DateFormat('yyyy-MM-dd', 'en_US').format(DateTime.now());
    final reportData = {
      'result': result,
      'collectData': data,
      'customer': user?.token != null ? user.toJson() : 'guest',
      'createdAt':
          DateFormat('yyyy-MM-dd hh:mm:ss', 'en_US').format(DateTime.now()),
      'appVersion': {
        'android': MarkaaVersion.androidVersion,
        'iOS': MarkaaVersion.iOSVersion
      },
      'platform': Platform.isAndroid ? 'Android' : 'IOS',
      'lang': lang
    };
    final path = FirebasePath.CART_ISSUE_COLL_PATH.replaceFirst('date', date);
    await firebaseRepository.addToCollection(reportData, path);
  }

  void submitPaymentResult(dynamic result, String chargeId) async {
    final date = DateFormat('yyyy-MM-dd', 'en_US').format(DateTime.now());
    final resultData = {
      'result': result,
      'chargeId': chargeId,
      'customer': user?.token != null ? user.toJson() : 'guest',
      'createdAt':
          DateFormat('yyyy-MM-dd hh:mm:ss', 'en_US').format(DateTime.now()),
      'appVersion': {
        'android': MarkaaVersion.androidVersion,
        'iOS': MarkaaVersion.iOSVersion,
      },
      'platform': Platform.isAndroid ? 'Android' : 'IOS',
      'lang': lang
    };
    final path =
        FirebasePath.PAYMENT_RESULT_COLL_PATH.replaceFirst('date', date);
    await firebaseRepository.addToCollection(resultData, path);
  }
}
