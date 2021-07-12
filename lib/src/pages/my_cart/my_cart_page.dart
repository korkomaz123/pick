import 'package:adjust_sdk/adjust.dart';
import 'package:adjust_sdk/adjust_event.dart';
import 'package:flutter/cupertino.dart';
import 'package:markaa/src/change_notifier/markaa_app_change_notifier.dart';
import 'package:markaa/src/change_notifier/my_cart_change_notifier.dart';
import 'package:markaa/src/change_notifier/wishlist_change_notifier.dart';
import 'package:markaa/src/components/markaa_bottom_bar.dart';
import 'package:markaa/src/components/markaa_text_button.dart';
import 'package:markaa/src/components/no_available_data.dart';
import 'package:markaa/src/config/config.dart';
import 'package:markaa/src/data/mock/mock.dart';
import 'package:markaa/src/data/models/enum.dart';
import 'package:markaa/src/data/models/index.dart';
import 'package:markaa/src/routes/routes.dart';
import 'package:markaa/src/theme/styles.dart';
import 'package:markaa/src/theme/theme.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:markaa/src/utils/repositories/checkout_repository.dart';
import 'package:markaa/src/utils/services/flushbar_service.dart';
import 'package:markaa/src/utils/services/numeric_service.dart';
import 'package:markaa/src/utils/services/progress_service.dart';
import 'package:markaa/src/utils/services/snackbar_service.dart';
import 'package:provider/provider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sliding_sheet/sliding_sheet.dart';

import 'widgets/my_cart_coupon_code.dart';
import 'widgets/my_cart_item.dart';
import 'widgets/my_cart_save_for_later_items.dart';
import 'widgets/my_cart_quick_access_login_dialog.dart';

class MyCartPage extends StatefulWidget {
  @override
  _MyCartPageState createState() => _MyCartPageState();
}

