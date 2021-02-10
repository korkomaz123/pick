import 'package:markaa/src/data/models/index.dart';
import 'package:markaa/src/data/models/order_entity.dart';
import 'package:markaa/src/routes/routes.dart';
import 'package:markaa/src/theme/icons.dart';
import 'package:markaa/src/theme/styles.dart';
import 'package:markaa/src/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:isco_custom_widgets/isco_custom_widgets.dart';

class OrderCard extends StatefulWidget {
  final OrderEntity order;
  final PageStyle pageStyle;
  final Function onTap;

  OrderCard({this.order, this.pageStyle, this.onTap});

  @override
  _OrderCardState createState() => _OrderCardState();
}

class _OrderCardState extends State<OrderCard> {
  OrderEntity order;
  PageStyle pageStyle;
  bool isStock = false;

  @override
  void initState() {
    super.initState();
    order = widget.order;
    pageStyle = widget.pageStyle;
    _checkOrderItems();
  }

  void _checkOrderItems() {
    for (int i = 0; i < order.cartItems.length; i++) {
      if (order.cartItems[i].product.stockQty != null &&
          order.cartItems[i].product.stockQty > 0) {
        isStock = true;
        break;
      }
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    String icon = '';
    Color color;
    String status = '';
    switch (order.status) {
      case OrderStatusEnum.canceled:
        icon = cancelledIcon;
        color = greyDarkColor;
        status = 'order_cancelled'.tr();
        break;
      case OrderStatusEnum.pending:
        icon = pendingIcon;
        color = dangerColor;
        status = 'order_pending'.tr();
        break;
      case OrderStatusEnum.processing:
        icon = onProgressIcon;
        color = primaryColor;
        status = 'order_on_progress'.tr();
        break;
      case OrderStatusEnum.complete:
        icon = deliveredIcon;
        color = Color(0xFF32BEA6);
        status = 'order_delivered'.tr();
        break;
      case OrderStatusEnum.closed:
        icon = returnedIcon;
        color = darkColor;
        status = 'returned'.tr();
        break;
      default:
        icon = pendingIcon;
        color = dangerColor;
        status = 'order_pending'.tr();
    }
    return Container(
      width: double.infinity,
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(
              horizontal: pageStyle.unitWidth * 10,
              vertical: pageStyle.unitHeight * 15,
            ),
            color: Colors.grey.shade200,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'order_order_no'.tr() + ' #${order.orderNo}',
                  style: mediumTextStyle.copyWith(
                    color: greyDarkColor,
                    fontSize: pageStyle.unitFontSize * 14,
                  ),
                ),
                SvgPicture.asset(icon),
              ],
            ),
          ),
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(
              horizontal: pageStyle.unitWidth * 10,
              vertical: pageStyle.unitHeight * 10,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'order_order_date'.tr(),
                  style: mediumTextStyle.copyWith(
                    color: greyDarkColor,
                    fontSize: pageStyle.unitFontSize * 14,
                  ),
                ),
                Text(
                  order.orderDate,
                  style: mediumTextStyle.copyWith(
                    color: greyDarkColor,
                    fontSize: pageStyle.unitFontSize * 14,
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(
              horizontal: pageStyle.unitWidth * 10,
              vertical: pageStyle.unitHeight * 10,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'order_status'.tr(),
                  style: mediumTextStyle.copyWith(
                    color: greyDarkColor,
                    fontSize: pageStyle.unitFontSize * 14,
                  ),
                ),
                Text(
                  status,
                  style: mediumTextStyle.copyWith(
                    color: color,
                    fontSize: pageStyle.unitFontSize * 14,
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(
              horizontal: pageStyle.unitWidth * 10,
              vertical: pageStyle.unitHeight * 10,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'order_payment_method'.tr(),
                  style: mediumTextStyle.copyWith(
                    color: greyDarkColor,
                    fontSize: pageStyle.unitFontSize * 14,
                  ),
                ),
                Text(
                  order.paymentMethod.title,
                  style: mediumTextStyle.copyWith(
                    color: greyDarkColor,
                    fontSize: pageStyle.unitFontSize * 14,
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(
              horizontal: pageStyle.unitWidth * 10,
              vertical: pageStyle.unitHeight * 10,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'total'.tr(),
                  style: mediumTextStyle.copyWith(
                    color: greyDarkColor,
                    fontSize: pageStyle.unitFontSize * 14,
                  ),
                ),
                Text(
                  'currency'.tr() + ' ${order.totalPrice}',
                  style: mediumTextStyle.copyWith(
                    color: greyDarkColor,
                    fontSize: pageStyle.unitFontSize * 14,
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(
              vertical: pageStyle.unitHeight * 10,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                MaterialButton(
                  onPressed: () {
                    widget.onTap();
                    Navigator.pushNamed(
                      context,
                      Routes.viewOrder,
                      arguments: order,
                    );
                  },
                  height: pageStyle.unitHeight * 45,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  color: primaryColor,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        FontAwesomeIcons.eye,
                        color: Colors.white54,
                        size: pageStyle.unitFontSize * 20,
                      ),
                      SizedBox(width: pageStyle.unitWidth * 6),
                      Text(
                        'view_order_button_title'.tr(),
                        style: mediumTextStyle.copyWith(
                          fontSize: pageStyle.unitFontSize * 15,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: pageStyle.unitWidth * 5),
                MaterialButton(
                  onPressed:
                      !isStock || order.status == OrderStatusEnum.canceled
                          ? () => null
                          : () {
                              widget.onTap();
                              Navigator.pushNamed(
                                context,
                                Routes.reOrder,
                                arguments: order,
                              );
                            },
                  minWidth: pageStyle.unitWidth * 150,
                  height: pageStyle.unitHeight * 45,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  color: !isStock || order.status == OrderStatusEnum.canceled
                      ? greyColor
                      : primaryColor,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        FontAwesomeIcons.history,
                        color: Colors.white54,
                        size: pageStyle.unitFontSize * 20,
                      ),
                      SizedBox(width: pageStyle.unitWidth * 4),
                      Text(
                        'reorder_button_title'.tr(),
                        style: mediumTextStyle.copyWith(
                          fontSize: pageStyle.unitFontSize * 17,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
