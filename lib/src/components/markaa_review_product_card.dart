import 'package:cached_network_image/cached_network_image.dart';
import 'package:markaa/src/data/models/index.dart';
import 'package:markaa/src/routes/routes.dart';
import 'package:markaa/src/theme/styles.dart';
import 'package:markaa/src/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MarkaaReviewProductCard extends StatelessWidget {
  final CartItemEntity cartItem;

  MarkaaReviewProductCard({required this.cartItem});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 375.w,
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 20.h),
      child: Row(
        children: [
          CachedNetworkImage(
            imageUrl: cartItem.product.imageUrl,
            width: 90.h,
            height: 120.h,
            fit: BoxFit.fitHeight,
            errorWidget: (_, __, ___) => Center(child: Icon(Icons.image, size: 20)),
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InkWell(
                  onTap: () {
                    if (cartItem.product.brandEntity?.optionId != null) {
                      ProductListArguments arguments = ProductListArguments(
                        category: null,
                        subCategory: [],
                        brand: cartItem.product.brandEntity,
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
                    cartItem.product.brandEntity?.brandLabel ?? '',
                    style: mediumTextStyle.copyWith(
                      color: primaryColor,
                      fontSize: 12.sp,
                    ),
                  ),
                ),
                Text(
                  cartItem.product.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: mediumTextStyle.copyWith(
                    fontSize: 16.sp,
                  ),
                ),
                Text(
                  cartItem.product.shortDescription!,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  style: mediumTextStyle.copyWith(
                    fontSize: 12.sp,
                  ),
                ),
                SizedBox(height: 10.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'items'.tr().replaceFirst('0', '${cartItem.itemCount}'),
                      style: mediumTextStyle.copyWith(
                        fontSize: 14.sp,
                        color: primaryColor,
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          cartItem.product.price + ' ' + 'currency'.tr(),
                          style: mediumTextStyle.copyWith(
                            fontSize: 16.sp,
                            color: primaryColor,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
