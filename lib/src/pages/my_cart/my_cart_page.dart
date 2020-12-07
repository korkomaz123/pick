import 'package:ciga/src/components/ciga_app_bar.dart';
import 'package:ciga/src/components/ciga_bottom_bar.dart';
import 'package:ciga/src/components/ciga_side_menu.dart';
import 'package:ciga/src/components/ciga_text_button.dart';
import 'package:ciga/src/components/no_available_data.dart';
import 'package:ciga/src/data/models/product_list_arguments.dart';
import 'package:ciga/src/pages/ciga_app/bloc/cart_item_count/cart_item_count_bloc.dart';
import 'package:ciga/src/pages/my_cart/widgets/my_cart_remove_dialog.dart';
import 'package:ciga/src/config/config.dart';
import 'package:ciga/src/data/mock/mock.dart';
import 'package:ciga/src/data/models/enum.dart';
import 'package:ciga/src/data/models/index.dart';
import 'package:ciga/src/routes/routes.dart';
import 'package:ciga/src/theme/styles.dart';
import 'package:ciga/src/theme/theme.dart';
import 'package:ciga/src/utils/flushbar_service.dart';
import 'package:ciga/src/utils/local_storage_repository.dart';
import 'package:ciga/src/utils/progress_service.dart';
import 'package:ciga/src/utils/snackbar_service.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:isco_custom_widgets/isco_custom_widgets.dart';
import 'package:lottie/lottie.dart';

