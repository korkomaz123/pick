import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:markaa/src/apis/firebase_path.dart';
import 'package:markaa/src/config/config.dart';
import 'package:markaa/src/config/constants.dart';
import 'package:markaa/src/data/mock/mock.dart';
import 'package:markaa/src/data/models/index.dart';
import 'package:markaa/src/data/models/product_model.dart';
import 'package:markaa/src/utils/repositories/checkout_repository.dart';
import 'package:markaa/src/utils/repositories/firebase_repository.dart';
import 'package:markaa/src/utils/repositories/local_storage_repository.dart';
import 'package:markaa/src/utils/repositories/my_cart_repository.dart';
import 'package:markaa/src/utils/services/flushbar_service.dart';

class MyCartChangeNotifier extends ChangeNotifier {
  final myCartRepository = MyCartRepository();
  final localStorageRepository = LocalStorageRepository();
  final checkoutRepository = CheckoutRepository();
  final firebaseRepository = FirebaseRepository();

  ProcessStatus processStatus = ProcessStatus.none;
  String cartId = '';
  double cartTotalPrice = .0;
  double cartDiscountedTotalPrice = .0;
  int cartItemCount = 0;
  int cartTotalCount = 0;
  String couponCode = '';
  double discount = .0;
  Map<String, dynamic> condition = {};
  Map<String, CartItemEntity> cartItemsMap = {};
  String reorderCartId = '';
  double reorderCartTotalPrice = .0;
  int reorderCartItemCount = 0;
  int reorderCartTotalCount = 0;
  Map<String, CartItemEntity> reorderCartItemsMap = {};
  String errorMessage;
  String type;
  String cartIssue = 'Something went wrong regarding your shopping cart: ';
  bool isApplying = false;

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
    condition = {};
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
    condition = {};
    processStatus = ProcessStatus.process;
    if (onProcess != null) {
      onProcess();
    }
    try {
      final result = await myCartRepository.getCartItems(cartId, lang);
      if (result['code'] == 'SUCCESS') {
        couponCode = result['couponCode'];
        discount = result['discount'] + .0;
        type = result['type'];
        condition = result['condition'];

        cartItemCount = result['items'].length;
        for (var item in result['items']) {
          cartItemsMap[item.itemId] = item;
          cartTotalPrice += item.rowPrice;
          cartTotalCount += item.itemCount;
          cartDiscountedTotalPrice +=
              double.parse(item.product.price) >= condition['value']
                  ? item.rowPrice * (100 - discount) / 100
                  : item.rowPrice;
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
    } catch (e) {
      print(e.toString());
      onFailure('Network connection is bad');
      reportCartIssue(e.toString(), data);
      notifyListeners();
    }
  }

  Future<void> clearCart(
    Function onProcess,
    Function onSuccess,
    Function onFailure,
  ) async {
    final data = {'action': 'clearCart'};
    onProcess();
    try {
      String clearCartId = cartId;
      String clearType = type;
      String clearCouponCode = couponCode;
      double clearDiscount = discount;
      final result = await myCartRepository.clearCartItems(clearCartId);
      if (result['code'] != 'SUCCESS') {
        onFailure(result['errorMessage']);

        reportCartIssue(result, data);
      } else {
        initialize();
        notifyListeners();
        cartId = clearCartId;
        type = clearType;
        couponCode = clearCouponCode;
        discount = clearDiscount;
        onSuccess();
      }
    } catch (e) {
      onFailure('Network connection is bad');
      reportCartIssue(e.toString(), data);
    }
  }

  Future<void> removeCartItem(String key, Function onFailure) async {
    final data = {'action': 'removeCartItem', 'productId': key};
    final item = cartItemsMap[key];
    cartTotalPrice -= cartItemsMap[key].rowPrice;
    cartDiscountedTotalPrice -=
        double.parse(item.product.price) >= condition['value']
            ? item.rowPrice * (100 - discount) / 100
            : item.rowPrice;
    cartItemCount -= 1;
    cartTotalCount -= cartItemsMap[key].itemCount;
    cartItemsMap.remove(key);
    notifyListeners();

    try {
      final result = await myCartRepository.deleteCartItem(cartId, key);
      if (result['code'] != 'SUCCESS') {
        onFailure(result['errorMessage']);
        cartTotalPrice += item.rowPrice;
        cartDiscountedTotalPrice +=
            double.parse(item.product.price) >= condition['value']
                ? item.rowPrice * (100 - discount) / 100
                : item.rowPrice;
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
      cartDiscountedTotalPrice +=
          double.parse(item.product.price) >= condition['value']
              ? item.rowPrice * (100 - discount) / 100
              : item.rowPrice;
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
          cartDiscountedTotalPrice -=
              double.parse(oldItem.product.price) >= condition['value']
                  ? oldItem.rowPrice * (100 - discount) / 100
                  : oldItem.rowPrice;
        } else {
          cartItemCount += 1;
        }
        cartTotalCount += qty;
        cartTotalPrice += newItem.rowPrice;
        cartDiscountedTotalPrice +=
            double.parse(newItem.product.price) >= condition['value']
                ? newItem.rowPrice * (100 - discount) / 100
                : newItem.rowPrice;
        cartItemsMap[newItem.itemId] = newItem;
        if (onSuccess != null) onSuccess();
        notifyListeners();
      } else {
        onFailure(result['errorMessage']);
        reportCartIssue(result, data);
      }
    } catch (e) {
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
    double updatedPrice = double.parse(item.product.price) * updatedQty;
    cartTotalCount += updatedQty;
    cartTotalPrice += updatedPrice;
    cartDiscountedTotalPrice +=
        double.parse(item.product.price) >= condition['value']
            ? updatedPrice * (100 - discount) / 100
            : updatedPrice;
    cartItemsMap[item.itemId].itemCount = qty;
    cartItemsMap[item.itemId].rowPrice = double.parse(item.product.price) * qty;
    notifyListeners();

    try {
      final result = await myCartRepository.updateCartItem(
          cartId, item.itemId, qty.toString());
      if (result['code'] != 'SUCCESS') {
        onFailure(result['errorMessage']);
        cartTotalCount -= updatedQty;
        cartTotalPrice -= updatedPrice;
        cartDiscountedTotalPrice -=
            double.parse(item.product.price) >= condition['value']
                ? updatedPrice * (100 - discount) / 100
                : updatedPrice;
        cartItemsMap[item.itemId].itemCount = item.itemCount;
        cartItemsMap[item.itemId].rowPrice =
            double.parse(item.product.price) * item.itemCount;
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
      cartDiscountedTotalPrice -=
          double.parse(item.product.price) >= condition['value']
              ? updatedPrice * (100 - discount) / 100
              : updatedPrice;
      cartItemsMap[item.itemId].itemCount = item.itemCount;
      cartItemsMap[item.itemId].rowPrice =
          double.parse(item.product.price) * item.itemCount;
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
      print(result);
      couponCode = code;
      discount = result['discount'] + .0;
      type = result['type'];
      isApplying = false;
      condition = !result.containsKey('condition') || result['condition'] == ''
          ? {'value': 0}
          : result['condition'];
      resetDiscountPrice();
    } else {
      errorMessage = result['errorMessage'];
      flushBarService.showErrorDialog(errorMessage);
      isApplying = false;
    }
    notifyListeners();
  }

  void resetDiscountPrice() {
    cartDiscountedTotalPrice = 0;
    for (var key in cartItemsMap.keys.toList()) {
      final item = cartItemsMap[key];
      cartDiscountedTotalPrice +=
          double.parse(item.product.price) < condition['value']
              ? item.rowPrice
              : item.rowPrice * (100 - discount) / 100;
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
    } else {
      errorMessage = result['errorMessage'];
      flushBarService.showErrorDialog(errorMessage);
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
