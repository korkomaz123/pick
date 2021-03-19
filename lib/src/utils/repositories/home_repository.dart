import 'package:markaa/src/apis/api.dart';
import 'package:markaa/src/apis/endpoints.dart';

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
  Future<dynamic> getHomeBestDealsBanners(String lang) async {
    String url = EndPoints.getBestdealsBanner;
    final params = {'lang': lang};
    return await Api.getMethod(url, data: params);
  }

  //////////////////////////////////////////////////////////////////////////////
  ///
  //////////////////////////////////////////////////////////////////////////////
  Future<dynamic> getHomeNewArrivalsBanners(String lang) async {
    String url = EndPoints.getNewarrivalBanner;
    final params = {'lang': lang};
    return await Api.getMethod(url, data: params);
  }
}
