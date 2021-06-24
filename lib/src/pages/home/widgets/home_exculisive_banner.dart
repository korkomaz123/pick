import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:markaa/src/change_notifier/home_change_notifier.dart';
import 'package:markaa/src/data/models/brand_entity.dart';
import 'package:markaa/src/data/models/index.dart';
import 'package:markaa/src/data/models/product_list_arguments.dart';
import 'package:markaa/src/routes/routes.dart';
import 'package:markaa/src/utils/repositories/product_repository.dart';

class HomeExculisiveBanner extends StatelessWidget {
  final HomeChangeNotifier homeChangeNotifier;
  HomeExculisiveBanner({@required this.homeChangeNotifier});

  final ProductRepository productRepository = ProductRepository();

  @override
  Widget build(BuildContext context) {
    if (homeChangeNotifier.exculisiveBanners != null &&
        homeChangeNotifier.exculisiveBanners.isNotEmpty) {
      return Column(
        children: homeChangeNotifier.exculisiveBanners.map((banner) {
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
                    await productRepository.getProduct(banner.productId);
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
                horizontal: 10.w,
                vertical: 15.h,
              ),
              child: CachedNetworkImage(
                imageUrl: banner.bannerImage,
                errorWidget: (context, url, error) =>
                    Center(child: Icon(Icons.image, size: 20)),
              ),
            ),
          );
        }).toList(),
      );
    } else {
      return Container();
    }
  }
}
