import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:markaa/src/components/markaa_text_button.dart';
import 'package:markaa/src/config/config.dart';
import 'package:markaa/src/data/mock/mock.dart';
import 'package:markaa/src/data/models/brand_entity.dart';
import 'package:markaa/src/data/models/category_entity.dart';
import 'package:markaa/src/data/models/product_list_arguments.dart';
import 'package:markaa/src/data/models/slider_image_entity.dart';
import 'package:markaa/src/routes/routes.dart';
import 'package:markaa/src/theme/styles.dart';
import 'package:markaa/src/theme/theme.dart';
import 'package:markaa/src/utils/repositories/product_repository.dart';
import 'package:provider/provider.dart';
import 'package:markaa/src/change_notifier/home_change_notifier.dart';

import '../../../../preload.dart';

class HomeFragrancesBanners extends StatelessWidget {
  final HomeChangeNotifier homeChangeNotifier;
  HomeFragrancesBanners({@required this.homeChangeNotifier});

  final ProductRepository productRepository = ProductRepository();

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeChangeNotifier>(
      builder: (_, model, __) {
        if (model.fragrancesBanners.isNotEmpty ||
            model.fragrancesBannersTitle.isNotEmpty) {
          return Container(
            width: designWidth.w,
            margin: EdgeInsets.only(bottom: 10.h),
            child: Column(
              children: [
                if (model.fragrancesBanners.isNotEmpty) ...[
                  _buildBanners(model.fragrancesBanners)
                ],
                if (model.fragrancesBannersTitle.isNotEmpty) ...[
                  SizedBox(height: 10.h),
                  _buildTitle(model.fragrancesBannersTitle, context)
                ],
              ],
            ),
          );
        }
        return Container();
      },
    );
  }

  Widget _buildTitle(String title, BuildContext context) {
    return Container(
      width: double.infinity,
      color: Colors.white,
      padding: EdgeInsets.symmetric(
        horizontal: 10.w,
        vertical: 10.h,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: AutoSizeText(
              title,
              maxLines: 1,
              style: mediumTextStyle.copyWith(
                fontSize: 26.sp,
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 2.w),
            height: 30.h,
            child: MarkaaTextButton(
              title: 'view_all'.tr(),
              titleSize: Preload.language == 'en' ? 12.sp : 10.sp,
              titleColor: primaryColor,
              buttonColor: Colors.white,
              borderColor: primaryColor,
              borderWidth: Preload.language == 'en' ? 1 : 0.5,
              radius: 0,
              onPressed: () async {
                ProductListArguments arguments = ProductListArguments(
                  category: homeCategories[2],
                  subCategory: homeCategories[2].subCategories,
                  brand: BrandEntity(),
                  selectedSubCategoryIndex: 0,
                  isFromBrand: false,
                );
                Navigator.pushNamed(
                  context,
                  Routes.productList,
                  arguments: arguments,
                );
              },
            ),
          )
        ],
      ),
    );
  }

  Widget _buildBanners(List<SliderImageEntity> banners) {
    return Container(
      width: double.infinity,
      color: Colors.white,
      child: Column(
        children: banners.map((banner) {
          int index = banners.indexOf(banner);
          return Padding(
            padding:
                EdgeInsets.only(bottom: index < banners.length - 1 ? 3.h : 0),
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
                    Preload.navigatorKey.currentContext,
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
                    Preload.navigatorKey.currentContext,
                    Routes.productList,
                    arguments: arguments,
                  );
                } else if (banner?.productId != null) {
                  final product =
                      await productRepository.getProduct(banner.productId);
                  Navigator.pushNamedAndRemoveUntil(
                    Preload.navigatorKey.currentContext,
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
