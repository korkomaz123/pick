import 'dart:async';

import 'package:markaa/src/data/mock/mock.dart';
import 'package:markaa/src/data/models/category_entity.dart';
import 'package:markaa/src/data/models/product_list_arguments.dart';
import 'package:markaa/src/data/models/product_model.dart';
import 'package:markaa/src/pages/markaa_app/bloc/wishlist_item_count/wishlist_item_count_bloc.dart';
import 'package:markaa/src/pages/my_cart/bloc/my_cart/my_cart_bloc.dart';
import 'package:markaa/src/pages/my_cart/bloc/my_cart_repository.dart';
import 'package:markaa/src/pages/wishlist/bloc/wishlist_bloc.dart';
import 'package:markaa/src/pages/wishlist/bloc/wishlist_repository.dart';
import 'package:markaa/src/routes/routes.dart';
import 'package:markaa/src/theme/icons.dart';
import 'package:markaa/src/theme/styles.dart';
import 'package:markaa/src/theme/theme.dart';
import 'package:markaa/src/utils/flushbar_service.dart';
import 'package:markaa/src/utils/local_storage_repository.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:isco_custom_widgets/isco_custom_widgets.dart';

class ProductHCard extends StatefulWidget {
  final double cardWidth;
  final double cardHeight;
  final ProductModel product;
  final bool isShoppingCart;
  final bool isWishlist;
  final bool isShare;
  final bool isMinor;
  final PageStyle pageStyle;

  ProductHCard({
    this.cardWidth,
    this.cardHeight,
    this.product,
    this.isShoppingCart = false,
    this.isWishlist = false,
    this.isShare = false,
    this.isMinor = true,
    this.pageStyle,
  });

  @override
  _ProductHCardState createState() => _ProductHCardState();
}

