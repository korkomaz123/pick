import 'dart:convert';

import 'package:ciga/src/apis/api.dart';
import 'package:ciga/src/apis/endpoints.dart';
import 'package:ciga/src/data/models/product_model.dart';
import 'package:ciga/src/data/models/review_entity.dart';

class ProductRepository {
  //////////////////////////////////////////////////////////////////////////////
  ///
  //////////////////////////////////////////////////////////////////////////////
  Future<dynamic> getProducts(String categoryId, String lang, int page) async {
    String url = EndPoints.getCategoryProducts;
    final params = {'categoryId': categoryId, 'lang': lang, 'page': '$page'};
    return await Api.getMethod(url, data: params);
  }

  //////////////////////////////////////////////////////////////////////////////
  ///
  //////////////////////////////////////////////////////////////////////////////
  Future<dynamic> getPerfumesProducts(String lang) async {
    String url = EndPoints.getPerfumes;
    return await Api.getMethod(url, data: {'lang': lang});
  }

  //////////////////////////////////////////////////////////////////////////////
  ///
  //////////////////////////////////////////////////////////////////////////////
  Future<dynamic> getNewArrivalsProducts(String lang) async {
    String url = EndPoints.getNewArrivals;
    return await Api.getMethod(url, data: {'lang': lang});
  }

  //////////////////////////////////////////////////////////////////////////////
  ///
  //////////////////////////////////////////////////////////////////////////////
  Future<dynamic> getBestDealsProducts(String lang) async {
    String url = EndPoints.getBestDeals;
    return await Api.getMethod(url, data: {'lang': lang});
  }

  //////////////////////////////////////////////////////////////////////////////
  ///
  //////////////////////////////////////////////////////////////////////////////
  Future<dynamic> getHomeRecentlyViewedGuestProducts(
    List<String> ids,
    String lang,
  ) async {
    String url = EndPoints.getViewedGuestProducts;
    List<int> viewedIds = ids.map((id) => int.parse(id)).toList();
    return await Api.postMethod(
      url,
      data: {'viewedIds': json.encode(viewedIds), 'lang': lang},
    );
  }

  //////////////////////////////////////////////////////////////////////////////
  ///
  //////////////////////////////////////////////////////////////////////////////
  Future<dynamic> getHomeRecentlyViewedCustomerProducts(
    String token,
    String lang,
  ) async {
    String url = EndPoints.getViewedProducts;
    print(url);
    print({'token': token, 'lang': lang});
    return await Api.postMethod(
      url,
      data: {'token': token, 'lang': lang},
    );
  }

  //////////////////////////////////////////////////////////////////////////////
  ///
  //////////////////////////////////////////////////////////////////////////////
  Future<dynamic> setRecentlyViewedCustomerProduct(
    String token,
    String productId,
    String lang,
  ) async {
    String url = EndPoints.sendProductViewed;
    try {
      final result = await Api.postMethod(
        url,
        data: {'token': token, 'productId': productId, 'lang': lang},
      );
      print(result);
    } catch (e) {
      print(e.toString());
    }
  }

  //////////////////////////////////////////////////////////////////////////////
  ///
  //////////////////////////////////////////////////////////////////////////////
  Future<dynamic> sortProducts(
    String categoryId,
    String brandId,
    String sortItem,
    String lang,
    int page,
  ) async {
    String url = EndPoints.getSortedProducts;
    final params = {
      'brandId': brandId,
      'currentCategoryId': categoryId,
      'lang': lang,
      'sortItem': sortItem,
      'page': page.toString(),
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
    int page,
  ) async {
    String url = EndPoints.getBrandProducts;
    Map<String, dynamic> params = {};
    if (categoryId != 'all') {
      params = {
        'brandId': brandId,
        'categoryId': categoryId,
        'lang': lang,
        'page': '$page'
      };
    } else {
      params = {
        'brandId': brandId,
        'categoryId': null,
        'lang': lang,
        'page': '$page'
      };
    }
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

  //////////////////////////////////////////////////////////////////////////////
  ///
  //////////////////////////////////////////////////////////////////////////////
  Future<List<ReviewEntity>> getProductReviews(String productId) async {
    String url = EndPoints.getProductReviews;
    final params = {'product_id': productId};
    final result = await Api.getMethod(url, data: params);
    if (result['code'] == 'SUCCESS') {
      List<dynamic> reviewList = result['reviews'];
      List<ReviewEntity> reviews = [];
      for (int i = 0; i < reviewList.length; i++) {
        reviews.add(ReviewEntity.fromJson(reviewList[i]));
      }
      return reviews;
    } else {
      return <ReviewEntity>[];
    }
  }

  //////////////////////////////////////////////////////////////////////////////
  ///
  //////////////////////////////////////////////////////////////////////////////
  Future<bool> addReview(
    String productId,
    String title,
    String detail,
    String rate,
    String token,
    String username,
  ) async {
    final url = EndPoints.addProductReview;
    final params = {
      'product_id': productId,
      'title': title,
      'detail': detail,
      'rating_value': rate,
      'token': token,
      'nickname': username,
    };
    final result = await Api.postMethod(url, data: params);
    return result['code'] == 'SUCCESS';
  }
}
