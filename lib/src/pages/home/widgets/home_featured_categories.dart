import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:markaa/src/change_notifier/home_change_notifier.dart';
import 'package:markaa/src/data/models/brand_entity.dart';
import 'package:markaa/src/data/models/product_list_arguments.dart';
import 'package:markaa/src/routes/routes.dart';
import 'package:markaa/src/theme/styles.dart';
import 'package:markaa/src/theme/theme.dart';

import '../../../../config.dart';

class HomeFeaturedCategories extends StatelessWidget {
  final HomeChangeNotifier homeChangeNotifier;
  HomeFeaturedCategories({@required this.homeChangeNotifier});
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: homeChangeNotifier.featuredCategories.map((category) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: Config.pageStyle.unitWidth * 5),
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
                    Navigator.pushNamed(Config.navigatorKey.currentContext, Routes.productList, arguments: arguments);
                  },
                  child: Container(
                    width: Config.pageStyle.unitWidth * 70,
                    height: Config.pageStyle.unitWidth * 70,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: primaryColor, width: Config.pageStyle.unitWidth * 2),
                    ),
                    child: CachedNetworkImage(
                      imageBuilder: (context, imageProvider) => CircleAvatar(backgroundImage: imageProvider),
                      imageUrl: category.imageUrl,
                      fit: BoxFit.cover,
                      // progressIndicatorBuilder: (context, url, downloadProgress) =>
                      //     Center(child: CircularProgressIndicator(value: downloadProgress.progress)),
                      errorWidget: (context, url, error) => Center(child: Icon(Icons.image, size: 20)),
                    ),
                  ),
                ),
                SizedBox(height: Config.pageStyle.unitHeight * 5),
                Container(
                  width: Config.pageStyle.unitWidth * 75,
                  child: Text(
                    category.name,
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    style: mediumTextStyle.copyWith(fontSize: Config.pageStyle.unitFontSize * 10, color: greyDarkColor),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}
