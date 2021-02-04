import 'package:algolia/algolia.dart';
import 'package:markaa/src/apis/api.dart';
import 'package:markaa/src/apis/endpoints.dart';
import 'package:markaa/src/config/config.dart';
import 'package:markaa/src/data/models/product_model.dart';
import 'package:markaa/src/utils/algolia_service.dart';

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
  Future<List<ProductModel>> getSearchSuggestion(String q, String lang) async {
    // final url = EndPoints.getSearchSuggestion;
    // final params = {'q': query, 'lang': lang};
    // return await Api.getMethod(url, data: params);
    Algolia algolia = AlgoliaService.algolia;
    String index =
        lang == 'en' ? AlgoliaIndexes.enProducts : AlgoliaIndexes.arProducts;
    AlgoliaQuery query = algolia.instance.index(index).search(q);
    AlgoliaQuerySnapshot snap = await query.getObjects();
    List<ProductModel> products = [];
    for (int i = 0; i < snap.hits.length; i++) {
      Map<String, dynamic> data = {};
      AlgoliaObjectSnapshot item = snap.hits[i];
      data['entity_id'] = item.objectID;
      data['name'] = item.data['name'];
      data['price'] = item.data['price']['KWD']['default'].toString();
      data['image_url'] =
          item.data['image_url'].toString().replaceFirst('//', 'https://');
      products.add(ProductModel.fromJson(data));
    }
    return products;
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
