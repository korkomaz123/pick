import 'package:ciga/src/components/ciga_app_bar.dart';
import 'package:ciga/src/components/ciga_bottom_bar.dart';
import 'package:ciga/src/components/ciga_side_menu.dart';
import 'package:ciga/src/config/config.dart';
import 'package:ciga/src/data/mock/mock.dart';
import 'package:ciga/src/data/models/cart_item_entity.dart';
import 'package:ciga/src/data/models/enum.dart';
import 'package:ciga/src/data/models/order_entity.dart';
import 'package:ciga/src/routes/routes.dart';
import 'package:ciga/src/theme/icons.dart';
import 'package:ciga/src/theme/images.dart';
import 'package:ciga/src/theme/styles.dart';
import 'package:ciga/src/theme/theme.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
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

  @override
  void initState() {
    super.initState();
    order = widget.order;

    switch (order.status) {
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
      case OrderStatusEnum.on_hold:
        icon = deliveredIcon;
        color = Color(0xFF32BEA6);
        status = 'order_delivered'.tr();
        break;
      default:
        icon = pendingIcon;
        color = orangeColor;
        status = EnumToString.convertToString(order.status).tr();
    }
    setState(() {});
  }

  void _setPaymentWidget() {
    if (order.paymentMethod.title == 'Visa Card') {
      paymentWidget = Image.asset(
        visaImage,
        width: pageStyle.unitWidth * 35,
        height: pageStyle.unitHeight * 20,
      );
    } else if (order.paymentMethod.title == 'KNet') {
      paymentWidget = Image.asset(
        knetImage,
        width: pageStyle.unitWidth * 35,
        height: pageStyle.unitHeight * 20,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    pageStyle = PageStyle(context, designWidth, designHeight);
    pageStyle.initializePageStyles();
    _setPaymentWidget();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CigaAppBar(
        scaffoldKey: scaffoldKey,
        pageStyle: pageStyle,
        isCenter: false,
      ),
      drawer: CigaSideMenu(pageStyle: pageStyle),
      body: Column(
        children: [
          _buildAppBar(),
          _buildOrder(),
        ],
      ),
      bottomNavigationBar: CigaBottomBar(
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
              _buildReorderButton(),
              _buildCancelOrderButton(),
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
              _buildProductCard(order.cartItems[index]),
              index < (order.cartItems.length - 1)
                  ? Divider(color: greyColor, thickness: 0.5)
                  : SizedBox.shrink(),
            ],
          );
        },
      ),
    );
  }

  Widget _buildProductCard(CartItemEntity cartItem) {
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
                  cartItem.product.name,
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
                      cartItem.itemCount.toString() +
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
    int totalQty = double.parse(order.totalQty).ceil();
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
            'currency'.tr() +
                ' ' +
                (totalQty * order.shippingMethod.serviceFees).toString(),
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
            'currency'.tr() + ' ${order.totalPrice}',
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
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: pageStyle.unitWidth * 10,
        vertical: pageStyle.unitHeight * 30,
      ),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: pageStyle.unitWidth * 10,
          vertical: pageStyle.unitHeight * 30,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(2),
          color: Colors.grey.shade300,
        ),
        child: Center(
          child: Text(
            'Address: ${shippingAddresses[0].city} ${shippingAddresses[0].street}',
            style: mediumTextStyle.copyWith(
              fontSize: pageStyle.unitFontSize * 14,
            ),
          ),
        ),
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
}
