import 'package:ciga/src/apis/api.dart';
import 'package:ciga/src/apis/endpoints.dart';
import 'package:ciga/src/data/models/brand_entity.dart';
import 'package:ciga/src/data/models/category_entity.dart';
import 'package:ciga/src/data/models/product_model.dart';
import 'package:ciga/src/data/models/slider_image_entity.dart';

class HomeRepository {
  //////////////////////////////////////////////////////////////////////////////
  ///
  //////////////////////////////////////////////////////////////////////////////
  Future<List<SliderImageEntity>> getHomeSliderImages() async {
    String url = EndPoints.getHomeSliders;
    final result = await Api.getMethod(url);
    List<dynamic> data = result['data'];
    return data.map((e) => SliderImageEntity.fromJson(e)).toList();
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
  Future<List<ProductModel>> getNewArrivalsProducts(String lang) async {
    String url = EndPoints.getNewArrivals;
    final result = await Api.getMethod(url, data: {'lang': lang});
    List<dynamic> data = result['products'];
    return data.map((e) => ProductModel.fromJson(e)).toList();
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
  Future<List<CategoryEntity>> getAllCategories(String lang) async {
    String url = EndPoints.getAllCategories;
    final result = await Api.getMethod(url, data: {'lang': lang});
    List<dynamic> data = result['categories'];
    return data.map((e) => CategoryEntity.fromJson(e)).toList();
  }

  //////////////////////////////////////////////////////////////////////////////
  ///
  //////////////////////////////////////////////////////////////////////////////
  Future<List<BrandEntity>> getAllBrands() async {
    String url = EndPoints.getAllBrands;
    final result = await Api.getMethod(url);
    List<dynamic> data = result['brand'];
    return data.map((e) => BrandEntity.fromJson(e)).toList();
  }
}
