import 'package:markaa/src/data/models/category_entity.dart';
import 'package:markaa/src/data/models/index.dart';

import 'brand_entity.dart';

class ProductListArguments {
  final CategoryEntity category;
  final BrandEntity brand;
  final List<CategoryEntity> subCategory;
  final int selectedSubCategoryIndex;
  final bool isFromBrand;

  ProductListArguments({
    this.category,
    this.brand,
    this.subCategory,
    this.selectedSubCategoryIndex,
    this.isFromBrand,
  });
}
