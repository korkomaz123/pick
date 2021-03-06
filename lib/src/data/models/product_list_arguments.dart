import 'package:markaa/src/data/models/index.dart';

class ProductListArguments {
  final CategoryEntity? category;
  final BrandEntity? brand;
  final List<CategoryEntity>? subCategory;
  final int selectedSubCategoryIndex;
  final bool isFromBrand;
  final bool isFromCelebrity;

  ProductListArguments({
    this.category,
    this.brand,
    this.subCategory,
    required this.selectedSubCategoryIndex,
    this.isFromBrand = false,
    this.isFromCelebrity = false,
  });
}
