import 'package:cached_network_image/cached_network_image.dart';
import 'package:markaa/src/change_notifier/home_change_notifier.dart';
import 'package:markaa/src/data/models/brand_entity.dart';
import 'package:markaa/src/data/models/index.dart';
import 'package:markaa/src/data/models/product_list_arguments.dart';
import 'package:markaa/src/components/product_card.dart';
import 'package:markaa/src/routes/routes.dart';
import 'package:markaa/src/theme/styles.dart';
import 'package:flutter/material.dart';
import 'package:markaa/src/utils/repositories/product_repository.dart';

import '../../../../config.dart';

class HomeBestDealsBanner extends StatelessWidget {
  final HomeChangeNotifier homeChangeNotifier;
  HomeBestDealsBanner({@required this.homeChangeNotifier});
  @override
  Widget build(BuildContext context) {
    if (homeChangeNotifier.bestDealsBanners.isNotEmpty) {
      final banner = homeChangeNotifier.bestDealsBanners[0];
      return Container(
        width: Config.pageStyle.deviceWidth,
        height: Config.pageStyle.unitWidth * 550,
        color: Colors.white,
        margin: EdgeInsets.only(bottom: Config.pageStyle.unitHeight * 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(
                horizontal: Config.pageStyle.unitWidth * 10,
                vertical: Config.pageStyle.unitHeight * 10,
              ),
              child: Text(
                homeChangeNotifier.bestDealsBannerTitle,
                style: mediumTextStyle.copyWith(
                  fontSize: Config.pageStyle.unitFontSize * 26,
                ),
              ),
            ),
            InkWell(
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
                  final product = await ProductRepository().getProduct(banner.productId);
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    Routes.product,
                    (route) => route.settings.name == Routes.home,
                    arguments: product,
                  );
                }
              },
              child: CachedNetworkImage(
                imageUrl: banner.bannerImage,
                fit: BoxFit.fitHeight,
                // progressIndicatorBuilder: (context, url, downloadProgress) =>
                //     Center(child: CircularProgressIndicator(value: downloadProgress.progress)),
                errorWidget: (context, url, error) => Center(child: Icon(Icons.image, size: 20)),
              ),
            ),
            Expanded(
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: homeChangeNotifier.bestDealsItems.length,
                  itemBuilder: (context, index) {
                    return ProductCard(
                      cardWidth: Config.pageStyle.unitWidth * 120,
                      cardHeight: Config.pageStyle.unitWidth * 175,
                      product: homeChangeNotifier.bestDealsItems[index],
                      isWishlist: true,
                    );
                  }),
            ),
          ],
        ),
      );
    } else {
      return Container();
    }
  }
}
