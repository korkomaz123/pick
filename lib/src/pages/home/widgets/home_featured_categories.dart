import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:markaa/src/change_notifier/home_change_notifier.dart';
import 'package:markaa/src/components/markaa_page_loading_kit.dart';
import 'package:markaa/src/data/models/product_list_arguments.dart';
import 'package:markaa/src/routes/routes.dart';
import 'package:markaa/src/theme/styles.dart';
import 'package:markaa/src/theme/theme.dart';

import '../../../../preload.dart';

class HomeFeaturedCategories extends StatelessWidget {
  final HomeChangeNotifier homeChangeNotifier;

  HomeFeaturedCategories({required this.homeChangeNotifier});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: Colors.white,
      padding: EdgeInsets.symmetric(vertical: 10.h),
      child: homeChangeNotifier.featuredCategories.isEmpty
          ? Center(child: PulseLoadingSpinner())
          : SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: homeChangeNotifier.featuredCategories.map((category) {
                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: 5.w),
                    child: Column(
                      children: [
                        InkWell(
                          onTap: () {
                            ProductListArguments arguments =
                                ProductListArguments(
                              category: category,
                              subCategory: [],
                              brand: null,
                              selectedSubCategoryIndex: 0,
                              isFromBrand: false,
                            );
                            Navigator.pushNamed(
                              Preload.navigatorKey!.currentContext!,
                              Routes.productList,
                              arguments: arguments,
                            );
                          },
                          child: Container(
                            width: 70.w,
                            height: 70.w,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border:
                                  Border.all(color: primaryColor, width: 2.w),
                            ),
                            child: CachedNetworkImage(
                              imageBuilder: (context, imageProvider) =>
                                  CircleAvatar(backgroundImage: imageProvider),
                              imageUrl: category.imageUrl!,
                              fit: BoxFit.cover,
                              errorWidget: (context, url, error) =>
                                  Center(child: Icon(Icons.image, size: 20)),
                            ),
                          ),
                        ),
                        SizedBox(height: 5.h),
                        Container(
                          width: 75.w,
                          child: Text(
                            category.name,
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            style: mediumTextStyle.copyWith(
                              fontSize: 10.sp,
                              color: greyDarkColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
    );
  }
}
