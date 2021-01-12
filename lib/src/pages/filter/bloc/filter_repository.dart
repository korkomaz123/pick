import 'dart:convert';

import 'package:ciga/src/apis/api.dart';
import 'package:ciga/src/apis/endpoints.dart';

class FilterRepository {
  //////////////////////////////////////////////////////////////////////////////
  ///
  //////////////////////////////////////////////////////////////////////////////
  Future<dynamic> getFilterAttributes(
    String categoryId,
    String brandId,
    String lang,
  ) async {
    String url = EndPoints.getFilterAttributes;
    final params = {'categoryId': categoryId, 'brandId': brandId, 'lang': lang};
    return await Api.getMethod(url, data: params);
  }

  //////////////////////////////////////////////////////////////////////////////
  ///
  //////////////////////////////////////////////////////////////////////////////
  Future<dynamic> filter(
    List<dynamic> categoryIds,
    List<dynamic> priceRanges,
    List<dynamic> genders,
    List<dynamic> colors,
    List<dynamic> sizes,
    List<dynamic> brands,
    String lang,
  ) async {
    String url = EndPoints.filterProducts;
    final params = {
      'lang': json.encode(lang),
      'categoryIds': json.encode(categoryIds),
      'priceRanges': json.encode(priceRanges),
      'filter': json.encode({
        'color': colors,
        'gender': genders,
        'size': sizes,
        'manufacturer': brands,
      })
    };
    return await Api.postMethod(url, data: params);
  }
}
