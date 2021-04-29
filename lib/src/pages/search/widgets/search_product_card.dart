import 'package:markaa/src/data/models/product_model.dart';
import 'package:markaa/src/theme/styles.dart';
import 'package:markaa/src/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SearchProductCard extends StatelessWidget {
  final ProductModel product;

  SearchProductCard({this.product});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.network(
            product.imageUrl,
            width: 50.w,
            height: 50.h,
            fit: BoxFit.fitHeight,
          ),
          Expanded(
            child: Text(
              product.name,
              style: mediumTextStyle.copyWith(
                color: Colors.black,
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          SizedBox(width: 10.w),
          Text(
            product.price + ' ' + 'currency'.tr(),
            style: mediumTextStyle.copyWith(
              color: greyDarkColor,
              fontSize: 12.sp,
            ),
          ),
        ],
      ),
    );
  }
}
