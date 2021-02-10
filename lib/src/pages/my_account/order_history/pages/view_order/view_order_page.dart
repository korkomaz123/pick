import 'package:markaa/src/components/markaa_app_bar.dart';
import 'package:markaa/src/components/markaa_bottom_bar.dart';
import 'package:markaa/src/components/markaa_side_menu.dart';
import 'package:markaa/src/config/config.dart';
import 'package:markaa/src/data/models/enum.dart';
import 'package:markaa/src/data/models/order_entity.dart';
import 'package:markaa/src/pages/my_account/order_history/widgets/order_item_card.dart';
import 'package:markaa/src/routes/routes.dart';
import 'package:markaa/src/theme/icons.dart';
import 'package:markaa/src/theme/styles.dart';
import 'package:markaa/src/theme/theme.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:isco_custom_widgets/isco_custom_widgets.dart';

class ViewOrderPage extends StatefulWidget {
  final OrderEntity order;

  ViewOrderPage({this.order});

  @override
  _ViewOrderPageState createState() => _ViewOrderPageState();
}

class _ViewOrderPageState extends State<ViewOrderPage> {
  PageStyle pageStyle;
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
    pageStyle = PageStyle(context, designWidth, designHeight);
    pageStyle.initializePageStyles();
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.white,
      appBar: MarkaaAppBar(
        scaffoldKey: scaffoldKey,
        pageStyle: pageStyle,
        isCenter: false,
      ),
      drawer: MarkaaSideMenu(pageStyle: pageStyle),
      body: Column(
        children: [
          _buildAppBar(),
          _buildOrder(),
        ],
      ),
      bottomNavigationBar: MarkaaBottomBar(
        pageStyle: pageStyle,
        activeItem: BottomEnum.account,
      ),
    );
  }

  Widget _buildAppBar() {
    return AppBar(
      elevation: 0,
      toolbarHeight: pageStyle.unitHeight * 50,
      leading: IconButton(
        onPressed: () => Navigator.pop(context),
        icon: Icon(Icons.arrow_back_ios, size: pageStyle.unitFontSize * 22),
      ),
      centerTitle: true,
      title: Text(
        'view_order_button_title'.tr(),
        style: mediumTextStyle.copyWith(
          color: Colors.white,
          fontSize: pageStyle.unitFontSize * 17,
        ),
      ),
    );
  }

  Widget _buildOrder() {
    return Expanded(
      child: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: pageStyle.unitWidth * 10,
            vertical: pageStyle.unitHeight * 20,
          ),
          child: Column(
            children: [
              _buildOrderNo(),
              SizedBox(height: pageStyle.unitHeight * 10),
              _buildOrderDate(),
              Divider(color: greyColor, thickness: pageStyle.unitHeight * 0.5),
              _buildOrderStatus(),
              Divider(color: greyColor, thickness: pageStyle.unitHeight * 0.5),
              _buildOrderItems(),
              SizedBox(height: pageStyle.unitHeight * 20),
              _buildOrderPaymentMethod(),
              Divider(color: greyColor, thickness: pageStyle.unitHeight * 0.5),
              _buildSubtotal(),
              _buildShippingCost(),
              _buildTotal(),
              _buildAddressBar(),
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
    );
  }

  Widget _buildOrderDate() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: pageStyle.unitWidth * 10,
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
    );
  }

  Widget _buildOrderStatus() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: pageStyle.unitWidth * 10,
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
                pageStyle: pageStyle,
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
        horizontal: pageStyle.unitWidth * 10,
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
          Row(
            children: [
              paymentWidget,
              Text(
                order.paymentMethod.title,
                style: mediumTextStyle.copyWith(
                  color: greyDarkColor,
                  fontSize: pageStyle.unitFontSize * 14,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSubtotal() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: pageStyle.unitWidth * 10,
        vertical: pageStyle.unitHeight * 5,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'checkout_subtotal_title'.tr(),
            style: mediumTextStyle.copyWith(
              color: greyDarkColor,
              fontSize: pageStyle.unitFontSize * 14,
            ),
          ),
          Text(
            'currency'.tr() + ' ${order.subtotalPrice}',
            style: mediumTextStyle.copyWith(
              color: greyDarkColor,
              fontSize: pageStyle.unitFontSize * 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShippingCost() {
    double fees = .0;
    print(order.status);
    if (order.status != OrderStatusEnum.canceled) {
      fees = order.shippingMethod.serviceFees;
      print(fees);
    }
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: pageStyle.unitWidth * 10,
        vertical: pageStyle.unitHeight * 5,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'checkout_shipping_cost_title'.tr(),
            style: mediumTextStyle.copyWith(
              color: greyDarkColor,
              fontSize: pageStyle.unitFontSize * 14,
            ),
          ),
          Text(
            'currency'.tr() + ' ${fees.toStringAsFixed(2)}',
            style: mediumTextStyle.copyWith(
              color: greyDarkColor,
              fontSize: pageStyle.unitFontSize * 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTotal() {
    double total = double.parse(order.totalPrice);
    if (order.status == OrderStatusEnum.canceled) {
      total -= order.shippingMethod.serviceFees;
    }
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: pageStyle.unitWidth * 10,
        vertical: pageStyle.unitHeight * 10,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'total'.tr().toUpperCase(),
            style: mediumTextStyle.copyWith(
              color: primaryColor,
              fontSize: pageStyle.unitFontSize * 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            'currency'.tr() + ' ${total.toStringAsFixed(2)}',
            style: mediumTextStyle.copyWith(
              color: primaryColor,
              fontSize: pageStyle.unitFontSize * 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddressBar() {
    return Container(
      width: pageStyle.deviceWidth,
      margin: EdgeInsets.symmetric(
        horizontal: pageStyle.unitWidth * 10,
        vertical: pageStyle.unitHeight * 30,
      ),
      padding: EdgeInsets.symmetric(
        horizontal: pageStyle.unitWidth * 10,
        vertical: pageStyle.unitHeight * 30,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(2),
        color: Colors.grey.shade300,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            order.address.title.isNotEmpty
                ? '${order.address.title}: '
                : 'Unnamed title: ',
            style: boldTextStyle.copyWith(
              fontSize: pageStyle.unitFontSize * 14,
              color: primaryColor,
            ),
          ),
          Text(
            '${order.address.street}, ${order.address.city}, ${order.address.countryId}',
            style: mediumTextStyle.copyWith(
              fontSize: pageStyle.unitFontSize * 14,
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
      minWidth: pageStyle.unitWidth * 150,
      height: pageStyle.unitHeight * 45,
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
        padding: EdgeInsets.symmetric(vertical: pageStyle.unitHeight * 10),
        child: Text(
          'cancel_order_button_title'.tr(),
          style: mediumTextStyle.copyWith(
            fontSize: pageStyle.unitFontSize * 17,
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
        padding: EdgeInsets.symmetric(vertical: pageStyle.unitHeight * 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(returnIcon),
            SizedBox(width: pageStyle.unitWidth * 4),
            Text(
              'return_button_title'.tr(),
              style: mediumTextStyle.copyWith(
                fontSize: pageStyle.unitFontSize * 17,
                color: greyDarkColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
