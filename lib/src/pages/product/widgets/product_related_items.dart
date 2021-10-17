import 'package:markaa/src/change_notifier/product_change_notifier.dart';
import 'package:markaa/src/components/product_v_card.dart';
import 'package:markaa/src/data/models/index.dart';
import 'package:markaa/src/theme/styles.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProductRelatedItems extends StatefulWidget {
  final String productId;
  final ProductChangeNotifier model;

  ProductRelatedItems({required this.productId, required this.model});

  @override
  State<ProductRelatedItems> createState() => _ProductRelatedItemsState();
}

class _ProductRelatedItemsState extends State<ProductRelatedItems> {
  List<ProductModel> get relatedItems =>
      widget.model.relatedItemsMap[widget.productId] ?? [];

  @override
  Widget build(BuildContext context) {
    if (relatedItems.isNotEmpty) {
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
              style: mediumTextStyle.copyWith(fontSize: 16.sp),
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
