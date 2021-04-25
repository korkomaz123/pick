import 'package:flutter/material.dart';
import 'package:markaa/src/data/mock/mock.dart';
import 'package:markaa/src/data/models/brand_entity.dart';
import 'package:markaa/src/data/models/category_entity.dart';
import 'package:markaa/src/data/models/product_list_arguments.dart';
import 'package:markaa/src/data/models/slider_image_entity.dart';
import 'package:markaa/src/routes/routes.dart';
import 'package:markaa/src/theme/styles.dart';
import 'package:markaa/src/utils/repositories/product_repository.dart';
import 'package:provider/provider.dart';
import 'package:isco_custom_widgets/isco_custom_widgets.dart';
import 'package:markaa/src/change_notifier/home_change_notifier.dart';

class HomeFragrancesBanners extends StatefulWidget {
  final PageStyle pageStyle;

  HomeFragrancesBanners({this.pageStyle});

  @override
  _HomeFragrancesBannersState createState() => _HomeFragrancesBannersState();
}

class _HomeFragrancesBannersState extends State<HomeFragrancesBanners> {
  PageStyle pageStyle;
  HomeChangeNotifier homeChangeNotifier;
  ProductRepository productRepository;

  @override
  void initState() {
    super.initState();
    pageStyle = widget.pageStyle;
    productRepository = context.read<ProductRepository>();
    homeChangeNotifier = context.read<HomeChangeNotifier>();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeChangeNotifier>(
      builder: (_, model, __) {
        return Container(
          width: pageStyle.deviceWidth,
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
        horizontal: pageStyle.unitWidth * 10,
        vertical: pageStyle.unitHeight * 10,
      ),
      child: Text(
        title,
        style: mediumTextStyle.copyWith(
          fontSize: pageStyle.unitFontSize * 26,
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
            padding: EdgeInsets.only(bottom: pageStyle.unitHeight * 5),
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
                      banner.productId, lang);
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
          );
        }).toList(),
      ),
    );
  }
}
