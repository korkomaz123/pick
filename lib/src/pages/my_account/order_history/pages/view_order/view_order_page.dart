import 'package:markaa/src/components/markaa_app_bar.dart';
import 'package:markaa/src/components/markaa_bottom_bar.dart';
import 'package:markaa/src/components/markaa_side_menu.dart';
import 'package:markaa/src/data/models/enum.dart';
import 'package:markaa/src/data/models/order_entity.dart';
import 'package:markaa/src/pages/my_account/order_history/widgets/order_address_bar.dart';
import 'package:markaa/src/pages/my_account/order_history/widgets/order_item_card.dart';
import 'package:markaa/src/pages/my_account/order_history/widgets/order_payment_method.dart';
import 'package:markaa/src/routes/routes.dart';
import 'package:markaa/src/theme/icons.dart';
import 'package:markaa/src/theme/styles.dart';
import 'package:markaa/src/theme/theme.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:markaa/src/utils/services/numeric_service.dart';

class ViewOrderPage extends StatefulWidget {
  final OrderEntity order;

  ViewOrderPage({this.order});

  @override
  _ViewOrderPageState createState() => _ViewOrderPageState();
}

class _ViewOrderPageState extends State<ViewOrderPage> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  OrderEntity order;
  String icon = '';
  Color color;
  String status = '';
  Widget paymentWidget = SizedBox.shrink();
  bool isStock = false;

  @override
  void initState() {
    super.initState();
    order = widget.order;
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
    _checkOrderItems();
    setState(() {});
  }

  void _checkOrderItems() {
    for (int i = 0; i < order.cartItems.length; i++) {
      if (order.cartItems[i].product.stockQty != null &&
          order.cartItems[i].product.stockQty > 0) {
        isStock = true;
        break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.white,
      appBar: MarkaaAppBar(
        scaffoldKey: scaffoldKey,
        isCenter: false,
      ),
      drawer: MarkaaSideMenu(),
      body: Column(
        children: [
          _buildAppBar(),
          _buildOrder(),
        ],
      ),
      bottomNavigationBar: MarkaaBottomBar(
        activeItem: BottomEnum.account,
      ),
    );
  }

  Widget _buildAppBar() {
    return AppBar(
      elevation: 0,
      toolbarHeight: 50.h,
      leading: IconButton(
        onPressed: () => Navigator.pop(context),
        icon: Icon(Icons.arrow_back_ios, size: 22.sp),
      ),
      centerTitle: true,
      title: Text(
        'view_order_button_title'.tr(),
        style: mediumTextStyle.copyWith(
          color: Colors.white,
          fontSize: 17.sp,
        ),
      ),
    );
  }

  Widget _buildOrder() {
    return Expanded(
      child: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: 10.w,
            vertical: 20.h,
          ),
          child: Column(
            children: [
              _buildOrderNo(),
              SizedBox(height: 10.h),
              _buildOrderDate(),
              Divider(color: greyColor, thickness: 0.5.h),
              _buildOrderStatus(),
              Divider(color: greyColor, thickness: 0.5.h),
              _buildOrderItems(),
              SizedBox(height: 20.h),
              _buildOrderPaymentMethod(),
              Divider(color: greyColor, thickness: 0.5.h),
              _buildSubtotal(),
              _buildShippingCost(),
              if (widget.order.discountAmount != 0 &&
                  widget.order.status != OrderStatusEnum.canceled) ...[
                _buildDiscount(),
              ],
              _buildTotal(),
              OrderAddressBar(address: order.address),
              if (isStock && order.status != OrderStatusEnum.canceled) ...[
                _buildReorderButton()
              ],
              if (order.status == OrderStatusEnum.pending ||
                  order.status == OrderStatusEnum.order_approval_pending) ...[
                _buildCancelOrderButton()
              ],
              if (order.status == OrderStatusEnum.complete) ...[
                _buildReturnOrderButton()
              ]
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOrderNo() {
    return Container(
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
            'order_order_no'.tr() + ' #${order.orderNo}',
            style: mediumTextStyle.copyWith(
              color: greyDarkColor,
              fontSize: 14.sp,
            ),
          ),
          SvgPicture.asset(icon),
        ],
      ),
    );
  }

  Widget _buildOrderDate() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: 10.w,
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
            order.orderDate,
            style: mediumTextStyle.copyWith(
              color: greyDarkColor,
              fontSize: 14.sp,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderStatus() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: 10.w,
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
    );
  }

  Widget _buildOrderItems() {
    return Column(
      children: List.generate(
        order.cartItems.length,
        (index) {
          return Column(
            children: [
              OrderItemCard(
                cartItem: order.cartItems[index],
                canceled: order.cartItems[index].itemCountCanceled > 0,
                returned: order.cartItems[index].itemCountReturned > 0,
              ),
              if (index < (order.cartItems.length - 1)) ...[
                Divider(color: greyColor, thickness: 0.5)
              ],
            ],
          );
        },
      ),
    );
  }

  Widget _buildOrderPaymentMethod() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: 10.w,
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
            paymentMethod: order.paymentMethod.id,
          ),
        ],
      ),
    );
  }

  Widget _buildSubtotal() {
    String subtotal = '0.000';
    if (order.status != OrderStatusEnum.canceled) {
      subtotal = order.subtotalPrice;
    }
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: 10.w,
        vertical: 5.h,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'checkout_subtotal_title'.tr(),
            style: mediumTextStyle.copyWith(
              color: greyDarkColor,
              fontSize: 14.sp,
            ),
          ),
          Text(
            'currency'.tr() + ' $subtotal',
            style: mediumTextStyle.copyWith(
              color: greyDarkColor,
              fontSize: 14.sp,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShippingCost() {
    double fees = .0;
    if (order.status != OrderStatusEnum.canceled) {
      fees = order.shippingMethod.serviceFees;
    }
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: 10.w,
        vertical: 5.h,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'checkout_shipping_cost_title'.tr(),
            style: mediumTextStyle.copyWith(
              color: greyDarkColor,
              fontSize: 14.sp,
            ),
          ),
          Text(
            fees == 0
                ? 'free'.tr()
                : '${'currency'.tr()} ${NumericService.roundString(fees, 3)}',
            style: mediumTextStyle.copyWith(
              color: greyDarkColor,
              fontSize: 14.sp,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDiscount() {
    double discount = .0;
    if (widget.order.discountType == 'percentage') {
      discount = -double.parse(widget.order.subtotalPrice) *
          widget.order.discountAmount /
          100;
    } else {
      discount = -widget.order.discountAmount;
    }
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: 10.w,
        vertical: 5.h,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'discount'.tr(),
            style: mediumTextStyle.copyWith(
              color: greyDarkColor,
              fontSize: 14.sp,
            ),
          ),
          Text(
            '${'currency'.tr()} ${NumericService.roundString(discount, 3)}',
            style: mediumTextStyle.copyWith(
              color: greyDarkColor,
              fontSize: 14.sp,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTotal() {
    String totalPrice = '0.000';
    if (order.status != OrderStatusEnum.canceled) {
      totalPrice = order.totalPrice;
    }
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: 10.w,
        vertical: 10.h,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'total'.tr().toUpperCase(),
            style: mediumTextStyle.copyWith(
              color: primaryColor,
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            'currency'.tr() + ' $totalPrice',
            style: mediumTextStyle.copyWith(
              color: primaryColor,
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReorderButton() {
    return MaterialButton(
      onPressed: () => Navigator.pushNamed(
        context,
        Routes.reOrder,
        arguments: order,
      ),
      minWidth: 150.w,
      height: 45.h,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
      ),
      color: primaryColor,
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
    );
  }

  Widget _buildCancelOrderButton() {
    return InkWell(
      onTap: () => Navigator.pushNamed(
        context,
        Routes.cancelOrder,
        arguments: order,
      ),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10.h),
        child: Text(
          'cancel_order_button_title'.tr(),
          style: mediumTextStyle.copyWith(
            fontSize: 17.sp,
            color: dangerColor,
          ),
        ),
      ),
    );
  }

  Widget _buildReturnOrderButton() {
    return InkWell(
      onTap: () => Navigator.pushNamed(
        context,
        Routes.returnOrder,
        arguments: order,
      ),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(returnIcon),
            SizedBox(width: 4.w),
            Text(
              'return_button_title'.tr(),
              style: mediumTextStyle.copyWith(
                fontSize: 17.sp,
                color: greyDarkColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
