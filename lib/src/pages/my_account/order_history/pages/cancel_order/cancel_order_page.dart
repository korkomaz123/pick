import 'package:markaa/src/change_notifier/markaa_app_change_notifier.dart';
import 'package:markaa/src/components/markaa_app_bar.dart';
import 'package:markaa/src/components/markaa_bottom_bar.dart';
import 'package:markaa/src/components/markaa_side_menu.dart';
import 'package:markaa/src/config/config.dart';
import 'package:markaa/src/data/models/cart_item_entity.dart';
import 'package:markaa/src/data/models/enum.dart';
import 'package:markaa/src/data/models/order_entity.dart';
import 'package:markaa/src/pages/my_cart/widgets/my_cart_qty_horizontal_picker.dart';
import 'package:markaa/src/routes/routes.dart';
import 'package:markaa/src/theme/icons.dart';
import 'package:markaa/src/theme/images.dart';
import 'package:markaa/src/theme/styles.dart';
import 'package:markaa/src/theme/theme.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:markaa/src/utils/services/flushbar_service.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
  FlushBarService flushBarService;
  OrderEntity order;
  String icon = '';
  Color color;
  String status = '';
  Widget paymentWidget = SizedBox.shrink();
  Map<String, dynamic> cancelItemsMap = {};
  MarkaaAppChangeNotifier markaaAppChangeNotifier;
  double canceledPrice = .0;

  @override
  void initState() {
    super.initState();
    markaaAppChangeNotifier = context.read<MarkaaAppChangeNotifier>();
    flushBarService = FlushBarService(context: context);
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
      key: scaffoldKey,
      appBar: MarkaaAppBar(
        scaffoldKey: scaffoldKey,
        pageStyle: pageStyle,
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
              Consumer<MarkaaAppChangeNotifier>(
                builder: (_, __, ___) {
                  return _buildOrderItems();
                },
              ),
              SizedBox(height: pageStyle.unitHeight * 20),
              _buildOrderPaymentMethod(),
              Divider(color: greyColor, thickness: pageStyle.unitHeight * 0.5),
              Consumer<MarkaaAppChangeNotifier>(
                builder: (_, __, ___) {
                  return Column(
                    children: [
                      _buildCancelRequestCost(),
                      _buildSubtotal(),
                      _buildShippingCost(),
                      if (widget.order.discountAmount != 0) ...[
                        _buildDiscount(),
                      ],
                      _buildTotal(),
                    ],
                  );
                },
              ),
              _buildNextButton(),
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
          if (order.cartItems[index].availableCount == null || order.cartItems[index].availableCount == 0) {
            order.cartItems[index].availableCount = order.cartItems[index].itemCount;
          }
          String key = order.cartItems[index].product.productId.toString();
          bool isSelected = cancelItemsMap.containsKey(key);
          if (order.cartItems[index].itemCount > 0) {
            return Column(
              children: [
                Stack(
                  children: [
                    _buildProductCard(order.cartItems[index], index),
                    _buildCheckButton(isSelected, key, index),
                  ],
                ),
                if (index < (order.cartItems.length - 1)) ...[Divider(color: greyColor, thickness: 0.5)],
              ],
            );
          } else {
            return Container();
          }
        },
      ),
    );
  }

  Widget _buildProductCard(CartItemEntity cartItem, int index) {
    bool isDefaultValue = cancelItemsMap.containsKey(cartItem.product.productId.toString());
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
            fit: BoxFit.fitHeight,
            loadingBuilder: (_, child, chunkEvent) {
              return chunkEvent != null
                  ? Image.asset(
                      'lib/public/images/loading/image_loading.jpg',
                      width: pageStyle.unitWidth * 90,
                      height: pageStyle.unitHeight * 120,
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

  Widget _buildCheckButton(bool isSelected, String key, int index) {
    return Align(
      alignment: Alignment.topLeft,
      child: IconButton(
        icon: SvgPicture.asset(isSelected ? selectedIcon : unSelectedIcon),
        onPressed: () {
          if (isSelected) {
            canceledPrice -= order.cartItems[index].itemCount * double.parse(order.cartItems[index].product.price);
            cancelItemsMap.remove(key);
          } else {
            canceledPrice += order.cartItems[index].itemCount * double.parse(order.cartItems[index].product.price);
            cancelItemsMap[key] = order.cartItems[index].itemCount;
          }
          markaaAppChangeNotifier.rebuild();
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

  Widget _buildCancelRequestCost() {
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
            'cancel_request_price'.tr(),
            style: mediumTextStyle.copyWith(
              color: dangerColor,
              fontSize: pageStyle.unitFontSize * 14,
            ),
          ),
          Text(
            'currency'.tr() + ' ${canceledPrice.toStringAsFixed(3)}',
            style: mediumTextStyle.copyWith(
              color: dangerColor,
              fontSize: pageStyle.unitFontSize * 14,
            ),
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
            'currency'.tr() + ' ${(double.parse(order.subtotalPrice) - canceledPrice).toStringAsFixed(3)}',
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
    double subtotalPrice = double.parse(order.subtotalPrice);
    double changedPrice = subtotalPrice - canceledPrice;
    double fees = .0;
    if (changedPrice > 0) {
      fees = order.shippingMethod.serviceFees;
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
            'currency'.tr() + ' ${changedPrice == fees ? 0.00 : fees.toStringAsFixed(3)}',
            style: mediumTextStyle.copyWith(
              color: greyDarkColor,
              fontSize: pageStyle.unitFontSize * 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDiscount() {
    double subtotalPrice = double.parse(order.subtotalPrice);
    double changedPrice = canceledPrice - subtotalPrice;
    double discount = .0;
    if (widget.order.discountType == 'percentage') {
      discount = changedPrice * widget.order.discountAmount / 100;
    } else {
      discount = widget.order.discountAmount;
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
            'discount'.tr(),
            style: mediumTextStyle.copyWith(
              color: greyDarkColor,
              fontSize: pageStyle.unitFontSize * 14,
            ),
          ),
          Text(
            'currency'.tr() + ' ${discount.toStringAsFixed(3)}',
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
    double subtotalPrice = double.parse(order.subtotalPrice);
    double changedPrice = subtotalPrice - canceledPrice;
    double fees = .0;
    if (changedPrice > 0) {
      fees = order.shippingMethod.serviceFees;
    }
    double discount = .0;
    if (widget.order.discountType == 'percentage') {
      discount = changedPrice * widget.order.discountAmount / 100;
    } else {
      if (changedPrice != 0) {
        discount = widget.order.discountAmount;
      }
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
            'currency'.tr() + ' ${(changedPrice - discount + fees).toStringAsFixed(3)}',
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

  Widget _buildNextButton() {
    return MaterialButton(
      onPressed: () => _onNext(),
      minWidth: pageStyle.unitWidth * 150,
      height: pageStyle.unitHeight * 45,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
      ),
      color: primaryColor,
      child: Text(
        'next_button_title'.tr(),
        style: mediumTextStyle.copyWith(
          fontSize: pageStyle.unitFontSize * 17,
          color: Colors.white,
        ),
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
      int updatedCount = 0;
      if (!cancelItemsMap.containsKey(key)) {
        updatedCount = count;
      } else {
        updatedCount = count - order.cartItems[index].itemCount;
      }
      canceledPrice += double.parse(order.cartItems[index].product.price) * updatedCount;
      cancelItemsMap[key] = count;
      markaaAppChangeNotifier.rebuild();
    }
  }

  void _onNext() {
    List<String> keys = cancelItemsMap.keys.toList();
    if (keys.isNotEmpty) {
      final params = {'order': order, 'items': cancelItemsMap};
      Navigator.pushNamed(context, Routes.cancelOrderInfo, arguments: params);
    } else {
      String message = 'cancel_order_no_selected_item'.tr();
      flushBarService.showErrorMessage(pageStyle, message);
    }
  }
}
