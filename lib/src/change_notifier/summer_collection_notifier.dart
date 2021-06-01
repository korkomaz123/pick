import 'package:flutter/material.dart';
import 'package:markaa/src/data/models/summer_collection_entity.dart';
import 'package:markaa/src/utils/repositories/category_repository.dart';

import '../../preload.dart';

class SummerCollectionNotifier extends ChangeNotifier {
  final CategoryRepository categoryRepository = CategoryRepository();

  List<SummerCollectionEntity> categories = [];
  Future getSummerCollection() async {
    final result = await categoryRepository.getSummerCollection(Preload.language);
    if (result['code'] == 'SUCCESS') {
      List<dynamic> categoryList = result['data'];
      categories = [];
      for (int i = 0; i < categoryList.length; i++) {
        categories.add(SummerCollectionEntity.fromJson(categoryList[i]));
      }
    }
    notifyListeners();
  }
}
