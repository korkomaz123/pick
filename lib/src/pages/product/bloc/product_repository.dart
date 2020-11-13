import 'package:ciga/src/apis/api.dart';
import 'package:ciga/src/apis/endpoints.dart';
import 'package:ciga/src/data/models/product_model.dart';

class ProductRepository {
  //////////////////////////////////////////////////////////////////////////////
  ///
  //////////////////////////////////////////////////////////////////////////////
  Future<dynamic> getProducts(String categoryId, String lang) async {
    String url = EndPoints.getCategoryProducts;
    final params = {'categoryId': categoryId, 'lang': lang};
    return await Api.getMethod(url, data: params);
  }

  //////////////////////////////////////////////////////////////////////////////
  ///
  //////////////////////////////////////////////////////////////////////////////
  Future<List<ProductModel>> getPerfumesProducts(String lang) async {
    String url = EndPoints.getPerfumes;
    final result = await Api.getMethod(url, data: {'lang': lang});
    List<dynamic> data = result['products'];
    return data.map((e) => ProductModel.fromJson(e)).toList();
  }

  //////////////////////////////////////////////////////////////////////////////
  ///
  //////////////////////////////////////////////////////////////////////////////
  Future<List<ProductModel>> getNewArrivalsProducts(String lang) async {
    String url = EndPoints.getNewArrivals;
    final result = await Api.getMethod(url, data: {'lang': lang});
    List<dynamic> data = result['products'];
    return data.map((e) => ProductModel.fromJson(e)).toList();
  }

  //////////////////////////////////////////////////////////////////////////////
  ///
  //////////////////////////////////////////////////////////////////////////////
  Future<List<ProductModel>> getBestDealsProducts(String lang) async {
    String url = EndPoints.getBestDeals;
    final result = await Api.getMethod(url, data: {'lang': lang});
    List<dynamic> data = result['products'];
    return data.map((e) => ProductModel.fromJson(e)).toList();
  }

  //////////////////////////////////////////////////////////////////////////////
  ///
  //////////////////////////////////////////////////////////////////////////////
  Future<dynamic> sortProducts(
    String categoryId,
    String sortItem,
    String lang,
  ) async {
    String url = EndPoints.getSortedProducts;
    final params = {
      'currentCategoryId': categoryId,
      'lang': lang,
      'sortItem': sortItem,
    };
    return await Api.getMethod(url, data: params);
  }

  //////////////////////////////////////////////////////////////////////////////
  ///
  //////////////////////////////////////////////////////////////////////////////
  Future<dynamic> getBrandProducts(
    String brandId,
    String categoryId,
    String lang,
  ) async {
    String url = EndPoints.getBrandProducts;
    final params = {'brandId': brandId, 'categoryId': categoryId, 'lang': lang};
    return await Api.getMethod(url, data: params);
  }

  //////////////////////////////////////////////////////////////////////////////
  ///
  //////////////////////////////////////////////////////////////////////////////
  Future<dynamic> getProductDetails(String productId, String lang) async {
    String url = EndPoints.getProductDetails;
    final params = {'productId': productId, 'lang': lang};
    return await Api.getMethod(url, data: params);
  }

  //////////////////////////////////////////////////////////////////////////////
  ///
  //////////////////////////////////////////////////////////////////////////////
  Future<List<ProductModel>> getRelatedProducts(
    String productId,
    String lang,
  ) async {
    String url = EndPoints.getRelatedItems;
    final params = {'productId': productId, 'lang': lang};
    final result = await Api.getMethod(url, data: params);
    if (result['code'] == 'SUCCESS') {
      List<dynamic> productList = result['products'];
      List<ProductModel> products = [];
      for (int i = 0; i < productList.length; i++) {
        products.add(ProductModel.fromJson(productList[i]));
      }
      return products;
    } else {
      return [];
    }
  }

  //////////////////////////////////////////////////////////////////////////////
  ///
  //////////////////////////////////////////////////////////////////////////////
  Future<List<ProductModel>> getSameBrandProducts(
    String productId,
    String lang,
  ) async {
    String url = EndPoints.getSameBrandProducts;
    final params = {'productId': productId, 'lang': lang};
    final result = await Api.getMethod(url, data: params);
    if (result['code'] == 'SUCCESS') {
      List<dynamic> productList = result['products'];
      List<ProductModel> products = [];
      for (int i = 0; i < productList.length; i++) {
        products.add(ProductModel.fromJson(productList[i]));
      }
      return products;
    } else {
      return [];
    }
  }
}