class _ProductHCardState extends State<ProductHCard>
    with TickerProviderStateMixin {
  bool isWishlist;
  int index;
  String cartId;
  MyCartRepository cartRepo;
  WishlistRepository wishlistRepo;
  LocalStorageRepository localRepo;
  FlushBarService flushBarService;
  MyCartBloc myCartBloc;
  WishlistBloc wishlistBloc;
  WishlistItemCountBloc wishlistItemCountBloc;
  AnimationController _addToCartController;
  Animation<double> _addToCartScaleAnimation;

  @override
  void initState() {
    super.initState();
    isWishlist = false;
    cartRepo = context.read<MyCartRepository>();
    wishlistRepo = context.read<WishlistRepository>();
    localRepo = context.read<LocalStorageRepository>();
    myCartBloc = context.read<MyCartBloc>();
    wishlistBloc = context.read<WishlistBloc>();
    wishlistItemCountBloc = context.read<WishlistItemCountBloc>();
    flushBarService = FlushBarService(context: context);
    _getWishlist();
    _getMyCartId();
    _initAnimation();
  }

  void _getWishlist() async {
    if (user?.token != null) {
      isWishlist = await wishlistRepo.checkWishlistStatus(
        user.token,
        widget.product.productId,
      );
      if (mounted) setState(() {});
    }
  }

  Future<void> _getMyCartId() async {
    if (user?.token != null) {
      final result = await cartRepo.getCartId(user.token);
      if (result['code'] == 'SUCCESS') {
        cartId = result['cartId'];
      }
    } else {
      cartId = await localRepo.getCartId();
    }
    if (cartId.isEmpty) {
      final result = await cartRepo.createCart();
      if (result['code'] == 'SUCCESS') {
        cartId = result['cartId'];
        await localRepo.setCartId(cartId);
      }
    }
  }

  // void _saveCartId(cartId) async {
  //   await localRepo.setCartId(cartId);
  // }

  void _initAnimation() {
    /// add to cart button animation
    _addToCartController = AnimationController(
      duration: const Duration(milliseconds: 300),
      reverseDuration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _addToCartScaleAnimation = Tween<double>(
      begin: 1.0,
      end: 3.0,
    ).animate(CurvedAnimation(
      parent: _addToCartController,
      curve: Curves.easeIn,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.pushNamed(
        context,
        Routes.product,
        arguments: widget.product,
      ),
      child: Container(
        width: widget.cardWidth,
        height: widget.cardHeight,
        child: BlocConsumer<MyCartBloc, MyCartState>(
          listener: (context, state) {
            if (state is MyCartCreatedFailure) {
              flushBarService.showErrorMessage(
                widget.pageStyle,
                state.message,
              );
            }
            if (state is MyCartItemAddedInProcess) {
              flushBarService.showAddCartMessage(
                widget.pageStyle,
                state.product,
              );
            }
            if (state is MyCartItemAddedFailure) {
              flushBarService.showErrorMessage(
                widget.pageStyle,
                state.message,
              );
            }
          },
          builder: (context, state) {
            if (state is MyCartCreatedSuccess) {
              cartId = state.cartId;
            }
            return Stack(
              children: [
                _buildProductCard(),
                _buildToolbar(),
                _buildOutofStock(),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildProductCard() {
    return Container(
      width: widget.cardWidth,
      height: widget.cardHeight,
      color: Colors.white,
      padding: EdgeInsets.symmetric(
        horizontal: widget.pageStyle.unitWidth * 8,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(right: widget.pageStyle.unitHeight * 10),
            child: Image.network(
              widget.product.imageUrl,
              width: widget.cardHeight * 0.65,
              height: widget.cardHeight * 0.8,
              fit: BoxFit.fitHeight,
              loadingBuilder: (_, child, chunkEvent) {
                return chunkEvent != null
                    ? Image.asset(
                        'lib/public/images/loading/image_loading.jpg',
                      )
                    : child;
              },
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: widget.cardHeight * 0.1),
                InkWell(
                  onTap: () {
                    if (widget.product.brandId.isNotEmpty) {
                      ProductListArguments arguments = ProductListArguments(
                        category: CategoryEntity(),
                        subCategory: [],
                        brand: widget.product.brandEntity,
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
                    widget.product.brandLabel,
                    style: mediumTextStyle.copyWith(
                      color: primaryColor,
                      fontSize: widget.pageStyle.unitFontSize * 12,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    right: widget.pageStyle.unitWidth * 20,
                  ),
                  child: Text(
                    widget.product.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: mediumTextStyle.copyWith(
                      color: greyDarkColor,
                      fontSize: widget.pageStyle.unitFontSize *
                          (widget.isMinor ? 12 : 16),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                SizedBox(height: widget.pageStyle.unitHeight * 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        widget.product.price + ' ' + 'currency'.tr(),
                        style: mediumTextStyle.copyWith(
                          fontSize: widget.pageStyle.unitFontSize * 12,
                          color: greyColor,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        '',
                        style: mediumTextStyle.copyWith(
                          decorationStyle: TextDecorationStyle.solid,
                          decoration: TextDecoration.lineThrough,
                          decorationColor: dangerColor,
                          fontSize: widget.pageStyle.unitFontSize * 12,
                          color: greyColor,
                        ),
                      ),
                    ),
                    Spacer(),
                    widget.isShoppingCart &&
                            widget.product.stockQty != null &&
                            widget.product.stockQty > 0
                        ? InkWell(
                            onTap: () => _onAddProductToCart(context),
                            child: ScaleTransition(
                              scale: _addToCartScaleAnimation,
                              child: Container(
                                width: widget.pageStyle.unitHeight * 32,
                                height: widget.pageStyle.unitHeight * 32,
                                child: SvgPicture.asset(addCartIcon),
                              ),
                            ),
                          )
                        : SizedBox.shrink(),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildToolbar() {
    return BlocConsumer<WishlistItemCountBloc, WishlistItemCountState>(
      listener: (context, state) {
        _getWishlist();
      },
      builder: (context, state) {
        return Column(
          children: [
            if (widget.isWishlist) ...[
              Align(
                alignment:
                    lang == 'en' ? Alignment.topRight : Alignment.topLeft,
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: InkWell(
                    onTap: () => user != null
                        ? _onWishlist()
                        : Navigator.pushNamed(context, Routes.signIn),
                    child: Container(
                      width:
                          widget.pageStyle.unitWidth * (isWishlist ? 22 : 25),
                      height:
                          widget.pageStyle.unitWidth * (isWishlist ? 22 : 25),
                      child: isWishlist
                          ? SvgPicture.asset(wishlistedIcon)
                          : SvgPicture.asset(wishlistOpacityIcon),
                    ),
                  ),
                ),
              )
            ],
          ],
        );
      },
    );
  }

  Widget _buildOutofStock() {
    return widget.product.stockQty == null || widget.product.stockQty == 0
        ? Align(
            alignment:
                lang == 'en' ? Alignment.centerRight : Alignment.centerLeft,
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: widget.pageStyle.unitWidth * 15,
                vertical: widget.pageStyle.unitHeight * 5,
              ),
              color: primarySwatchColor.withOpacity(0.4),
              child: Text(
                'out_stock'.tr(),
                style: mediumTextStyle.copyWith(
                  fontSize: widget.pageStyle.unitFontSize * 14,
                  color: Colors.white70,
                ),
              ),
            ),
          )
        : SizedBox.shrink();
  }

  void _onAddProductToCart(BuildContext context) async {
    _addToCartController.repeat(reverse: true);
    Timer.periodic(Duration(milliseconds: 600), (timer) {
      _addToCartController.stop(canceled: true);
      timer.cancel();
    });
    if (widget.product.stockQty != null && widget.product.stockQty > 0) {
      await _getMyCartId();
      if (cartId.isEmpty) {
        myCartBloc.add(MyCartCreated(
          product: widget.product,
        ));
      } else {
        myCartBloc.add(MyCartItemAdded(
          cartId: cartId,
          product: widget.product,
          qty: '1',
        ));
      }
    } else {
      flushBarService.showErrorMessage(
        widget.pageStyle,
        'out_of_stock_error'.tr(),
      );
    }
  }

  void _onWishlist() async {
    if (isWishlist) {
      wishlistCount -= 1;
      wishlistBloc.add(WishlistRemoved(
        token: user.token,
        productId: widget.product.productId,
      ));
      await localRepo.removeWishlistItem(widget.product.productId);
    } else {
      wishlistCount += 1;
      wishlistBloc.add(WishlistAdded(
        token: user.token,
        productId: widget.product.productId,
      ));
    }
    isWishlist = !isWishlist;
    wishlistItemCountBloc.add(WishlistItemCountSet(
      wishlistItemCount: wishlistCount,
    ));
    setState(() {});
  }
}
