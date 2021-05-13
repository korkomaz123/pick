import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:markaa/src/config/config.dart';
import 'package:markaa/src/data/models/brand_entity.dart';
import 'package:markaa/src/data/models/category_entity.dart';
import 'package:markaa/src/data/models/product_list_arguments.dart';
import 'package:markaa/src/data/models/slider_image_entity.dart';
import 'package:markaa/src/routes/routes.dart';
import 'package:markaa/src/theme/styles.dart';
import 'package:markaa/src/utils/repositories/product_repository.dart';
import 'package:provider/provider.dart';
import 'package:markaa/src/change_notifier/home_change_notifier.dart';

import '../../../../config.dart';

class HomeFragrancesBanners extends StatelessWidget {
  final HomeChangeNotifier homeChangeNotifier;
  HomeFragrancesBanners({@required this.homeChangeNotifier});

  final ProductRepository productRepository = ProductRepository();

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeChangeNotifier>(
      builder: (_, model, __) {
        return Container(
          width: designWidth.w,
          color: Colors.white,
          child: Column(
            children: [
              if (model.fragrancesBannersTitle.isNotEmpty) ...[
                _buildTitle(model.fragrancesBannersTitle)
              ],
              if (model.fragrancesBanners.isNotEmpty) ...[
                _buildBanners(model.fragrancesBanners)
              ]
            ],
          ),
        );
      },
    );
  }

  Widget _buildTitle(String title) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: 10.w,
        vertical: 10.h,
      ),
      child: Text(
        title,
        style: mediumTextStyle.copyWith(
          fontSize: 26.sp,
        ),
      ),
    );
  }

  Widget _buildBanners(List<SliderImageEntity> banners) {
    return Container(
      width: double.infinity,
      child: Column(
        children: banners.map((banner) {
          return Padding(
            padding: EdgeInsets.only(bottom: 5.h),
            child: InkWell(
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
                  final product =
                      await productRepository.getProduct(banner.productId);
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
                errorWidget: (context, url, error) =>
                    Center(child: Icon(Icons.image, size: 20)),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
