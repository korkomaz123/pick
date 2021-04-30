import 'package:flutter/material.dart';
import 'package:markaa/src/data/models/brand_entity.dart';
import 'package:markaa/src/data/models/product_list_arguments.dart';
import 'package:markaa/src/routes/routes.dart';
import 'package:markaa/src/theme/styles.dart';
import 'package:markaa/src/theme/theme.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:markaa/src/change_notifier/category_change_notifier.dart';

class HomeFeaturedCategories extends StatefulWidget {
  final CategoryChangeNotifier model;

  HomeFeaturedCategories({this.model});

  @override
  _HomeFeaturedCategoriesState createState() => _HomeFeaturedCategoriesState();
}

class _HomeFeaturedCategoriesState extends State<HomeFeaturedCategories> {
  CategoryChangeNotifier model;

  @override
  void initState() {
    super.initState();
    model = widget.model;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 375.w,
      padding: EdgeInsets.symmetric(vertical: 15.h),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: model.featuredCategories.map((category) {
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 5.w),
              child: Column(
                children: [
                  InkWell(
                    onTap: () {
                      ProductListArguments arguments = ProductListArguments(
                        category: category,
                        subCategory: [],
                        brand: BrandEntity(),
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
                      width: 70.w,
                      height: 70.w,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(category.imageUrl),
                          fit: BoxFit.cover,
                        ),
                        shape: BoxShape.circle,
                        border: Border.all(color: primaryColor, width: 2.w),
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
