import 'package:markaa/src/change_notifier/markaa_app_change_notifier.dart';
import 'package:markaa/src/change_notifier/my_cart_change_notifier.dart';
import 'package:markaa/src/change_notifier/wishlist_change_notifier.dart';
import 'package:markaa/src/components/markaa_app_bar.dart';
import 'package:markaa/src/components/markaa_bottom_bar.dart';
import 'package:markaa/src/components/markaa_side_menu.dart';
import 'package:markaa/src/components/markaa_text_button.dart';
import 'package:markaa/src/components/no_available_data.dart';
import 'package:markaa/src/config/config.dart';
import 'package:markaa/src/data/mock/mock.dart';
import 'package:markaa/src/data/models/enum.dart';
import 'package:markaa/src/data/models/index.dart';
import 'package:markaa/src/pages/my_cart/bloc/my_cart_repository.dart';
import 'package:markaa/src/pages/my_cart/widgets/my_cart_remove_dialog.dart';
import 'package:markaa/src/routes/routes.dart';
import 'package:markaa/src/theme/styles.dart';
import 'package:markaa/src/theme/theme.dart';
import 'package:markaa/src/utils/flushbar_service.dart';
import 'package:markaa/src/utils/local_storage_repository.dart';
import 'package:markaa/src/utils/progress_service.dart';
import 'package:markaa/src/utils/snackbar_service.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:isco_custom_widgets/isco_custom_widgets.dart';

