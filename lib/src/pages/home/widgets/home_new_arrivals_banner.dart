import 'package:markaa/src/change_notifier/home_change_notifier.dart';
import 'package:markaa/src/data/models/brand_entity.dart';
import 'package:markaa/src/data/models/index.dart';
import 'package:markaa/src/data/models/product_list_arguments.dart';
import 'package:markaa/src/routes/routes.dart';
import 'package:markaa/src/theme/styles.dart';
import 'package:markaa/src/components/product_card.dart';
import 'package:flutter/material.dart';
import 'package:markaa/src/utils/repositories/product_repository.dart';
import 'package:provider/provider.dart';
import 'package:isco_custom_widgets/isco_custom_widgets.dart';

class HomeNewArrivalsBanner extends StatefulWidget {
  final PageStyle pageStyle;

  HomeNewArrivalsBanner({this.pageStyle});

  @override
  _HomeNewArrivalsBannerState createState() => _HomeNewArrivalsBannerState();
}

class _HomeNewArrivalsBannerState extends State<HomeNewArrivalsBanner> {
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
      builder: (_, model, __) {
        if (model.newArrivalsBanners.isNotEmpty) {
          final banner = model.newArrivalsBanners[0];
          return Container(
            width: widget.pageStyle.deviceWidth,
            color: Colors.white,
            margin: EdgeInsets.only(bottom: widget.pageStyle.unitHeight * 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(
                    horizontal: widget.pageStyle.unitWidth * 10,
                    vertical: widget.pageStyle.unitHeight * 10,
                  ),
                  child: Text(
                    model.newArrivalsBannerTitle,
                    style: mediumTextStyle.copyWith(
                      fontSize: widget.pageStyle.unitFontSize * 26,
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
                      final product = await productRepository.getProduct(
                          banner.productId);
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        Routes.product,
                        (route) => route.settings.name == Routes.home,
                        arguments: product,
                      );
                    }
                  },
                  child: Image.network(banner.bannerImage),
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: model.newArrivalsItems.map((item) {
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
        } else {
          return Container();
        }
      },
    );
  }
}
