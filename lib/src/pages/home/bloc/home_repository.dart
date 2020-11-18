import 'package:ciga/src/apis/api.dart';
import 'package:ciga/src/apis/endpoints.dart';

class HomeRepository {
  //////////////////////////////////////////////////////////////////////////////
  ///
  //////////////////////////////////////////////////////////////////////////////
  Future<dynamic> getHomeSliderImages() async {
    String url = EndPoints.getHomeSliders;
    return await Api.getMethod(url);
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
