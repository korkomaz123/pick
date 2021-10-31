import 'package:flutter/material.dart';
import 'package:markaa/src/data/models/brand_entity.dart';
import 'package:markaa/src/utils/repositories/brand_repository.dart';
import 'package:markaa/src/utils/repositories/local_storage_repository.dart';

class BrandChangeNotifier extends ChangeNotifier {
  BrandChangeNotifier({
    required this.brandRepository,
    required this.localStorageRepository,
  });

  final BrandRepository brandRepository;
  final LocalStorageRepository localStorageRepository;

  List<BrandEntity> brandList = [];
  List<BrandEntity> sortedBrandList = [];

  Future<void> getBrandsList(String lang, String from) async {
    String key = 'brands-$lang-$from';
    final exist = await localStorageRepository.existItem(key);
    if (exist) {
      List<dynamic> list = await localStorageRepository.getItem(key);
      List<BrandEntity> brands = [];
      for (int i = 0; i < list.length; i++) {
        brands.add(BrandEntity.fromJson(list[i]));
      }
      if (from == 'home') {
        brandList = brands;
      } else {
        sortedBrandList = brands;
      }
      notifyListeners();
    }
    final result = await brandRepository.getAllBrands(lang, from);
    if (result['code'] == 'SUCCESS') {
      await localStorageRepository.setItem(key, result['brand']);
      if (!exist) {
        List<dynamic> list = result['brand'];
        List<BrandEntity> brands = [];
        for (int i = 0; i < list.length; i++) {
          brands.add(BrandEntity.fromJson(list[i]));
        }
        if (from == 'home') {
          brandList = brands;
        } else {
          sortedBrandList = brands;
        }
        notifyListeners();
      }
    }
  }
}
