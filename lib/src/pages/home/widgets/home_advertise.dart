import 'package:cached_network_image/cached_network_image.dart';
import 'package:markaa/preload.dart';
import 'package:markaa/src/change_notifier/home_change_notifier.dart';
import 'package:markaa/src/components/markaa_text_button.dart';
import 'package:markaa/src/data/models/brand_entity.dart';
import 'package:markaa/src/data/models/index.dart';
import 'package:markaa/src/data/models/product_list_arguments.dart';
import 'package:markaa/src/components/product_card.dart';
import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:markaa/src/theme/styles.dart';
import 'package:markaa/src/theme/theme.dart';
import 'package:markaa/src/utils/repositories/product_repository.dart';
import 'package:markaa/src/routes/routes.dart';

class HomeAdvertise extends StatelessWidget {
  final HomeChangeNotifier homeChangeNotifier;

  HomeAdvertise({@required this.homeChangeNotifier});

  final ProductRepository productRepository = ProductRepository();

  @override
  Widget build(BuildContext context) {
    if (homeChangeNotifier.ads != null && homeChangeNotifier.ads.isNotEmpty) {
      SliderImageEntity banner = homeChangeNotifier.ads[0];
      return Container(
        color: Colors.white,
        margin: EdgeInsets.only(bottom: 10.h),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: AutoSizeText(
                      banner?.categoryId != null
                          ? banner.categoryName
                          : banner?.brand != null
                              ? banner.brand.brandLabel
                              : '',
                      maxLines: 1,
                      style: mediumTextStyle.copyWith(
                        fontSize: 26.sp,
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 2.w),
                    height: 30.h,
                    child: MarkaaTextButton(
                      title: 'view_all'.tr(),
                      titleSize: Preload.language == 'en' ? 12.sp : 10.sp,
                      titleColor: primaryColor,
                      buttonColor: Colors.white,
                      borderColor: primaryColor,
                      borderWidth: Preload.language == 'en' ? 1 : 0.5,
                      radius: 0,
                      onPressed: () => _onLink(context, banner),
                    ),
                  ),
                ],
              ),
            ),
            Column(
              children: homeChangeNotifier.ads.map((item) {
                return InkWell(
                  onTap: () => _onLink(context, item),
                  child: CachedNetworkImage(
                    imageUrl: item.bannerImage,
                  ),
                );
              }).toList(),
            ),
            Container(
              height: 175.w,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: homeChangeNotifier.perfumesItems.length,
                itemBuilder: (context, index) => ProductCard(
                  cardWidth: 120.w,
                  cardHeight: 175.w,
                  product: homeChangeNotifier.perfumesItems[index],
                  isWishlist: true,
                ),
              ),
            ),
          ],
        ),
      );
    }
    return Container();
  }

  _onLink(BuildContext context, SliderImageEntity banner) async {
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
  }
}
