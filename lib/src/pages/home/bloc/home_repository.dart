import 'package:ciga/src/apis/api.dart';
import 'package:ciga/src/apis/endpoints.dart';

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
}
