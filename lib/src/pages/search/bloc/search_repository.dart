import 'package:markaa/src/apis/api.dart';
import 'package:markaa/src/apis/endpoints.dart';

class SearchRepository {
  //////////////////////////////////////////////////////////////////////////////
  ///
  //////////////////////////////////////////////////////////////////////////////
  Future<List<dynamic>> getGenderOptions(String lang) async {
    final url = EndPoints.getSearchAttrOptions;
    final params = {'attribute_code': 'gender', 'lang': lang};
    final result = await Api.postMethod(url, data: params);
    if (result['code'] == 'SUCCESS') {
      return result['data'];
    } else {
      return [];
    }
  }

  //////////////////////////////////////////////////////////////////////////////
  ///
  //////////////////////////////////////////////////////////////////////////////
  Future<List<dynamic>> getCategoryOptions(String lang) async {
    final url = EndPoints.getSearchAttrOptions;
    final params = {'attribute_code': 'category', 'lang': lang};
    final result = await Api.postMethod(url, data: params);
    if (result['code'] == 'SUCCESS') {
      return result['data'];
    } else {
      return [];
    }
  }

  //////////////////////////////////////////////////////////////////////////////
  ///
  //////////////////////////////////////////////////////////////////////////////
  Future<List<dynamic>> getBrandOptions(String lang) async {
    final url = EndPoints.getSearchAttrOptions;
    final params = {'attribute_code': 'brand', 'lang': lang};
    final result = await Api.postMethod(url, data: params);
    if (result['code'] == 'SUCCESS') {
      return result['data'];
    } else {
      return [];
    }
  }

  //////////////////////////////////////////////////////////////////////////////
  ///
  //////////////////////////////////////////////////////////////////////////////
  Future<dynamic> getSearchSuggestion(String query, String lang) async {
    final url = EndPoints.getSearchSuggestion;
    final params = {'q': query, 'lang': lang};
    return await Api.getMethod(url, data: params);
  }

  //////////////////////////////////////////////////////////////////////////////
  ///
  //////////////////////////////////////////////////////////////////////////////
  Future<dynamic> searchProducts(
    String query,
    List<dynamic> categories,
    List<dynamic> brands,
    List<dynamic> genders,
    String lang,
  ) async {
    final url = EndPoints.getSearchedProducts;
    String categoryString = '';
    String brandString = '';
    String genderString = '';
    for (int i = 0; i < categories.length; i++) {
      categoryString += categories[i];
      if (i < categories.length - 1) categoryString += ',';
    }
    for (int i = 0; i < brands.length; i++) {
      brandString += brands[i];
      if (i < brands.length - 1) brandString += ',';
    }
    for (int i = 0; i < genders.length; i++) {
      genderString += genders[i];
      if (i < genders.length - 1) genderString += ',';
    }
    final params = {
      'q': query,
      'categories': categoryString,
      'brands': brandString,
      'gender': genderString,
      'lang': lang,
    };
    return await Api.getMethod(url, data: params);
  }
}
