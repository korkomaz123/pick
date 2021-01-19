import 'package:markaa/src/apis/api.dart';
import 'package:markaa/src/apis/endpoints.dart';
import 'package:markaa/src/data/models/category_entity.dart';
import 'package:markaa/src/data/models/category_menu_entity.dart';

class CategoryRepository {
  //////////////////////////////////////////////////////////////////////////////
  ///
  //////////////////////////////////////////////////////////////////////////////
  Future<List<CategoryEntity>> getAllCategoriesEntity(String lang) async {
    String url = EndPoints.getCategories;
    final result = await Api.getMethod(url, data: {'lang': lang});
    List<dynamic> data = result['categories'];
    return data.map((e) => CategoryEntity.fromJson(e)).toList();
  }

  //////////////////////////////////////////////////////////////////////////////
  ///
  //////////////////////////////////////////////////////////////////////////////
  Future<dynamic> getAllCategories(String lang) async {
    String url = EndPoints.getCategories;
    return await Api.getMethod(url, data: {'lang': lang});
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

  //////////////////////////////////////////////////////////////////////////////
  ///
  //////////////////////////////////////////////////////////////////////////////
  Future<List<CategoryEntity>> getHomeCategories(String lang) async {
    final url = EndPoints.getHomeCategories;
    final params = {'lang': lang};
    final result = await Api.getMethod(url, data: params);
    if (result['code'] == 'SUCCESS') {
      List<dynamic> categoriesList = result['categories'];
      List<CategoryEntity> categories = [];
      for (int i = 0; i < categoriesList.length; i++) {
        categories.add(CategoryEntity.fromJson(categoriesList[i]));
      }
      return categories;
    }
    return [];
  }
}
