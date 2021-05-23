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
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomeBestDealsBanner extends StatefulWidget {
  final HomeChangeNotifier model;

  HomeBestDealsBanner({@required this.model});

  @override
  _HomeBestDealsBannerState createState() => _HomeBestDealsBannerState();
}

class _HomeBestDealsBannerState extends State<HomeBestDealsBanner> {
  HomeChangeNotifier model;
  ProductRepository productRepository = ProductRepository();

  @override
  void initState() {
    super.initState();
    model = widget.model;
  }

  @override
  Widget build(BuildContext context) {
    final banner = model.bestDealsBanners[0];
    return Container(
      width: 375.w,
      color: Colors.white,
      margin: EdgeInsets.only(bottom: 10.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(
              horizontal: 10.w,
              vertical: 10.h,
            ),
            child: Text(
              model.bestDealsBannerTitle,
              style: mediumTextStyle.copyWith(fontSize: 26.sp),
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
                final product =
                    await productRepository.getProduct(banner.productId);
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  Routes.product,
                  (route) => route.settings.name == Routes.home,
                  arguments: product,
                );
              }
            },
            child: CachedNetworkImage(imageUrl:banner.bannerImage),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: model.bestDealsItems.map((item) {
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
