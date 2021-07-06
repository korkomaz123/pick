import 'dart:async';

import 'package:adjust_sdk/adjust.dart';
import 'package:adjust_sdk/adjust_event.dart';
import 'package:badges/badges.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:markaa/preload.dart';
import 'package:markaa/src/change_notifier/home_change_notifier.dart';
import 'package:markaa/src/change_notifier/markaa_app_change_notifier.dart';
import 'package:markaa/src/change_notifier/product_change_notifier.dart';
import 'package:markaa/src/change_notifier/my_cart_change_notifier.dart';
import 'package:markaa/src/components/custom/sliding_sheet.dart';
import 'package:markaa/src/components/markaa_bottom_bar.dart';
import 'package:markaa/src/components/markaa_cart_added_success_dialog.dart';
import 'package:markaa/src/components/markaa_page_loading_kit.dart';
import 'package:markaa/src/components/markaa_round_image_button.dart';
import 'package:markaa/src/components/markaa_text_button.dart';
import 'package:markaa/src/config/config.dart';
import 'package:markaa/src/data/mock/mock.dart';
import 'package:markaa/src/data/models/enum.dart';
import 'package:markaa/src/data/models/index.dart';
import 'package:markaa/src/data/models/product_model.dart';
import 'package:markaa/src/routes/routes.dart';
import 'package:markaa/src/theme/icons.dart';
import 'package:markaa/src/theme/theme.dart';
import 'package:markaa/src/utils/repositories/local_storage_repository.dart';
import 'package:flutter/material.dart';
import 'package:markaa/src/utils/repositories/product_repository.dart';
import 'package:markaa/src/utils/services/flushbar_service.dart';
import 'package:markaa/src/utils/services/progress_service.dart';
import 'package:provider/provider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'widgets/product_details_tabs.dart';
import 'widgets/product_related_items.dart';
import 'widgets/product_same_brand_products.dart';
import 'widgets/product_single_product.dart';
import 'widgets/product_review_total.dart';
import 'widgets/top_brands_in_category.dart';

class ProductPage extends StatefulWidget {
  final Object arguments;

  ProductPage({this.arguments});

  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> with TickerProviderStateMixin {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final _refreshController = RefreshController();

  ProgressService progressService;
  FlushBarService flushBarService;

  LocalStorageRepository localStorageRepository = LocalStorageRepository();
  ProductRepository productRepository = ProductRepository();

  AnimationController _addToCartController;
  Animation<double> _addToCartScaleAnimation;

  MyCartChangeNotifier myCartChangeNotifier;
  ProductChangeNotifier productChangeNotifier;
  MarkaaAppChangeNotifier markaaAppChangeNotifier;

  ProductModel product;
  String productId;

  bool isBuyNow = false;

  bool get variantSelectRequired =>
      productChangeNotifier.productDetailsMap[productId].typeId == 'configurable' && productChangeNotifier.selectedVariant == null;

  bool get isChildOutOfStock =>
      productChangeNotifier.productDetailsMap[productId].typeId == 'configurable' &&
      (productChangeNotifier.selectedVariant?.stockQty == null || productChangeNotifier.selectedVariant.stockQty == 0);

  bool get isParentOutOfStock =>
      productChangeNotifier.productDetailsMap[productId].typeId != 'configurable' &&
      (productChangeNotifier.productDetailsMap[productId]?.stockQty == null || productChangeNotifier.productDetailsMap[productId].stockQty == 0);

  @override
  void initState() {
    super.initState();
    product = widget.arguments as ProductModel;
    productId = product.productId;

    productChangeNotifier = context.read<ProductChangeNotifier>();
    myCartChangeNotifier = context.read<MyCartChangeNotifier>();
    markaaAppChangeNotifier = context.read<MarkaaAppChangeNotifier>();
    productChangeNotifier.setInitalInfo(product);

    progressService = ProgressService(context: context);
    flushBarService = FlushBarService(context: context);

    _loadDetails();
    _initAnimation();
    _sendViewedProduct();

    AdjustEvent adjustEvent = new AdjustEvent(AdjustSDKConfig.viewProduct);
    Adjust.trackEvent(adjustEvent);
  }

  void _loadDetails() async {
    print('PRODUCT ID >>> $productId');
    await productChangeNotifier.getProductDetails(productId);
  }

  void _initAnimation() {
    /// add to cart button animation
    _addToCartController = AnimationController(
      duration: const Duration(milliseconds: 300),
      reverseDuration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _addToCartScaleAnimation = Tween<double>(begin: 1.0, end: 3.0).animate(CurvedAnimation(
      parent: _addToCartController,
      curve: Curves.easeIn,
    ));
  }

  @override
  void dispose() {
    isBuyNow = false;
    _addToCartController.dispose();
    productChangeNotifier.close();
    super.dispose();
  }

  _onRefresh() async {
    Future.delayed(Duration(milliseconds: 500), () {
      _refreshController.refreshCompleted();
    });
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await productChangeNotifier.getProductDetails(productId);
    });
  }

