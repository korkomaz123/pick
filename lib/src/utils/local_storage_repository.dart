import 'package:cross_local_storage/cross_local_storage.dart';

class LocalStorageRepository {
  final Future<LocalStorageInterface> localStorage = LocalStorage.getInstance();

  Future<List<String>> getWishlistIds() async {
    List<String> wishlists = (await localStorage).containsKey('wishlist')
        ? (await localStorage).getStringList('wishlist')
        : [];
    return wishlists;
  }

  Future<String> getToken() async {
    String token = (await localStorage).containsKey('token')
        ? (await localStorage).getString('token')
        : '';
    return token;
  }

  Future<String> getCartId() async {
    String cartId = (await localStorage).containsKey('cartId')
        ? (await localStorage).getString('cartId')
        : '';
    return cartId;
  }

  Future<void> setToken(String token) async {
    await (await localStorage).setString('token', token);
  }

  Future<void> removeToken() async {
    await (await localStorage).remove('token');
  }

  Future<void> addWishlistItem(String id) async {
    List<String> wishlists = await getWishlistIds();
    wishlists.add(id);
    await (await localStorage).setStringList('wishlist', wishlists);
  }

  Future<void> removeWishlistItem(String id) async {
    List<String> wishlists = await getWishlistIds();
    int index = wishlists.indexOf(id);
    if (index != -1) wishlists.removeAt(index);
    await (await localStorage).setStringList('wishlist', wishlists);
  }

  Future<void> clearWishlistItem() async {
    await (await localStorage).setStringList('wishlist', []);
  }

  Future<void> setCartId(String cartId) async {
    await (await localStorage).setString('cartId', cartId);
  }
}
