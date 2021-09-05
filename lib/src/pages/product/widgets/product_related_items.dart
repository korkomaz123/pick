import 'package:markaa/src/components/product_v_card.dart';
import 'package:markaa/src/data/models/product_model.dart';
import 'package:markaa/src/theme/styles.dart';
import 'package:markaa/src/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProductRelatedItems extends StatelessWidget {
  final List<ProductModel> relatedItems;
  ProductRelatedItems({this.relatedItems});
  @override
  Widget build(BuildContext context) {
    if (relatedItems != null && relatedItems.isNotEmpty) {
      return Container(
        width: 375.w,
        padding: EdgeInsets.symmetric(
          horizontal: 10.w,
          vertical: 6.h,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'product_related_items'.tr(),
              style: mediumTextStyle.copyWith(
                color: greyColor,
                fontSize: 16.sp,
              ),
            ),
            SizedBox(height: 4.h),
            Container(
              width: double.infinity,
              height: 320.h,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: relatedItems.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.only(right: 10.w),
                    child: ProductVCard(
                      cardWidth: 180.w,
                      cardHeight: 320.h,
                      product: relatedItems[index],
                      isShoppingCart: true,
                      isWishlist: true,
                      isShare: true,
                      isLine: true,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      );
    }
    return Container();
  }
}
