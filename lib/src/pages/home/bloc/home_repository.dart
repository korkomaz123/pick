import 'package:markaa/src/apis/api.dart';
import 'package:markaa/src/apis/endpoints.dart';

class HomeRepository {
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
  Future<String> getHomeAds() async {
    String url = EndPoints.getHomeAds;
    final result = await Api.getMethod(url);
    if (result['code'] == 'SUCCESS') {
      return result['data']['image'];
    } else {
      return '';
    }
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
