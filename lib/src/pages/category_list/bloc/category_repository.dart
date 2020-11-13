import 'package:ciga/src/apis/api.dart';
import 'package:ciga/src/apis/endpoints.dart';
import 'package:ciga/src/data/models/category_entity.dart';
import 'package:ciga/src/data/models/category_menu_entity.dart';

class CategoryRepository {
  //////////////////////////////////////////////////////////////////////////////
  ///
  //////////////////////////////////////////////////////////////////////////////
  Future<List<CategoryEntity>> getAllCategories(String lang) async {
    String url = EndPoints.getCategories;
    final result = await Api.getMethod(url, data: {'lang': lang});
    List<dynamic> data = result['categories'];
    return data.map((e) => CategoryEntity.fromJson(e)).toList();
  }

  //////////////////////////////////////////////////////////////////////////////
  ///
  //////////////////////////////////////////////////////////////////////////////
  Future<dynamic> getSubCategories(String categoryId, String lang) async {
    final params = {'categoryId': categoryId, 'lang': lang};
    String url = EndPoints.getSubCategories;
    return await Api.getMethod(url, data: params);
  }

  //////////////////////////////////////////////////////////////////////////////
  ///
  //////////////////////////////////////////////////////////////////////////////
  Future<List<CategoryMenuEntity>> getMenuCategories(String lang) async {
    final params = {'lang': lang};
    String url = EndPoints.getSideMenus;
    final result = await Api.getMethod(url, data: params);
    if (result['code'] == 'SUCCESS') {
      List<dynamic> menuList = result['menuCategories'];
      List<CategoryMenuEntity> menus = [];
      for (int i = 0; i < menuList.length; i++) {
        menus.add(CategoryMenuEntity.fromJson(menuList[i]));
      }
      return menus;
    } else {
      return <CategoryMenuEntity>[];
    }
  }
}
