import 'package:markaa/src/apis/api.dart';
import 'package:markaa/src/apis/endpoints.dart';
import 'package:markaa/src/data/models/index.dart';

class HomeRepository {
  //////////////////////////////////////////////////////////////////////////////
  ///
  //////////////////////////////////////////////////////////////////////////////
  Future<dynamic> getPopupItem(String lang) async {
    String url = EndPoints.getPopup;
    final params = {'lang': lang};
    return await Api.getMethod(url, data: params);
  }

  //////////////////////////////////////////////////////////////////////////////
  ///
  //////////////////////////////////////////////////////////////////////////////
  Future<dynamic> getHomeSliderImages(String lang) async {
    String url = EndPoints.getHomeSliders;
    final params = {'lang': lang};
    return await Api.getMethod(url, data: params);
  }

  //////////////////////////////////////////////////////////////////////////////
  ///
  //////////////////////////////////////////////////////////////////////////////
  Future<dynamic> getHomeAds(String lang) async {
    String url = EndPoints.getHomeAds;
    final params = {'lang': lang};
    return await Api.getMethod(url, data: params);
  }

  //////////////////////////////////////////////////////////////////////////////
  ///
  //////////////////////////////////////////////////////////////////////////////
  Future<dynamic> getHomeMegaBanner(String lang) async {
    String url = EndPoints.getMegaBanner;
    final params = {'lang': lang};
    return await Api.getMethod(url, data: params);
  }

  //////////////////////////////////////////////////////////////////////////////
  ///
  //////////////////////////////////////////////////////////////////////////////
  Future<dynamic> getHomeExculisiveBanner(String lang) async {
    String url = EndPoints.getExculisiveBanner;
    final params = {'lang': lang};
    return await Api.getMethod(url, data: params);
  }

  //////////////////////////////////////////////////////////////////////////////
  ///
  //////////////////////////////////////////////////////////////////////////////
  Future<dynamic> getHomeSection(String lang, String url) async {
    final params = {'lang': lang};
    final result = await Api.getMethod(url, data: params);
    if (result['code'] == 'SUCCESS') {
      String title = result['title'];
      SliderImageEntity viewAll;
      List<SliderImageEntity> banners = [];
      List<ProductModel> products = [];
      viewAll = SliderImageEntity.fromJson(result['view_all']);
      for (var banner in result['image']) {
        banners.add(SliderImageEntity.fromJson(banner));
      }
      for (var product in result['product']) {
        products.add(ProductModel.fromJson(product));
      }
      return {
        'code': 'SUCCESS',
        'title': title,
        'viewAll': viewAll,
        'banners': banners,
        'products': products
      };
    } else {
      return {'code': 'ERROR'};
    }
  }

  //////////////////////////////////////////////////////////////////////////////
  ///
  //////////////////////////////////////////////////////////////////////////////
  Future<dynamic> getHomeNewArrivalsBanners(String lang) async {
    String url = EndPoints.getNewarrivalBanner;
    final params = {'lang': lang};
    return await Api.getMethod(url, data: params);
  }

  //////////////////////////////////////////////////////////////////////////////
  ///
  //////////////////////////////////////////////////////////////////////////////
  Future<dynamic> getHomeFragrancesBanners(String lang) async {
    String url = EndPoints.getFragrancesBanner;
    final params = {'lang': lang};
    return await Api.getMethod(url, data: params);
  }

  //////////////////////////////////////////////////////////////////////////////
  ///
  //////////////////////////////////////////////////////////////////////////////
  Future<dynamic> getHomeBestWatches(String lang) async {
    String url = EndPoints.getWatchesSection;
    final params = {'lang': lang};
    return await Api.getMethod(url, data: params);
  }

  //////////////////////////////////////////////////////////////////////////////
  ///
  //////////////////////////////////////////////////////////////////////////////
  Future<dynamic> getHomeGrooming(String lang) async {
    String url = EndPoints.getGroomingSection;
    final params = {'lang': lang};
    return await Api.getMethod(url, data: params);
  }

  //////////////////////////////////////////////////////////////////////////////
  ///
  //////////////////////////////////////////////////////////////////////////////
  Future<dynamic> getHomeSmartTech(String lang) async {
    String url = EndPoints.getSmartTechSection;
    final params = {'lang': lang};
    return await Api.getMethod(url, data: params);
  }
}
