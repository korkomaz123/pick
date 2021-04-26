import 'package:markaa/src/data/models/cart_item_entity.dart';
import 'package:markaa/src/data/models/index.dart';
import 'package:markaa/src/data/models/product_list_arguments.dart';
import 'package:markaa/src/routes/routes.dart';
import 'package:markaa/src/theme/styles.dart';
import 'package:markaa/src/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:isco_custom_widgets/isco_custom_widgets.dart';

class MarkaaReviewProductCard extends StatelessWidget {
  final PageStyle pageStyle;
  final CartItemEntity cartItem;

  MarkaaReviewProductCard({this.pageStyle, this.cartItem});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: pageStyle.deviceWidth,
      padding: EdgeInsets.symmetric(
        horizontal: pageStyle.unitWidth * 10,
        vertical: pageStyle.unitHeight * 20,
      ),
      child: Row(
        children: [
          Image.network(
            cartItem.product.imageUrl,
            width: pageStyle.unitHeight * 90,
            height: pageStyle.unitHeight * 120,
            fit: BoxFit.fitHeight,
            loadingBuilder: (_, child, chunkEvent) {
              return chunkEvent != null
                  ? Image.asset(
                      'lib/public/images/loading/image_loading.jpg',
                      width: pageStyle.unitHeight * 90,
                      height: pageStyle.unitHeight * 120,
                    )
                  : child;
            },
          ),
          SizedBox(width: pageStyle.unitWidth * 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InkWell(
                  onTap: () {
                    if (cartItem?.product?.brandEntity?.optionId != null) {
                      ProductListArguments arguments = ProductListArguments(
                        category: CategoryEntity(),
                        subCategory: [],
                        brand: cartItem.product.brandEntity,
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
                    cartItem?.product?.brandEntity?.brandLabel ?? '',
                    style: mediumTextStyle.copyWith(
                      color: primaryColor,
                      fontSize: pageStyle.unitFontSize * 12,
                    ),
                  ),
                ),
                Text(
                  cartItem.product.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: mediumTextStyle.copyWith(
                    fontSize: pageStyle.unitFontSize * 16,
                  ),
                ),
                Text(
                  cartItem.product.shortDescription,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  style: mediumTextStyle.copyWith(
                    fontSize: pageStyle.unitFontSize * 12,
                  ),
                ),
                SizedBox(height: pageStyle.unitHeight * 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'items'.tr().replaceFirst('0', '${cartItem.itemCount}'),
                      style: mediumTextStyle.copyWith(
                        fontSize: pageStyle.unitFontSize * 14,
                        color: primaryColor,
                      ),
                    ),
                    Text(
                      cartItem.product.price + ' ' + 'currency'.tr(),
                      style: mediumTextStyle.copyWith(
                        fontSize: pageStyle.unitFontSize * 16,
                        color: primaryColor,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}