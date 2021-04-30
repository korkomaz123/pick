import 'package:flutter/material.dart';
import 'package:markaa/src/change_notifier/home_change_notifier.dart';
import 'package:markaa/src/data/mock/mock.dart';
import 'package:markaa/src/data/models/brand_entity.dart';
import 'package:markaa/src/data/models/index.dart';
import 'package:markaa/src/data/models/product_list_arguments.dart';
import 'package:markaa/src/routes/routes.dart';
import 'package:markaa/src/utils/repositories/product_repository.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomeMegaBanner extends StatefulWidget {
  final HomeChangeNotifier model;

  HomeMegaBanner({this.model});

  @override
  _HomeMegaBannerState createState() => _HomeMegaBannerState();
}

class _HomeMegaBannerState extends State<HomeMegaBanner> {
  HomeChangeNotifier model;
  ProductRepository productRepository;

  @override
  void initState() {
    super.initState();
    model = widget.model;
    productRepository = context.read<ProductRepository>();
  }

  @override
  Widget build(BuildContext context) {
    if (model.megaBanner != null) {
      final banner = model.megaBanner;
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
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.w),
          child: Image.network(banner.bannerImage),
        ),
      );
    } else {
      return Container();
    }
  }
}
