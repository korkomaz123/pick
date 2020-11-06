import 'dart:convert';

import 'package:ciga/src/apis/api.dart';
import 'package:ciga/src/apis/endpoints.dart';

class WishlistRepository {
  //////////////////////////////////////////////////////////////////////////////
  ///
  //////////////////////////////////////////////////////////////////////////////
  Future<dynamic> getWishlists(List<String> ids, String token) async {
    String url = EndPoints.getWishlist;
    final params = {'token': token, 'wishlists': json.encode(ids)};
    return await Api.postMethod(url, data: params);
  }
}
