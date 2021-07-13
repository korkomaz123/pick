import 'package:cached_network_image/cached_network_image.dart';
import 'package:markaa/src/data/models/brand_entity.dart';
import 'package:markaa/src/data/models/category_entity.dart';
import 'package:markaa/src/data/models/product_list_arguments.dart';
import 'package:markaa/src/routes/routes.dart';
import 'package:markaa/src/theme/styles.dart';
import 'package:markaa/src/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:markaa/src/utils/repositories/product_repository.dart';

import '../../../../preload.dart';

class TopBrandsInCategory extends StatefulWidget {
  final String productId;
  TopBrandsInCategory({this.productId});
  @override
  _TopBrandsInCategoryState createState() => _TopBrandsInCategoryState();
}

class _TopBrandsInCategoryState extends State<TopBrandsInCategory> {
  final ProductRepository productRepository = ProductRepository();
  List<BrandEntity> brands = [];
  Future<dynamic> _loadData() async {
    var res = await productRepository.getTopBrandByProductCategory(widget.productId, Preload.language);
    if (res['code'] == 'SUCCESS') {
      if (res['brands'].length > 0) {
        brands.clear();
        res['brands'].forEach((key, obj) {
          brands.add(BrandEntity.fromJson(obj));
        });
        return res['categories'][0];
      }
    }
    return [];
  }

  @override
  void initState() {
    _loadTopBtands = _loadData();
    super.initState();
  }

  Future _loadTopBtands;
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _loadTopBtands,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting || !snapshot.hasData || brands.isEmpty)
          return Container();
        else
          return Container(
            width: double.infinity,
            color: Colors.white,
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
            margin: EdgeInsets.symmetric(vertical: 10.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'home_top_brands'.tr() + snapshot.data['category_name'],
                  style: mediumTextStyle.copyWith(color: greyColor, fontSize: 16.sp),
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
                                category: CategoryEntity(),
                                subCategory: [],
                                brand: e,
                                selectedSubCategoryIndex: 0,
                                isFromBrand: true,
                              );
                              Navigator.pushNamed(context, Routes.productList, arguments: arguments);
                            },
                            child: CachedNetworkImage(
                              imageUrl: e.brandThumbnail,
                              placeholder: (context, url) => Container(),
                              errorWidget: (context, url, error) => Icon(Icons.error),
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
      },
    );
  }
}
