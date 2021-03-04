import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:isco_custom_widgets/isco_custom_widgets.dart';
import 'package:markaa/src/data/mock/mock.dart';
import 'package:markaa/src/data/models/index.dart';
import 'package:markaa/src/data/models/product_model.dart';
import 'package:markaa/src/pages/my_cart/bloc/my_cart_repository.dart';
import 'package:markaa/src/utils/flushbar_service.dart';
import 'package:markaa/src/utils/local_storage_repository.dart';

class MyCartChangeNotifier extends ChangeNotifier {
  final MyCartRepository myCartRepository;
  final LocalStorageRepository localStorageRepository;

  MyCartChangeNotifier({
    @required this.myCartRepository,
    @required this.localStorageRepository,
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
    notifyListeners();
  }

  Future<void> getCartItems(String lang) async {
    cartItemCount = 0;
    cartTotalPrice = .0;
    cartTotalCount = 0;
    cartItemsMap = {};
    processStatus = ProcessStatus.process;
    final result = await myCartRepository.getCartItems(cartId, lang);
    if (result['code'] == 'SUCCESS') {
      processStatus = ProcessStatus.done;
      cartItemCount = result['items'].length;
      for (var item in result['items']) {
        cartItemsMap[item.itemId] = item;
        cartTotalPrice += item.rowPrice;
        cartTotalCount += item.itemCount;
      }
      couponCode = result['couponCode'];
      discount = result['discount'] + .0;
      type = result['type'];
    } else {
      processStatus = ProcessStatus.failed;
    }
    notifyListeners();
  }

  Future<void> clearCart() async {
    String clearCartId = cartId;
    initialize();
    notifyListeners();
    cartId = clearCartId;
    await myCartRepository.clearCartItems(clearCartId);
  }

  Future<void> removeCartItem(String key) async {
    cartTotalPrice -= cartItemsMap[key].rowPrice;
    cartItemCount -= 1;
    cartTotalCount -= cartItemsMap[key].itemCount;
    cartItemsMap.remove(key);
    notifyListeners();
    await myCartRepository.deleteCartItem(cartId, key);
  }

  Future<void> addProductToCart(
    BuildContext context,
    PageStyle pageStyle,
    ProductModel product,
    int qty,
    String lang,
    Map<String, dynamic> options,
  ) async {
    final result = await myCartRepository.addCartItem(
      cartId,
      product.productId,
      qty.toString(),
      lang,
      options,
    );
    if (result['code'] == 'SUCCESS') {
      CartItemEntity newItem = result['item'];
      if (cartItemsMap.containsKey(newItem.itemId)) {
        cartTotalPrice -= double.parse(product.price) * qty;
      } else {
        cartItemCount += 1;
      }
      cartTotalCount += qty;
      cartTotalPrice += newItem.rowPrice;
      cartItemsMap[newItem.itemId] = newItem;
      notifyListeners();
      final flushBarService = FlushBarService(context: context);
      flushBarService.showAddCartMessage(pageStyle, product);
    }
  }

  Future<void> updateCartItem(CartItemEntity item, int qty) async {
    int updatedQty = qty - item.itemCount;
    cartTotalCount += updatedQty;
    cartTotalPrice += double.parse(item.product.price) * updatedQty;
    cartItemsMap[item.itemId].itemCount = qty;
    cartItemsMap[item.itemId].rowPrice = double.parse(item.product.price) * qty;
    notifyListeners();
    await myCartRepository.updateCartItem(cartId, item.itemId, qty.toString());
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
    String code,
    FlushBarService flushBarService,
    PageStyle pageStyle,
  ) async {
    final result = await myCartRepository.couponCode(cartId, code, '0');
    if (result['code'] == 'SUCCESS') {
      couponCode = code;
      discount = result['discount'] + .0;
      type = result['type'];
    } else {
      errorMessage = result['errMessage'];
      flushBarService.showErrorMessage(pageStyle, 'incorrect_coupon_code'.tr());
    }
    notifyListeners();
  }

  Future<void> cancelCouponCode(
    FlushBarService flushBarService,
    PageStyle pageStyle,
  ) async {
    final result = await myCartRepository.couponCode(cartId, couponCode, '1');
    if (result['code'] == 'SUCCESS') {
      couponCode = '';
      discount = .0;
      type = '';
      notifyListeners();
    } else {
      flushBarService.showErrorMessage(pageStyle, 'incorrect_coupon_code'.tr());
    }
  }

  Future<void> transferCartItems() async {
    final viewerCartId = await localStorageRepository.getCartId();
    print(viewerCartId);
    print(cartId);
    await myCartRepository.transferCart(viewerCartId, cartId);
  }
}
