import 'package:markaa/src/change_notifier/home_change_notifier.dart';
import 'package:markaa/src/data/models/brand_entity.dart';
import 'package:markaa/src/data/models/index.dart';
import 'package:markaa/src/data/models/product_list_arguments.dart';
import 'package:markaa/src/components/product_card.dart';
import 'package:flutter/material.dart';
import 'package:markaa/src/utils/repositories/product_repository.dart';
import 'package:markaa/src/routes/routes.dart';

import '../../../../config.dart';

class HomeAdvertise extends StatelessWidget {
  final HomeChangeNotifier homeChangeNotifier;
  HomeAdvertise({@required this.homeChangeNotifier});

  final ProductRepository productRepository = ProductRepository();

  @override
  Widget build(BuildContext context) {
    if (homeChangeNotifier.ads != null) {
      return Container(
        color: Colors.white,
        child: Column(
          children: [
            InkWell(
              onTap: () async {
                if (homeChangeNotifier.ads.categoryId != null) {
                  final arguments = ProductListArguments(
                    category: CategoryEntity(
                      id: homeChangeNotifier.ads.categoryId,
                      name: homeChangeNotifier.ads.categoryName,
                    ),
                    brand: BrandEntity(),
                    subCategory: [],
                    selectedSubCategoryIndex: 0,
                    isFromBrand: false,
                  );
                  Navigator.pushNamed(context, Routes.productList, arguments: arguments);
                } else if (homeChangeNotifier?.ads?.brand?.optionId != null) {
                  final arguments = ProductListArguments(
                    category: CategoryEntity(),
                    brand: homeChangeNotifier.ads.brand,
                    subCategory: [],
                    selectedSubCategoryIndex: 0,
                    isFromBrand: true,
                  );
                  Navigator.pushNamed(context, Routes.productList, arguments: arguments);
                } else if (homeChangeNotifier?.ads?.productId != null) {
                  final product = await productRepository.getProduct(homeChangeNotifier.ads.productId);
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    Routes.product,
                    (route) => route.settings.name == Routes.home,
                    arguments: product,
                  );
                }
              },
              child: Image.network(homeChangeNotifier.ads.bannerImage),
            ),
            Container(
              height: Config.pageStyle.unitWidth * 175,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: homeChangeNotifier.perfumesItems.length,
                itemBuilder: (context, index) => ProductCard(
                  cardWidth: Config.pageStyle.unitWidth * 120,
                  cardHeight: Config.pageStyle.unitWidth * 175,
                  product: homeChangeNotifier.perfumesItems[index],
                  isWishlist: true,
                ),
              ),
            ),
          ],
        ),
      );
    }
    return Container();
  }
}
