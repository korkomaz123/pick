import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:markaa/src/data/mock/mock.dart';
import 'package:markaa/src/data/models/product_list_arguments.dart';
import 'package:markaa/src/data/models/product_model.dart';
import 'package:markaa/src/routes/routes.dart';
import 'package:markaa/src/theme/styles.dart';
import 'package:markaa/src/theme/theme.dart';

class AmazingProductCard extends StatelessWidget {
  final double cardSize;
  final double contentSize;
  final ProductModel product;

  AmazingProductCard({
    required this.cardSize,
    required this.contentSize,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.pushNamed(
        context,
        Routes.product,
        arguments: product,
      ),
      child: Container(
        width: cardSize + 20.w,
        height: cardSize,
        child: Stack(
          children: [
            Align(
              alignment:
                  lang == 'en' ? Alignment.centerRight : Alignment.centerLeft,
              child: Card(
                margin: lang == 'en'
                    ? EdgeInsets.only(left: 20.w)
                    : EdgeInsets.only(right: 20.w),
                shadowColor: greyLightColor,
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.sp),
                ),
                child: Container(
                  width: cardSize,
                  height: cardSize - 20.w,
                  margin: EdgeInsets.only(
                    left: lang == 'en' ? 20.w : 0,
                    right: lang == 'ar' ? 20.w : 0,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    image: DecorationImage(
                      image: CachedNetworkImageProvider(
                        product.imageUrl,
                        cacheKey: product.imageUrl,
                      ),
                      fit: BoxFit.fitHeight,
                    ),
                    borderRadius: BorderRadius.circular(20.sp),
                  ),
                ),
              ),
            ),
            Align(
              alignment:
                  lang == 'en' ? Alignment.bottomLeft : Alignment.bottomRight,
              child: Container(
                width: contentSize,
                height: contentSize,
                margin: EdgeInsets.only(bottom: 40.h),
                padding: EdgeInsets.symmetric(
                  horizontal: 6.w,
                  vertical: 10.h,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.sp),
                  color: Color(0xFF009AFB),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        InkWell(
                          onTap: () {
                            if (product.brandEntity != null) {
                              ProductListArguments arguments =
                                  ProductListArguments(
                                category: null,
                                subCategory: [],
                                brand: product.brandEntity,
                                selectedSubCategoryIndex: 0,
                                isFromBrand: true,
                              );
                              Navigator.pushNamed(
                                context,
                                Routes.productList,
                                arguments: arguments,
                              );
                            }
                          },
                          child: Text(
                            product.brandEntity?.brandLabel ?? '',
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: mediumTextStyle.copyWith(
                              color: Colors.white,
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          product.name,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: mediumTextStyle.copyWith(
                            color: Colors.white70,
                            fontSize: 10.sp,
                            height: 1.5.h,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      product.price + ' ' + 'currency'.tr(),
                      style: mediumTextStyle.copyWith(
                        fontSize: 16.sp,
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