  _sendViewedProduct() async {
    if (user?.token != null) {
      await productRepository.setRecentlyViewedCustomerProduct(user.token, productId, lang);
    } else {
      await localStorageRepository.addRecentlyViewedItem(productId);
    }
    Preload.navigatorKey.currentContext.read<HomeChangeNotifier>().getViewedProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Container(
          color: backgroundColor,
          child: Consumer<ProductChangeNotifier>(
            builder: (context, model, child) {
              if (model.productDetailsMap.containsKey(productId)) {
                return Stack(
                  children: [
                    SmartRefresher(
                      enablePullDown: true,
                      enablePullUp: false,
                      header: MaterialClassicHeader(color: primaryColor),
                      controller: _refreshController,
                      onRefresh: _onRefresh,
                      onLoading: () => null,
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            ProductSingleProduct(
                              product: product,
                              productDetails: model.productDetailsMap[productId],
                              model: model,
                            ),
                            ProductReviewTotal(
                              model: model,
                              product: model.productDetailsMap[productId],
                              onFirstReview: () => _onFirstReview(model.productDetailsMap[productId]),
                              onReviews: () => _onReviews(model.productDetailsMap[productId]),
                            ),
                            ProductSameBrandProducts(product: product),
                            ProductDetailsTabs(
                              model: model,
                              productEntity: model.productDetailsMap[productId],
                            ),
                            TopBrandsInCategory(productId: productId),
                            ProductRelatedItems(product: product),
                            SizedBox(height: 60.h),
                          ],
                        ),
                      ),
                    ),
                    Positioned(left: 0, right: 0, bottom: 0, child: _buildToolbar(model)),
                    Positioned(left: 0, right: 0, top: 0, child: _buildStickyHeader()),
                  ],
                );
              } else {
                return Center(child: PulseLoadingSpinner());
              }
            },
          ),
        ),
      ),
      bottomNavigationBar: MarkaaBottomBar(activeItem: BottomEnum.home),
    );
  }

  Widget _buildStickyHeader() {
    return Container(
      width: 375.w,
      color: Colors.white54,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(Icons.arrow_back_ios, color: primaryColor, size: 26.sp),
          ),
          Expanded(
            child: SizedBox(
              height: 35.h,
              child: TextFormField(
                controller: TextEditingController(),
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 20.w,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.sp),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.sp),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.sp),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: greyLightColor,
                  hintText: 'search_items'.tr(),
                  hintStyle: TextStyle(color: darkColor),
                  suffixIcon: Icon(
                    Icons.search,
                    color: greyDarkColor,
                    size: 25.sp,
                  ),
                ),
                readOnly: true,
                onTap: () => Navigator.pushNamed(context, Routes.search),
              ),
            ),
          ),
          IconButton(
            onPressed: () => Navigator.pushNamed(context, Routes.myCart),
            icon: Center(
              child: Consumer<MyCartChangeNotifier>(
                builder: (_, model, __) {
                  return Badge(
                    badgeColor: badgeColor,
                    badgeContent: Text(
                      '${model.cartTotalCount}',
                      style: TextStyle(fontSize: 8.sp, color: Colors.white),
                    ),
                    showBadge: model.cartItemCount > 0,
                    toAnimate: false,
                    animationDuration: Duration.zero,
                    position: Preload.languageCode == 'ar' ? BadgePosition.topStart(start: 0, top: -2.h) : BadgePosition.topEnd(end: 0, top: -2.h),
                    child: SvgPicture.asset(addCart1Icon),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildToolbar(ProductChangeNotifier model) {
    return Consumer<MarkaaAppChangeNotifier>(
      builder: (_, appModel, __) {
        if (model.productDetailsMap[productId].typeId == 'configurable' || (!isParentOutOfStock && !isChildOutOfStock)) {
          return Container(
            width: 375.w,
            height: 60.h,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (appModel.buying) ...[
                  Container(
                    width: 317.w,
                    height: 60.h,
                    color: Color(0xFFFF8B00),
                    child: CircleLoadingSpinner(loadingColor: Colors.white),
                  )
                ] else ...[
                  Container(
                    width: 317.w,
                    height: 60.h,
                    child: MarkaaTextButton(
                      title: 'product_buy_now'.tr(),
                      titleSize: 23.sp,
                      titleColor: Colors.white,
                      buttonColor: Color(0xFFFF8B00),
                      borderColor: Colors.transparent,
                      radius: 1,
                      onPressed: () => _onBuyNow(model),
                      isBold: true,
                    ),
                  )
                ],
                MarkaaRoundImageButton(
                  width: 58.w,
                  height: 60.h,
                  color: primarySwatchColor,
                  child: ScaleTransition(
                    scale: _addToCartScaleAnimation,
                    child: Container(
                      width: 25.w,
                      height: 25.h,
                      child: SvgPicture.asset(
                        shoppingCartIcon,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  onTap: () {
                    if (appModel.activeAddCart) {
                      appModel.changeAddCartStatus(false);
                      _onAddToCart(model);
                      appModel.changeAddCartStatus(true);
                    }
                  },
                  radius: 1,
                ),
              ],
            ),
          );
        } else {
          return Container();
        }
      },
    );
  }

  _onAddToCart(ProductChangeNotifier model) async {
    if (variantSelectRequired) {
      flushBarService.showErrorDialog('required_options'.tr(), "select_option.svg");
      return;
    }
    if (isParentOutOfStock || isChildOutOfStock) {
      flushBarService.showErrorDialog('out_of_stock_error'.tr(), "no_qty.svg");
      return;
    }

    _addToCartController.repeat(reverse: true);
    Timer.periodic(Duration(milliseconds: 600), (timer) {
      _addToCartController.stop(canceled: true);
      timer.cancel();
    });

    await myCartChangeNotifier.addProductToCart(product, 1, lang, model.selectedOptions,
        onProcess: _onAdding, onSuccess: _onAddSuccess, onFailure: _onAddFailure);
  }

  _onBuyNow(ProductChangeNotifier model) {
    if (variantSelectRequired) {
      flushBarService.showErrorDialog('required_options'.tr(), "select_option.svg");
      return;
    }
    if (isParentOutOfStock || isChildOutOfStock) {
      flushBarService.showErrorDialog('out_of_stock_error'.tr(), "no_qty.svg");
      return;
    }
    myCartChangeNotifier.addProductToCart(product, 1, lang, model.selectedOptions,
        onProcess: _onBuyProcess, onSuccess: _onBuySuccess, onFailure: _onBuyFailure);
  }

  _onBuyProcess() {
    markaaAppChangeNotifier.changeBuyStatus(true);
  }

  _onBuySuccess() {
    AdjustEvent adjustEvent = new AdjustEvent(AdjustSDKConfig.addToCart);
    Adjust.trackEvent(adjustEvent);

    markaaAppChangeNotifier.changeBuyStatus(false);

    Navigator.pushNamed(context, Routes.myCart);
  }

  _onBuyFailure(String message) {
    markaaAppChangeNotifier.changeBuyStatus(false);
    flushBarService.showErrorDialog('out_of_stock_error'.tr(), "no_qty.svg");
  }

  _onAdding() {
    progressService.addingProductProgress();
  }

  _onAddSuccess() {
    progressService.hideProgress();
    showSlidingTopSheet(
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
            return MarkaaCartAddedSuccessDialog(product: product);
          },
        );
      },
    );

    AdjustEvent adjustEvent = new AdjustEvent(AdjustSDKConfig.addToCart);
    Adjust.trackEvent(adjustEvent);
  }

  _onAddFailure(String message) {
    progressService.hideProgress();
    flushBarService.showErrorDialog('out_of_stock_error'.tr(), "no_qty.svg");
  }

  _onFirstReview(ProductEntity product) async {
    await Navigator.pushNamed(
      context,
      Routes.addProductReview,
      arguments: product,
    );
    setState(() {});
  }

  _onReviews(ProductEntity product) async {
    await Navigator.pushNamed(
      context,
      Routes.productReviews,
      arguments: product,
    );
    setState(() {});
  }
}
