import 'package:markaa/src/change_notifier/markaa_app_change_notifier.dart';
import 'package:markaa/src/components/markaa_app_bar.dart';
import 'package:markaa/src/components/markaa_bottom_bar.dart';
import 'package:markaa/src/components/markaa_side_menu.dart';
import 'package:markaa/src/components/markaa_text_button.dart';
import 'package:markaa/src/components/no_available_data.dart';
import 'package:markaa/src/config/config.dart';
import 'package:markaa/src/data/mock/mock.dart';
import 'package:markaa/src/data/models/enum.dart';
import 'package:markaa/src/data/models/index.dart';
import 'package:markaa/src/pages/markaa_app/bloc/cart_item_count/cart_item_count_bloc.dart';
import 'package:markaa/src/pages/my_cart/bloc/my_cart_repository.dart';
import 'package:markaa/src/pages/my_cart/bloc/save_later/save_later_bloc.dart';
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

import 'bloc/my_cart/my_cart_bloc.dart';
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
  MyCartBloc myCartBloc;
  CartItemCountBloc markaaAppBloc;
  SaveLaterBloc saveLaterBloc;
  LocalStorageRepository localRepo;
  MyCartRepository cartRepo;
  MarkaaAppChangeNotifier markaaAppChangeNotifier;
  bool showSign = false;

  @override
  void initState() {
    super.initState();
    myCartItems = null;
    progressService = ProgressService(context: context);
    flushBarService = FlushBarService(context: context);
    snackBarService = SnackBarService(
      context: context,
      scaffoldKey: scaffoldKey,
    );
    myCartBloc = context.read<MyCartBloc>();
    markaaAppBloc = context.read<CartItemCountBloc>();
    saveLaterBloc = context.read<SaveLaterBloc>();
    localRepo = context.read<LocalStorageRepository>();
    cartRepo = context.read<MyCartRepository>();
    markaaAppChangeNotifier = context.read<MarkaaAppChangeNotifier>();
    if (user?.token != null) {
      saveLaterBloc.add(SaveLaterItemsLoaded(token: user.token, lang: lang));
    }
    _getMyCartId();
  }

  @override
  void dispose() {
    myCartBloc.add(MyCartItemsInitialize());
    super.dispose();
  }

  void _getMyCartId() async {
    if (user?.token != null) {
      final result = await cartRepo.getCartId(user.token);
      if (result['code'] == 'SUCCESS') {
        cartId = result['cartId'];
      }
    } else {
      cartId = await localRepo.getCartId();
    }
    if (cartId.isNotEmpty) {
      myCartBloc.add(MyCartItemsLoaded(cartId: cartId, lang: lang));
    } else {
      myCartItems = [];
      setState(() {});
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
                _buildMyCartPage(),
                Consumer<MarkaaAppChangeNotifier>(
                  builder: (_, __, ___) {
                    if (user?.token != null) {
                      _getMyCartId();
                      return MyCartSaveForLaterItems(
                        pageStyle: pageStyle,
                        progressService: progressService,
                        flushBarService: flushBarService,
                        cartBloc: myCartBloc,
                        saveLaterBloc: saveLaterBloc,
                        cartRepo: cartRepo,
                        onPutInCart: (value) => _onPutInCart(value),
                      );
                    } else {
                      return Container();
                    }
                  },
                ),
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
                      verticalOffset: 50.0,
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

  Widget _buildMyCartPage() {
    return BlocConsumer<MyCartBloc, MyCartState>(
      listener: (context, state) {
        if (state is MyCartItemsLoadedSuccess) {
          markaaAppBloc.add(CartItemCountUpdated(
            cartItems: state.cartItems,
          ));
        }
        if (state is MyCartItemAddedFailure) {
          flushBarService.showErrorMessage(pageStyle, state.message);
        }
        if (state is MyCartItemAddedSuccess) {
          myCartBloc.add(MyCartItemsLoaded(cartId: cartId, lang: lang));
        }
        if (state is MyCartItemsLoadedFailure) {
          flushBarService.showErrorMessage(pageStyle, state.message);
        }
        if (state is MyCartItemUpdatedInProcess) {
          progressService.showProgress();
        }
        if (state is MyCartItemUpdatedSuccess) {
          progressService.hideProgress();
          myCartBloc.add(MyCartItemsLoaded(cartId: cartId, lang: lang));
        }
        if (state is MyCartItemUpdatedFailure) {
          progressService.hideProgress();
          flushBarService.showErrorMessage(pageStyle, state.message);
        }
        if (state is MyCartItemRemovedInProcess) {
          progressService.showProgress();
        }
        if (state is MyCartItemRemovedSuccess) {
          progressService.hideProgress();
          flushBarService.showInformMessage(pageStyle, 'done'.tr());
          myCartBloc.add(MyCartItemsLoaded(cartId: cartId, lang: lang));
        }
        if (state is MyCartItemRemovedFailure) {
          progressService.hideProgress();
          flushBarService.showErrorMessage(pageStyle, state.message);
        }
        if (state is MyCartItemsClearedInProcess) {
          progressService.showProgress();
        }
        if (state is MyCartItemsClearedSuccess) {
          progressService.hideProgress();
          markaaAppBloc.add(CartItemCountSet(cartItemCount: 0));
          myCartBloc.add(MyCartItemsLoaded(cartId: cartId, lang: lang));
        }
        if (state is MyCartItemsClearedFailure) {
          progressService.hideProgress();
          flushBarService.showErrorMessage(pageStyle, state.message);
        }
        if (state is CouponCodeAppliedSuccess) {
          flushBarService.showSuccessMessage(pageStyle, 'success'.tr());
          myCartBloc.add(MyCartItemsLoaded(cartId: cartId, lang: lang));
        }
        if (state is CouponCodeAppliedFailure) {
          flushBarService.showErrorMessage(pageStyle, state.message);
        }
        if (state is CouponCodeCancelledSuccess) {
          flushBarService.showSuccessMessage(pageStyle, 'success'.tr());
          myCartBloc.add(MyCartItemsLoaded(cartId: cartId, lang: lang));
        }
        if (state is CouponCodeCancelledFailure) {
          flushBarService.showErrorMessage(pageStyle, state.message);
        }
      },
      builder: (context, state) {
        if (state is MyCartItemsLoadedSuccess) {
          myCartItems = state.cartItems;
          couponCode = state.couponCode ?? couponCode;
          discount = state.discount;
          _getTotalPrice();
        }
        if (state is MyCartItemsClearedSuccess) {
          myCartItems.clear();
          cartItemCount = 0;
          totalPrice = 0;
          cartTotalPrice = 0;
        }
        if (myCartItems == null) {
          return Container();
        } else if (myCartItems.isEmpty) {
          return BlocBuilder<SaveLaterBloc, SaveLaterState>(
            builder: (context, state) {
              double dimension = .0;
              if (state is SaveLaterItemsLoadedSuccess) {
                if (state.items.isNotEmpty) {
                  dimension = 1 / 3;
                } else {
                  dimension = 2 / 3;
                }
              } else {
                dimension = 1 / 3;
              }
              return Container(
                height: pageStyle.deviceHeight * dimension,
                alignment: Alignment.center,
                child: NoAvailableData(
                  pageStyle: pageStyle,
                  message: 'no_cart_items_available',
                ),
              );
            },
          );
        }
        return Column(
          children: [
            _buildTitleBar(),
            _buildTotalItemsTitle(),
            _buildTotalItems(),
            MyCartCouponCode(
              pageStyle: pageStyle,
              cartId: cartId,
              couponCode: couponCode,
            ),
            _buildTotalPrice(),
            _buildCheckoutButton(),
          ],
        );
      },
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
            'items'.tr().replaceFirst('0', '${myCartItems.length}'),
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
    return Container(
      width: pageStyle.deviceWidth,
      padding: EdgeInsets.symmetric(
        horizontal: pageStyle.unitWidth * 10,
        vertical: pageStyle.unitHeight * 15,
      ),
      child: AnimationLimiter(
        child: Column(
          children: List.generate(
            myCartItems.length,
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
                          cartItem: myCartItems[index],
                          discount: discount,
                          cartId: cartId,
                          onRemoveCartItem: () => _onRemoveCartItem(index),
                          onSaveForLaterItem: () => _onSaveForLaterItem(index),
                          onSignIn: () => _onSignIn(),
                        ),
                        index < (myCartItems.length - 1)
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
                'items'.tr().replaceFirst('0', '${myCartItems.length}'),
                style: mediumTextStyle.copyWith(
                  color: greyDarkColor,
                  fontSize: pageStyle.unitFontSize * 13,
                ),
              )
            ],
          ),
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

  void _onRemoveCartItem(int index) async {
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
      isDeleting = true;
      myCartItems.removeAt(index);
      myCartBloc.add(MyCartItemRemoved(
        cartId: cartId,
        itemId: myCartItems[index].itemId,
      ));
    }
  }

  void _onSaveForLaterItem(int index) {
    myCartBloc.add(MyCartItemRemoved(
      cartId: cartId,
      itemId: myCartItems[index].itemId,
    ));
    saveLaterBloc.add(SaveLaterItemChanged(
      token: user.token,
      productId: myCartItems[index].product.productId,
      action: 'add',
      qty: myCartItems[index].itemCount,
      product: myCartItems[index].product,
      itemId: myCartItems[index].itemId,
    ));
    myCartItems.removeAt(index);
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
    if (cartId.isNotEmpty) {
      final result = await showDialog(
        context: context,
        builder: (context) {
          return MyCartClearDialog(pageStyle: pageStyle);
        },
      );
      if (result != null) {
        myCartBloc.add(MyCartItemsCleared(cartId: cartId));
      }
    }
  }

  void _getTotalPrice() {
    totalPrice = 0;
    cartTotalPrice = 0;
    for (int i = 0; i < myCartItems.length; i++) {
      totalPrice += myCartItems[i].rowPrice;
    }
    cartTotalPrice = totalPrice;
  }

  void _onCheckout() {
    bool isStock = true;
    for (int i = 0; i < myCartItems.length; i++) {
      if (myCartItems[i].availableCount == 0) {
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

  void _onPutInCart(CartItemEntity value) {
    myCartItems.add(value);
    setState(() {});
  }
}
