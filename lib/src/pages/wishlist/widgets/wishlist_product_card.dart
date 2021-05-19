import 'package:cached_network_image/cached_network_image.dart';
import 'package:markaa/src/components/markaa_text_button.dart';
import 'package:markaa/src/data/mock/mock.dart';
import 'package:markaa/src/data/models/product_model.dart';
import 'package:markaa/src/theme/styles.dart';
import 'package:markaa/src/theme/theme.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class WishlistProductCard extends StatelessWidget {
  final ProductModel product;
  final Function onRemoveWishlist;
  final Function onAddToCart;

  WishlistProductCard({
    this.product,
    this.onRemoveWishlist,
    this.onAddToCart,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(vertical: 10.h),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              InkWell(
                onTap: onRemoveWishlist,
                child: Icon(
                  Icons.remove_circle_outline,
                  size: 22.sp,
                  color: greyDarkColor,
                ),
              ),
              CachedNetworkImage(
                imageUrl: product.imageUrl,
                width: 114.w,
                height: 140.h,
                fit: BoxFit.fitHeight,
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      product.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: mediumTextStyle.copyWith(
                        color: greyDarkColor,
                        fontSize: 14.sp,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      product.shortDescription,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: mediumTextStyle.copyWith(
                        color: greyDarkColor,
                        fontSize: 12.sp,
                      ),
                    ),
                    Text(
                      product.price + ' ' + 'currency'.tr(),
                      style: mediumTextStyle.copyWith(
                        fontSize: 12.sp,
                        color: greyColor,
                      ),
                    ),
                    SizedBox(height: 10.h),
                    if (product.stockQty != null && product.stockQty > 0) ...[
                      MarkaaTextButton(
                        title: 'wishlist_add_cart_button_title'.tr(),
                        titleSize: 15.sp,
                        titleColor: Colors.white,
                        buttonColor: primaryColor,
                        borderColor: Colors.transparent,
                        onPressed: () => onAddToCart(),
                        radius: 10,
                      )
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
        product.stockQty == null || product.stockQty == 0 ? _buildOutOfStock() : SizedBox.shrink(),
      ],
    );
  }

  Widget _buildOutOfStock() {
    return lang == 'en'
        ? Positioned(
            top: 50.h,
            right: 0,
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: 15.w,
                vertical: 5.h,
              ),
              color: primarySwatchColor.withOpacity(0.4),
              child: Text(
                'out_stock'.tr(),
                style: mediumTextStyle.copyWith(
                  fontSize: 14.sp,
                  color: Colors.white70,
                ),
              ),
            ),
          )
        : Positioned(
            top: 50.h,
            left: 0,
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: 15.w,
                vertical: 5.h,
              ),
              color: primarySwatchColor.withOpacity(0.4),
              child: Text(
                'out_stock'.tr(),
                style: mediumTextStyle.copyWith(
                  fontSize: 14.sp,
                  color: Colors.white70,
                ),
              ),
            ),
          );
  }
}
