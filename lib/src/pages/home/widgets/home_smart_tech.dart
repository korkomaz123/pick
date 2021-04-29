import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:markaa/src/components/amazing_product_card.dart';
import 'package:markaa/src/components/markaa_text_icon_button.dart';
import 'package:markaa/src/data/mock/mock.dart';
import 'package:markaa/src/data/models/brand_entity.dart';
import 'package:markaa/src/data/models/category_entity.dart';
import 'package:markaa/src/data/models/product_list_arguments.dart';
import 'package:markaa/src/data/models/product_model.dart';
import 'package:markaa/src/data/models/slider_image_entity.dart';
import 'package:markaa/src/routes/routes.dart';
import 'package:markaa/src/theme/styles.dart';
import 'package:markaa/src/theme/theme.dart';
import 'package:markaa/src/utils/repositories/product_repository.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:markaa/src/change_notifier/home_change_notifier.dart';

class HomeSmartTech extends StatefulWidget {
  @override
  _HomeSmartTechState createState() => _HomeSmartTechState();
}

class _HomeSmartTechState extends State<HomeSmartTech> {
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
        return Container(
          width: 375.w,
          color: Colors.white,
          child: Column(
            children: [
              if (model.smartTechTitle.isNotEmpty) ...[
                _buildTitle(model.smartTechTitle)
              ],
              if (model.smartTechBanners.isNotEmpty) ...[
                _buildBanners(model.smartTechBanners)
              ],
              if (model.smartTechItems.isNotEmpty) ...[
                _buildProducts(model.smartTechItems)
              ],
              if (model.smartTechCategory != null) ...[
                _buildFooter(model.smartTechCategory, model.smartTechTitle)
              ],
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
        horizontal: 10.w,
        vertical: 10.h,
      ),
      child: Text(
        title,
        style: mediumTextStyle.copyWith(
          fontSize: 26.sp,
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

  Widget _buildProducts(List<ProductModel> list) {
    return Container(
      width: 375.w,
      padding: EdgeInsets.symmetric(vertical: 20.h),
      color: backgroundColor,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: list.map((item) {
            return Padding(
              padding: EdgeInsets.only(left: 8.w),
              child: AmazingProductCard(
                cardSize: 302.w,
                contentSize: 96.w,
                product: item,
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildFooter(CategoryEntity category, String title) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        vertical: 4.h,
        horizontal: 10.w,
      ),
      color: backgroundColor,
      child: MarkaaTextIconButton(
        onPressed: () {
          ProductListArguments arguments = ProductListArguments(
            category: category,
            subCategory: [],
            brand: BrandEntity(),
            selectedSubCategoryIndex: 0,
            isFromBrand: false,
          );
          Navigator.pushNamed(
            context,
            Routes.productList,
            arguments: arguments,
          );
        },
        title: 'view_all_smart_tech'.tr(),
        titleColor: Colors.white,
        titleSize: 18.sp,
        icon: Icon(
          Icons.arrow_forward_ios,
          color: Colors.white,
          size: 24.sp,
        ),
        borderColor: primaryColor,
        buttonColor: primaryColor,
        leading: false,
      ),
    );
  }
}
