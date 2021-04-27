import 'package:flutter/material.dart';
import 'package:markaa/src/data/models/product_model.dart';
import 'package:markaa/src/utils/repositories/wishlist_repository.dart';

class WishlistChangeNotifier extends ChangeNotifier {
  final WishlistRepository wishlistRepository = WishlistRepository();

  Map<String, ProductModel> wishlistItemsMap = {};
  int wishlistItemsCount = 0;

  void initialize() {
    wishlistItemsMap = {};
    wishlistItemsCount = 0;
    notifyListeners();
  }

  Future<void> getWishlistItems(String token, String lang) async {
    final result = await wishlistRepository.getSaveForLaterItems(token, lang);
    if (result['code'] == 'SUCCESS') {
      List<ProductModel> items = result['items'];
      wishlistItemsCount = items.length;
      for (var item in items) {
        wishlistItemsMap[item.productId] = item;
      }
      notifyListeners();
    }
  }

  Future<void> addItemToWishlist(
    String token,
    ProductModel product,
    int qty,
    Map<String, dynamic> options, [
    ProductModel variant,
  ]) async {
    String productId;
    String parentId = '';
    ProductModel newItem;
    int count = 0;
    if (variant != null) {
      parentId = product.productId;
      productId = variant.productId;
      newItem = variant;
    } else {
      productId = product.productId;
      newItem = product;
    }
    newItem.parentId = parentId;
    if (wishlistItemsMap.containsKey(productId)) {
      ProductModel item = wishlistItemsMap[productId];
      item.qtySaveForLater += qty;
      wishlistItemsMap[productId] = item;
    } else {
      newItem.qtySaveForLater = qty;
      newItem.wishlistItemId = productId;
      wishlistItemsMap[productId] = newItem;
      wishlistItemsCount += 1;
      count = 1;
    }
    notifyListeners();
    final result = await wishlistRepository.changeSaveForLaterItem(token, product.productId, '', 'add', qty, options);
    if (result['code'] != 'SUCCESS') {
      wishlistItemsCount -= count;
      wishlistItemsMap.remove(productId);
      notifyListeners();
    }
  }

  Future<void> removeItemFromWishlist(
    String token,
    ProductModel product, [
    ProductModel variant,
  ]) async {
    String productId;
    String parentId = '';
    if (variant != null) {
      productId = variant.productId;
      parentId = product.productId;
    } else {
      productId = product.productId;
      parentId = product.parentId;
    }
    final item = wishlistItemsMap[productId];
    wishlistItemsMap.remove(productId);
    wishlistItemsCount -= 1;
    notifyListeners();
    await wishlistRepository.changeSaveForLaterItem(token, productId, parentId, 'delete_new', item.qtySaveForLater, {}, item.wishlistItemId);
  }
}
