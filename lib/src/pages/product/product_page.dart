import 'dart:async';

import 'package:adjust_sdk/adjust.dart';
import 'package:adjust_sdk/adjust_event.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:markaa/src/change_notifier/home_change_notifier.dart';
import 'package:markaa/src/change_notifier/product_change_notifier.dart';
import 'package:markaa/src/change_notifier/my_cart_change_notifier.dart';
import 'package:markaa/src/components/markaa_bottom_bar.dart';
import 'package:markaa/src/components/markaa_page_loading_kit.dart';
import 'package:markaa/src/components/markaa_round_image_button.dart';
import 'package:markaa/src/components/markaa_side_menu.dart';
import 'package:markaa/src/components/markaa_text_button.dart';
import 'package:markaa/src/config/config.dart';
import 'package:markaa/src/data/mock/mock.dart';
import 'package:markaa/src/data/models/enum.dart';
import 'package:markaa/src/data/models/index.dart';
import 'package:markaa/src/data/models/product_model.dart';
import 'package:markaa/src/pages/product/widgets/product_more_about.dart';
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

import '../../../config.dart';
import 'widgets/product_related_items.dart';
import 'widgets/product_same_brand_products.dart';
import 'widgets/product_single_product.dart';
import 'widgets/product_review.dart';
import 'widgets/product_review_total.dart';
import 'widgets/product_configurable_options.dart';

class ProductPage extends StatefulWidget {
  final Object arguments;

  ProductPage({this.arguments});

  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage>
    with TickerProviderStateMixin {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final _refreshController = RefreshController(initialRefresh: false);
  ProductModel product;
  ProgressService progressService;
  LocalStorageRepository localStorageRepository = LocalStorageRepository();
  ProductRepository productRepository = ProductRepository();
  FlushBarService flushBarService;
  bool isBuyNow = false;
  bool isStock = false;
  AnimationController _addToCartController;
  Animation<double> _addToCartScaleAnimation;
  MyCartChangeNotifier myCartChangeNotifier;
  final ProductChangeNotifier _productChangeNotifier =
      Config.navigatorKey.currentContext.watch<ProductChangeNotifier>();

  @override
  void initState() {
    super.initState();
    product = widget.arguments as ProductModel;
    _productChangeNotifier.setInitalInfo(product);
    progressService = ProgressService(context: context);
    flushBarService = FlushBarService(context: context);
    myCartChangeNotifier = context.read<MyCartChangeNotifier>();
    _loadDetails();
    _initAnimation();
    _sendViewedProduct();
    AdjustEvent adjustEvent = new AdjustEvent(AdjustSDKConfig.viewProduct);
    Adjust.trackEvent(adjustEvent);
  }

  void _loadDetails() async {
    _productChangeNotifier.getProductDetails(product.productId);
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
  void dispose() {
    isBuyNow = false;
    _addToCartController.dispose();
    _productChangeNotifier.close();
    super.dispose();
  }

  void _onRefresh() async {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(Duration.zero, () async {
        await _productChangeNotifier.getProductDetails(product.productId);
      });
    });
  }

