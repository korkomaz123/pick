import 'package:ciga/src/apis/api.dart';
import 'package:ciga/src/apis/endpoints.dart';

class WishlistRepository {
  //////////////////////////////////////////////////////////////////////////////
  ///
  //////////////////////////////////////////////////////////////////////////////
  Future<dynamic> getWishlists(
    String token,
    String lang,
  ) async {
    String url = EndPoints.getWishlist;
    final params = {'token': token, 'lang': lang};
    print(url);
    print(params);
    return await Api.postMethod(url, data: params);
  }

  //////////////////////////////////////////////////////////////////////////////
  ///
  //////////////////////////////////////////////////////////////////////////////
  Future<bool> changeWishlist(
    String token,
    String productId,
    String action,
  ) async {
    String url = EndPoints.addWishlist;
    final params = {'token': token, 'productId': productId, 'action': action};
    final result = await Api.postMethod(url, data: params);
    return result['code'] == 'SUCCESS';
  }

  //////////////////////////////////////////////////////////////////////////////
  ///
  //////////////////////////////////////////////////////////////////////////////
  Future<bool> checkWishlistStatus(String token, String productId) async {
    try {
      String url = EndPoints.checkWishlistStatus;
      final params = {'token': token, 'productId': productId};
      final result = await Api.postMethod(url, data: params);
      return result['code'] == 'SUCCESS' && result['isWishlisted'];
    } catch (e) {
      return false;
    }
  }
}
