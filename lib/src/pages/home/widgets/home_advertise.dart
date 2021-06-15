import 'package:cached_network_image/cached_network_image.dart';
import 'package:markaa/src/change_notifier/home_change_notifier.dart';
import 'package:markaa/src/components/markaa_text_button.dart';
import 'package:markaa/src/data/models/brand_entity.dart';
import 'package:markaa/src/data/models/index.dart';
import 'package:markaa/src/data/models/product_list_arguments.dart';
import 'package:markaa/src/components/product_card.dart';
import 'package:flutter/material.dart';
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
    if (homeChangeNotifier.ads != null) {
      return Container(
        color: Colors.white,
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(left: 10.w, right: 10.w, top: 10.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    homeChangeNotifier?.ads?.categoryId != null
                        ? homeChangeNotifier.ads.categoryName
                        : homeChangeNotifier?.ads?.brand != null
                            ? homeChangeNotifier.ads.brand.brandLabel
                            : '',
                    style: mediumTextStyle.copyWith(
                      fontSize: 26.sp,
                    ),
                  ),
                  Container(
                    width: 80.w,
                    height: 30.h,
                    child: MarkaaTextButton(
                      title: 'view_all'.tr(),
                      titleSize: 12.sp,
                      titleColor: primaryColor,
                      buttonColor: Colors.white,
                      borderColor: primaryColor,
                      radius: 0,
                      onPressed: () async {
                        if (homeChangeNotifier.ads.categoryId != null) {
                          final arguments = ProductListArguments(
                            category: CategoryEntity(
                              id: homeChangeNotifier.ads.categoryId,
                              name: homeChangeNotifier.ads.categoryName,
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
                        } else if (homeChangeNotifier?.ads?.brand?.optionId !=
                            null) {
                          final arguments = ProductListArguments(
                            category: CategoryEntity(),
                            brand: homeChangeNotifier.ads.brand,
                            subCategory: [],
                            selectedSubCategoryIndex: 0,
                            isFromBrand: true,
                          );
                          Navigator.pushNamed(
                            context,
                            Routes.productList,
                            arguments: arguments,
                          );
                        } else if (homeChangeNotifier?.ads?.productId != null) {
                          final product = await productRepository
                              .getProduct(homeChangeNotifier.ads.productId);
                          Navigator.pushNamedAndRemoveUntil(
                            context,
                            Routes.product,
                            (route) => route.settings.name == Routes.home,
                            arguments: product,
                          );
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
            CachedNetworkImage(imageUrl: homeChangeNotifier.ads.bannerImage),
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
}
