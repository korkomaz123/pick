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
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'order_payment_method.dart';

class OrderCard extends StatefulWidget {
  final OrderEntity order;

  OrderCard({required this.order});

  @override
  _OrderCardState createState() => _OrderCardState();
}

class _OrderCardState extends State<OrderCard> {
  bool isStock = false;

  @override
  void initState() {
    super.initState();
    _checkOrderItems();
  }

  void _checkOrderItems() {
    for (int i = 0; i < widget.order.cartItems.length; i++) {
      if (widget.order.cartItems[i].product.stockQty! > 0) {
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
    switch (widget.order.status) {
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
              horizontal: 10.w,
              vertical: 15.h,
            ),
            color: Colors.grey.shade200,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'order_order_no'.tr() + ' #${widget.order.orderNo}',
                  style: mediumTextStyle.copyWith(
                    color: greyDarkColor,
                    fontSize: 14.sp,
                  ),
                ),
                SvgPicture.asset(icon),
              ],
            ),
          ),
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(
              horizontal: 10.w,
              vertical: 10.h,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'order_order_date'.tr(),
                  style: mediumTextStyle.copyWith(
                    color: greyDarkColor,
                    fontSize: 14.sp,
                  ),
                ),
                Text(
                  widget.order.orderDate,
                  style: mediumTextStyle.copyWith(
                    color: greyDarkColor,
                    fontSize: 14.sp,
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(
              horizontal: 10.w,
              vertical: 10.h,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'order_status'.tr(),
                  style: mediumTextStyle.copyWith(
                    color: greyDarkColor,
                    fontSize: 14.sp,
                  ),
                ),
                Text(
                  status,
                  style: mediumTextStyle.copyWith(
                    color: color,
                    fontSize: 14.sp,
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(
              horizontal: 10.w,
              vertical: 10.h,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'order_payment_method'.tr(),
                  style: mediumTextStyle.copyWith(
                    color: greyDarkColor,
                    fontSize: 14.sp,
                  ),
                ),
                OrderPaymentMethod(
                  paymentMethod: widget.order.paymentMethod.id,
                ),
              ],
            ),
          ),
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(
              horizontal: 10.w,
              vertical: 10.h,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'total'.tr(),
                  style: mediumTextStyle.copyWith(
                    color: greyDarkColor,
                    fontSize: 14.sp,
                  ),
                ),
                Text(
                  'currency'.tr() + ' ${widget.order.totalPrice}',
                  style: mediumTextStyle.copyWith(
                    color: greyDarkColor,
                    fontSize: 14.sp,
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(
              vertical: 10.h,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                MaterialButton(
                  elevation: 0,
                  onPressed: () => Navigator.pushNamed(
                    context,
                    Routes.viewOrder,
                    arguments: widget.order,
                  ),
                  height: 45.h,
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
                        size: 20.sp,
                      ),
                      SizedBox(width: 6.w),
                      Text(
                        'view_order_button_title'.tr(),
                        style: mediumTextStyle.copyWith(
                          fontSize: 15.sp,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 5.w),
                MaterialButton(
                  elevation: 0,
                  onPressed:
                      !isStock //|| widget.order.status == OrderStatusEnum.canceled
                          ? () => null
                          : () => Navigator.pushNamed(
                                context,
                                Routes.reOrder,
                                arguments: widget.order,
                              ),
                  minWidth: 150.w,
                  height: 45.h,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  color:
                      !isStock //||widget.order.status == OrderStatusEnum.canceled
                          ? greyColor
                          : primaryColor,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        FontAwesomeIcons.history,
                        color: Colors.white54,
                        size: 20.sp,
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        'reorder_button_title'.tr(),
                        style: mediumTextStyle.copyWith(
                          fontSize: 17.sp,
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
