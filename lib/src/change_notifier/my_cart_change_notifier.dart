import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:markaa/env.dart';
import 'package:markaa/slack.dart';
import 'package:markaa/src/apis/firebase_path.dart';
import 'package:markaa/src/config/config.dart';
import 'package:markaa/src/data/mock/mock.dart';
import 'package:markaa/src/data/models/condition_entity.dart';
import 'package:markaa/src/data/models/index.dart';
import 'package:markaa/src/data/models/product_model.dart';
import 'package:markaa/src/utils/repositories/firebase_repository.dart';
import 'package:markaa/src/utils/repositories/local_storage_repository.dart';
import 'package:markaa/src/utils/repositories/my_cart_repository.dart';
import 'package:markaa/src/utils/services/flushbar_service.dart';
import 'package:markaa/src/utils/services/numeric_service.dart';
import 'package:markaa/src/utils/services/string_service.dart';

class MyCartChangeNotifier extends ChangeNotifier {
  final myCartRepository = MyCartRepository();
  final localStorageRepository = LocalStorageRepository();
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

  /// cart items count with product id as key
  Map<String, int> cartItemsCountMap = {};

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
  String? type;

  /// coupon apply status
  bool isApplying = false;

  double getDiscountedPrice(CartItemEntity item, {bool isRowPrice = true}) {
    double price = .0;
    bool cartConditionMatched = true;
    for (var condition in this.cartConditions) {
      if (condition.attribute == 'price' || condition.attribute == 'special_price') {
        if (condition.attribute == 'price') {
          price = StringService.roundDouble(item.product.beforePrice!, 3);
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
        cartConditionMatched =
            condition.operator == '==' ? item.product.sku == condition.value : item.product.sku != condition.value;
      } else if (condition.attribute == 'manufacturer') {
        cartConditionMatched = condition.operator == '=='
            ? item.product.brandEntity!.optionId == condition.value
            : item.product.brandEntity!.optionId != condition.value;
      } else if (condition.attribute == 'category_ids') {
        List<String> values = condition.value.split(', ');
        cartConditionMatched = condition.operator == '=='
            ? values.any(
                (value) => item.product.categories!.contains(value) || item.product.parentCategories!.contains(value))
            : !values.any(
                (value) => item.product.categories!.contains(value) || item.product.parentCategories!.contains(value));
      }
    }
    bool productConditionMatched = true;
    for (var condition in this.productConditions) {
      if (condition.attribute == 'price' || condition.attribute == 'special_price') {
        if (condition.attribute == 'price') {
          price = StringService.roundDouble(item.product.beforePrice!, 3);
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
        productConditionMatched =
            condition.operator == '==' ? item.product.sku == condition.value : item.product.sku != condition.value;
      } else if (condition.attribute == 'manufacturer') {
        productConditionMatched = condition.operator == '=='
            ? item.product.brandEntity?.optionId == condition.value
            : item.product.brandEntity?.optionId != condition.value;
      } else if (condition.attribute == 'category_ids') {
        List<String> values = condition.value.split(', ');
        productConditionMatched = condition.operator == '=='
            ? values.any(
                (value) => item.product.categories!.contains(value) || item.product.parentCategories!.contains(value))
            : !values.any(
                (value) => item.product.categories!.contains(value) || item.product.parentCategories!.contains(value));
      }
    }
    bool isOkay =
        (cartConditionMatched == this.isOkayCartCondition) && (productConditionMatched == this.isOkayProductCondition);
    if (isRowPrice) {
      return isOkay ? NumericService.roundDouble(item.rowPrice * (100 - discount) / 100, 3) : item.rowPrice;
    } else {
      return isOkay
          ? NumericService.roundDouble(double.parse(item.product.price) * (100 - discount) / 100, 3)
          : StringService.roundDouble(item.product.price, 3);
    }
  }

  void initialize([bool isFullRefresh = true]) {
    if (isFullRefresh) this.cartId = '';
    this.cartItemCount = 0;
    this.cartTotalPrice = .0;
    this.cartTotalCount = 0;
    this.cartDiscountedTotalPrice = 0;
    this.cartItemsMap = {};
    this.cartItemsCountMap = {};
    this.reorderCartId = '';
    this.reorderCartItemCount = 0;
    this.reorderCartTotalCount = 0;
    this.reorderCartTotalPrice = .0;
    this.reorderCartItemsMap = {};
    this.type = '';
    this.couponCode = '';
    this.discount = .0;
    this.isOkayCartCondition = true;
    this.isOkayProductCondition = true;
    this.cartConditions = [];
    this.productConditions = [];
    if (isFullRefresh) notifyListeners();
  }

  Future<String> getCartId() async {
    try {
      if (user != null) {
        this.cartId = await myCartRepository.getShoppingCart(user!.token);
      } else {
        bool isExist = await localStorageRepository.existItem('cartId');
        if (isExist) {
          this.cartId = await localStorageRepository.getCartId();
        } else {
          this.cartId = await myCartRepository.getShoppingCart();
          if (this.cartId.isNotEmpty) {
            await localStorageRepository.setCartId(this.cartId);
          }
        }
      }
      notifyListeners();
      return this.cartId;
    } catch (e) {
      print('GET SHOPPING CART ID CATCH ERROR: $e');
      return '';
    }
  }

  Future<void> getCartItems(
    String lang, [
    Function? onProcess,
    Function? onSuccess,
    Function? onFailure,
  ]) async {
    final data = {'action': 'getCartItems'};
    this.initialize(false);
    if (onProcess != null) onProcess();
    try {
      if (this.cartId.isEmpty) this.cartId = await this.getCartId();
      if (this.cartId.isNotEmpty) {
        final result = await myCartRepository.getCartItems(this.cartId, lang);
        if (result['code'] == 'SUCCESS') {
          this.couponCode = result['couponCode'];
          this.discount = result['discount'] + .0;
          this.type = result['type'];
          this.cartConditions = result['cartCondition'];
          this.productConditions = result['productCondition'];
          this.isOkayCartCondition = result['isCartConditionOkay'];
          this.isOkayProductCondition = result['isProductConditionOkay'];
          this.cartItemCount = result['items'].length;
          for (CartItemEntity item in result['items']) {
            this.cartItemsCountMap[item.product.productId] = item.itemCount;
            this.cartItemsMap[item.itemId] = item;
            this.cartTotalPrice += item.rowPrice;
            this.cartTotalCount += item.itemCount;
            this.cartDiscountedTotalPrice += this.getDiscountedPrice(item);
          }
          if (onSuccess != null) onSuccess(cartItemCount);
          notifyListeners();
        } else {
          if (onFailure != null) onFailure(result['errorMessage']);
          this._reportCartIssue(result, data);
          notifyListeners();
        }
      }
    } catch (e) {
      if (onFailure != null) onFailure('connection_error');
      this._reportCartIssue(e.toString(), data);
      notifyListeners();
    }
  }

  Future<void> removeCartItem(String key, Function onFailure) async {
    final data = {'action': 'removeCartItem', 'productId': key};
    final item = cartItemsMap[key]!;
    this._onRemoveHandler(item, key);
    notifyListeners();
    try {
      final result = await myCartRepository.deleteCartItem(this.cartId, key);
      if (result['code'] != 'SUCCESS') {
        onFailure(result['errorMessage']);
        this._onRemoveFailedHandler(item, key);
        this._reportCartIssue(result, data);
        notifyListeners();
      }
    } catch (e) {
      onFailure('connection_error');
      this._onRemoveFailedHandler(item, key);
      this._reportCartIssue(e.toString(), data);
      notifyListeners();
    }
  }

  _onRemoveHandler(CartItemEntity item, String key) {
    this.cartTotalPrice -= this.cartItemsMap[key]!.rowPrice;
    this.cartDiscountedTotalPrice -= this.getDiscountedPrice(item);
    this.cartItemCount -= 1;
    this.cartTotalCount -= this.cartItemsMap[key]!.itemCount;
    this.cartItemsMap.remove(key);
    this.cartItemsCountMap.remove(item.product.productId);
  }

  _onRemoveFailedHandler(CartItemEntity item, String key) {
    this.cartTotalPrice += item.rowPrice;
    this.cartDiscountedTotalPrice += this.getDiscountedPrice(item);
    this.cartItemCount += 1;
    this.cartTotalCount += item.itemCount;
    this.cartItemsMap[key] = item;
    this.cartItemsCountMap[item.product.productId] = item.itemCount;
  }

  Future<void> addProductToCart(
    ProductModel product,
    int qty,
    String lang,
    Map<String, dynamic> options, {
    Function? onProcess,
    Function? onSuccess,
    Function? onFailure,
  }) async {
    if (onProcess != null) onProcess();
    if (this.cartId.isEmpty) await this.getCartItems(lang);
    if (this.cartId.isNotEmpty) {
      final data = {'action': 'addProductToCart', 'productId': product.productId, 'qty': qty, 'options': options};
      try {
        final result = await myCartRepository.addCartItem(this.cartId, product.productId, '$qty', lang, options);
        if (result['code'] == 'SUCCESS') {
          CartItemEntity newItem = result['item'];
          this._onAddItemHandler(newItem, qty);
          if (onSuccess != null) onSuccess();
          notifyListeners();
        } else {
          if (onFailure != null) onFailure(result['errorMessage']);
          this._reportCartIssue(result, data);
        }
      } catch (e) {
        if (onFailure != null) onFailure('connection_error');
        this._reportCartIssue(e.toString(), data);
      }
    }
  }

  _onAddItemHandler(CartItemEntity newItem, int qty) {
    if (this.cartItemsMap.containsKey(newItem.itemId)) {
      CartItemEntity oldItem = cartItemsMap[newItem.itemId]!;
      this.cartTotalPrice -= oldItem.rowPrice;
      this.cartDiscountedTotalPrice -= this.getDiscountedPrice(oldItem);
    } else {
      this.cartItemCount += 1;
    }
    this.cartTotalCount += qty;
    this.cartTotalPrice += newItem.rowPrice;
    this.cartDiscountedTotalPrice += this.getDiscountedPrice(newItem);
    this.cartItemsMap[newItem.itemId] = newItem;
    this.cartItemsCountMap[newItem.product.productId] = newItem.itemCount;
  }

  Future<void> updateCartItem(CartItemEntity item, int qty, Function onFailure) async {
    if (this.cartId.isEmpty) await this.getCartItems(lang);
    if (this.cartId.isNotEmpty) {
      final data = {'action': 'updateCartItem', 'itemid': item.itemId, 'qty': qty, 'lang': lang};
      int updatedQty = qty - item.itemCount;
      double updatedPrice = StringService.roundDouble(item.product.price, 3) * updatedQty;
      this._onUpdateHandler(qty, updatedQty, updatedPrice, item);
      notifyListeners();

      try {
        final result = await myCartRepository.updateCartItem(this.cartId, item.itemId, qty.toString());
        if (result['code'] != 'SUCCESS') {
          onFailure(result['errorMessage']);
          this._onUpdateFailedHandler(updatedQty, updatedPrice, item);
          this._reportCartIssue(result, data);
          notifyListeners();
        }
      } catch (e) {
        onFailure('connection_error');
        this._onUpdateFailedHandler(updatedQty, updatedPrice, item);
        this._reportCartIssue(e.toString(), data);
        notifyListeners();
      }
    }
  }

  _onUpdateHandler(int qty, int updatedQty, double updatedPrice, CartItemEntity item) {
    this.cartTotalCount += updatedQty;
    this.cartTotalPrice += updatedPrice;
    this.cartDiscountedTotalPrice -= this.getDiscountedPrice(this.cartItemsMap[item.itemId]!);
    this.cartItemsMap[item.itemId]!.itemCount = qty;
    this.cartItemsMap[item.itemId]!.rowPrice = StringService.roundDouble(item.product.price, 3) * qty;
    this.cartDiscountedTotalPrice += this.getDiscountedPrice(this.cartItemsMap[item.itemId]!);
    this.cartItemsCountMap[item.product.productId] = qty;
  }

  _onUpdateFailedHandler(int updatedQty, double updatedPrice, CartItemEntity item) {
    this.cartTotalCount -= updatedQty;
    this.cartTotalPrice -= updatedPrice;
    this.cartDiscountedTotalPrice -= this.getDiscountedPrice(this.cartItemsMap[item.itemId]!);
    this.cartItemsMap[item.itemId]!.itemCount = item.itemCount;
    this.cartItemsMap[item.itemId]!.rowPrice = StringService.roundDouble(item.product.price, 3) * item.itemCount;
    this.cartDiscountedTotalPrice += this.getDiscountedPrice(this.cartItemsMap[item.itemId]!);
    this.cartItemsCountMap[item.product.productId] = item.itemCount;
  }

  Future<bool> activateCart() async {
    try {
      final result = await myCartRepository.activateCart(this.cartId);
      if (result['code'] == 'SUCCESS') {
        return true;
      } else {
        print('activated failure: ${result['errorMessage']}');
        return false;
      }
    } catch (e) {
      print('activated catch failure:  $e');
      return false;
    }
  }

  Future<void> getReorderCartItems(
    String lang, {
    Function? onProcess,
    Function? onSuccess,
    Function? onFailure,
  }) async {
    if (onProcess != null) onProcess();
    final result = await myCartRepository.getCartItems(this.reorderCartId, lang);
    if (result['code'] == 'SUCCESS') {
      this.reorderCartItemCount = result['items'].length;
      for (CartItemEntity item in result['items']) {
        this.reorderCartItemsMap[item.itemId] = item;
        this.reorderCartTotalPrice += item.rowPrice;
        this.reorderCartTotalCount += item.itemCount;
      }
      if (onSuccess != null) onSuccess();
    } else {
      if (onFailure != null) onFailure();
    }
    notifyListeners();
  }

  Future<void> removeReorderCartItem(String key) async {
    this.reorderCartTotalPrice -= this.reorderCartItemsMap[key]!.rowPrice;
    this.reorderCartItemCount -= 1;
    this.reorderCartTotalCount -= this.reorderCartItemsMap[key]!.itemCount;
    this.reorderCartItemsMap.remove(key);
    notifyListeners();
    await myCartRepository.deleteCartItem(this.reorderCartId, key);
  }

  Future<void> getReorderCartId(
    String orderId,
    String lang, {
    Function? onProcess,
    Function? onSuccess,
    Function? onFailure,
  }) async {
    if (onProcess != null) onProcess();
    try {
      this.reorderCartId = await myCartRepository.getReorderCartId(orderId, lang);
      if (onSuccess != null) onSuccess();
    } catch (e) {
      if (onFailure != null) onFailure();
    }
  }

  void initializeReorderCart() {
    this.reorderCartId = '';
    this.reorderCartItemCount = 0;
    this.reorderCartTotalCount = 0;
    this.reorderCartTotalPrice = .0;
    this.reorderCartItemsMap = {};
  }

  Future<void> applyCouponCode(
    String code,
    FlushBarService flushBarService,
  ) async {
    this.isApplying = true;
    notifyListeners();
    final result = await myCartRepository.couponCode(this.cartId, code, '0');
    if (result['code'] == 'SUCCESS') {
      this.couponCode = code;
      this.discount = result['discount'] + .0;
      this.type = result['type'];
      this.isApplying = false;
      this.cartConditions = result['cartCondition'];
      this.productConditions = result['productCondition'];
      this.isOkayCartCondition = result['isCartConditionOkay'];
      this.isOkayProductCondition = result['isProductConditionOkay'];
      resetDiscountPrice();
    } else {
      flushBarService.showErrorDialog(result['errorMessage']);
      this.isApplying = false;
    }
    notifyListeners();
  }

  void resetDiscountPrice() {
    this.cartDiscountedTotalPrice = 0;
    for (var key in this.cartItemsMap.keys.toList()) {
      final item = this.cartItemsMap[key]!;
      this.cartDiscountedTotalPrice += this.getDiscountedPrice(item);
    }
  }

  Future<void> cancelCouponCode(
    FlushBarService flushBarService,
  ) async {
    this.isApplying = true;
    notifyListeners();
    final result = await myCartRepository.couponCode(this.cartId, this.couponCode, '1');
    if (result['code'] == 'SUCCESS') {
      this.couponCode = '';
      this.discount = .0;
      this.type = '';
      this.isApplying = false;
      this.cartDiscountedTotalPrice = this.cartTotalPrice;
      this.cartConditions.clear();
      this.productConditions.clear();
      this.isOkayCartCondition = true;
      this.isOkayProductCondition = true;
    } else {
      flushBarService.showErrorDialog(result['errorMessage']);
      this.isApplying = false;
    }
    notifyListeners();
  }

  Future<void> transferCartItems() async {
    final viewerCartId = await localStorageRepository.getCartId();
    await myCartRepository.transferCart(viewerCartId, this.cartId);
  }

  void _reportCartIssue(dynamic result, dynamic data) async {
    data['cartId'] = this.cartId;
    Map<String, dynamic> appVersion = {'android': MarkaaVersion.androidVersion, 'iOS': MarkaaVersion.iOSVersion};
    SlackChannels.send(
      '$env CART ERROR: ${result.toString()} \r\n ${data.toString()} \r\n [${Platform.isAndroid ? 'Android => ${MarkaaVersion.androidVersion}' : 'iOS => ${MarkaaVersion.iOSVersion}'}] \r\n [customer_info => ${user?.toJson() ?? 'Guest'}] \r\n [DashboardVisitorUrl => $gDashboardVisitorUrl] [DashboardSessionUrl => $gDashboardSessionUrl]',
      SlackChannels.logCartError,
    );
    final date = DateFormat('yyyy-MM-dd', 'en_US').format(DateTime.now());
    final reportData = {
      'result': result,
      'collectData': data,
      'customer': user?.token != null ? user!.toJson() : 'guest',
      'createdAt': DateFormat('yyyy-MM-dd hh:mm:ss', 'en_US').format(DateTime.now()),
      'appVersion': appVersion,
      'platform': Platform.isAndroid ? 'Android' : 'IOS',
      'lang': lang
    };
    final path = FirebasePath.CART_ISSUE_COLL_PATH.replaceFirst('date', date);
    await firebaseRepository.addToCollection(reportData, path);
  }
}