  void _sendViewedProduct() async {
    if (user?.token != null) {
      await productRepository.setRecentlyViewedCustomerProduct(
          user.token, product.productId, lang);
    } else {
      await localStorageRepository.addRecentlyViewedItem(product.productId);
    }
    Config.navigatorKey.currentContext
        .read<HomeChangeNotifier>()
        .getViewedProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: backgroundColor,
      drawer: MarkaaSideMenu(),
      body: SafeArea(
        child: Consumer<ProductChangeNotifier>(
          builder: (context, productChangeNotifier, child) {
            if (productChangeNotifier.productDetails != null) {
              isStock = productChangeNotifier.productDetails.typeId ==
                      'configurable' ||
                  (productChangeNotifier.productDetails.stockQty != null &&
                      productChangeNotifier.productDetails.stockQty > 0);
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
                              product: product, model: productChangeNotifier),
                          if (productChangeNotifier.productDetails.typeId ==
                              'configurable') ...[
                            ProductConfigurableOptions(
                              productEntity:
                                  productChangeNotifier.productDetails,
                            )
                          ],
                          ProductReviewTotal(
                            product: productChangeNotifier.productDetails,
                            onFirstReview: () => _onFirstReview(
                                productChangeNotifier.productDetails),
                            onReviews: () => _onReviews(
                                productChangeNotifier.productDetails),
                          ),
                          ProductRelatedItems(
                            product: product,
                          ),
                          ProductSameBrandProducts(
                            product: product,
                          ),
                          ProductMoreAbout(
                            productEntity: productChangeNotifier.productDetails,
                          ),
                          ProductReview(
                            product: productChangeNotifier.productDetails,
                          ),
                          SizedBox(height: 50.h),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: _buildToolbar(productChangeNotifier),
                  ),
                ],
              );
            } else {
              return Center(child: PulseLoadingSpinner());
            }
          },
        ),
      ),
      bottomNavigationBar: MarkaaBottomBar(activeItem: BottomEnum.home),
    );
  }

  Widget _buildToolbar(ProductChangeNotifier model) {
    return Container(
      width: 375.w,
      height: 60.h,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (isStock) ...[
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
          ] else ...[
            Container(width: 317.w, height: 60.h)
          ],
          if (isStock) ...[
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
              onTap: () => _onAddToCart(model),
              radius: 1,
            )
          ] else ...[
            SizedBox.shrink()
          ],
        ],
      ),
    );
  }

  void _onAddToCart(ProductChangeNotifier model) async {
    if (model.productDetails.typeId == 'configurable' &&
        model.selectedOptions.keys.toList().length !=
            model.productDetails.configurable.keys.toList().length) {
      flushBarService.showErrorMessage('required_options'.tr());
      return;
    }
    if (model.productDetails.typeId == 'configurable' &&
        (model?.selectedVariant?.stockQty == null ||
            model.selectedVariant.stockQty == 0)) {
      flushBarService.showErrorMessage('out_of_stock_error'.tr());
      return;
    }
    _addToCartController.repeat(reverse: true);
    Timer.periodic(Duration(milliseconds: 600), (timer) {
      _addToCartController.stop(canceled: true);
      timer.cancel();
    });
    await myCartChangeNotifier.addProductToCart(
        context, product, 1, lang, model.selectedOptions);
    AdjustEvent adjustEvent = new AdjustEvent(AdjustSDKConfig.addToCartToken);
    Adjust.trackEvent(adjustEvent);
  }

  void _onBuyNow(ProductChangeNotifier model) {
    if (model.productDetails.typeId == 'configurable' &&
        model.selectedOptions.keys.toList().length !=
            model.productDetails.configurable.keys.toList().length) {
      flushBarService.showErrorMessage('required_options'.tr());
      return;
    }
    if (model.productDetails.typeId == 'configurable' &&
        (model?.selectedVariant?.stockQty == null ||
            model.selectedVariant.stockQty == 0)) {
      flushBarService.showErrorMessage('out_of_stock_error'.tr());
      return;
    }
    myCartChangeNotifier.addProductToCart(
        context, product, 1, lang, model.selectedOptions);
    Navigator.pushNamed(context, Routes.myCart);
    AdjustEvent adjustEvent = new AdjustEvent(AdjustSDKConfig.addToCartToken);
    Adjust.trackEvent(adjustEvent);
  }

  void _onFirstReview(ProductEntity product) async {
    await Navigator.pushNamed(
      context,
      Routes.addProductReview,
      arguments: product,
    );
    setState(() {});
  }

  void _onReviews(ProductEntity product) async {
    await Navigator.pushNamed(
      context,
      Routes.productReviews,
      arguments: product,
    );
    setState(() {});
  }
}
