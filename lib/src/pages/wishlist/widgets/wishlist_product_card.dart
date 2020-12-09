import 'package:ciga/src/components/ciga_text_button.dart';
import 'package:ciga/src/data/models/product_model.dart';
import 'package:ciga/src/theme/styles.dart';
import 'package:ciga/src/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:isco_custom_widgets/isco_custom_widgets.dart';

class WishlistProductCard extends StatelessWidget {
  final PageStyle pageStyle;
  final ProductModel product;
  final Function onRemoveWishlist;
  final Function onAddToCart;

  WishlistProductCard({
    this.pageStyle,
    this.product,
    this.onRemoveWishlist,
    this.onAddToCart,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: pageStyle.unitHeight * 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          InkWell(
            onTap: onRemoveWishlist,
            child: Icon(
              Icons.remove_circle_outline,
              size: pageStyle.unitFontSize * 22,
              color: greyDarkColor,
            ),
          ),
          Image.network(
            product.imageUrl,
            width: pageStyle.unitWidth * 124,
            height: pageStyle.unitHeight * 140,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  product.name,
                  style: mediumTextStyle.copyWith(
                    color: greyDarkColor,
                    fontSize: pageStyle.unitFontSize * 14,
                  ),
                ),
                SizedBox(height: pageStyle.unitHeight * 4),
                Text(
                  product.shortDescription,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: mediumTextStyle.copyWith(
                    color: greyDarkColor,
                    fontSize: pageStyle.unitFontSize * 12,
                  ),
                ),
                Text(
                  product.price + ' ' + 'currency'.tr(),
                  style: mediumTextStyle.copyWith(
                    fontSize: pageStyle.unitFontSize * 12,
                    color: greyColor,
                  ),
                ),
                SizedBox(height: pageStyle.unitHeight * 10),
                CigaTextButton(
                  title: 'wishlist_add_cart_button_title'.tr(),
                  titleSize: pageStyle.unitFontSize * 15,
                  titleColor: Colors.white,
                  buttonColor: primaryColor,
                  borderColor: Colors.transparent,
                  onPressed: onAddToCart,
                  radius: 10,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
