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
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:markaa/src/change_notifier/home_change_notifier.dart';

class HomeFragrancesBanners extends StatefulWidget {
  final HomeChangeNotifier model;

  HomeFragrancesBanners({this.model});

  @override
  _HomeFragrancesBannersState createState() => _HomeFragrancesBannersState();
}

class _HomeFragrancesBannersState extends State<HomeFragrancesBanners> {
  HomeChangeNotifier model;
  ProductRepository productRepository;

  @override
  void initState() {
    super.initState();
    productRepository = context.read<ProductRepository>();
    model = widget.model;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 375.w,
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
  }

  Widget _buildTitle(String title) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
      child: Text(
        title,
        style: mediumTextStyle.copyWith(fontSize: 26.sp),
      ),
    );
  }

  Widget _buildBanners(List<SliderImageEntity> banners) {
    return Container(
      width: double.infinity,
      child: Column(
        children: banners.map((banner) {
          return Padding(
            padding: EdgeInsets.only(bottom: 5.h),
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
