import 'dart:convert';
import 'dart:math';

import 'package:markaa/preload.dart';
import 'package:markaa/src/apis/api.dart';
import 'package:markaa/src/apis/endpoints.dart';
import 'package:markaa/src/data/models/brand_entity.dart';
import 'package:markaa/src/data/models/product_model.dart';
import 'package:markaa/src/data/models/review_entity.dart';

class ProductRepository {
  //////////////////////////////////////////////////////////////////////////////
  ///
  //////////////////////////////////////////////////////////////////////////////
  Future<ProductModel?> getProduct(String productId) async {
    String url = EndPoints.getProduct;
    final params = {'productId': productId, 'lang': Preload.language};
    final result = await Api.getMethod(url, data: params);
    if (result['code'] == 'SUCCESS') {
      return ProductModel.fromJson(result['product']);
    }
    return null;
  }

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
  Future<dynamic> getOrientalProducts(String lang) async {
    String url = EndPoints.getOrientalFragrances;
    return await Api.getMethod(url, data: {'lang': lang});
  }

  //////////////////////////////////////////////////////////////////////////////
  ///
  //////////////////////////////////////////////////////////////////////////////
  Future<dynamic> getHomeRecentlyViewedGuestProducts(
    List<String?> ids,
    String lang,
  ) async {
    String url = EndPoints.getViewedGuestProducts;
    int length = (ids.length / 20).ceil();
    int rest = ids.length % 20;
    Random random = Random();
    int page = random.nextInt(length);
    List<int> viewedIds = [];
    for (int i = 0; i < (page == length - 1 ? rest : 20); i++) {
      int index = page * 20 + i;
      if (ids[index] != null) {
        viewedIds.add(int.parse(ids[index]!));
      } else {
        break;
      }
    }
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
      await Api.postMethod(
        url,
        data: {'token': token, 'productId': productId, 'lang': lang},
      );
    } catch (e) {
      print('UPDATE RECENTLY VIEWED PRODUCT FOR CUSTOMER CATCH ERROR: $e');
    }
  }

  //////////////////////////////////////////////////////////////////////////////
  ///
  //////////////////////////////////////////////////////////////////////////////
  Future<dynamic> sortProducts(
    String? categoryId,
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
    Map<String, dynamic> params = {
      'brandId': brandId,
      'categoryId': categoryId == 'all' ? null : categoryId,
      'lang': lang,
      'page': '$page'
    };
    return await Api.getMethod(url, data: params);
  }

  Future<dynamic> getTopBrandByProductCategory(
    String productId,
    String lang,
  ) async {
    String url = EndPoints.getTopBrandsByCategory;
    Map<String, dynamic> params = {'productId': productId, 'lang': lang};
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

  Future<dynamic> getProductInfo(String productId, String lang) async {
    String url = EndPoints.getProductInfo;
    final params = {'productId': productId, 'lang': lang};
    return await Api.getMethod(url, data: params);
  }

  //////////////////////////////////////////////////////////////////////////////
  ///
  //////////////////////////////////////////////////////////////////////////////
  Future<List<ProductModel>> getRelatedProducts(String productId) async {
    String url = EndPoints.getRelatedItems;
    final params = {'productId': productId, 'lang': Preload.language};
    final result = await Api.getMethod(url, data: params);
    if (result['code'] == 'SUCCESS') {
      List<ProductModel> products = [];
      for (int i = 0; i < result['products'].length; i++) {
        products.add(ProductModel.fromJson(result['products'][i]));
      }
      return products;
    } else {
      return [];
    }
  }

  Future<dynamic> getProductInfoBrand(String productId) async {
    String url = EndPoints.getProductInfoBrand;
    final params = {'productId': productId, 'lang': Preload.language};
    final result = await Api.getMethod(url, data: params);
    if (result['code'] == 'SUCCESS') {
      List<ProductModel> sameBrandProducts = [];

      List<BrandEntity> brands = [];
      if (result['samebranditems'] != null)
        for (int i = 0; i < result['samebranditems'].length; i++) {
          sameBrandProducts
              .add(ProductModel.fromJson(result['samebranditems'][i]));
        }
      if (result['brands'] != null && result['brands'].isNotEmpty)
        result['brands'].forEach((key, obj) {
          brands.add(BrandEntity.fromJson(obj));
        });
      return {
        "sameBrandProducts": sameBrandProducts,
        "brands": brands,
        "category": result['categories'][0]
      };
    } else {
      return {};
    }
  }

  //////////////////////////////////////////////////////////////////////////////
  ///
  //////////////////////////////////////////////////////////////////////////////
  Future<List<ProductModel>> getSameBrandProducts(
    String productId,
  ) async {
    String url = EndPoints.getSameBrandProducts;
    final params = {'productId': productId, 'lang': Preload.language};
    final result = await Api.getMethod(url, data: params);
    if (result['code'] == 'SUCCESS') {
      List<ProductModel> products = [];
      for (int i = 0; i < result['products'].length; i++) {
        products.add(ProductModel.fromJson(result['products'][i]));
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

  //////////////////////////////////////////////////////////////////////////////
  ///
  //////////////////////////////////////////////////////////////////////////////
  Future<dynamic> filterProducts(
    String categoryId,
    String brandId,
    Map<String, dynamic> filterValues,
    String lang,
    int page,
  ) async {
    String url = EndPoints.filterProducts;
    filterValues['selectedValues']['gender'] = filterValues['selectedGenders'];
    final params = {
      'selectedCategoryId': categoryId,
      'selectedBrandId': brandId == '' ? 'all' : brandId,
      'lang': lang,
      'categoryIds': json.encode(filterValues['selectedCategories']),
      'priceRanges':
          json.encode([filterValues['minPrice'], filterValues['maxPrice']]),
      'filter': json.encode(filterValues['selectedValues']),
      'page': page.toString(),
    };
    return await Api.postMethod(url, data: params);
  }
}
