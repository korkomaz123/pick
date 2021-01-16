import 'package:ciga/src/data/models/index.dart';
import 'package:ciga/src/data/models/product_list_arguments.dart';
import 'package:ciga/src/routes/routes.dart';
import 'package:ciga/src/theme/styles.dart';
import 'package:ciga/src/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:isco_custom_widgets/isco_custom_widgets.dart';

import 'my_cart_qty_horizontal_picker.dart';

class MyCartItem extends StatelessWidget {
  final PageStyle pageStyle;
  final CartItemEntity cartItem;
  final int discount;
  final String cartId;
  final Function onRemoveCartItem;

  MyCartItem({
    this.pageStyle,
    this.cartItem,
    this.discount,
    this.cartId,
    this.onRemoveCartItem,
  });

  @override
  Widget build(BuildContext context) {
    String priceString = cartItem.product.price;
    double price = double.parse(priceString);
    double discountPrice = price * (100 - discount) / 100;
    String discountPriceString = discountPrice.toStringAsFixed(2);
    return Stack(
      children: [
        Container(
          width: double.infinity,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              InkWell(
                onTap: onRemoveCartItem,
                child: Icon(
                  Icons.remove_circle_outline,
                  size: pageStyle.unitFontSize * 22,
                  color: greyDarkColor,
                ),
              ),
              Image.network(
                cartItem.product.imageUrl,
                width: pageStyle.unitWidth * 134,
                height: pageStyle.unitHeight * 150,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: () {
                        if (cartItem.product.brandId.isNotEmpty) {
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
                        cartItem.product.brandLabel,
                        style: mediumTextStyle.copyWith(
                          color: primaryColor,
                          fontSize: pageStyle.unitFontSize * 10,
                        ),
                      ),
                    ),
                    Text(
                      cartItem.product.name,
                      style: mediumTextStyle.copyWith(
                        fontSize: pageStyle.unitFontSize * 14,
                      ),
                    ),
                    Text(
                      cartItem.product.shortDescription,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: mediumTextStyle.copyWith(
                        color: greyColor,
                        fontSize: pageStyle.unitFontSize * 12,
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          priceString + ' ' + 'currency'.tr(),
                          style: mediumTextStyle.copyWith(
                            fontSize: pageStyle.unitFontSize * 12,
                            color: greyColor,
                          ),
                        ),
                        SizedBox(width: pageStyle.unitWidth * 20),
                        Text(
                          discount != 0
                              ? discountPriceString + ' ' + 'currency'.tr()
                              : '',
                          style: mediumTextStyle.copyWith(
                            decorationStyle: TextDecorationStyle.solid,
                            decoration: TextDecoration.lineThrough,
                            decorationColor: dangerColor,
                            fontSize: pageStyle.unitFontSize * 12,
                            color: greyColor,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: pageStyle.unitHeight * 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          onTap: () => null,
                          child: Text(
                            'save_for_later'.tr(),
                            style: mediumTextStyle.copyWith(
                              fontSize: pageStyle.unitFontSize * 12,
                              color: primaryColor,
                            ),
                          ),
                        ),
                        MyCartQtyHorizontalPicker(
                          pageStyle: pageStyle,
                          cartItem: cartItem,
                          cartId: cartId,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        cartItem.availableCount == 0 ? _buildOutOfStock() : SizedBox.shrink(),
      ],
    );
  }

  Widget _buildOutOfStock() {
    return Positioned(
      top: pageStyle.unitHeight * 50,
      right: 0,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: pageStyle.unitWidth * 15,
          vertical: pageStyle.unitHeight * 5,
        ),
        color: primarySwatchColor.withOpacity(0.4),
        child: Text(
          'out_stock'.tr(),
          style: mediumTextStyle.copyWith(
            fontSize: pageStyle.unitFontSize * 14,
            color: Colors.white70,
          ),
        ),
      ),
    );
  }
}