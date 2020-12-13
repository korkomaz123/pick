import 'package:ciga/src/components/ciga_app_bar.dart';
import 'package:ciga/src/components/ciga_bottom_bar.dart';
import 'package:ciga/src/components/ciga_side_menu.dart';
import 'package:ciga/src/config/config.dart';
import 'package:ciga/src/data/models/cart_item_entity.dart';
import 'package:ciga/src/data/models/enum.dart';
import 'package:ciga/src/data/models/order_entity.dart';
import 'package:ciga/src/pages/my_cart/widgets/my_cart_qty_horizontal_picker.dart';
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

class CancelOrderPage extends StatefulWidget {
  final OrderEntity order;

  CancelOrderPage({this.order});

  @override
  _CancelOrderPageState createState() => _CancelOrderPageState();
}

class _CancelOrderPageState extends State<CancelOrderPage> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  PageStyle pageStyle;
  OrderEntity order;
  String icon = '';
  Color color;
  String status = '';
  Widget paymentWidget = SizedBox.shrink();
  Map<String, dynamic> cancelItemsMap = {};

  @override
  void initState() {
    super.initState();
    order = widget.order;
    switch (order.status) {
      case OrderStatusEnum.pending:
        icon = cancelledIcon;
        color = dangerColor;
        status = 'order_pending'.tr();
        break;
      case OrderStatusEnum.processing:
        icon = cancelledIcon;
        color = primaryColor;
        status = 'order_on_progress'.tr();
        break;
      case OrderStatusEnum.on_hold:
        icon = cancelledIcon;
        color = Color(0xFF32BEA6);
        status = 'order_delivered'.tr();
        break;
      default:
        icon = cancelledIcon;
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
        'cancel_order_button_title'.tr(),
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
              _buildReorderButton(),
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
          if (order.cartItems[index].availableCount == null) {
            order.cartItems[index].availableCount =
                order.cartItems[index].itemCount;
          }
          return Column(
            children: [
              _buildProductCard(order.cartItems[index], index),
              index < (order.cartItems.length - 1)
                  ? Divider(color: greyColor, thickness: 0.5)
                  : SizedBox.shrink(),
            ],
          );
        },
      ),
    );
  }

  Widget _buildProductCard(CartItemEntity cartItem, int index) {
    bool isDefaultValue =
        cancelItemsMap.containsKey(cartItem.product.productId);
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
                      cartItem.product.price + ' ' + 'currency'.tr(),
                      style: mediumTextStyle.copyWith(
                        fontSize: pageStyle.unitFontSize * 16,
                        color: primaryColor,
                      ),
                    ),
                    MyCartQtyHorizontalPicker(
                      pageStyle: pageStyle,
                      cartItem: cartItem,
                      cartId: 'cartId',
                      isDefaultValue: isDefaultValue,
                      onChange: () => _onChangeItemQty(index),
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

  void _onChangeItemQty(int index) async {
    final result = await showDialog(
      barrierColor: Colors.white.withOpacity(0.0000000001),
      context: context,
      builder: (context) {
        return QtyDropdownDialog(
          pageStyle: pageStyle,
          cartItem: order.cartItems[index],
        );
      },
    );
    if (result != null) {
      final count = result as int;
      order.cartItems[index].itemCount = count;
      final key = order.cartItems[index].product.productId;
      cancelItemsMap[key] = count;
      setState(() {});
    }
  }
}
