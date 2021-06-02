import 'package:markaa/src/change_notifier/my_cart_change_notifier.dart';
import 'package:markaa/src/change_notifier/address_change_notifier.dart';
import 'package:markaa/src/components/markaa_app_bar.dart';
import 'package:markaa/src/components/markaa_bottom_bar.dart';
import 'package:markaa/src/components/markaa_review_product_card.dart';
import 'package:markaa/src/components/markaa_side_menu.dart';
import 'package:markaa/src/data/mock/mock.dart';
import 'package:markaa/src/data/models/enum.dart';
import 'package:markaa/src/data/models/order_entity.dart';
import 'package:markaa/src/routes/routes.dart';
import 'package:markaa/src/theme/icons.dart';
import 'package:markaa/src/theme/images.dart';
import 'package:markaa/src/theme/styles.dart';
import 'package:markaa/src/theme/theme.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:markaa/src/utils/services/flushbar_service.dart';
import 'package:markaa/src/utils/services/progress_service.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ReOrderPage extends StatefulWidget {
  final OrderEntity order;

  ReOrderPage({this.order});

  @override
  _ReOrderPageState createState() => _ReOrderPageState();
}

class _ReOrderPageState extends State<ReOrderPage> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  OrderEntity order;
  String icon = '';
  Color color;
  String status = '';
  Widget paymentWidget = SizedBox.shrink();
  ProgressService progressService;
  FlushBarService flushBarService;
  MyCartChangeNotifier myCartChangeNotifier;
  AddressChangeNotifier addressChangeNotifier;

  @override
  void initState() {
    super.initState();
    progressService = ProgressService(context: context);
    flushBarService = FlushBarService(context: context);

    myCartChangeNotifier = context.read<MyCartChangeNotifier>();
    addressChangeNotifier = context.read<AddressChangeNotifier>();

    if (!addressChangeNotifier.addressesMap
        .containsKey(widget.order.address.addressId)) {
      widget.order.address = addressChangeNotifier.defaultAddress;
    }

    Future.delayed(Duration.zero, () async {
      myCartChangeNotifier.initializeReorderCart();
      await myCartChangeNotifier.getReorderCartId(
        widget.order.orderId,
        lang,
        onProcess: _onLoading,
      );
      await myCartChangeNotifier.getReorderCartItems(
        lang,
        onSuccess: _onLoaded,
        onFailure: _onLoaded,
      );
    });

    _getOrderStatus();
  }

  void _onLoading() {
    progressService.showProgress();
  }

  void _onLoaded() {
    progressService.hideProgress();
  }

  @override
  void dispose() {
    myCartChangeNotifier.initializeReorderCart();
    super.dispose();
  }

  void _getOrderStatus() {
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
      body: Stack(
        children: [
          Column(
            children: [
              _buildAppBar(),
              _buildOrder(),
            ],
          ),
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
        'reorder_button_title'.tr(),
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
              _buildTotal(),
              _buildAddressBar(),
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
    return Consumer<MyCartChangeNotifier>(
      builder: (_, model, __) {
        final keys = model.reorderCartItemsMap.keys.toList();
        return Column(
          children: List.generate(
            model.reorderCartItemCount,
            (index) {
              return Column(
                children: [
                  Stack(
                    children: [
                      MarkaaReviewProductCard(
                        cartItem: model.reorderCartItemsMap[keys[index]],
                      ),
                      if (model.reorderCartItemCount > 1) ...[
                        Align(
                          alignment: Alignment.topRight,
                          child: IconButton(
                            onPressed: () => _onDeleteOrderItem(keys[index]),
                            icon: SvgPicture.asset(trashIcon, color: greyColor),
                          ),
                        )
                      ],
                    ],
                  ),
                  if (index < (model.reorderCartItemCount - 1)) ...[
                    Divider(color: greyColor, thickness: 0.5)
                  ],
                ],
              );
            },
          ),
        );
      },
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
          Row(
            children: [
              paymentWidget,
              Text(
                order.paymentMethod.title,
                style: mediumTextStyle.copyWith(
                  color: greyDarkColor,
                  fontSize: 14.sp,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSubtotal() {
    return Consumer<MyCartChangeNotifier>(builder: (_, model, __) {
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
                  ' ${model.reorderCartTotalPrice.toStringAsFixed(3)}',
              style: mediumTextStyle.copyWith(
                color: greyDarkColor,
                fontSize: 14.sp,
              ),
            ),
          ],
        ),
      );
    });
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
            'currency'.tr() + ' ' + order.shippingMethod.serviceFees.toString(),
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
    return Consumer<MyCartChangeNotifier>(builder: (_, model, __) {
      double totalPrice =
          order.shippingMethod.serviceFees + model.reorderCartTotalPrice;
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
              'currency'.tr() + ' ${totalPrice.toStringAsFixed(3)}',
              style: mediumTextStyle.copyWith(
                color: primaryColor,
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildAddressBar() {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 10.w,
        vertical: 30.h,
      ),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 10.w,
          vertical: 30.h,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(2),
          color: Colors.grey.shade300,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              order.address.title.isNotEmpty
                  ? '${order.address.title}: '
                  : 'Unnamed title: ',
              style: boldTextStyle.copyWith(
                fontSize: 14.sp,
                color: primaryColor,
              ),
            ),
            Text(
              '${order.address.street}, ${order.address.city}, ${order.address.countryId}',
              style: mediumTextStyle.copyWith(
                fontSize: 14.sp,
              ),
            ),
          ],
        ),
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

  void _onDeleteOrderItem(String key) async {
    final result = await flushBarService.showConfirmDialog(
        message: 'remove_reorder_item_subtitle');
    if (result != null) {
      await myCartChangeNotifier.removeReorderCartItem(key);
    }
  }

  void _onNext() {
    if (myCartChangeNotifier.reorderCartItemCount > 0) {
      if (addressChangeNotifier.addressesMap
          .containsKey(widget.order.address.addressId)) {
        addressChangeNotifier.setDefaultAddress(widget.order.address);
      }
      Navigator.pushNamed(context, Routes.checkout, arguments: order);
    } else {
      flushBarService
          .showSimpleErrorMessageWithImage('reorder_items_error'.tr());
    }
  }
}
