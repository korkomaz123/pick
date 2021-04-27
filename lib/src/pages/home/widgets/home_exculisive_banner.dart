import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:markaa/src/change_notifier/home_change_notifier.dart';
import 'package:markaa/src/data/models/brand_entity.dart';
import 'package:markaa/src/data/models/index.dart';
import 'package:markaa/src/data/models/product_list_arguments.dart';
import 'package:markaa/src/routes/routes.dart';
import 'package:markaa/src/utils/repositories/product_repository.dart';

import '../../../../config.dart';

class HomeExculisiveBanner extends StatelessWidget {
  final HomeChangeNotifier homeChangeNotifier;
  HomeExculisiveBanner({@required this.homeChangeNotifier});

  final ProductRepository productRepository = ProductRepository();

  @override
  Widget build(BuildContext context) {
    if (homeChangeNotifier.exculisiveBanner != null) {
      return InkWell(
        onTap: () async {
          if (homeChangeNotifier.exculisiveBanner.categoryId != null) {
            final arguments = ProductListArguments(
              category: CategoryEntity(
                id: homeChangeNotifier.exculisiveBanner.categoryId,
                name: homeChangeNotifier.exculisiveBanner.categoryName,
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
          } else if (homeChangeNotifier.exculisiveBanner?.brand?.optionId != null) {
            final arguments = ProductListArguments(
              category: CategoryEntity(),
              brand: homeChangeNotifier.exculisiveBanner.brand,
              subCategory: [],
              selectedSubCategoryIndex: 0,
              isFromBrand: true,
            );
            Navigator.pushNamed(
              context,
              Routes.productList,
              arguments: arguments,
            );
          } else if (homeChangeNotifier.exculisiveBanner?.productId != null) {
            final product = await productRepository.getProduct(homeChangeNotifier.exculisiveBanner.productId);
            Navigator.pushNamedAndRemoveUntil(
              context,
              Routes.product,
              (route) => route.settings.name == Routes.home,
              arguments: product,
            );
          }
        },
        child: Container(
          margin: EdgeInsets.symmetric(
            horizontal: Config.pageStyle.unitWidth * 10,
            vertical: Config.pageStyle.unitHeight * 15,
          ),
          child: CachedNetworkImage(
            imageUrl: homeChangeNotifier.exculisiveBanner.bannerImage,
            progressIndicatorBuilder: (context, url, downloadProgress) => Center(child: CircularProgressIndicator(value: downloadProgress.progress)),
            errorWidget: (context, url, error) => Center(child: Icon(Icons.image, size: 20)),
          ),
        ),
      );
    } else {
      return Container();
    }
  }
}
