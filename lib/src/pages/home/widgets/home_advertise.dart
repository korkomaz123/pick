import 'package:markaa/src/change_notifier/home_change_notifier.dart';
import 'package:markaa/src/data/models/brand_entity.dart';
import 'package:markaa/src/data/models/index.dart';
import 'package:markaa/src/data/models/product_list_arguments.dart';
import 'package:markaa/src/components/product_card.dart';
import 'package:flutter/material.dart';
import 'package:markaa/src/utils/repositories/product_repository.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:markaa/src/routes/routes.dart';

class HomeAdvertise extends StatefulWidget {
  final HomeChangeNotifier model;

  HomeAdvertise({@required this.model});

  @override
  _HomeAdvertiseState createState() => _HomeAdvertiseState();
}

class _HomeAdvertiseState extends State<HomeAdvertise> {
  ProductRepository productRepository = ProductRepository();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 375.w,
      color: Colors.white,
      child: Column(
        children: [
          InkWell(
            onTap: () async {
              if (widget.model.ads.categoryId != null) {
                final arguments = ProductListArguments(
                  category: CategoryEntity(
                    id: widget.model.ads.categoryId,
                    name: widget.model.ads.categoryName,
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
              } else if (widget.model?.ads?.brand?.optionId != null) {
                final arguments = ProductListArguments(
                  category: CategoryEntity(),
                  brand: widget.model.ads.brand,
                  subCategory: [],
                  selectedSubCategoryIndex: 0,
                  isFromBrand: true,
                );
                Navigator.pushNamed(
                  context,
                  Routes.productList,
                  arguments: arguments,
                );
              } else if (widget.model?.ads?.productId != null) {
                final product = await productRepository
                    .getProduct(widget.model.ads.productId);
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  Routes.product,
                  (route) => route.settings.name == Routes.home,
                  arguments: product,
                );
              }
            },
            child: Image.network(widget.model.ads.bannerImage),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: widget.model.perfumesItems.map((item) {
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
}