class _MyCartPageState extends State<MyCartPage>
    with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController couponCodeController = TextEditingController();

  bool isDeleting = false;
  bool showSign = false;
  bool isCheckout = false;

  String cartId = '';
  double totalPrice = 0;

  String shippingMethodId;
  double serviceFees;

  ProgressService progressService;
  SnackBarService snackBarService;
  FlushBarService flushBarService;

  MarkaaAppChangeNotifier markaaAppChangeNotifier;
  MyCartChangeNotifier myCartChangeNotifier;
  WishlistChangeNotifier wishlistChangeNotifier;

  CheckoutRepository checkoutRepo = CheckoutRepository();

  _determineShippingMethod() {
    for (var shippingMethod in shippingMethods) {
      if (shippingMethod.minOrderAmount <=
          myCartChangeNotifier.cartDiscountedTotalPrice) {
        shippingMethodId = shippingMethod.id;
        serviceFees = shippingMethod.serviceFees;
      } else {
        break;
      }
    }
  }

  _loadData() async {
    if (shippingMethods.isEmpty) {
      shippingMethods = await checkoutRepo.getShippingMethod();
    }
    _determineShippingMethod();

    if (myCartChangeNotifier.cartItemCount == 0)
      await myCartChangeNotifier.getCartItems(lang);
  }

  @override
  void initState() {
    super.initState();
    progressService = ProgressService(context: context);
    flushBarService = FlushBarService(context: context);
    snackBarService = SnackBarService(
      context: context,
      scaffoldKey: scaffoldKey,
    );
    markaaAppChangeNotifier = context.read<MarkaaAppChangeNotifier>();
    myCartChangeNotifier = context.read<MyCartChangeNotifier>();
    wishlistChangeNotifier = context.read<WishlistChangeNotifier>();
    _loadData();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            size: 25.sp,
            color: greyColor,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Consumer<MyCartChangeNotifier>(
              builder: (_, model, ___) {
                if (model.cartItemCount > 0) {
                  return Column(
                    children: [
                      _buildTitleBar(),
                      _buildCartItems(),
                      MyCartCouponCode(
                        cartId: cartId,
                        onSignIn: () => _onSignIn(false),
                      ),
                      _buildTotalPrice(),
                      _buildCheckoutButton(),
                    ],
                  );
                } else {
                  return Consumer<WishlistChangeNotifier>(
                    builder: (_, model, ___) {
                      return Padding(
                        padding: EdgeInsets.symmetric(
                          vertical:
                              model.wishlistItemsCount > 0 ? 100.h : 250.h,
                        ),
                        child: Center(
                          child: NoAvailableData(
                            message: 'no_cart_items_available',
                          ),
                        ),
                      );
                    },
                  );
                }
              },
            ),
            if (user?.token != null) ...[
              MyCartSaveForLaterItems(
                progressService: progressService,
                flushBarService: flushBarService,
                myCartChangeNotifier: myCartChangeNotifier,
                wishlistChangeNotifier: wishlistChangeNotifier,
              )
            ]
          ],
        ),
      ),
      bottomNavigationBar: MarkaaBottomBar(
        activeItem: BottomEnum.home,
      ),
    );
  }

  Widget _buildTitleBar() {
    return Container(
      width: 375.w,
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 15.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'my_cart_title'.tr(),
            style: mediumTextStyle.copyWith(color: darkColor, fontSize: 23.sp),
          ),
          Row(
            children: [
              Text(
                'total'.tr() + ' ',
                style: mediumTextStyle.copyWith(
                  color: primaryColor,
                  fontSize: 16.sp,
                ),
              ),
              Text(
                'items'
                    .tr()
                    .replaceFirst('0', '${myCartChangeNotifier.cartItemCount}'),
                style: mediumTextStyle.copyWith(
                  color: primaryColor,
                  fontSize: 13.sp,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCartItems() {
    final keys = myCartChangeNotifier.cartItemsMap.keys.toList();
    return Container(
      width: 375.w,
      padding: EdgeInsets.symmetric(
        horizontal: 10.w,
        vertical: 15.h,
      ),
      child: AnimationLimiter(
        child: Column(
          children: List.generate(
            keys.length,
            (index) {
              return AnimationConfiguration.staggeredList(
                position: index,
                duration: Duration(seconds: 1),
                child: SlideAnimation(
                  verticalOffset: 50.0,
                  child: FadeInAnimation(
                    child: Column(
                      children: [
                        MyCartItem(
                          cartItem:
                              myCartChangeNotifier.cartItemsMap[keys[index]],
                          discount: myCartChangeNotifier.discount,
                          type: myCartChangeNotifier.type,
                          cartId: cartId,
                          onRemoveCartItem: () =>
                              _onRemoveCartItem(keys[index]),
                          onSaveForLaterItem: () =>
                              _onSaveForLaterItem(keys[index]),
                          onSignIn: () => _onSignIn(false),
                        ),
                        index < (myCartChangeNotifier.cartItemCount - 1)
                            ? Divider(color: greyColor, thickness: 0.5)
                            : SizedBox.shrink(),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildTotalPrice() {
    double subTotal = myCartChangeNotifier.cartTotalPrice;
    double discount = myCartChangeNotifier.type == 'fixed'
        ? myCartChangeNotifier.discount
        : myCartChangeNotifier.cartTotalPrice -
            myCartChangeNotifier.cartDiscountedTotalPrice;
    double totalPrice = subTotal - discount;
    return Container(
      width: 375.w,
      margin: EdgeInsets.symmetric(
        horizontal: 10.w,
        vertical: 15.h,
      ),
      padding: EdgeInsets.symmetric(
        horizontal: 10.w,
        vertical: 6.h,
      ),
      decoration: BoxDecoration(
        color: greyLightColor,
        borderRadius: BorderRadius.circular(2),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'products'.tr(),
                style: mediumTextStyle.copyWith(
                  color: greyDarkColor,
                  fontSize: 13.sp,
                ),
              ),
              Text(
                'items'
                    .tr()
                    .replaceFirst('0', '${myCartChangeNotifier.cartItemCount}'),
                style: mediumTextStyle.copyWith(
                  color: greyDarkColor,
                  fontSize: 13.sp,
                ),
              )
            ],
          ),
          if (discount > 0) ...[
            SizedBox(height: 10.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'checkout_subtotal_title'.tr(),
                  style: mediumTextStyle.copyWith(
                    color: greyColor,
                    fontSize: 17.sp,
                  ),
                ),
                Text(
                  '${NumericService.roundString(subTotal, 3)} ${'currency'.tr()}',
                  style: mediumTextStyle.copyWith(
                    color: primaryColor,
                    fontSize: 18.sp,
                  ),
                )
              ],
            ),
            SizedBox(height: 10.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'discount'.tr(),
                  style: mediumTextStyle.copyWith(
                    color: darkColor,
                    fontSize: 17.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  '${NumericService.roundString(discount, 3)} ${'currency'.tr()}',
                  style: mediumTextStyle.copyWith(
                    color: primaryColor,
                    fontSize: 18.sp,
                  ),
                )
              ],
            )
          ],
          SizedBox(height: 10.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'total'.tr(),
                style: mediumTextStyle.copyWith(
                  color: greyColor,
                  fontSize: 17.sp,
                ),
              ),
              Text(
                '${NumericService.roundString(totalPrice, 3)} ${'currency'.tr()}',
                style: mediumTextStyle.copyWith(
                  color: primaryColor,
                  fontSize: 18.sp,
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  Widget _buildCheckoutButton() {
    return Container(
      width: 375.w,
      height: 80.h,
      padding: EdgeInsets.symmetric(
        horizontal: 10.w,
        vertical: 15.h,
      ),
      child: MarkaaTextButton(
        title: 'checkout_button_title'.tr(),
        titleSize: 23.sp,
        titleColor: primaryColor,
        buttonColor: Colors.white,
        borderColor: primarySwatchColor,
        onPressed: () => user?.token != null ? _onCheckout() : _onSignIn(true),
        radius: 0,
      ),
    );
  }

  void _onRemoveCartItem(String key) async {
    final result = await flushBarService.showConfirmDialog(
        message: 'my_cart_remove_item_dialog_text');
    if (result != null) {
      await myCartChangeNotifier.removeCartItem(key, _onRemoveFailure);
    }
  }

  void _onSaveForLaterItem(String key) {
    final product = myCartChangeNotifier.cartItemsMap[key].product;
    final count = myCartChangeNotifier.cartItemsMap[key].itemCount;
    myCartChangeNotifier.removeCartItem(key, _onRemoveFailure);
    wishlistChangeNotifier.addItemToWishlist(user.token, product, count, {});
  }

  void _onSignIn(bool checkout) async {
    isCheckout = checkout;
    await showSlidingBottomSheet(
      context,
      builder: (_) {
        return SlidingSheetDialog(
          color: Colors.white,
          elevation: 2,
          cornerRadius: 0,
          snapSpec: const SnapSpec(
            snap: true,
            snappings: [1],
            positioning: SnapPositioning.relativeToSheetHeight,
          ),
          duration: Duration(milliseconds: 500),
          builder: (context, state) {
            return MyCartQuickAccessLoginDialog(
              cartId: cartId,
              isCheckout: isCheckout,
              prepareDetails: _prepareDetails,
            );
          },
        );
      },
    );
  }

  void _onCheckout() async {
    await myCartChangeNotifier.getCartItems(
        lang, _onProcess, _onReloadItemSuccess, _onFailure);
  }

  void _onReloadItemSuccess() {
    progressService.hideProgress();

    List<String> keys = myCartChangeNotifier.cartItemsMap.keys.toList();

    for (int i = 0; i < myCartChangeNotifier.cartItemCount; i++) {
      if (myCartChangeNotifier.cartItemsMap[keys[i]].availableCount == 0) {
        flushBarService.showErrorDialog(
          '${myCartChangeNotifier.cartItemsMap[keys[i]].product.name}' +
              'out_stock_items_error'.tr(),
        );
        return;
      }
    }

    _prepareDetails();
    Navigator.pushNamed(context, Routes.checkout);
  }

  _prepareDetails() {
    AdjustEvent adjustEvent = new AdjustEvent(AdjustSDKConfig.initiateCheckout);
    Adjust.trackEvent(adjustEvent);

    adjustEvent = new AdjustEvent(AdjustSDKConfig.checkout);
    Adjust.trackEvent(adjustEvent);

    _determineShippingMethod();

    orderDetails = {};
    orderDetails['shipping'] = shippingMethodId;
    orderDetails['cartId'] = myCartChangeNotifier.cartId;
    if (user?.token != null) {
      orderDetails['token'] = user.token;
    }

    double totalPrice = .0;
    double subtotalPrice = .0;
    double discount = .0;

    discount = myCartChangeNotifier.type == 'fixed'
        ? myCartChangeNotifier.discount
        : myCartChangeNotifier.cartTotalPrice -
            myCartChangeNotifier.cartDiscountedTotalPrice;
    subtotalPrice = myCartChangeNotifier.cartTotalPrice;

    totalPrice = subtotalPrice + serviceFees - discount;

    orderDetails['orderDetails'] = {};
    orderDetails['orderDetails']['discount'] =
        NumericService.roundString(discount, 3);
    orderDetails['orderDetails']['totalPrice'] =
        NumericService.roundString(totalPrice, 3);
    orderDetails['orderDetails']['subTotalPrice'] =
        NumericService.roundString(subtotalPrice, 3);
    orderDetails['orderDetails']['fees'] =
        NumericService.roundString(serviceFees, 3);
  }

  void _onRemoveFailure(String message) {
    flushBarService.showErrorDialog(message);
  }

  void _onProcess() {
    progressService.showProgress();
  }

  void _onFailure(String message) {
    progressService.hideProgress();
    flushBarService.showErrorDialog(message, "no_qty.svg");
  }
}
