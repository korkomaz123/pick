import 'package:ciga/src/data/mock/mock.dart';
import 'package:ciga/src/data/models/product_model.dart';
import 'package:ciga/src/pages/ciga_app/bloc/cart_item_count/cart_item_count_bloc.dart';
import 'package:ciga/src/pages/ciga_app/bloc/wishlist_item_count/wishlist_item_count_bloc.dart';
import 'package:ciga/src/pages/my_cart/bloc/my_cart_bloc.dart';
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

class ProductVCard extends StatefulWidget {
  final double cardWidth;
  final double cardHeight;
  final ProductModel product;
  final bool isShoppingCart;
  final bool isWishlist;
  final bool isShare;
  final PageStyle pageStyle;

  ProductVCard({
    this.cardWidth,
    this.cardHeight,
    this.product,
    this.isShoppingCart = false,
    this.isWishlist = false,
    this.isShare = false,
    this.pageStyle,
  });

  @override
  _ProductVCardState createState() => _ProductVCardState();
}

class _ProductVCardState extends State<ProductVCard> {
  bool isWishlist;
  int index;
  String cartId;
  List<String> myWishlists;
  LocalStorageRepository localRepo;
  FlushBarService flushBarService;
  MyCartBloc myCartBloc;
  CartItemCountBloc cartItemCountBloc;
  WishlistItemCountBloc wishlistItemCountBloc;

  @override
  void initState() {
    super.initState();
    isWishlist = false;
    localRepo = context.repository<LocalStorageRepository>();
    myCartBloc = context.bloc<MyCartBloc>();
    cartItemCountBloc = context.bloc<CartItemCountBloc>();
    wishlistItemCountBloc = context.bloc<WishlistItemCountBloc>();
    flushBarService = FlushBarService(context: context);
    _getWishlist();
    _getMyCartId();
  }

  void _getWishlist() async {
    myWishlists = await localRepo.getWishlistIds();
    index = myWishlists.indexOf(widget.product.productId);
    isWishlist = index >= 0;
    setState(() {});
  }

  void _getMyCartId() async {
    cartId = await localRepo.getCartId();
  }

  void _setMyCartId(String cartId) async {
    await localRepo.setCartId(cartId);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.cardWidth,
      height: widget.cardHeight,
      child: BlocConsumer<MyCartBloc, MyCartState>(
        listener: (context, state) {
          if (state is MyCartCreatedSuccess) {
            _setMyCartId(state.cartId);
            myCartBloc.add(MyCartItemAdded(
              cartId: state.cartId,
              productId: widget.product.productId,
              qty: '1',
            ));
          }
          if (state is MyCartCreatedFailure) {
            flushBarService.showErrorMessage(
              widget.pageStyle,
              state.message,
            );
          }
          if (state is MyCartItemAddedSuccess) {
            flushBarService.showAddCartMessage(
              widget.pageStyle,
              widget.product,
            );
            cartItemCountBloc.add(CartItemCountIncremented(
              incrementedCount: cartItemCount + 1,
            ));
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
            ],
          );
        },
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
      child: Column(
        children: [
          Expanded(
            flex: 2,
            child: InkWell(
              onTap: () => Navigator.pushNamed(
                context,
                Routes.product,
                arguments: widget.product,
              ),
              child: Image.network(
                widget.product.imageUrl,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.product.brandLabel,
                  style: mediumTextStyle.copyWith(
                    color: primaryColor,
                    fontSize: widget.pageStyle.unitFontSize * 10,
                  ),
                ),
                Text(
                  widget.product.description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: mediumTextStyle.copyWith(
                    color: greyDarkColor,
                    fontSize: widget.pageStyle.unitFontSize * 12,
                    height: widget.pageStyle.unitHeight * 1.2,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.product.price + ' ' + 'currency'.tr(),
                      style: mediumTextStyle.copyWith(
                        fontSize: widget.pageStyle.unitFontSize * 12,
                        color: greyColor,
                      ),
                    ),
                    SizedBox(width: widget.pageStyle.unitWidth * 10),
                    Text(
                      widget.product.price + ' ' + 'currency'.tr(),
                      style: mediumTextStyle.copyWith(
                        decorationStyle: TextDecorationStyle.solid,
                        decoration: TextDecoration.lineThrough,
                        decorationColor: dangerColor,
                        fontSize: widget.pageStyle.unitFontSize * 12,
                        color: greyColor,
                      ),
                    ),
                    Spacer(),
                    widget.isShoppingCart
                        ? InkWell(
                            onTap: () => _onAddProductToCart(context),
                            child: Container(
                              width: widget.pageStyle.unitWidth * 18,
                              height: widget.pageStyle.unitHeight * 17,
                              child: SvgPicture.asset(
                                shoppingCartIcon,
                                color: primaryColor,
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
    return Column(
      children: [
        widget.isWishlist
            ? Align(
                alignment:
                    lang == 'en' ? Alignment.topRight : Alignment.topLeft,
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: InkWell(
                    onTap: () => _onWishlist(),
                    child: Container(
                      width: widget.pageStyle.unitWidth * 18,
                      height: widget.pageStyle.unitHeight * 17,
                      child: isWishlist
                          ? SvgPicture.asset(wishlistedIcon)
                          : SvgPicture.asset(
                              wishlistIcon,
                              color: greyColor,
                            ),
                    ),
                  ),
                ),
              )
            : SizedBox.shrink(),
      ],
    );
  }

  void _onAddProductToCart(BuildContext context) {
    if (cartId.isEmpty) {
      myCartBloc.add(MyCartCreated());
    } else {
      myCartBloc.add(MyCartItemAdded(
        cartId: cartId,
        productId: widget.product.productId,
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