import 'widgets/my_cart_clear_dialog.dart';
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
  String cartId = '';
  double totalPrice = 0;
  PageStyle pageStyle;
  ProgressService progressService;
  SnackBarService snackBarService;
  FlushBarService flushBarService;
  LocalStorageRepository localRepo;
  MyCartRepository cartRepo;
  MarkaaAppChangeNotifier markaaAppChangeNotifier;
  MyCartChangeNotifier myCartChangeNotifier;
  WishlistChangeNotifier wishlistChangeNotifier;
  bool showSign = false;

  @override
  void initState() {
    super.initState();
    progressService = ProgressService(context: context);
    flushBarService = FlushBarService(context: context);
    snackBarService = SnackBarService(
      context: context,
      scaffoldKey: scaffoldKey,
    );
    localRepo = context.read<LocalStorageRepository>();
    cartRepo = context.read<MyCartRepository>();
    markaaAppChangeNotifier = context.read<MarkaaAppChangeNotifier>();
    myCartChangeNotifier = context.read<MyCartChangeNotifier>();
    wishlistChangeNotifier = context.read<WishlistChangeNotifier>();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    pageStyle = PageStyle(context, designWidth, designHeight);
    pageStyle.initializePageStyles();
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.white,
      appBar: MarkaaAppBar(
        pageStyle: pageStyle,
        scaffoldKey: scaffoldKey,
        isCartPage: true,
      ),
      drawer: MarkaaSideMenu(pageStyle: pageStyle),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                Consumer<MyCartChangeNotifier>(
                  builder: (_, model, ___) {
                    if (model.cartItemCount > 0) {
                      return Column(
                        children: [
                          _buildTitleBar(),
                          _buildTotalItemsTitle(),
                          _buildTotalItems(),
                          MyCartCouponCode(
                            pageStyle: pageStyle,
                            cartId: cartId,
                            onSignIn: _onSignIn,
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
                              vertical: pageStyle.unitHeight *
                                  (model.wishlistItemsCount > 0 ? 100 : 250),
                            ),
                            child: Center(
                              child: NoAvailableData(
                                pageStyle: pageStyle,
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
                    pageStyle: pageStyle,
                    progressService: progressService,
                    flushBarService: flushBarService,
                    myCartChangeNotifier: myCartChangeNotifier,
                    wishlistChangeNotifier: wishlistChangeNotifier,
                  )
                ]
              ],
            ),
          ),
          Consumer<MarkaaAppChangeNotifier>(
            builder: (_, __, ___) {
              if (showSign) {
                return AnimationLimiter(
                  child: AnimationConfiguration.staggeredList(
                    position: 1,
                    duration: Duration(milliseconds: 300),
                    child: SlideAnimation(
                      verticalOffset: -50.0,
                      child: FadeInAnimation(
                        child: MyCartQuickAccessLoginDialog(
                          cartId: cartId,
                          onClose: _onClose,
                        ),
                      ),
                    ),
                  ),
                );
              } else {
                return Container();
              }
            },
          ),
        ],
      ),
      bottomNavigationBar: MarkaaBottomBar(
        pageStyle: pageStyle,
        activeItem: BottomEnum.home,
      ),
    );
  }

  Widget _buildTitleBar() {
    return Container(
      width: pageStyle.deviceWidth,
      padding: EdgeInsets.symmetric(
        horizontal: pageStyle.unitWidth * 10,
        vertical: pageStyle.unitHeight * 15,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'my_cart_title'.tr(),
            style: mediumTextStyle.copyWith(
              color: darkColor,
              fontSize: pageStyle.unitFontSize * 23,
            ),
          ),
          InkWell(
            onTap: () => _onClearCartItems(),
            child: Text(
              'my_cart_clear_cart'.tr(),
              style: mediumTextStyle.copyWith(
                color: dangerColor,
                fontSize: pageStyle.unitFontSize * 11,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTotalItemsTitle() {
    return Container(
      width: pageStyle.deviceWidth,
      padding: EdgeInsets.symmetric(
        horizontal: pageStyle.unitWidth * 10,
        vertical: pageStyle.unitHeight * 15,
      ),
      child: Row(
        children: [
          Text(
            'total'.tr() + ' ',
            style: mediumTextStyle.copyWith(
              color: primaryColor,
              fontSize: pageStyle.unitFontSize * 16,
            ),
          ),
          Text(
            'items'
                .tr()
                .replaceFirst('0', '${myCartChangeNotifier.cartItemCount}'),
            style: mediumTextStyle.copyWith(
              color: primaryColor,
              fontSize: pageStyle.unitFontSize * 13,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTotalItems() {
    final keys = myCartChangeNotifier.cartItemsMap.keys.toList();
    return Container(
      width: pageStyle.deviceWidth,
      padding: EdgeInsets.symmetric(
        horizontal: pageStyle.unitWidth * 10,
        vertical: pageStyle.unitHeight * 15,
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
                          pageStyle: pageStyle,
                          cartItem:
                              myCartChangeNotifier.cartItemsMap[keys[index]],
                          discount: myCartChangeNotifier.discount,
                          type: myCartChangeNotifier.type,
                          cartId: cartId,
                          onRemoveCartItem: () =>
                              _onRemoveCartItem(keys[index]),
                          onSaveForLaterItem: () =>
                              _onSaveForLaterItem(keys[index]),
                          onSignIn: () => _onSignIn(),
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
    print(myCartChangeNotifier.type);
    double discount = myCartChangeNotifier.type == 'fixed'
        ? myCartChangeNotifier.discount
        : subTotal * myCartChangeNotifier.discount / 100;
    double totalPrice = subTotal - discount;
    return Container(
      width: pageStyle.deviceWidth,
      margin: EdgeInsets.symmetric(
        horizontal: pageStyle.unitWidth * 10,
        vertical: pageStyle.unitHeight * 15,
      ),
      padding: EdgeInsets.symmetric(
        horizontal: pageStyle.unitWidth * 10,
        vertical: pageStyle.unitHeight * 6,
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
                  fontSize: pageStyle.unitFontSize * 13,
                ),
              ),
              Text(
                'items'
                    .tr()
                    .replaceFirst('0', '${myCartChangeNotifier.cartItemCount}'),
                style: mediumTextStyle.copyWith(
                  color: greyDarkColor,
                  fontSize: pageStyle.unitFontSize * 13,
                ),
              )
            ],
          ),
          if (discount > 0) ...[
            SizedBox(height: pageStyle.unitHeight * 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'checkout_subtotal_title'.tr(),
                  style: mediumTextStyle.copyWith(
                    color: greyColor,
                    fontSize: pageStyle.unitFontSize * 17,
                  ),
                ),
                Text(
                  '${subTotal.toStringAsFixed(2)} ' + 'currency'.tr(),
                  style: mediumTextStyle.copyWith(
                    color: primaryColor,
                    fontSize: pageStyle.unitFontSize * 18,
                  ),
                )
              ],
            ),
            SizedBox(height: pageStyle.unitHeight * 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'discount'.tr(),
                  style: mediumTextStyle.copyWith(
                    color: darkColor,
                    fontSize: pageStyle.unitFontSize * 17,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  '${discount.toStringAsFixed(2)} ' + 'currency'.tr(),
                  style: mediumTextStyle.copyWith(
                    color: primaryColor,
                    fontSize: pageStyle.unitFontSize * 18,
                  ),
                )
              ],
            )
          ],
          SizedBox(height: pageStyle.unitHeight * 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'total'.tr(),
                style: mediumTextStyle.copyWith(
                  color: greyColor,
                  fontSize: pageStyle.unitFontSize * 17,
                ),
              ),
              Text(
                '${totalPrice.toStringAsFixed(2)} ' + 'currency'.tr(),
                style: mediumTextStyle.copyWith(
                  color: primaryColor,
                  fontSize: pageStyle.unitFontSize * 18,
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
      width: pageStyle.deviceWidth,
      height: pageStyle.unitHeight * 80,
      padding: EdgeInsets.symmetric(
        horizontal: pageStyle.unitWidth * 10,
        vertical: pageStyle.unitHeight * 15,
      ),
      child: MarkaaTextButton(
        title: 'checkout_button_title'.tr(),
        titleSize: pageStyle.unitFontSize * 23,
        titleColor: primaryColor,
        buttonColor: Colors.white,
        borderColor: primarySwatchColor,
        onPressed: () => user?.token != null ? _onCheckout() : _onSignIn(),
        radius: 0,
      ),
    );
  }

  void _onRemoveCartItem(String key) async {
    final result = await showDialog(
      context: context,
      builder: (context) {
        return MyCartRemoveDialog(
          pageStyle: pageStyle,
          title: 'my_cart_remove_item_dialog_title'.tr(),
          text: 'my_cart_remove_item_dialog_text'.tr(),
        );
      },
    );
    if (result != null) {
      await myCartChangeNotifier.removeCartItem(key);
    }
  }

  void _onSaveForLaterItem(String key) async {
    final product = myCartChangeNotifier.cartItemsMap[key].product;
    final count = myCartChangeNotifier.cartItemsMap[key].itemCount;
    await myCartChangeNotifier.removeCartItem(key);
    await wishlistChangeNotifier.addItemToWishlist(user.token, product, count);
  }

  void _onSignIn() {
    showSign = true;
    markaaAppChangeNotifier.rebuild();
  }

  void _onClose() {
    showSign = false;
    markaaAppChangeNotifier.rebuild();
  }

  void _onClearCartItems() async {
    if (myCartChangeNotifier.cartItemCount > 0) {
      final result = await showDialog(
        context: context,
        builder: (context) {
          return MyCartClearDialog(pageStyle: pageStyle);
        },
      );
      if (result != null) {
        await myCartChangeNotifier.clearCart();
      }
    }
  }

  void _onCheckout() {
    bool isStock = true;
    List<String> keys = myCartChangeNotifier.cartItemsMap.keys.toList();
    for (int i = 0; i < myCartChangeNotifier.cartItemCount; i++) {
      if (myCartChangeNotifier.cartItemsMap[keys[i]].availableCount == 0) {
        isStock = false;
        flushBarService.showErrorMessage(
          pageStyle,
          'out_stock_items_error'.tr(),
        );
      }
    }
    if (isStock) {
      Navigator.pushNamed(context, Routes.checkoutAddress);
    }
  }
}
