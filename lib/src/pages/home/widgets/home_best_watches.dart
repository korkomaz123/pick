import 'package:flutter/material.dart';
import 'package:markaa/src/components/product_vv_card.dart';
import 'package:markaa/src/data/mock/mock.dart';
import 'package:markaa/src/data/models/brand_entity.dart';
import 'package:markaa/src/data/models/category_entity.dart';
import 'package:markaa/src/data/models/product_list_arguments.dart';
import 'package:markaa/src/data/models/product_model.dart';
import 'package:markaa/src/data/models/slider_image_entity.dart';
import 'package:markaa/src/routes/routes.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:markaa/src/change_notifier/home_change_notifier.dart';
import 'package:markaa/src/utils/repositories/product_repository.dart';

class HomeBestWatches extends StatefulWidget {
  @override
  _HomeBestWatchSecties createState() => _HomeBestWatchSecties();
}

class _HomeBestWatchSecties extends State<HomeBestWatches> {
  HomeChangeNotifier homeChangeNotifier;
  ProductRepository productRepository;

  @override
  void initState() {
    super.initState();
    productRepository = context.read<ProductRepository>();
    homeChangeNotifier = context.read<HomeChangeNotifier>();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeChangeNotifier>(
      builder: (_, model, __) {
        return Container(
          width: 375.w,
          child: Column(
            children: [
              if (model.bestWatchesBanner != null) ...[
                _buildBanner(model.bestWatchesBanner)
              ],
              if (model.bestWatchesItems.isNotEmpty) ...[
                _buildProducts(model.bestWatchesItems)
              ]
            ],
          ),
        );
      },
    );
  }

  Widget _buildBanner(SliderImageEntity banner) {
    return InkWell(
      onTap: () async {
        if (banner.categoryId != null) {
          final arguments = ProductListArguments(
            category: CategoryEntity(
              id: banner.categoryId,
              name: banner.categoryName,
            ),
            brand: BrandEntity(),
            subCategory: [],
            selectedSubCategoryIndex: 0,
            isFromBrand: false,
          );
          Navigator.pushNamed(
            context,
            Routes.productList,
            arguments: arguments,
          );
        } else if (banner?.brand?.optionId != null) {
          final arguments = ProductListArguments(
            category: CategoryEntity(),
            brand: banner.brand,
            subCategory: [],
            selectedSubCategoryIndex: 0,
            isFromBrand: true,
          );
          Navigator.pushNamed(
            context,
            Routes.productList,
            arguments: arguments,
          );
        } else if (banner?.productId != null) {
          final product =
              await productRepository.getProduct(banner.productId, lang);
          Navigator.pushNamedAndRemoveUntil(
            context,
            Routes.product,
            (route) => route.settings.name == Routes.home,
            arguments: product,
          );
        }
      },
      child: Image.network(banner.bannerImage),
    );
  }

  Widget _buildProducts(List<ProductModel> list) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(top: 15.h, bottom: 10.h),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: list.map((item) {
            return Container(
              margin: EdgeInsets.only(left: 5.w),
              child: ProductVVCard(
                cardWidth: 170.w,
                cardHeight: 330.h,
                product: item,
                isShoppingCart: true,
                isLine: false,
                isMinor: true,
                isWishlist: true,
                isShare: false,
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
