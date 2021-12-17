import 'package:adjust_sdk/adjust.dart';
import 'package:adjust_sdk/adjust_event.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:markaa/src/change_notifier/markaa_app_change_notifier.dart';
import 'package:markaa/src/change_notifier/my_cart_change_notifier.dart';
import 'package:markaa/src/change_notifier/wishlist_change_notifier.dart';
import 'package:markaa/src/components/markaa_bottom_bar.dart';
import 'package:markaa/src/components/markaa_text_icon_button.dart';
import 'package:markaa/src/components/no_available_data.dart';
import 'package:markaa/src/config/config.dart';
import 'package:markaa/src/data/mock/mock.dart';
import 'package:markaa/src/data/models/enum.dart';
import 'package:markaa/src/data/models/index.dart';
import 'package:markaa/src/routes/routes.dart';
import 'package:markaa/src/theme/icons.dart';
import 'package:markaa/src/theme/styles.dart';
import 'package:markaa/src/theme/theme.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:markaa/src/utils/repositories/app_repository.dart';
import 'package:markaa/src/utils/services/flushbar_service.dart';
import 'package:markaa/src/utils/services/numeric_service.dart';
import 'package:markaa/src/utils/services/progress_service.dart';
import 'package:markaa/src/utils/services/snackbar_service.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:provider/provider.dart';

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

