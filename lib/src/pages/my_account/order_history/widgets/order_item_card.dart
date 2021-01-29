import 'package:markaa/src/data/mock/mock.dart';
import 'package:markaa/src/data/models/index.dart';
import 'package:markaa/src/theme/styles.dart';
import 'package:markaa/src/theme/theme.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:isco_custom_widgets/isco_custom_widgets.dart';

class OrderItemCard extends StatelessWidget {
  final PageStyle pageStyle;
  final CartItemEntity cartItem;
  final bool canceled;
  final bool returned;

  OrderItemCard({
    this.pageStyle,
    this.cartItem,
    this.canceled = false,
    this.returned = false,
  });

  @override
  Widget build(BuildContext context) {
    bool isStock =
        cartItem.product.stockQty == null || cartItem.product.stockQty == 0;
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
                fit: BoxFit.fitHeight,
                loadingBuilder: (_, child, chunkEvent) {
                  return chunkEvent != null
                      ? Image.asset(
                          'lib/public/images/loading/image_loading.jpg',
                        )
                      : child;
                },
              ),
              SizedBox(width: pageStyle.unitWidth * 5),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      cartItem.product.name ?? '',
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
                          'items'
                              .tr()
                              .replaceFirst('0', '${cartItem.itemCount}'),
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
        if (returned) ...[
          _buildReturnedLabel()
        ] else if (canceled) ...[
          _buildCanceledLabel()
        ] else if (isStock) ...[
          _buildOutStockLabel()
        ],
      ],
    );
  }

  Widget _buildCanceledLabel() {
    if (lang == 'en') {
      return Positioned(
        bottom: 0,
        right: 0,
        child: Row(
          children: [
            Text(
              'items'.tr().replaceFirst('0', '${cartItem.itemCountCanceled}'),
              style: mediumTextStyle.copyWith(
                fontSize: pageStyle.unitFontSize * 14,
                color: dangerColor,
              ),
            ),
            SizedBox(width: pageStyle.unitWidth * 20),
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: pageStyle.unitWidth * 10,
                vertical: pageStyle.unitHeight * 4,
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
          ],
        ),
      );
    } else {
      return Positioned(
        bottom: 0,
        left: 0,
        child: Row(
          children: [
            Text(
              'items'.tr().replaceFirst('0', '${cartItem.itemCountCanceled}'),
              style: mediumTextStyle.copyWith(
                fontSize: pageStyle.unitFontSize * 14,
                color: dangerColor,
              ),
            ),
            SizedBox(width: pageStyle.unitWidth * 20),
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: pageStyle.unitWidth * 10,
                vertical: pageStyle.unitHeight * 4,
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
          ],
        ),
      );
    }
  }

  Widget _buildOutStockLabel() {
    if (lang == 'en') {
      return Positioned(
        bottom: 0,
        right: 0,
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: pageStyle.unitWidth * 10,
            vertical: pageStyle.unitHeight * 4,
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
      );
    } else {
      return Positioned(
        bottom: 0,
        left: 0,
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: pageStyle.unitWidth * 10,
            vertical: pageStyle.unitHeight * 4,
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
      );
    }
  }

  Widget _buildReturnedLabel() {
    String label = '';
    Color color;
    switch (cartItem.returnedStatus) {
      case 0:
        label = 'waiting_for_approval'.tr();
        color = primaryColor;
        break;
      case 1:
        label = 'return_approved'.tr();
        color = orangeColor;
        break;
      case 2:
        label = 'returned'.tr();
        color = orangeColor;
        break;
      case 3:
        label = 'declined'.tr();
        color = greyColor;
        break;
      default:
        label = 'waiting_for_approval'.tr();
        color = greyColor;
    }
    if (lang == 'en') {
      return Positioned(
        bottom: 0,
        right: 0,
        child: Row(
          children: [
            Text(
              'items'.tr().replaceFirst('0', '${cartItem.itemCountReturned}'),
              style: mediumTextStyle.copyWith(
                fontSize: pageStyle.unitFontSize * 14,
                color: color,
              ),
            ),
            SizedBox(width: pageStyle.unitWidth * 20),
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: pageStyle.unitWidth * 10,
                vertical: pageStyle.unitHeight * 4,
              ),
              color: color.withOpacity(0.5),
              child: Text(
                label,
                style: mediumTextStyle.copyWith(
                  fontSize: pageStyle.unitFontSize * 14,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      );
    } else {
      return Positioned(
        bottom: 0,
        left: 0,
        child: Row(
          children: [
            Text(
              'items'.tr().replaceFirst('0', '${cartItem.itemCountReturned}'),
              style: mediumTextStyle.copyWith(
                fontSize: pageStyle.unitFontSize * 14,
                color: color,
              ),
            ),
            SizedBox(width: pageStyle.unitWidth * 20),
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: pageStyle.unitWidth * 10,
                vertical: pageStyle.unitHeight * 4,
              ),
              color: color.withOpacity(0.5),
              child: Text(
                label,
                style: mediumTextStyle.copyWith(
                  fontSize: pageStyle.unitFontSize * 14,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      );
    }
  }
}
