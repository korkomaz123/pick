import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:isco_custom_widgets/isco_custom_widgets.dart';
import 'package:markaa/src/apis/firebase_path.dart';
import 'package:markaa/src/config/config.dart';
import 'package:markaa/src/data/mock/mock.dart';
import 'package:markaa/src/data/models/index.dart';
import 'package:markaa/src/data/models/product_model.dart';
import 'package:markaa/src/utils/repositories/checkout_repository.dart';
import 'package:markaa/src/utils/repositories/firebase_repository.dart';
import 'package:markaa/src/utils/repositories/local_storage_repository.dart';
import 'package:markaa/src/utils/repositories/my_cart_repository.dart';
import 'package:markaa/src/utils/services/flushbar_service.dart';

class MyCartChangeNotifier extends ChangeNotifier {
  final MyCartRepository myCartRepository;
  final LocalStorageRepository localStorageRepository;
  final CheckoutRepository checkoutRepository;
  final FirebaseRepository firebaseRepository;

  MyCartChangeNotifier({
    @required this.myCartRepository,
    @required this.localStorageRepository,
    @required this.checkoutRepository,
    @required this.firebaseRepository,
  });

  ProcessStatus processStatus = ProcessStatus.none;
  String cartId = '';
  double cartTotalPrice = .0;
  int cartItemCount = 0;
  int cartTotalCount = 0;
  String couponCode = '';
  double discount = .0;
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
    cartItemsMap = {};
    reorderCartId = '';
    reorderCartItemCount = 0;
    reorderCartTotalCount = 0;
    reorderCartTotalPrice = .0;
    reorderCartItemsMap = {};
    type = '';
    couponCode = '';
    discount = .0;
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
    cartTotalCount = 0;
    cartItemsMap = {};
    processStatus = ProcessStatus.process;
    if (onProcess != null) {
      onProcess();
    }
    try {
      final result = await myCartRepository.getCartItems(cartId, lang);
      if (result['code'] == 'SUCCESS') {
        cartItemCount = result['items'].length;
        for (var item in result['items']) {
          cartItemsMap[item.itemId] = item;
          cartTotalPrice += item.rowPrice;
          cartTotalCount += item.itemCount;
        }
        couponCode = result['couponCode'];
        discount = result['discount'] + .0;
        type = result['type'];
        processStatus = ProcessStatus.done;
        if (onSuccess != null) {
          onSuccess();
        }
      } else {
        processStatus = ProcessStatus.failed;
        if (onFailure != null) {
          onFailure('$cartIssue$cartId');
          reportCartIssue(result, data);
        }
      }
      notifyListeners();
    } catch (e) {
      onFailure('$cartIssue$cartId\nMore details: $e');
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
        onFailure('$cartIssue$cartId');

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
      onFailure('$cartIssue$cartId\nMore details: $e');
      reportCartIssue(e.toString(), data);
    }
  }

  Future<void> removeCartItem(String key, Function onFailure) async {
    final data = {'action': 'removeCartItem', 'productId': key};
    final item = cartItemsMap[key];
    cartTotalPrice -= cartItemsMap[key].rowPrice;
    cartItemCount -= 1;
    cartTotalCount -= cartItemsMap[key].itemCount;
    cartItemsMap.remove(key);
    notifyListeners();
    try {
      final result = await myCartRepository.deleteCartItem(cartId, key);
      if (result['code'] != 'SUCCESS') {
        onFailure('$cartIssue$cartId');
        cartTotalPrice += item.rowPrice;
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
      onFailure('$cartIssue$cartId\nMore details: $e');
      cartTotalPrice += item.rowPrice;
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
    BuildContext context,
    PageStyle pageStyle,
    ProductModel product,
    int qty,
    String lang,
    Map<String, dynamic> options,
  ) async {
    final data = {
      'action': 'addProductToCart',
      'productId': product.productId,
      'qty': qty,
      'options': options
    };
    final flushBarService = FlushBarService(context: context);
    try {
      final result = await myCartRepository.addCartItem(
          cartId, product.productId, '$qty', lang, options);
      if (result['code'] == 'SUCCESS') {
        CartItemEntity newItem = result['item'];
        if (cartItemsMap.containsKey(newItem.itemId)) {
          cartTotalPrice -= cartItemsMap[newItem.itemId].rowPrice;
        } else {
          cartItemCount += 1;
        }
        cartTotalCount += qty;
        cartTotalPrice += newItem.rowPrice;
        cartItemsMap[newItem.itemId] = newItem;
        notifyListeners();
        flushBarService.showAddCartMessage(pageStyle, product);
      } else {
        flushBarService.showErrorMessage(pageStyle, '$cartIssue$cartId');
        if (processStatus != ProcessStatus.process) {
          await getCartItems(lang);
        }
        reportCartIssue(result, data);
      }
    } catch (e) {
      flushBarService.showErrorMessage(
        pageStyle,
        '$cartIssue$cartId\nMore details: $e',
      );
      if (processStatus != ProcessStatus.process) {
        await getCartItems(lang);
      }
      reportCartIssue(e.toString(), data);
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
    cartTotalCount += updatedQty;
    cartTotalPrice += double.parse(item.product.price) * updatedQty;
    cartItemsMap[item.itemId].itemCount = qty;
    cartItemsMap[item.itemId].rowPrice = double.parse(item.product.price) * qty;
    notifyListeners();
    try {
      final result = await myCartRepository.updateCartItem(
          cartId, item.itemId, qty.toString());
      if (result['code'] != 'SUCCESS') {
        onFailure('$cartIssue$cartId');
        cartTotalCount -= updatedQty;
        cartTotalPrice -= double.parse(item.product.price) * updatedQty;
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
      onFailure('$cartIssue$cartId\nMore details: $e');
      cartTotalCount -= updatedQty;
      cartTotalPrice -= double.parse(item.product.price) * updatedQty;
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
  }

  Future<void> getReorderCartItems(String lang) async {
    final result = await myCartRepository.getCartItems(reorderCartId, lang);
    if (result['code'] == 'SUCCESS') {
      reorderCartItemCount = result['items'].length;
      for (var item in result['items']) {
        reorderCartItemsMap[item.itemId] = item;
        reorderCartTotalPrice += item.rowPrice;
        reorderCartTotalCount += item.itemCount;
      }
    } else {
      processStatus = ProcessStatus.failed;
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

  Future<void> getReorderCartId(String orderId, String lang) async {
    reorderCartId = await myCartRepository.getReorderCartId(orderId, lang);
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
    String deviceId,
    String token,
    String code,
    FlushBarService flushBarService,
    PageStyle pageStyle,
  ) async {
    isApplying = true;
    notifyListeners();
    final result = await myCartRepository.couponCode(cartId, code, '0');
    if (result['code'] == 'SUCCESS') {
      couponCode = code;
      discount = result['discount'] + .0;
      type = result['type'];
      isApplying = false;
    } else {
      errorMessage = result['errMessage'];
      flushBarService.showErrorMessage(pageStyle, errorMessage);
      isApplying = false;
    }
    notifyListeners();
  }

  Future<void> cancelCouponCode(
    FlushBarService flushBarService,
    PageStyle pageStyle,
  ) async {
    isApplying = true;
    final result = await myCartRepository.couponCode(cartId, couponCode, '1');
    if (result['code'] == 'SUCCESS') {
      couponCode = '';
      discount = .0;
      type = '';
      isApplying = false;
    } else {
      errorMessage = result['errMessage'];
      flushBarService.showErrorMessage(pageStyle, errorMessage);
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
      if (result['status'] == 'CAPTURED') {
        onSuccess();
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
}
