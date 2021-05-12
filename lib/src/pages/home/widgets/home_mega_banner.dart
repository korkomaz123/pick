import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:markaa/src/change_notifier/home_change_notifier.dart';
import 'package:markaa/src/data/models/brand_entity.dart';
import 'package:markaa/src/data/models/index.dart';
import 'package:markaa/src/data/models/product_list_arguments.dart';
import 'package:markaa/src/routes/routes.dart';
import 'package:markaa/src/utils/repositories/product_repository.dart';

import '../../../../config.dart';

class HomeMegaBanner extends StatelessWidget {
  final HomeChangeNotifier homeChangeNotifier;
  HomeMegaBanner({@required this.homeChangeNotifier});

  @override
  Widget build(BuildContext context) {
    if (homeChangeNotifier.megaBanner == null) return Container();
    return InkWell(
      onTap: () async {
        if (homeChangeNotifier.megaBanner.categoryId != null) {
          final arguments = ProductListArguments(
            category: CategoryEntity(
              id: homeChangeNotifier.megaBanner.categoryId,
              name: homeChangeNotifier.megaBanner.categoryName,
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
        } else if (homeChangeNotifier.megaBanner?.brand?.optionId != null) {
          final arguments = ProductListArguments(
            category: CategoryEntity(),
            brand: homeChangeNotifier.megaBanner.brand,
            subCategory: [],
            selectedSubCategoryIndex: 0,
            isFromBrand: true,
          );
          Navigator.pushNamed(
            Config.navigatorKey.currentContext,
            Routes.productList,
            arguments: arguments,
          );
        } else if (homeChangeNotifier.megaBanner?.productId != null) {
          final product = await ProductRepository()
              .getProduct(homeChangeNotifier.megaBanner.productId);
          Navigator.pushNamedAndRemoveUntil(
            Config.navigatorKey.currentContext,
            Routes.product,
            (route) => route.settings.name == Routes.home,
            arguments: product,
          );
        }
      },
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.w),
        child: CachedNetworkImage(
          imageUrl: homeChangeNotifier.megaBanner.bannerImage,
          fit: BoxFit.fill,
          errorWidget: (context, url, error) => Center(
            child: Icon(Icons.image, size: 20),
          ),
        ),
      ),
    );
  }
}
