import 'package:flutter/material.dart';
import 'package:markaa/src/change_notifier/home_change_notifier.dart';
import 'package:markaa/src/data/models/brand_entity.dart';
import 'package:markaa/src/data/models/index.dart';
import 'package:markaa/src/data/models/product_list_arguments.dart';
import 'package:markaa/src/routes/routes.dart';
import 'package:markaa/src/utils/repositories/product_repository.dart';
import 'package:provider/provider.dart';
import 'package:isco_custom_widgets/isco_custom_widgets.dart';

class HomeExculisiveBanner extends StatefulWidget {
  final PageStyle pageStyle;

  HomeExculisiveBanner({this.pageStyle});

  @override
  _HomeExculisiveBannerState createState() => _HomeExculisiveBannerState();
}

class _HomeExculisiveBannerState extends State<HomeExculisiveBanner> {
  HomeChangeNotifier homeChangeNotifier;
  ProductRepository productRepository;

  @override
  void initState() {
    super.initState();
    homeChangeNotifier = context.read<HomeChangeNotifier>();
    productRepository = context.read<ProductRepository>();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeChangeNotifier>(
      builder: (_, model, __) {
        if (model.exculisiveBanner != null) {
          final banner = model.exculisiveBanner;
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
                final product = await productRepository.getProduct(banner.productId);
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  Routes.product,
                  (route) => route.settings.name == Routes.home,
                  arguments: product,
                );
              }
            },
            child: Container(
              margin: EdgeInsets.symmetric(
                horizontal: widget.pageStyle.unitWidth * 10,
                vertical: widget.pageStyle.unitHeight * 15,
              ),
              child: Image.network(banner.bannerImage),
            ),
          );
        } else {
          return Container();
        }
      },
    );
  }
}
