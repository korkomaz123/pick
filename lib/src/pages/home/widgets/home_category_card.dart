import 'package:cached_network_image/cached_network_image.dart';
import 'package:markaa/src/components/markaa_text_button.dart';
import 'package:markaa/src/config/config.dart';
import 'package:markaa/src/data/models/category_entity.dart';
import 'package:markaa/src/data/models/product_list_arguments.dart';
import 'package:markaa/src/routes/routes.dart';
import 'package:markaa/src/theme/styles.dart';
import 'package:markaa/src/theme/theme.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomeCategoryCard extends StatelessWidget {
  final CategoryEntity category;

  HomeCategoryCard({required this.category});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        ProductListArguments arguments = ProductListArguments(
          category: category,
          subCategory: [],
          brand: null,
          selectedSubCategoryIndex: 0,
          isFromBrand: false,
        );
        Navigator.pushNamed(
          context,
          Routes.productList,
          arguments: arguments,
        );
      },
      child: Container(
        width: designWidth.w,
        height: 249.h,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: CachedNetworkImageProvider(category.imageUrl!),
            fit: BoxFit.cover,
          ),
        ),
        padding: EdgeInsets.symmetric(
          horizontal: 18.w,
          vertical: 23.h,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: designWidth.w / 1.5,
              child: Text(
                category.name,
                style: mediumTextStyle.copyWith(
                  color: darkColor,
                  fontSize: 23.sp,
                ),
              ),
            ),
            Container(
              width: designWidth.w / 2,
              padding: EdgeInsets.only(top: 10.h),
              child: Text(
                category.description ?? '',
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
                style: mediumTextStyle.copyWith(
                  color: greyDarkColor,
                  fontSize: 10.sp,
                ),
              ),
            ),
            Container(
              width: 120.w,
              padding: EdgeInsets.only(top: 4.h),
              child: MarkaaTextButton(
                title: 'view_all'.tr(),
                titleSize: 18.sp,
                titleColor: greyDarkColor,
                buttonColor: Colors.transparent,
                borderColor: greyDarkColor,
                onPressed: () {
                  ProductListArguments arguments = ProductListArguments(
                    category: category,
                    subCategory: [],
                    brand: null,
                    selectedSubCategoryIndex: 0,
                    isFromBrand: false,
                  );
                  Navigator.pushNamed(
                    context,
                    Routes.productList,
                    arguments: arguments,
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
