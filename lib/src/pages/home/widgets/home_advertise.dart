import 'package:markaa/src/change_notifier/home_change_notifier.dart';
import 'package:markaa/src/data/mock/mock.dart';
import 'package:markaa/src/data/models/brand_entity.dart';
import 'package:markaa/src/data/models/index.dart';
import 'package:markaa/src/data/models/product_list_arguments.dart';
import 'package:markaa/src/components/product_card.dart';
import 'package:flutter/material.dart';
import 'package:markaa/src/utils/repositories/product_repository.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:markaa/src/routes/routes.dart';

class HomeAdvertise extends StatefulWidget {
  @override
  _HomeAdvertiseState createState() => _HomeAdvertiseState();
}

class _HomeAdvertiseState extends State<HomeAdvertise> {
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
      builder: (_, model, ___) {
        if (model.ads != null) {
          return Container(
            width: 375.w,
            color: Colors.white,
            child: Column(
              children: [
                InkWell(
                  onTap: () async {
                    if (model.ads.categoryId != null) {
                      final arguments = ProductListArguments(
                        category: CategoryEntity(
                          id: model.ads.categoryId,
                          name: model.ads.categoryName,
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
                    } else if (model?.ads?.brand?.optionId != null) {
                      final arguments = ProductListArguments(
                        category: CategoryEntity(),
                        brand: model.ads.brand,
                        subCategory: [],
                        selectedSubCategoryIndex: 0,
                        isFromBrand: true,
                      );
                      Navigator.pushNamed(
                        context,
                        Routes.productList,
                        arguments: arguments,
                      );
                    } else if (model?.ads?.productId != null) {
                      final product = await productRepository.getProduct(
                          model.ads.productId, lang);
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        Routes.product,
                        (route) => route.settings.name == Routes.home,
                        arguments: product,
                      );
                    }
                  },
                  child: Image.network(model.ads.bannerImage),
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: model.perfumesItems.map((item) {
                      return ProductCard(
                        cardWidth: 120.w,
                        cardHeight: 175.w,
                        product: item,
                        isWishlist: true,
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          );
        }
        return Container();
      },
    );
  }
}
