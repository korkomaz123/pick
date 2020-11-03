import 'package:ciga/src/apis/api.dart';
import 'package:ciga/src/apis/endpoints.dart';
import 'package:ciga/src/data/models/brand_entity.dart';

class BrandRepository {
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
