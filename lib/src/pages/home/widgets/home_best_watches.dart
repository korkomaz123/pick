import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:markaa/src/components/product_vv_card.dart';
import 'package:markaa/src/data/models/brand_entity.dart';
import 'package:markaa/src/data/models/category_entity.dart';
import 'package:markaa/src/data/models/product_list_arguments.dart';
import 'package:markaa/src/data/models/product_model.dart';
import 'package:markaa/src/data/models/slider_image_entity.dart';
import 'package:markaa/src/routes/routes.dart';
import 'package:markaa/src/change_notifier/home_change_notifier.dart';
import 'package:markaa/src/utils/repositories/product_repository.dart';

import '../../../../config.dart';

class HomeBestWatches extends StatelessWidget {
  final HomeChangeNotifier homeChangeNotifier;
  HomeBestWatches({@required this.homeChangeNotifier});

  final ProductRepository productRepository = ProductRepository();

  Widget build(BuildContext context) {
    return Container(
      width: Config.pageStyle.deviceWidth,
      child: Column(
        children: [
          if (homeChangeNotifier.bestWatchesBanner != null) ...[_buildBanner(homeChangeNotifier.bestWatchesBanner)],
          if (homeChangeNotifier.bestWatchesItems.isNotEmpty) ...[_buildProducts(homeChangeNotifier.bestWatchesItems)]
        ],
      ),
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
            Config.navigatorKey.currentContext,
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
            Config.navigatorKey.currentContext,
            Routes.productList,
            arguments: arguments,
          );
        } else if (banner?.productId != null) {
          final product = await productRepository.getProduct(banner.productId);
          Navigator.pushNamedAndRemoveUntil(
            Config.navigatorKey.currentContext,
            Routes.product,
            (route) => route.settings.name == Routes.home,
            arguments: product,
          );
        }
      },
      child: CachedNetworkImage(
        imageUrl: banner.bannerImage,
        // progressIndicatorBuilder: (context, url, downloadProgress) => Center(child: CircularProgressIndicator(value: downloadProgress.progress)),
        errorWidget: (context, url, error) => Center(child: Icon(Icons.image, size: 20)),
      ),
    );
  }

  Widget _buildProducts(List<ProductModel> list) {
    return Container(
      padding: EdgeInsets.only(top: Config.pageStyle.unitHeight * 15, bottom: Config.pageStyle.unitHeight * 10),
      height: Config.pageStyle.unitHeight * 350,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: list.length,
        itemBuilder: (context, index) => Container(
          margin: EdgeInsets.only(left: Config.pageStyle.unitWidth * 5),
          child: ProductVVCard(
            cardWidth: Config.pageStyle.unitWidth * 170,
            cardHeight: Config.pageStyle.unitHeight * 330,
            product: list[index],
            isShoppingCart: true,
            isLine: false,
            isMinor: true,
            isWishlist: true,
            isShare: false,
          ),
        ),
      ),
    );
  }
}
