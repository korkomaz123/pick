import 'dart:convert';

import 'package:markaa/src/apis/api.dart';
import 'package:markaa/src/apis/endpoints.dart';
import 'package:markaa/src/data/models/product_model.dart';

class WishlistRepository {
  //////////////////////////////////////////////////////////////////////////////
  /// [LOAD SAVE FOR LATER ITEMS]
  //////////////////////////////////////////////////////////////////////////////
  Future<dynamic> getSaveForLaterItems(String token, String lang) async {
    final url = EndPoints.getSaveForLaterItems;
    final params = {'token': token, 'lang': lang};
    final result = await Api.postMethod(url, data: params);
    if (result['code'] == 'SUCCESS') {
      List<dynamic> list = result['wishlists'];
      List<ProductModel> items = [];
      for (int i = 0; i < list.length; i++) {
        items.add(ProductModel.fromJson(list[i]));
      }
      return {'code': 'SUCCESS', 'items': items};
    }
    return result;
  }

  //////////////////////////////////////////////////////////////////////////////
  /// [ADD/REMOVE ITEMS FOR SAVE LATER]
  //////////////////////////////////////////////////////////////////////////////
  Future<dynamic> changeSaveForLaterItem(
    String token,
    String productId,
    String parentId,
    String action,
    int qty,
    Map<String, dynamic> options, [
    String? itemId,
  ]) async {
    final url = EndPoints.changeSaveForLaterItem;
    final params = {
      'token': token,
      'productId': productId,
      'parentId': parentId,
      'action': action,
      'qty': qty.toString(),
      'option': jsonEncode(options),
      'itemId': itemId ?? '',
    };
    print(params);
    return await Api.postMethod(url, data: params);
  }
}