import 'bloc/my_cart/my_cart_bloc.dart';
import 'widgets/my_cart_clear_dialog.dart';
import 'widgets/my_cart_coupon_code.dart';
import 'widgets/my_cart_qty_horizontal_picker.dart';

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
  int totalPrice = 0;
  PageStyle pageStyle;
  ProgressService progressService;
  SnackBarService snackBarService;
  FlushBarService flushBarService;
  MyCartBloc myCartBloc;
  CartItemCountBloc cigaAppBloc;
  LocalStorageRepository localRepo;

  @override
  void initState() {
    super.initState();
    progressService = ProgressService(context: context);
    flushBarService = FlushBarService(context: context);
    snackBarService = SnackBarService(
      context: context,
      scaffoldKey: scaffoldKey,
    );
    myCartBloc = context.read<MyCartBloc>();
    cigaAppBloc = context.read<CartItemCountBloc>();
    localRepo = context.read<LocalStorageRepository>();
    _getMyCartId();
  }

  void _getMyCartId() async {
    cartId = await localRepo.getCartId();
    if (cartId.isNotEmpty) {
      myCartBloc.add(MyCartItemsLoaded(cartId: cartId, lang: lang));
    }
  }

  @override
  Widget build(BuildContext context) {
    pageStyle = PageStyle(context, designWidth, designHeight);
    pageStyle.initializePageStyles();
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.white,
      appBar: CigaAppBar(
        pageStyle: pageStyle,
        scaffoldKey: scaffoldKey,
        isCartPage: true,
      ),
      drawer: CigaSideMenu(pageStyle: pageStyle),
      body: Stack(
        children: [
          BlocConsumer<MyCartBloc, MyCartState>(
            listener: (context, state) {
              if (state is MyCartItemsLoadedInProcess) {
                // print('inprocess');
                // progressService.showProgress();
              }
              if (state is MyCartItemsLoadedSuccess) {
                // progressService.hideProgress();
                // print(state.cartItems);
                // print('success');
                cigaAppBloc.add(CartItemCountUpdated(
                  cartItems: state.cartItems,
                ));
              }
              if (state is MyCartItemsLoadedFailure) {
                // progressService.hideProgress();
                // print('failed');
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
                cigaAppBloc.add(CartItemCountSet(cartItemCount: 0));
              }
              if (state is MyCartItemsClearedFailure) {
                progressService.hideProgress();
                flushBarService.showErrorMessage(pageStyle, state.message);
              }
              if (state is CouponCodeAppliedSuccess) {
                flushBarService.showSuccessMessage(pageStyle, 'Success');
                myCartBloc.add(MyCartItemsLoaded(cartId: cartId, lang: lang));
              }
              if (state is CouponCodeAppliedFailure) {
                flushBarService.showErrorMessage(pageStyle, state.message);
              }
              if (state is CouponCodeCancelledSuccess) {
                flushBarService.showSuccessMessage(pageStyle, 'Success');
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
              return (state is MyCartItemsLoadedSuccess &&
                          myCartItems.isEmpty) ||
                      cartId.isEmpty
                  ? Center(
                      child: NoAvailableData(
                        pageStyle: pageStyle,
                        message: 'no_cart_items_available',
                      ),
                    )
                  : SingleChildScrollView(
                      child: Column(
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
                      ),
                    );
            },
          ),
          isDeleting
              ? Material(
                  color: Colors.black.withOpacity(0),
                  child: Center(
                    child: Lottie.asset(
                      'lib/public/animations/trash-clean.json',
                      width: pageStyle.unitWidth * 100,
                      height: pageStyle.unitHeight * 100,
                    ),
                  ),
                )
              : SizedBox.shrink(),
        ],
      ),
      bottomNavigationBar: CigaBottomBar(
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
              color: greyDarkColor,
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
                        _buildMyCartProduct(index),
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

  Widget _buildMyCartProduct(int index) {
    String priceString = myCartItems[index].product.price;
    double price = double.parse(priceString);
    double discountPrice = price * (100 - discount) / 100;
    String discountPriceString = discountPrice.toStringAsFixed(2);
    return Container(
      width: double.infinity,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          InkWell(
            onTap: () => _onRemoveCartItem(index),
            child: Icon(
              Icons.remove_circle_outline,
              size: pageStyle.unitFontSize * 22,
              color: greyDarkColor,
            ),
          ),
          Image.network(
            myCartItems[index].product.imageUrl,
            width: pageStyle.unitWidth * 134,
            height: pageStyle.unitHeight * 150,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () {
                    if (myCartItems[index].product.brandId.isNotEmpty) {
                      ProductListArguments arguments = ProductListArguments(
                        category: CategoryEntity(),
                        subCategory: [],
                        brand: myCartItems[index].product.brandEntity,
                        selectedSubCategoryIndex: 0,
                        isFromBrand: true,
                      );
                      Navigator.pushNamed(
                        context,
                        Routes.productList,
                        arguments: arguments,
                      );
                    }
                  },
                  child: Text(
                    myCartItems[index].product.brandLabel,
                    style: mediumTextStyle.copyWith(
                      color: primaryColor,
                      fontSize: pageStyle.unitFontSize * 10,
                    ),
                  ),
                ),
                Text(
                  myCartItems[index].product.description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: mediumTextStyle.copyWith(
                    color: greyDarkColor,
                    fontSize: pageStyle.unitFontSize * 14,
                  ),
                ),
                Row(
                  children: [
                    Text(
                      priceString + ' ' + 'currency'.tr(),
                      style: mediumTextStyle.copyWith(
                        fontSize: pageStyle.unitFontSize * 12,
                        color: greyColor,
                      ),
                    ),
                    SizedBox(width: pageStyle.unitWidth * 20),
                    Text(
                      discount != 0
                          ? discountPriceString + ' ' + 'currency'.tr()
                          : '',
                      style: mediumTextStyle.copyWith(
                        decorationStyle: TextDecorationStyle.solid,
                        decoration: TextDecoration.lineThrough,
                        decorationColor: dangerColor,
                        fontSize: pageStyle.unitFontSize * 12,
                        color: greyColor,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: pageStyle.unitHeight * 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () => null,
                      child: Text(
                        'save_for_later'.tr(),
                        style: mediumTextStyle.copyWith(
                          fontSize: pageStyle.unitFontSize * 12,
                          color: primaryColor,
                        ),
                      ),
                    ),
                    MyCartQtyHorizontalPicker(
                      pageStyle: pageStyle,
                      cartItem: myCartItems[index],
                      cartId: cartId,
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
                '$totalPrice ' + 'currency'.tr(),
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
      child: CigaTextButton(
        title: 'checkout_button_title'.tr(),
        titleSize: pageStyle.unitFontSize * 23,
        titleColor: primaryColor,
        buttonColor: Colors.white,
        borderColor: primarySwatchColor,
        onPressed: () => user?.token != null
            ? Navigator.pushNamed(context, Routes.checkoutAddress)
            : Navigator.pushNamed(context, Routes.signIn),
        radius: 0,
      ),
    );
  }

  void _onRemoveCartItem(int index) async {
    final result = await showDialog(
      context: context,
      builder: (context) {
        return MyCartRemoveDialog(pageStyle: pageStyle);
      },
    );
    if (result != null) {
      isDeleting = true;
      myCartBloc.add(MyCartItemRemoved(
        cartId: cartId,
        itemId: myCartItems[index].itemId,
      ));
    }
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
}
