import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageRepository {
  final Future<SharedPreferences> prefs = SharedPreferences.getInstance();

  Future<List<String>> getWishlistIds() async {
    List<String> wishlists = (await prefs).containsKey('wishlist')
        ? (await prefs).getStringList('wishlist')
        : [];
    return wishlists;
  }

  Future<List<String>> getRecentlyViewedIds() async {
    List<String> recentlyViews = (await prefs).containsKey('recently-viewed')
        ? (await prefs).getStringList('recently-viewed')
        : [];
    return recentlyViews;
  }

  Future<String> getToken() async {
    String token = (await prefs).containsKey('token')
        ? (await prefs).getString('token')
        : '';
    return token;
  }

  Future<String> getCartId() async {
    String cartId = (await prefs).containsKey('cartId')
        ? (await prefs).getString('cartId')
        : '';
    return cartId;
  }

  Future<void> setToken(String token) async {
    await (await prefs).setString('token', token);
  }

  Future<void> removeToken() async {
    await (await prefs).remove('token');
  }

  Future<void> addWishlistItem(String id) async {
    List<String> wishlists = await getWishlistIds();
    wishlists.add(id);
    await (await prefs).setStringList('wishlist', wishlists);
  }

  Future<void> removeWishlistItem(String id) async {
    List<String> wishlists = await getWishlistIds();
    int index = wishlists.indexOf(id);
    if (index != -1) wishlists.removeAt(index);
    await (await prefs).setStringList('wishlist', wishlists);
  }

  Future<void> addRecentlyViewedItem(String id) async {
    List<String> recentlyViews = await getRecentlyViewedIds();
    recentlyViews.add(id);
    await (await prefs).setStringList('recently-viewed', recentlyViews);
  }

  Future<void> removeRecentlyViewedItem(String id) async {
    List<String> recentlyViews = await getRecentlyViewedIds();
    int index = recentlyViews.indexOf(id);
    if (index != -1) recentlyViews.removeAt(index);
    await (await prefs).setStringList('recently-viewed', recentlyViews);
  }

  Future<void> clearWishlistItem() async {
    await (await prefs).setStringList('wishlist', []);
  }

  Future<void> setCartId(String cartId) async {
    await (await prefs).setString('cartId', cartId);
  }

  Future<bool> existItem(String key) async {
    return (await prefs).containsKey(key);
  }

  Future<dynamic> getItem(String key) async {
    return json.decode((await prefs).getString(key));
  }

  Future<void> setItem(String key, dynamic data) async {
    return await (await prefs).setString(key, json.encode(data));
  }
}
