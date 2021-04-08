import 'package:markaa/src/change_notifier/home_change_notifier.dart';
import 'package:markaa/src/data/mock/mock.dart';
import 'package:markaa/src/data/models/brand_entity.dart';
import 'package:markaa/src/data/models/index.dart';
import 'package:markaa/src/data/models/product_list_arguments.dart';
import 'package:markaa/src/components/product_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:isco_custom_widgets/isco_custom_widgets.dart';
import 'package:markaa/src/routes/routes.dart';

class HomeAdvertise extends StatefulWidget {
  final PageStyle pageStyle;

  HomeAdvertise({this.pageStyle});

  @override
  _HomeAdvertiseState createState() => _HomeAdvertiseState();
}

class _HomeAdvertiseState extends State<HomeAdvertise> {
  HomeChangeNotifier homeChangeNotifier;

  @override
  void initState() {
    super.initState();
    homeChangeNotifier = context.read<HomeChangeNotifier>();
    homeChangeNotifier.loadAds(lang);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeChangeNotifier>(
      builder: (_, model, ___) {
        if (model.ads != null) {
          return Container(
            width: widget.pageStyle.deviceWidth,
            color: Colors.white,
            child: Column(
              children: [
                InkWell(
                  onTap: () {
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
                    }
                  },
                  child: Image.network(model.ads.bannerImage),
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: model.perfumesItems.map((item) {
                      return ProductCard(
                        cardWidth: widget.pageStyle.unitWidth * 120,
                        cardHeight: widget.pageStyle.unitWidth * 175,
                        product: item,
                        isWishlist: true,
                        pageStyle: widget.pageStyle,
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
