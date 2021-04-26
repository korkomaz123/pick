import 'package:flutter/material.dart';
import 'package:markaa/src/components/product_vv_card.dart';
import 'package:markaa/src/data/mock/mock.dart';
import 'package:markaa/src/data/models/brand_entity.dart';
import 'package:markaa/src/data/models/category_entity.dart';
import 'package:markaa/src/data/models/product_list_arguments.dart';
import 'package:markaa/src/data/models/product_model.dart';
import 'package:markaa/src/data/models/slider_image_entity.dart';
import 'package:markaa/src/routes/routes.dart';
import 'package:provider/provider.dart';
import 'package:isco_custom_widgets/isco_custom_widgets.dart';
import 'package:markaa/src/change_notifier/home_change_notifier.dart';
import 'package:markaa/src/utils/repositories/product_repository.dart';

class HomeBestWatches extends StatefulWidget {
  final PageStyle pageStyle;

  HomeBestWatches({@required this.pageStyle});

  @override
  _HomeBestWatchSecties createState() => _HomeBestWatchSecties();
}

class _HomeBestWatchSecties extends State<HomeBestWatches> {
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
          child: Column(
            children: [
              if (model.bestWatchesBanner != null) ...[
                _buildBanner(model.bestWatchesBanner)
              ],
              if (model.bestWatchesItems.isNotEmpty) ...[
                _buildProducts(model.bestWatchesItems)
              ]
            ],
          ),
        );
      },
    );
  }

  Widget _buildBanner(SliderImageEntity banner) {
    return InkWell(
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
          final product =
              await productRepository.getProduct(banner.productId, lang);
          Navigator.pushNamedAndRemoveUntil(
            context,
            Routes.product,
            (route) => route.settings.name == Routes.home,
            arguments: product,
          );
        }
      },
      child: Image.network(banner.bannerImage),
    );
  }

  Widget _buildProducts(List<ProductModel> list) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(
        top: widget.pageStyle.unitHeight * 15,
        bottom: widget.pageStyle.unitHeight * 10,
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: list.map((item) {
            return Container(
              margin: EdgeInsets.only(left: widget.pageStyle.unitWidth * 5),
              child: ProductVVCard(
                cardWidth: widget.pageStyle.unitWidth * 170,
                cardHeight: widget.pageStyle.unitHeight * 330,
                product: item,
                isShoppingCart: true,
                isLine: false,
                isMinor: true,
                isWishlist: true,
                isShare: false,
                pageStyle: widget.pageStyle,
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