class _MyCartPageState extends State<MyCartPage> with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController couponCodeController = TextEditingController();

  bool isDeleting = false;
  bool showSign = false;
  bool isCheckout = false;

  String cartId = '';
  double totalPrice = 0;

  String? shippingMethodId;
  double? serviceFees;

  late ProgressService progressService;
  late SnackBarService snackBarService;
  late FlushBarService flushBarService;

  late MarkaaAppChangeNotifier markaaAppChangeNotifier;
  late MyCartChangeNotifier myCartChangeNotifier;
  late WishlistChangeNotifier wishlistChangeNotifier;

  AppRepository appRepository = AppRepository();

  _determineShippingMethod() {
    for (var shippingMethod in shippingMethods) {
      if (shippingMethod.minOrderAmount! <= myCartChangeNotifier.cartDiscountedTotalPrice) {
        shippingMethodId = shippingMethod.id;
        serviceFees = shippingMethod.serviceFees;
      } else {
        break;
      }
    }
  }

  _loadData() async {
    if (shippingMethods.isEmpty) {
      shippingMethods = await appRepository.getShippingMethod();
    }
    _determineShippingMethod();

    if (myCartChangeNotifier.cartItemCount == 0) await myCartChangeNotifier.getCartItems(lang);
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
    OneSignal.shared.addTriggers({
      'iam': 'free_shipping',
      'totalPrice': myCartChangeNotifier.cartTotalPrice,
      'lang': lang,
    });
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
      body: Consumer<MyCartChangeNotifier>(
        builder: (_, model, __) {
          return NestedScrollView(
            headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
              return <Widget>[
                SliverAppBar(
                  backgroundColor: Colors.white,
                  expandedHeight: 100.h,
                  floating: false,
                  pinned: true,
                  leading: SizedBox.shrink(),
                  flexibleSpace: FlexibleSpaceBar(
                    titlePadding: EdgeInsetsDirectional.only(bottom: 16.0),
                    centerTitle: false,
                    title: _buildTitleBar(),
                  ),
                ),
              ];
            },
            body: Stack(
              children: [
                RefreshIndicator(
                  onRefresh: () async {
                    await myCartChangeNotifier.getCartItems(lang);
                  },
                  color: primaryColor,
                  backgroundColor: Colors.white,
                  child: SingleChildScrollView(
                    padding: EdgeInsets.only(bottom: 60.h),
                    child: Column(
                      children: [
                        if (model.cartItemCount > 0) ...[
                          Column(
                            children: [
                              SizedBox(height: 10.h),
                              _buildCartItems(),
                              MyCartCouponCode(
                                cartId: cartId,
                                onSignIn: () => _onSignIn(false),
                              ),
                              _buildTotalPrice(),
                            ],
                          )
                        ] else ...[
                          Consumer<WishlistChangeNotifier>(
                            builder: (_, model, ___) {
                              return Padding(
                                padding: EdgeInsets.symmetric(
                                  vertical: model.wishlistItemsCount > 0 ? 100.h : 250.h,
                                ),
                                child: Center(
                                  child: NoAvailableData(
                                    message: 'no_cart_items_available',
                                  ),
                                ),
                              );
                            },
                          )
                        ],
                        if (user != null) ...[
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
                ),
                if (model.cartTotalCount > 0) ...[
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: _buildCheckoutButton(),
                  ),
                ],
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: MarkaaBottomBar(activeItem: BottomEnum.home),
    );
  }

  Widget _buildTitleBar() {
    return Container(
      width: 375.w,
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'my_cart_title'.tr(),
            style: mediumTextStyle.copyWith(color: darkColor, fontSize: 18.sp),
          ),
          Row(
            children: [
              Text(
                'total'.tr() + ' ',
                style: mediumTextStyle.copyWith(color: primaryColor, fontSize: 12.sp),
              ),
              Text(
                'items'.tr().replaceFirst('0', '${myCartChangeNotifier.cartItemCount}'),
                style: mediumTextStyle.copyWith(color: primaryColor, fontSize: 9.sp),
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
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 15.h),
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
                          cartItem: myCartChangeNotifier.cartItemsMap[keys[index]]!,
                          discount: myCartChangeNotifier.discount,
                          type: myCartChangeNotifier.type,
                          cartId: cartId,
                          onRemoveCartItem: () => _onRemoveCartItem(keys[index]),
                          onSaveForLaterItem: () => _onSaveForLaterItem(keys[index]),
                          onSignIn: () => _onSignIn(false),
                          myCartChangeNotifier: myCartChangeNotifier,
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
        : myCartChangeNotifier.cartTotalPrice - myCartChangeNotifier.cartDiscountedTotalPrice;
    double totalPrice = subTotal - discount;
    return Container(
      width: 375.w,
      margin: EdgeInsets.symmetric(horizontal: 10.w, vertical: 15.h),
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
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
                style: mediumTextStyle.copyWith(color: greyDarkColor, fontSize: 13.sp),
              ),
              Text(
                'items'.tr().replaceFirst('0', '${myCartChangeNotifier.cartItemCount}'),
                style: mediumTextStyle.copyWith(color: greyDarkColor, fontSize: 13.sp),
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
                  style: mediumTextStyle.copyWith(color: greyColor, fontSize: 17.sp),
                ),
                Text(
                  '${NumericService.roundString(subTotal, 3)} ${'currency'.tr()}',
                  style: mediumTextStyle.copyWith(color: primaryColor, fontSize: 18.sp),
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
                  style: mediumTextStyle.copyWith(color: primaryColor, fontSize: 18.sp),
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
                style: mediumTextStyle.copyWith(color: greyColor, fontSize: 17.sp),
              ),
              Text(
                '${NumericService.roundString(totalPrice, 3)} ${'currency'.tr()}',
                style: mediumTextStyle.copyWith(color: primaryColor, fontSize: 18.sp),
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
      height: 60.h,
      padding: EdgeInsets.only(bottom: 10.h, left: 10.w, right: 10.w),
      child: MarkaaTextIconButton(
        icon: SvgPicture.asset(circleArrowRightIcon, width: 20.w),
        title: 'checkout_button_title'.tr(),
        titleSize: 20.sp,
        titleColor: Colors.white,
        buttonColor: primaryColor,
        borderColor: primaryColor,
        onPressed: () => user?.token != null ? _onCheckout() : _onSignIn(true),
        radius: 6.sp,
      ),
    );
  }

  void _onRemoveCartItem(String key) async {
    final result = await flushBarService.showConfirmDialog(message: 'my_cart_remove_item_dialog_text');
    if (result != null) {
      await myCartChangeNotifier.removeCartItem(key, _onRemoveFailure);
    }
  }

  void _onSaveForLaterItem(String key) {
    final product = myCartChangeNotifier.cartItemsMap[key]!.product;
    final count = myCartChangeNotifier.cartItemsMap[key]!.itemCount;
    myCartChangeNotifier.removeCartItem(key, _onRemoveFailure);
    wishlistChangeNotifier.addItemToWishlist(user!.token, product, count, {});
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
    await myCartChangeNotifier.getCartItems(lang, _onProcess, _onReloadItemSuccess, _onFailure);
  }

  void _onReloadItemSuccess(int count) {
    progressService.hideProgress();
    List<String> keys = myCartChangeNotifier.cartItemsMap.keys.toList();

    if (count == 0) {
      flushBarService.showErrorDialog('cart_empty_error'.tr());
      return;
    }
    for (int i = 0; i < myCartChangeNotifier.cartItemCount; i++) {
      var item = myCartChangeNotifier.cartItemsMap[keys[i]]!;
      if (item.availableCount == 0) {
        flushBarService.showErrorDialog(
          '${item.product.name}' + 'out_stock_items_error'.tr(),
          'no_qty.svg',
        );
        return;
      }
      if (item.itemCount > item.availableCount) {
        flushBarService.showErrorDialog(
          'inventory_qty_exceed_error'.tr().replaceFirst('A', item.product.name),
          'no_qty.svg',
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
    if (user != null) {
      orderDetails['token'] = user!.token;
    }

    double totalPrice = .0;
    double subtotalPrice = .0;
    double discount = .0;

    discount = myCartChangeNotifier.type == 'fixed'
        ? myCartChangeNotifier.discount
        : myCartChangeNotifier.cartTotalPrice - myCartChangeNotifier.cartDiscountedTotalPrice;
    subtotalPrice = myCartChangeNotifier.cartTotalPrice;

    totalPrice = subtotalPrice + (serviceFees ?? 0) - discount;

    orderDetails['orderDetails'] = {};
    orderDetails['orderDetails']['discount'] = NumericService.roundString(discount, 3);
    orderDetails['orderDetails']['totalPrice'] = NumericService.roundString(totalPrice, 3);
    orderDetails['orderDetails']['subTotalPrice'] = NumericService.roundString(subtotalPrice, 3);
    orderDetails['orderDetails']['fees'] = NumericService.roundString(serviceFees!, 3);
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
