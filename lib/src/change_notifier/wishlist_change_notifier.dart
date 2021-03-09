import 'package:flutter/material.dart';
import 'package:markaa/src/data/models/product_model.dart';
import 'package:markaa/src/pages/wishlist/bloc/wishlist_repository.dart';

class WishlistChangeNotifier extends ChangeNotifier {
  final WishlistRepository wishlistRepository;

  WishlistChangeNotifier({this.wishlistRepository});

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
    final result = await wishlistRepository.changeSaveForLaterItem(
        token, product.productId, 'add', qty, options);
    String productId;
    ProductModel newItem;
    if (variant != null) {
      productId = variant.productId;
      newItem = variant;
    } else {
      productId = product.productId;
      newItem = product;
    }
    if (wishlistItemsMap.containsKey(productId)) {
      ProductModel item = wishlistItemsMap[productId];
      item.qtySaveForLater += qty;
      wishlistItemsMap[productId] = item;
    } else {
      newItem.qtySaveForLater = qty;
      newItem.wishlistItemId = result['itemId'];
      wishlistItemsMap[productId] = newItem;
      wishlistItemsCount += 1;
    }
    notifyListeners();
  }

  Future<void> removeItemFromWishlist(
    String token,
    String productId, [
    ProductModel variant,
  ]) async {
    if (variant != null) {
      productId = variant.productId;
    }
    final item = wishlistItemsMap[productId];
    wishlistItemsMap.remove(productId);
    wishlistItemsCount -= 1;
    notifyListeners();
    await wishlistRepository.changeSaveForLaterItem(token, productId, 'delete',
        item.qtySaveForLater, {}, item.wishlistItemId);
  }
}
