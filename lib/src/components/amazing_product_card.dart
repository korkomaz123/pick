import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:isco_custom_widgets/isco_custom_widgets.dart';
import 'package:markaa/src/data/mock/mock.dart';
import 'package:markaa/src/data/models/category_entity.dart';
import 'package:markaa/src/data/models/product_list_arguments.dart';
import 'package:markaa/src/data/models/product_model.dart';
import 'package:markaa/src/routes/routes.dart';
import 'package:markaa/src/theme/styles.dart';

class AmazingProductCard extends StatelessWidget {
  final PageStyle pageStyle;
  final double cardSize;
  final double contentSize;
  final ProductModel product;

  AmazingProductCard({
    @required this.pageStyle,
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
        width: cardSize + pageStyle.unitWidth * 20,
        height: cardSize,
        child: Stack(
          children: [
            Container(
              width: cardSize,
              height: cardSize,
              margin: EdgeInsets.only(
                left: lang == 'en' ? pageStyle.unitWidth * 20 : 0,
                right: lang == 'ar' ? pageStyle.unitWidth * 20 : 0,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                image: DecorationImage(
                  image: NetworkImage(product.imageUrl),
                  fit: BoxFit.fitHeight,
                ),
                borderRadius:
                    BorderRadius.circular(pageStyle.unitFontSize * 20),
              ),
            ),
            Align(
              alignment:
                  lang == 'en' ? Alignment.bottomLeft : Alignment.bottomRight,
              child: Container(
                width: contentSize,
                height: contentSize,
                margin: EdgeInsets.only(bottom: pageStyle.unitHeight * 20),
                padding: EdgeInsets.symmetric(
                  horizontal: pageStyle.unitWidth * 6,
                  vertical: pageStyle.unitHeight * 10,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(
                    pageStyle.unitFontSize * 10,
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
                              ProductListArguments arguments =
                                  ProductListArguments(
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
                              fontSize: pageStyle.unitFontSize * 12,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        SizedBox(height: pageStyle.unitHeight * 2),
                        Text(
                          product.name,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: mediumTextStyle.copyWith(
                            color: Colors.white70,
                            fontSize: pageStyle.unitFontSize * 10,
                            height: pageStyle.unitHeight * 1.5,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      product.price != null
                          ? (product.price + ' ' + 'currency'.tr())
                          : '',
                      style: mediumTextStyle.copyWith(
                        fontSize: pageStyle.unitFontSize * 16,
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
