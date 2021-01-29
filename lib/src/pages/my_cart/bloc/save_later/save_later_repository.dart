import 'package:markaa/src/apis/api.dart';
import 'package:markaa/src/apis/endpoints.dart';
import 'package:markaa/src/data/models/product_model.dart';

class SaveLaterRepository {
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
    String action,
    int qty,
  ) async {
    final url = EndPoints.changeSaveForLaterItem;
    final params = {
      'token': token,
      'productId': productId,
      'action': action,
      'qty': qty.toString(),
    };
    return await Api.postMethod(url, data: params);
  }
}