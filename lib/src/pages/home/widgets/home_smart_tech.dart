import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:markaa/src/components/amazing_product_card.dart';
import 'package:markaa/src/components/markaa_text_icon_button.dart';
import 'package:markaa/src/data/models/brand_entity.dart';
import 'package:markaa/src/data/models/category_entity.dart';
import 'package:markaa/src/data/models/product_list_arguments.dart';
import 'package:markaa/src/data/models/product_model.dart';
import 'package:markaa/src/data/models/slider_image_entity.dart';
import 'package:markaa/src/routes/routes.dart';
import 'package:markaa/src/theme/styles.dart';
import 'package:markaa/src/theme/theme.dart';
import 'package:markaa/src/utils/repositories/product_repository.dart';
import 'package:markaa/src/change_notifier/home_change_notifier.dart';

import '../../../../config.dart';

class HomeSmartTech extends StatelessWidget {
  final HomeChangeNotifier homeChangeNotifier;
  HomeSmartTech({@required this.homeChangeNotifier});
  final ProductRepository productRepository = ProductRepository();
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          if (homeChangeNotifier.smartTechTitle.isNotEmpty) ...[_buildTitle(homeChangeNotifier.smartTechTitle)],
          if (homeChangeNotifier.smartTechBanners.isNotEmpty) ...[_buildBanners(homeChangeNotifier.smartTechBanners)],
          if (homeChangeNotifier.smartTechItems.isNotEmpty) ...[_buildProducts(homeChangeNotifier.smartTechItems)],
          if (homeChangeNotifier.smartTechCategory != null) ...[
            _buildFooter(homeChangeNotifier.smartTechCategory, homeChangeNotifier.smartTechTitle)
          ],
        ],
      ),
    );
  }

  Widget _buildTitle(String title) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: Config.pageStyle.unitWidth * 10,
        vertical: Config.pageStyle.unitHeight * 10,
      ),
      child: Text(
        title,
        style: mediumTextStyle.copyWith(
          fontSize: Config.pageStyle.unitFontSize * 26,
        ),
      ),
    );
  }

  Widget _buildBanners(List<SliderImageEntity> banners) {
    return Column(
      children: banners.map((banner) {
        return Padding(
          padding: EdgeInsets.only(bottom: Config.pageStyle.unitHeight * 5),
          child: InkWell(
            onTap: () async {
              if (banner.categoryId != null) {
                final arguments = ProductListArguments(
                  category: CategoryEntity(id: banner.categoryId, name: banner.categoryName),
                  brand: BrandEntity(),
                  subCategory: [],
                  selectedSubCategoryIndex: 0,
                  isFromBrand: false,
                );
                Navigator.pushNamed(Config.navigatorKey.currentContext, Routes.productList, arguments: arguments);
              } else if (banner?.brand?.optionId != null) {
                final arguments = ProductListArguments(
                  category: CategoryEntity(),
                  brand: banner.brand,
                  subCategory: [],
                  selectedSubCategoryIndex: 0,
                  isFromBrand: true,
                );
                Navigator.pushNamed(Config.navigatorKey.currentContext, Routes.productList, arguments: arguments);
              } else if (banner?.productId != null) {
                final product = await productRepository.getProduct(banner.productId);
                Navigator.pushNamedAndRemoveUntil(Config.navigatorKey.currentContext, Routes.product, (route) => route.settings.name == Routes.home,
                    arguments: product);
              }
            },
            child: CachedNetworkImage(
              imageUrl: banner.bannerImage,
              // progressIndicatorBuilder: (context, url, downloadProgress) =>
              //     Center(child: CircularProgressIndicator(value: downloadProgress.progress)),
              errorWidget: (context, url, error) => Center(child: Icon(Icons.image, size: 20)),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildProducts(List<ProductModel> list) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: Config.pageStyle.unitHeight * 20),
      color: backgroundColor,
      height: Config.pageStyle.unitWidth * 302,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: list.length,
        itemBuilder: (context, index) => Padding(
          padding: EdgeInsets.only(left: Config.pageStyle.unitWidth * 8),
          child: AmazingProductCard(
            cardSize: Config.pageStyle.unitWidth * 302,
            contentSize: Config.pageStyle.unitWidth * 100,
            product: list[index],
          ),
        ),
      ),
    );
  }

  Widget _buildFooter(CategoryEntity category, String title) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: Config.pageStyle.unitHeight * 4, horizontal: Config.pageStyle.unitWidth * 10),
      color: backgroundColor,
      child: MarkaaTextIconButton(
        onPressed: () {
          ProductListArguments arguments = ProductListArguments(
            category: category,
            subCategory: [],
            brand: BrandEntity(),
            selectedSubCategoryIndex: 0,
            isFromBrand: false,
          );
          Navigator.pushNamed(Config.navigatorKey.currentContext, Routes.productList, arguments: arguments);
        },
        title: 'view_all_smart_tech'.tr(),
        titleColor: Colors.white,
        titleSize: Config.pageStyle.unitFontSize * 18,
        icon: Icon(Icons.arrow_forward_ios, color: Colors.white, size: Config.pageStyle.unitFontSize * 24),
        borderColor: primaryColor,
        buttonColor: primaryColor,
        leading: false,
      ),
    );
  }
}
