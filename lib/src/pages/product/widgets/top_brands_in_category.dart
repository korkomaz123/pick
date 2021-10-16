import 'package:cached_network_image/cached_network_image.dart';
import 'package:markaa/src/change_notifier/product_change_notifier.dart';
import 'package:markaa/src/data/models/index.dart';
import 'package:markaa/src/data/models/product_list_arguments.dart';
import 'package:markaa/src/routes/routes.dart';
import 'package:markaa/src/theme/styles.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TopBrandsInCategory extends StatefulWidget {
  final String productId;
  final ProductChangeNotifier model;

  TopBrandsInCategory({required this.productId, required this.model});

  @override
  State<TopBrandsInCategory> createState() => _TopBrandsInCategoryState();
}

class _TopBrandsInCategoryState extends State<TopBrandsInCategory> {
  List<BrandEntity> get brands => widget.model.brandsMap[widget.productId]!;
  dynamic get category => widget.model.categoryMap[widget.productId];

  @override
  Widget build(BuildContext context) {
    if (brands.isEmpty) {
      return Container();
    } else {
      return Container(
        width: double.infinity,
        color: Colors.white,
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
        margin: EdgeInsets.symmetric(vertical: 10.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'home_top_brands'.tr() + category['category_name'],
              style: mediumTextStyle.copyWith(fontSize: 16.sp),
            ),
            Divider(),
            SizedBox(height: 4.h),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: brands
                    .map(
                      (e) => InkWell(
                        onTap: () {
                          ProductListArguments arguments = ProductListArguments(
                            category: null,
                            subCategory: [],
                            brand: e,
                            selectedSubCategoryIndex: 0,
                            isFromBrand: true,
                          );
                          Navigator.pushNamed(context, Routes.productList,
                              arguments: arguments);
                        },
                        child: CachedNetworkImage(
                          imageUrl: e.brandThumbnail!,
                          placeholder: (context, url) => Container(),
                          errorWidget: (context, url, error) =>
                              Icon(Icons.error),
                          width: 120.w,
                          height: 60.h,
                          fit: BoxFit.fitHeight,
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
          ],
        ),
      );
    }
  }
}
