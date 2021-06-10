import 'package:cached_network_image/cached_network_image.dart';
import 'package:markaa/src/change_notifier/markaa_app_change_notifier.dart';
import 'package:markaa/src/components/markaa_app_bar.dart';
import 'package:markaa/src/components/markaa_bottom_bar.dart';
import 'package:markaa/src/components/markaa_side_menu.dart';
import 'package:markaa/src/data/models/cart_item_entity.dart';
import 'package:markaa/src/data/models/enum.dart';
import 'package:markaa/src/data/models/order_entity.dart';
import 'package:markaa/src/pages/my_account/order_history/widgets/order_payment_method.dart';
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
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ReturnOrderPage extends StatefulWidget {
  final OrderEntity order;

  ReturnOrderPage({this.order});

  @override
  _ReturnOrderPageState createState() => _ReturnOrderPageState();
}

class _ReturnOrderPageState extends State<ReturnOrderPage> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  FlushBarService flushBarService;
  OrderEntity order;
  String icon = '';
  Color color;
  String status = '';
  Widget paymentWidget = SizedBox.shrink();
  Map<String, dynamic> returnItemsMap = {};
  MarkaaAppChangeNotifier markaaAppChangeNotifier;
  double returnPrice = .0;

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
        width: 35.w,
        height: 20.h,
      );
    } else if (order.paymentMethod.title == 'KNet') {
      paymentWidget = Image.asset(
        knetImage,
        width: 35.w,
        height: 20.h,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    _setPaymentWidget();
    return Scaffold(
      backgroundColor: Colors.white,
      key: scaffoldKey,
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
        'return_button_title'.tr(),
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
              Consumer<MarkaaAppChangeNotifier>(
                builder: (_, __, ___) {
                  return _buildOrderItems();
                },
              ),
              SizedBox(height: 20.h),
              _buildOrderPaymentMethod(),
              Divider(color: greyColor, thickness: 0.5.h),
              Consumer<MarkaaAppChangeNotifier>(
                builder: (_, __, ___) {
                  return Column(
                    children: [
                      _buildReturnRequestPrice(),
                      _buildSubtotal(),
                      _buildShippingCost(),
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
          if (order.cartItems[index].availableCount == null ||
              order.cartItems[index].availableCount == 0) {
            order.cartItems[index].availableCount =
                order.cartItems[index].itemCount;
          }
          String key = order.cartItems[index].itemId.toString();
          bool isSelected = returnItemsMap.containsKey(key);
          if (order.cartItems[index].itemCount > 0) {
            return Column(
              children: [
                Stack(
                  children: [
                    _buildProductCard(order.cartItems[index], index),
                    _buildCheckButton(isSelected, key, index),
                  ],
                ),
                if (index < (order.cartItems.length - 1)) ...[
                  Divider(color: greyColor, thickness: 0.5)
                ],
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
    bool isDefaultValue =
        returnItemsMap.containsKey(cartItem.itemId.toString());
    return Container(
      width: 375.w,
      padding: EdgeInsets.symmetric(
        horizontal: 10.w,
        vertical: 20.h,
      ),
      child: Row(
        children: [
          CachedNetworkImage(
            imageUrl: cartItem.product.imageUrl,
            width: 90.w,
            height: 120.h,
            fit: BoxFit.fitHeight,
          ),
          SizedBox(width: 5.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  cartItem.product.name ?? '',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: mediumTextStyle.copyWith(
                    fontSize: 16.sp,
                  ),
                ),
                Text(
                  cartItem.product.shortDescription,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  style: mediumTextStyle.copyWith(
                    fontSize: 12.sp,
                  ),
                ),
                SizedBox(height: 10.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      cartItem.product.price + ' ' + 'currency'.tr(),
                      style: mediumTextStyle.copyWith(
                        fontSize: 16.sp,
                        color: primaryColor,
                      ),
                    ),
                    MyCartQtyHorizontalPicker(
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
          int count = 0;
          if (isSelected) {
            count = -returnItemsMap[key];
            returnItemsMap.remove(key);
          } else {
            count = order.cartItems[index].itemCount;
            returnItemsMap[key] = order.cartItems[index].itemCount;
          }
          returnPrice +=
              double.parse(order.cartItems[index].product.price) * count;
          markaaAppChangeNotifier.rebuild();
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

  Widget _buildReturnRequestPrice() {
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
            'return_request_price'.tr(),
            style: mediumTextStyle.copyWith(
              color: dangerColor,
              fontSize: 14.sp,
            ),
          ),
          Text(
            'currency'.tr() + ' ${returnPrice.toStringAsFixed(3)}',
            style: mediumTextStyle.copyWith(
              color: dangerColor,
              fontSize: 14.sp,
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
            'currency'.tr() +
                ' ${(double.parse(order.subtotalPrice) - returnPrice).toStringAsFixed(3)}',
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
            order.shippingMethod.serviceFees == 0
                ? 'free'.tr()
                : 'currency'.tr() +
                    ' ' +
                    order.shippingMethod.serviceFees.toString(),
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
            'currency'.tr() +
                ' ${(double.parse(order.totalPrice) - returnPrice).toStringAsFixed(3)}',
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

  Widget _buildNextButton() {
    return MaterialButton(
      onPressed: () => _onNext(),
      minWidth: 150.w,
      height: 45.h,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
      ),
      color: primaryColor,
      child: Text(
        'next_button_title'.tr(),
        style: mediumTextStyle.copyWith(
          fontSize: 17.sp,
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
          cartItem: order.cartItems[index],
        );
      },
    );
    if (result != null) {
      final key = order.cartItems[index].itemId;
      final count = result as int;
      int updatedCount = 0;
      if (returnItemsMap.containsKey(key)) {
        updatedCount = count - order.cartItems[index].itemCount;
      } else {
        updatedCount = count;
      }
      order.cartItems[index].itemCount = count;
      returnItemsMap[key] = count;
      returnPrice =
          double.parse(order.cartItems[index].product.price) * updatedCount;
      markaaAppChangeNotifier.rebuild();
    }
  }

  void _onNext() {
    List<String> keys = returnItemsMap.keys.toList();
    if (keys.isNotEmpty) {
      final params = {'order': order, 'items': returnItemsMap};
      Navigator.pushNamed(context, Routes.returnOrderInfo, arguments: params);
    } else {
      String message = 'return_order_no_selected_item'.tr();
      flushBarService.showErrorDialog(message);
    }
  }
}
