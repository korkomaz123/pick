import 'package:ciga/src/data/models/category_entity.dart';
import 'package:ciga/src/data/models/index.dart';

class ProductListArguments {
  final CategoryEntity category;
  final StoreEntity store;
  final List<CategoryEntity> subCategory;
  final int selectedSubCategoryIndex;
  final bool isFromStore;

  ProductListArguments({
    this.category,
    this.store,
    this.subCategory,
    this.selectedSubCategoryIndex,
    this.isFromStore,
  });
}
