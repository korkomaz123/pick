import 'package:cached_network_image/cached_network_image.dart';
import 'package:markaa/src/change_notifier/home_change_notifier.dart';
import 'package:markaa/src/components/markaa_text_button.dart';
import 'package:markaa/src/data/models/brand_entity.dart';
import 'package:markaa/src/data/models/index.dart';
import 'package:markaa/src/data/models/product_list_arguments.dart';
import 'package:markaa/src/routes/routes.dart';
import 'package:markaa/src/theme/styles.dart';
import 'package:markaa/src/components/product_card.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:markaa/src/theme/theme.dart';
import 'package:markaa/src/utils/repositories/product_repository.dart';

class HomeNewArrivalsBanner extends StatelessWidget {
  final HomeChangeNotifier homeChangeNotifier;
  HomeNewArrivalsBanner({@required this.homeChangeNotifier});
  final ProductRepository productRepository = ProductRepository();

  @override
  Widget build(BuildContext context) {
    if (homeChangeNotifier.newArrivalsBanners.isNotEmpty) {
      final banner = homeChangeNotifier.newArrivalsBanners[0];
      return Container(
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
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    homeChangeNotifier.newArrivalsBannerTitle,
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
                          final product = await productRepository
                              .getProduct(banner.productId);
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
            CachedNetworkImage(
              imageUrl: banner.bannerImage,
              errorWidget: (context, url, error) =>
                  Center(child: Icon(Icons.image, size: 20)),
            ),
            Container(
              height: 175.w,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: homeChangeNotifier.newArrivalsItems.length,
                itemBuilder: (context, index) => ProductCard(
                  cardWidth: 120.w,
                  cardHeight: 175.w,
                  product: homeChangeNotifier.newArrivalsItems[index],
                  isWishlist: true,
                ),
              ),
            ),
          ],
        ),
      );
    } else {
      return Container();
    }
  }
}
