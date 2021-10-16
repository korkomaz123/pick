import 'package:cached_network_image/cached_network_image.dart';
import 'package:markaa/src/change_notifier/markaa_app_change_notifier.dart';
import 'package:markaa/src/components/markaa_app_bar.dart';
import 'package:markaa/src/components/markaa_bottom_bar.dart';
import 'package:markaa/src/components/markaa_side_menu.dart';
import 'package:markaa/src/data/mock/mock.dart';
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
import 'package:markaa/src/utils/repositories/checkout_repository.dart';
import 'package:markaa/src/utils/services/flushbar_service.dart';
import 'package:markaa/src/utils/services/numeric_service.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CancelOrderPage extends StatefulWidget {
  final OrderEntity order;

  CancelOrderPage({required this.order});

  @override
  _CancelOrderPageState createState() => _CancelOrderPageState();
}

class _CancelOrderPageState extends State<CancelOrderPage> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  FlushBarService? flushBarService;
  OrderEntity? order;
  String icon = '';
  Color? color;
  String status = '';
  Widget paymentWidget = SizedBox.shrink();
  Map<String, dynamic> cancelItemsMap = {};
  MarkaaAppChangeNotifier? markaaAppChangeNotifier;
  CheckoutRepository checkoutRepo = CheckoutRepository();

  double subtotalPrice = .0;
  double totalPrice = .0;
  double discount = .0;
  double canceledPrice = .0;
  double serviceFees = .0;

  @override
  void initState() {
    super.initState();
    markaaAppChangeNotifier = context.read<MarkaaAppChangeNotifier>();
    flushBarService = FlushBarService(context: context);
    order = widget.order;
    subtotalPrice = double.parse(order!.subtotalPrice);
    totalPrice = double.parse(order!.totalPrice);
    serviceFees = order!.shippingMethod.serviceFees;
    discount = subtotalPrice + serviceFees - totalPrice;
    switch (order!.status) {
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
    if (order!.paymentMethod.title == 'Visa Card') {
      paymentWidget = Image.asset(
        visaImage,
        width: 35.w,
        height: 20.h,
      );
    } else if (order!.paymentMethod.title == 'KNet') {
      paymentWidget = Image.asset(
        knetImage,
        width: 35.w,
        height: 20.h,
      );
    }
  }

  void _getShippingMethods() async {
    if (shippingMethods.isEmpty) {
      shippingMethods = await checkoutRepo.getShippingMethod();
    }
    for (var shippingMethod in shippingMethods) {
      if (shippingMethod.minOrderAmount! <= (subtotalPrice - discount)) {
        double differ = shippingMethod.serviceFees - serviceFees;
        serviceFees = shippingMethod.serviceFees;
        totalPrice += differ;
      } else {
        break;
      }
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
        'cancel_order_button_title'.tr(),
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
        horizontal: 10.w,
        vertical: 15.h,
      ),
      color: Colors.grey.shade200,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'order_order_no'.tr() + ' #${order!.orderNo}',
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
            order!.orderDate,
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
        order!.cartItems.length,
        (index) {
          String key = order!.cartItems[index].product.productId.toString();
          bool isSelected = cancelItemsMap.containsKey(key);
          int availableCount = order!.cartItems[index].availableCount;
          if (availableCount == 0) {
            order!.cartItems[index].availableCount =
                order!.cartItems[index].itemCount;
          }
          if (order!.cartItems[index].itemCount > 0) {
            return Column(
              children: [
                Stack(
                  children: [
                    _buildProductCard(order!.cartItems[index], index),
                    _buildCheckButton(isSelected, key, index),
                  ],
                ),
                if (index < (order!.cartItems.length - 1)) ...[
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
    String productId = cartItem.product.productId.toString();
    bool isDefaultValue = cancelItemsMap.containsKey(productId);
    double discountedPrice =
        order!.getDiscountedPrice(cartItem, isRowPrice: false);
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
                  cartItem.product.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: mediumTextStyle.copyWith(fontSize: 16.sp),
                ),
                Text(
                  cartItem.product.shortDescription!,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  style: mediumTextStyle.copyWith(fontSize: 12.sp),
                ),
                SizedBox(height: 10.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (discountedPrice ==
                        double.parse(cartItem.product.price)) ...[
                      Text(
                        cartItem.product.price + ' ' + 'currency'.tr(),
                        style: mediumTextStyle.copyWith(
                          fontSize: 16.sp,
                          color: primaryColor,
                        ),
                      )
                    ] else ...[
                      Text(
                        '$discountedPrice ' + 'currency'.tr(),
                        style: mediumTextStyle.copyWith(
                          fontSize: 16.sp,
                          color: primaryColor,
                        ),
                      ),
                      SizedBox(width: 5.w),
                      Text(
                        cartItem.product.price + ' ' + 'currency'.tr(),
                        style: mediumTextStyle.copyWith(
                          decorationStyle: TextDecorationStyle.solid,
                          decoration: TextDecoration.lineThrough,
                          decorationColor: dangerColor,
                          fontSize: 12.sp,
                          color: greyColor,
                        ),
                      )
                    ],
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
          double discountedRowPrice =
              order!.getDiscountedPrice(order!.cartItems[index]);
          if (isSelected) {
            canceledPrice -= discountedRowPrice;
            cancelItemsMap.remove(key);
            subtotalPrice += order!.cartItems[index].rowPrice;
            totalPrice += discountedRowPrice;
            discount += (order!.cartItems[index].rowPrice - discountedRowPrice);
          } else {
            canceledPrice += discountedRowPrice;
            cancelItemsMap[key] = order!.cartItems[index].itemCount;
            subtotalPrice -= order!.cartItems[index].rowPrice;
            totalPrice -= discountedRowPrice;
            discount -= (order!.cartItems[index].rowPrice - discountedRowPrice);
          }
          _getShippingMethods();
          markaaAppChangeNotifier!.rebuild();
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
            paymentMethod: order!.paymentMethod.id,
          ),
        ],
      ),
    );
  }

  Widget _buildCancelRequestCost() {
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
            'cancel_request_price'.tr(),
            style: mediumTextStyle.copyWith(
              color: dangerColor,
              fontSize: 14.sp,
            ),
          ),
          Text(
            '${'currency'.tr()} ${NumericService.roundString(canceledPrice, 3)}',
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
            '${'currency'.tr()} ${NumericService.roundDouble(subtotalPrice, 3)}',
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
            serviceFees == 0
                ? 'free'.tr()
                : '${'currency'.tr()} ${NumericService.roundString(serviceFees, 3)}',
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
            '${'currency'.tr()} ${NumericService.roundDouble(discount, 3)}',
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
            '${'currency'.tr()} ${NumericService.roundDouble(totalPrice, 3)}',
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
          cartItem: order!.cartItems[index],
        );
      },
    );
    if (result != null) {
      final key = order!.cartItems[index].product.productId;
      final count = result as int;
      order!.cartItems[index].itemCount = count;

      int updatedCount = 0;
      if (!cancelItemsMap.containsKey(key)) {
        updatedCount = count;
      } else {
        updatedCount = count - order!.cartItems[index].itemCount;
      }
      double discountedUpdatePrice = order!
              .getDiscountedPrice(order!.cartItems[index], isRowPrice: false) *
          updatedCount;
      double updatePrice =
          double.parse(order!.cartItems[index].product.price) * updatedCount;
      canceledPrice += discountedUpdatePrice;
      subtotalPrice -= updatePrice;
      totalPrice -= discountedUpdatePrice;
      discount -= (updatePrice - discountedUpdatePrice);
      cancelItemsMap[key] = count;
      _getShippingMethods();
      markaaAppChangeNotifier!.rebuild();
    }
  }

  void _onNext() {
    List<String> keys = cancelItemsMap.keys.toList();
    if (keys.isNotEmpty) {
      final params = {'order': order, 'items': cancelItemsMap};
      Navigator.pushNamed(context, Routes.cancelOrderInfo, arguments: params);
    } else {
      String message = 'cancel_order_no_selected_item'.tr();
      flushBarService!.showErrorDialog(message);
    }
  }
}
