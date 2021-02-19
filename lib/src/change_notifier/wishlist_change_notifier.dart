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
  ) async {
    product.qtySaveForLater = qty;
    wishlistItemsMap[product.productId] = product;
    wishlistItemsCount += 1;
    notifyListeners();
    await wishlistRepository.changeSaveForLaterItem(
        token, product.productId, 'add', qty);
  }

  Future<void> removeItemFromWishlist(String token, String productId) async {
    final item = wishlistItemsMap[productId];
    wishlistItemsMap.remove(productId);
    wishlistItemsCount -= 1;
    notifyListeners();
    await wishlistRepository.changeSaveForLaterItem(
        token, productId, 'delete', item.qtySaveForLater);
  }
}
