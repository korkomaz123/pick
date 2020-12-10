import 'dart:async';

import 'package:ciga/src/data/mock/mock.dart';
import 'package:ciga/src/data/models/category_entity.dart';
import 'package:ciga/src/data/models/product_list_arguments.dart';
import 'package:ciga/src/data/models/product_model.dart';
import 'package:ciga/src/pages/ciga_app/bloc/wishlist_item_count/wishlist_item_count_bloc.dart';
import 'package:ciga/src/pages/my_cart/bloc/my_cart/my_cart_bloc.dart';
import 'package:ciga/src/routes/routes.dart';
import 'package:ciga/src/theme/icons.dart';
import 'package:ciga/src/theme/styles.dart';
import 'package:ciga/src/theme/theme.dart';
import 'package:ciga/src/utils/flushbar_service.dart';
import 'package:ciga/src/utils/local_storage_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:isco_custom_widgets/isco_custom_widgets.dart';

class ProductHCard extends StatefulWidget {
  final double cardWidth;
  final double cardHeight;
  final ProductModel product;
  final bool isShoppingCart;
  final bool isWishlist;
  final bool isShare;
  final PageStyle pageStyle;

  ProductHCard({
    this.cardWidth,
    this.cardHeight,
    this.product,
    this.isShoppingCart = false,
    this.isWishlist = false,
    this.isShare = false,
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
  List<String> myWishlists;
  LocalStorageRepository localRepo;
  FlushBarService flushBarService;
  MyCartBloc myCartBloc;
  WishlistItemCountBloc wishlistItemCountBloc;
  AnimationController _addToCartController;
  Animation<double> _addToCartScaleAnimation;

  @override
  void initState() {
    super.initState();
    isWishlist = false;
    localRepo = context.read<LocalStorageRepository>();
    myCartBloc = context.read<MyCartBloc>();
    wishlistItemCountBloc = context.read<WishlistItemCountBloc>();
    flushBarService = FlushBarService(context: context);
    _getWishlist();
    _getMyCartId();
    _initAnimation();
  }

  void _getWishlist() async {
    myWishlists = await localRepo.getWishlistIds();
    index = myWishlists.indexOf(widget.product.productId);
    isWishlist = index != -1;
    setState(() {});
  }

  Future<void> _getMyCartId() async {
    cartId = await localRepo.getCartId();
  }

  void _saveCartId(cartId) async {
    await localRepo.setCartId(cartId);
  }

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
            if (state is MyCartItemAddedSuccess) {
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
            if (state is MyCartCreatedSuccess) {
              _saveCartId(state.cartId);
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
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.network(
            widget.product.imageUrl,
            width: widget.cardWidth * 0.3,
            height: widget.cardHeight * 0.7,
            fit: BoxFit.fill,
            loadingBuilder: (_, child, chunkEvent) {
              return chunkEvent != null
                  ? Image.asset(
                      'lib/public/images/loading/image_loading.jpg',
                    )
                  : child;
            },
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: widget.cardHeight * 0.2),
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
                Text(
                  widget.product.shortDescription,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: mediumTextStyle.copyWith(
                    color: greyDarkColor,
                    fontSize: widget.pageStyle.unitFontSize * 12,
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
                        // widget.product.price + ' ' + 'currency'.tr(),
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
                    widget.isShoppingCart
                        ? InkWell(
                            onTap: () => _onAddProductToCart(context),
                            child: ScaleTransition(
                              scale: _addToCartScaleAnimation,
                              child: Container(
                                width: widget.pageStyle.unitWidth * 18,
                                height: widget.pageStyle.unitHeight * 17,
                                child: SvgPicture.asset(
                                  shoppingCartIcon,
                                  color: primaryColor,
                                ),
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
        if (myWishlists.length != state.wishlistItemCount) {
          _getWishlist();
        }
      },
      builder: (context, state) {
        return Column(
          children: [
            widget.isWishlist
                ? Align(
                    alignment:
                        lang == 'en' ? Alignment.topRight : Alignment.topLeft,
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: InkWell(
                        onTap: () => user != null
                            ? _onWishlist()
                            : Navigator.pushNamed(context, Routes.signIn),
                        child: Container(
                          width: widget.pageStyle.unitWidth * 18,
                          height: widget.pageStyle.unitHeight * 17,
                          child: isWishlist
                              ? SvgPicture.asset(wishlistedIcon)
                              : SvgPicture.asset(wishlistIcon,
                                  color: greyColor),
                        ),
                      ),
                    ),
                  )
                : SizedBox.shrink(),
          ],
        );
      },
    );
  }

  void _onAddProductToCart(BuildContext context) async {
    _addToCartController.repeat(reverse: true);
    Timer.periodic(Duration(milliseconds: 600), (timer) {
      _addToCartController.stop(canceled: true);
      timer.cancel();
    });
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
  }

  void _onWishlist() async {
    if (isWishlist) {
      wishlistCount -= 1;
      myWishlists.removeAt(index);
      await localRepo.removeWishlistItem(widget.product.productId);
    } else {
      wishlistCount += 1;
      myWishlists.add(widget.product.productId);
      index = myWishlists.length - 1;
      await localRepo.addWishlistItem(widget.product.productId);
    }
    isWishlist = !isWishlist;
    wishlistItemCountBloc.add(WishlistItemCountSet(
      wishlistItemCount: wishlistCount,
    ));
    setState(() {});
  }
}
