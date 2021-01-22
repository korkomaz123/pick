import 'dart:async';

import 'package:markaa/src/components/markaa_page_loading_kit.dart';
import 'package:markaa/src/components/markaa_text_button.dart';
import 'package:markaa/src/data/mock/mock.dart';
import 'package:markaa/src/data/models/index.dart';
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
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:isco_custom_widgets/isco_custom_widgets.dart';
import 'package:share/share.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:string_validator/string_validator.dart';

class ProductSingleProduct extends StatelessWidget {
  final PageStyle pageStyle;
  final ProductModel product;
  final ProductEntity productEntity;

  ProductSingleProduct({
    this.pageStyle,
    this.product,
    this.productEntity,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: context.watch<MyCartBloc>(),
      child: ProductSingleProductView(
        pageStyle: pageStyle,
        product: product,
        productEntity: productEntity,
      ),
    );
  }
}

class ProductSingleProductView extends StatefulWidget {
  final PageStyle pageStyle;
  final ProductModel product;
  final ProductEntity productEntity;

  ProductSingleProductView({
    this.pageStyle,
    this.product,
    this.productEntity,
  });

  @override
  _ProductSingleProductViewState createState() =>
      _ProductSingleProductViewState();
}

class _ProductSingleProductViewState extends State<ProductSingleProductView>
    with TickerProviderStateMixin {
  bool isMore = false;
  int activeIndex = 0;
  bool isFavorite = true;
  bool isBuyNow = false;
  bool isWishlist = false;
  bool isStock = false;
  int index;
  AnimationController _addToCartController;
  AnimationController _favoriteController;
  Animation<double> _addToCartScaleAnimation;
  Animation<double> _favoriteScaleAnimation;
  ProductModel product;
  ProductEntity productEntity;
  PageStyle pageStyle;
  MyCartBloc cartBloc;
  WishlistItemCountBloc wishlistItemCountBloc;
  FlushBarService flushBarService;
  LocalStorageRepository localStorageRepo;
  WishlistRepository wishlistRepo;
  MyCartRepository cartRepo;
  WishlistBloc wishlistBloc;

  @override
  void initState() {
    super.initState();
    pageStyle = widget.pageStyle;
    product = widget.product;
    productEntity = widget.productEntity;
    isStock = productEntity.stockQty != null && productEntity.stockQty > 0;
    cartBloc = context.read<MyCartBloc>();
    wishlistBloc = context.read<WishlistBloc>();
    wishlistItemCountBloc = context.read<WishlistItemCountBloc>();
    flushBarService = FlushBarService(context: context);
    localStorageRepo = context.read<LocalStorageRepository>();
    cartRepo = context.read<MyCartRepository>();
    wishlistRepo = context.read<WishlistRepository>();
    _initFavorite();
    _initAnimation();
  }

  void _initFavorite() async {
    if (user?.token != null) {
      isWishlist = await wishlistRepo.checkWishlistStatus(
        user.token,
        widget.product.entityId,
      );
      setState(() {});
    }
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

    /// favorite button animation
    _favoriteController = AnimationController(
      duration: const Duration(milliseconds: 300),
      reverseDuration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _favoriteScaleAnimation = Tween<double>(
      begin: 1.0,
      end: 3.0,
    ).animate(CurvedAnimation(
      parent: _favoriteController,
      curve: Curves.easeIn,
    ));
  }

  @override
  void dispose() {
    isBuyNow = false;
    _addToCartController.dispose();
    _favoriteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: pageStyle.deviceWidth,
      color: Colors.white,
      padding: EdgeInsets.all(pageStyle.unitWidth * 8),
      child: Column(
        children: [
          if (productEntity.gallery.isNotEmpty) ...[
            _buildImageCarousel()
          ] else ...[
            Container(
              width: double.infinity,
              height: pageStyle.unitHeight * 300,
              child: Image.asset('lib/public/images/loading/image_loading.jpg'),
            )
          ],
          _buildTitle(),
          SizedBox(height: pageStyle.unitHeight * 10),
          _buildDescription(),
          _buildPrice(),
          SizedBox(height: pageStyle.unitHeight * 10),
          _buildToolbar(),
        ],
      ),
    );
  }

  Widget _buildTitlebar() {
    return Container(
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: pageStyle.unitWidth * 22,
              height: pageStyle.unitHeight * 22,
              child: SvgPicture.asset(closeIcon),
            ),
          ),
          Column(
            children: [
              InkWell(
                onTap: () => _onShareProduct(),
                child: SvgPicture.asset(shareIcon),
              ),
              SizedBox(height: pageStyle.unitHeight * 10),
              InkWell(
                onTap: () => user != null
                    ? _onFavorite()
                    : Navigator.pushNamed(context, Routes.signIn),
                child: ScaleTransition(
                  scale: _favoriteScaleAnimation,
                  child: Container(
                    width: pageStyle.unitWidth * 22,
                    height: pageStyle.unitHeight * 22,
                    child: SvgPicture.asset(
                      isWishlist ? wishlistedIcon : wishlistIcon,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildImageCarousel() {
    return Container(
      width: double.infinity,
      height: widget.pageStyle.unitHeight * 350,
      child: Stack(
        children: [
          _buildProduct(),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.only(
                bottom: widget.pageStyle.unitHeight * 20,
              ),
              child: SmoothIndicator(
                offset: activeIndex.toDouble(),
                count: productEntity.gallery.length,
                axisDirection: Axis.horizontal,
                effect: SlideEffect(
                  spacing: 8.0,
                  radius: 30,
                  dotWidth: widget.pageStyle.unitHeight * 8,
                  dotHeight: widget.pageStyle.unitHeight * 8,
                  paintStyle: PaintingStyle.fill,
                  strokeWidth: 0,
                  dotColor: greyLightColor,
                  activeDotColor: primarySwatchColor,
                ),
              ),
            ),
          ),
          _buildTitlebar(),
        ],
      ),
    );
  }

  Widget _buildTitle() {
    return Container(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (productEntity.brandLabel.isNotEmpty) ...[
                InkWell(
                  onTap: () {
                    ProductListArguments arguments = ProductListArguments(
                      category: CategoryEntity(),
                      subCategory: [],
                      brand: productEntity.brandEntity,
                      selectedSubCategoryIndex: 0,
                      isFromBrand: true,
                    );
                    Navigator.pushNamed(
                      context,
                      Routes.productList,
                      arguments: arguments,
                    );
                  },
                  child: Text(
                    productEntity.brandLabel,
                    style: mediumTextStyle.copyWith(
                      color: primaryColor,
                      fontSize: pageStyle.unitFontSize * 13,
                    ),
                  ),
                )
              ],
              Text(
                isStock
                    ? 'in_stock'.tr().toUpperCase()
                    : 'out_stock'.tr().toUpperCase(),
                style: mediumTextStyle.copyWith(
                  color: isStock ? succeedColor : dangerColor,
                  fontSize: pageStyle.unitFontSize * 11,
                ),
              ),
            ],
          ),
          Text(
            productEntity.name,
            overflow: TextOverflow.ellipsis,
            style: mediumTextStyle.copyWith(
              fontSize: pageStyle.unitFontSize * 20,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProduct() {
    return Container(
      width: widget.pageStyle.deviceWidth,
      height: widget.pageStyle.unitHeight * 300,
      child: productEntity.gallery.length < 2
          ? Image.network(
              productEntity.gallery[0],
              width: pageStyle.unitWidth * 343,
              height: pageStyle.unitHeight * 240.31,
              loadingBuilder: (_, child, chunkEvent) {
                if (chunkEvent != null) {
                  return Image.asset(
                    'lib/public/images/loading/image_loading.jpg',
                  );
                }
                return child;
              },
            )
          : Swiper(
              itemCount: productEntity.gallery.length,
              autoplay: true,
              curve: Curves.easeIn,
              duration: 300,
              autoplayDelay: 5000,
              onIndexChanged: (value) {
                setState(() {
                  activeIndex = value;
                });
              },
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () => Navigator.pushNamed(
                    context,
                    Routes.viewFullImage,
                    arguments: productEntity.gallery,
                  ),
                  child: Image.network(
                    productEntity.gallery[index],
                    width: pageStyle.unitWidth * 343,
                    height: pageStyle.unitHeight * 240.31,
                    loadingBuilder: (_, child, chunkEvent) {
                      if (chunkEvent != null) {
                        return Image.asset(
                          'lib/public/images/loading/image_loading.jpg',
                        );
                      }
                      return child;
                    },
                  ),
                );
              },
            ),
    );
  }

  Widget _buildDescription() {
    return Container(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (isMore) ...[
            Text(
              productEntity.shortDescription,
              style: mediumTextStyle.copyWith(
                fontSize: pageStyle.unitFontSize * 12,
              ),
            )
          ] else if (isLength(productEntity.shortDescription, 110)) ...[
            Text(
              productEntity.shortDescription.substring(0, 110) + ' ...',
              style: mediumTextStyle.copyWith(
                fontSize: pageStyle.unitFontSize * 12,
              ),
            )
          ] else ...[
            Text(
              productEntity.shortDescription,
              style: mediumTextStyle.copyWith(
                fontSize: pageStyle.unitFontSize * 12,
              ),
            )
          ],
          if (isLength(productEntity.shortDescription, 110)) ...[
            InkWell(
              onTap: () {
                isMore = !isMore;
                setState(() {});
              },
              child: Text(
                isMore ? 'product_less'.tr() : 'product_more'.tr(),
                style: mediumTextStyle.copyWith(
                  color: primaryColor,
                  fontSize: pageStyle.unitFontSize * 14,
                ),
              ),
            )
          ] else ...[
            SizedBox.shrink()
          ],
        ],
      ),
    );
  }

  Widget _buildPrice() {
    return Container(
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            productEntity.price + ' ' + 'currency'.tr(),
            style: mediumTextStyle.copyWith(
              fontSize: pageStyle.unitFontSize * 14,
              color: greyColor,
            ),
          ),
          Text(
            'sku'.tr() + ': ' + productEntity.sku,
            style: mediumTextStyle.copyWith(
              fontSize: pageStyle.unitFontSize * 10,
              color: primaryColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildToolbar() {
    return BlocConsumer<MyCartBloc, MyCartState>(
      listener: (context, state) {
        if (state is MyCartCreatedFailure) {
          flushBarService.showErrorMessage(
            widget.pageStyle,
            state.message,
          );
        }
        if (state is MyCartItemAddedSuccess) {
          if (isBuyNow) {
            isBuyNow = false;
            Navigator.pushNamed(context, Routes.myCart);
          }
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
        bool isCreating = state is MyCartCreatedInProcess;
        bool isAdding = state is MyCartItemAddedInProcess;
        return Container(
          width: double.infinity,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (isBuyNow && (isCreating || isAdding)) ...[
                Container(
                  width: pageStyle.unitWidth * 296,
                  height: pageStyle.unitHeight * 50,
                  child: Center(child: CircleLoadingSpinner()),
                )
              ] else if (isStock) ...[
                Container(
                  width: pageStyle.unitWidth * 296,
                  height: pageStyle.unitHeight * 50,
                  child: MarkaaTextButton(
                    title: 'product_buy_now'.tr(),
                    titleSize: pageStyle.unitFontSize * 23,
                    titleColor: Colors.white,
                    buttonColor: Color(0xFFFF8B00),
                    borderColor: Colors.transparent,
                    radius: 1,
                    onPressed: () => _onBuyNow(),
                  ),
                )
              ] else ...[
                Container(
                  width: pageStyle.unitWidth * 296,
                  height: pageStyle.unitHeight * 50,
                )
              ],
              if (isStock) ...[
                RoundImageButton(
                  width: pageStyle.unitWidth * 58,
                  height: pageStyle.unitHeight * 50,
                  color: primarySwatchColor,
                  child: ScaleTransition(
                    scale: _addToCartScaleAnimation,
                    child: Container(
                      width: pageStyle.unitWidth * 25,
                      height: pageStyle.unitHeight * 25,
                      child: SvgPicture.asset(
                        shoppingCartIcon,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  onTap: () => _onAddToCart(),
                  radius: 1,
                )
              ] else ...[
                SizedBox.shrink()
              ],
            ],
          ),
        );
      },
    );
  }

  void _addToCart(String cartId) async {
    cartBloc.add(MyCartItemAdded(
      cartId: cartId,
      product: product,
      qty: '1',
    ));
  }

  void _onAddToCart() async {
    _addToCartController.repeat(reverse: true);
    Timer.periodic(Duration(milliseconds: 600), (timer) {
      _addToCartController.stop(canceled: true);
      timer.cancel();
    });
    String cartId = '';
    if (user?.token != null) {
      final result = await cartRepo.getCartId(user.token);
      if (result['code'] == 'SUCCESS') {
        cartId = result['cartId'];
      }
    } else {
      cartId = await localStorageRepo.getCartId();
    }
    if (cartId.isEmpty) {
      cartBloc.add(MyCartCreated(product: product));
    } else {
      _addToCart(cartId);
    }
  }

  void _onFavorite() async {
    _updateWishlist();
    _favoriteController.repeat(reverse: true);
    Timer.periodic(Duration(milliseconds: 600), (timer) {
      _favoriteController.stop(canceled: true);
      timer.cancel();
    });
  }

  void _updateWishlist() async {
    if (isWishlist) {
      wishlistCount -= 1;
      wishlistBloc.add(WishlistRemoved(
        token: user.token,
        productId: widget.product.entityId,
      ));
    } else {
      wishlistCount += 1;
      wishlistBloc.add(WishlistAdded(
        token: user.token,
        productId: widget.product.entityId,
      ));
    }
    isWishlist = !isWishlist;
    wishlistItemCountBloc.add(WishlistItemCountSet(
      wishlistItemCount: wishlistCount,
    ));
    setState(() {});
  }

  void _onBuyNow() async {
    isBuyNow = true;
    String cartId = '';
    if (user?.token != null) {
      final result = await cartRepo.getCartId(user.token);
      if (result['code'] == 'SUCCESS') {
        cartId = result['cartId'];
      }
    } else {
      cartId = await localStorageRepo.getCartId();
    }
    if (cartId.isEmpty) {
      cartBloc.add(MyCartCreated(product: product));
    } else {
      _addToCart(cartId);
    }
  }

  void _onShareProduct() {
    Share.share(product.imageUrl, subject: product.name);
  }
}
