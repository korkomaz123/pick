import 'package:ciga/src/data/models/index.dart';
import 'package:ciga/src/theme/styles.dart';
import 'package:ciga/src/theme/theme.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:isco_custom_widgets/isco_custom_widgets.dart';

class OrderItemCard extends StatelessWidget {
  final PageStyle pageStyle;
  final CartItemEntity cartItem;
  final bool canceled;

  OrderItemCard({
    this.pageStyle,
    this.cartItem,
    this.canceled = false,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: pageStyle.deviceWidth,
          padding: EdgeInsets.symmetric(
            horizontal: pageStyle.unitWidth * 10,
            vertical: pageStyle.unitHeight * 20,
          ),
          child: Row(
            children: [
              Image.network(
                cartItem.product.imageUrl,
                width: pageStyle.unitWidth * 90,
                height: pageStyle.unitHeight * 120,
                fit: BoxFit.fill,
                loadingBuilder: (_, child, chunkEvent) {
                  return chunkEvent != null
                      ? Image.asset(
                          'lib/public/images/loading/image_loading.jpg',
                        )
                      : child;
                },
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      cartItem.product.name ?? '',
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
                          (canceled
                                      ? cartItem.itemCountCanceled
                                      : cartItem.itemCount)
                                  .toString() +
                              'items'.tr().replaceFirst('0', ''),
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
        ),
        canceled
            ? Positioned(
                top: pageStyle.unitHeight * 50,
                right: 0,
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: pageStyle.unitWidth * 20,
                    vertical: pageStyle.unitHeight * 10,
                  ),
                  color: dangerColor.withOpacity(0.5),
                  child: Text(
                    'item_canceled'.tr(),
                    style: mediumTextStyle.copyWith(
                      fontSize: pageStyle.unitFontSize * 14,
                      color: Colors.white,
                    ),
                  ),
                ),
              )
            : SizedBox.shrink(),
        !canceled &&
                (cartItem.product.stockQty == null ||
                    cartItem.product.stockQty == 0)
            ? Positioned(
                top: pageStyle.unitHeight * 50,
                right: 0,
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: pageStyle.unitWidth * 20,
                    vertical: pageStyle.unitHeight * 10,
                  ),
                  color: primarySwatchColor.withOpacity(0.5),
                  child: Text(
                    'out_stock'.tr(),
                    style: mediumTextStyle.copyWith(
                      fontSize: pageStyle.unitFontSize * 14,
                      color: Colors.white,
                    ),
                  ),
                ),
              )
            : SizedBox.shrink(),
      ],
    );
  }
}
