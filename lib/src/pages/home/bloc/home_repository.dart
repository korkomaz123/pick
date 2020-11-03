import 'package:ciga/src/apis/api.dart';
import 'package:ciga/src/apis/endpoints.dart';
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
}
