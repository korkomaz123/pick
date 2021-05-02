import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:markaa/src/data/mock/mock.dart';
import 'package:markaa/src/data/models/category_entity.dart';
import 'package:markaa/src/data/models/product_list_arguments.dart';
import 'package:markaa/src/data/models/product_model.dart';
import 'package:markaa/src/routes/routes.dart';
import 'package:markaa/src/theme/styles.dart';

import '../../config.dart';

class AmazingProductCard extends StatelessWidget {
  final double cardSize;
  final double contentSize;
  final ProductModel product;

  AmazingProductCard({
    @required this.cardSize,
    @required this.contentSize,
    @required this.product,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.pushNamed(
        context,
        Routes.product,
        arguments: product,
      ),
      child: Container(
        width: cardSize + Config.pageStyle.unitWidth * 20,
        height: cardSize,
        child: Stack(
          children: [
            Container(
              width: cardSize,
              height: cardSize,
              margin: EdgeInsets.only(
                left: lang == 'en' ? Config.pageStyle.unitWidth * 20 : 0,
                right: lang == 'ar' ? Config.pageStyle.unitWidth * 20 : 0,
              ),
              child: CachedNetworkImage(
                imageUrl: product.imageUrl,
                fit: BoxFit.fitHeight,
                // progressIndicatorBuilder: (context, url, downloadProgress) =>
                //     Center(child: CircularProgressIndicator(value: downloadProgress.progress)),
                errorWidget: (context, url, error) => Center(child: Icon(Icons.image, size: 20)),
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(Config.pageStyle.unitFontSize * 20),
              ),
            ),
            Align(
              alignment: lang == 'en' ? Alignment.bottomLeft : Alignment.bottomRight,
              child: Container(
                width: contentSize,
                height: contentSize,
                margin: EdgeInsets.only(bottom: Config.pageStyle.unitHeight * 20),
                padding: EdgeInsets.symmetric(
                  horizontal: Config.pageStyle.unitWidth * 6,
                  vertical: Config.pageStyle.unitHeight * 10,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(
                    Config.pageStyle.unitFontSize * 10,
                  ),
                  color: Color(0xFF009AFB),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        InkWell(
                          onTap: () {
                            if (product?.brandEntity?.optionId != null) {
                              ProductListArguments arguments = ProductListArguments(
                                category: CategoryEntity(),
                                subCategory: [],
                                brand: product.brandEntity,
                                selectedSubCategoryIndex: 0,
                                isFromBrand: true,
                              );
                              Navigator.pushNamed(
                                context,
                                Routes.productList,
                                arguments: arguments,
                              );
                            }
                          },
                          child: Text(
                            product?.brandEntity?.brandLabel ?? '',
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: mediumTextStyle.copyWith(
                              color: Colors.white,
                              fontSize: Config.pageStyle.unitFontSize * 12,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        SizedBox(height: Config.pageStyle.unitHeight * 2),
                        Text(
                          product.name,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: mediumTextStyle.copyWith(
                            color: Colors.white70,
                            fontSize: Config.pageStyle.unitFontSize * 10,
                            height: Config.pageStyle.unitHeight * 1.5,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      product.price != null ? (product.price + ' ' + 'currency'.tr()) : '',
                      style: mediumTextStyle.copyWith(
                        fontSize: Config.pageStyle.unitFontSize * 16,
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
