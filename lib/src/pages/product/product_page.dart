import 'dart:async';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:markaa/src/change_notifier/product_change_notifier.dart';
import 'package:markaa/src/change_notifier/my_cart_change_notifier.dart';
import 'package:markaa/src/components/markaa_app_bar.dart';
import 'package:markaa/src/components/markaa_bottom_bar.dart';
import 'package:markaa/src/components/markaa_page_loading_kit.dart';
import 'package:markaa/src/components/markaa_side_menu.dart';
import 'package:markaa/src/components/markaa_text_button.dart';
import 'package:markaa/src/config/config.dart';
import 'package:markaa/src/data/mock/mock.dart';
import 'package:markaa/src/data/models/enum.dart';
import 'package:markaa/src/data/models/index.dart';
import 'package:markaa/src/data/models/product_model.dart';
import 'package:markaa/src/pages/home/bloc/home_bloc.dart';
import 'package:markaa/src/pages/my_cart/bloc/my_cart_repository.dart';
import 'package:markaa/src/pages/product/bloc/product_repository.dart';
import 'package:markaa/src/pages/product/widgets/product_more_about.dart';
import 'package:markaa/src/routes/routes.dart';
import 'package:markaa/src/theme/icons.dart';
import 'package:markaa/src/theme/theme.dart';
import 'package:markaa/src/utils/flushbar_service.dart';
import 'package:markaa/src/utils/local_storage_repository.dart';
import 'package:markaa/src/utils/progress_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:isco_custom_widgets/isco_custom_widgets.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'widgets/product_related_items.dart';
import 'widgets/product_same_brand_products.dart';
import 'widgets/product_single_product.dart';
import 'widgets/product_review.dart';
import 'widgets/product_review_total.dart';

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
  PageStyle pageStyle;
  ProductModel product;
  MyCartRepository cartRepo;
  ProgressService progressService;
  LocalStorageRepository localStorageRepository;
  ProductRepository productRepository;
  HomeBloc homeBloc;
  FlushBarService flushBarService;
  bool isBuyNow = false;
  bool isStock = false;
  AnimationController _addToCartController;
  Animation<double> _addToCartScaleAnimation;
  ProductChangeNotifier productChangeNotifier;
  MyCartChangeNotifier myCartChangeNotifier;

  @override
  void initState() {
    super.initState();
    product = widget.arguments as ProductModel;
    progressService = ProgressService(context: context);
    flushBarService = FlushBarService(context: context);
    productRepository = context.read<ProductRepository>();
    localStorageRepository = context.read<LocalStorageRepository>();
    homeBloc = context.read<HomeBloc>();
    productChangeNotifier = context.read<ProductChangeNotifier>();
    myCartChangeNotifier = context.read<MyCartChangeNotifier>();
    _loadDetails();
    _initAnimation();
    _sendViewedProduct();
  }

  void _loadDetails() async {
    await productChangeNotifier.getProductDetails(product.productId, lang);
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

  void _sendViewedProduct() async {
    if (user?.token != null) {
      await productRepository.setRecentlyViewedCustomerProduct(
          user.token, product.productId, lang);
      homeBloc.add(HomeRecentlyViewedCustomerLoaded(
        lang: lang,
        token: user.token,
      ));
    } else {
      await localStorageRepository.addRecentlyViewedItem(product.productId);
      List<String> ids = await localStorageRepository.getRecentlyViewedIds();
      homeBloc.add(HomeRecentlyViewedGuestLoaded(ids: ids, lang: lang));
    }
  }

  @override
  void dispose() {
    isBuyNow = false;
    _addToCartController.dispose();
    super.dispose();
  }

  void _onRefresh() async {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(Duration.zero, () async {
        await productChangeNotifier.getProductDetails(product.productId, lang);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    pageStyle = PageStyle(context, designWidth, designHeight);
    pageStyle.initializePageStyles();
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: backgroundColor,
      appBar: MarkaaAppBar(pageStyle: pageStyle, scaffoldKey: scaffoldKey),
      drawer: MarkaaSideMenu(pageStyle: pageStyle),
      body: Consumer<ProductChangeNotifier>(
        builder: (_, model, ___) {
          if (model.productDetails != null) {
            isStock = model.productDetails.stockQty != null &&
                model.productDetails.stockQty > 0;
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
                          pageStyle: pageStyle,
                          product: product,
                          productEntity: model.productDetails,
                        ),
                        ProductReviewTotal(
                          pageStyle: pageStyle,
                          product: model.productDetails,
                          onFirstReview: () =>
                              _onFirstReview(model.productDetails),
                          onReviews: () => _onReviews(model.productDetails),
                        ),
                        ProductRelatedItems(
                          pageStyle: pageStyle,
                          product: product,
                        ),
                        ProductSameBrandProducts(
                          pageStyle: pageStyle,
                          product: product,
                        ),
                        ProductMoreAbout(
                          pageStyle: pageStyle,
                          productEntity: model.productDetails,
                        ),
                        ProductReview(
                          pageStyle: pageStyle,
                          product: model.productDetails,
                        ),
                        SizedBox(height: pageStyle.unitHeight * 50),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: _buildToolbar(),
                ),
              ],
            );
          } else {
            return Center(child: PulseLoadingSpinner());
          }
        },
      ),
      bottomNavigationBar: MarkaaBottomBar(
        pageStyle: pageStyle,
        activeItem: BottomEnum.home,
      ),
    );
  }

  Widget _buildToolbar() {
    return Container(
      width: pageStyle.deviceWidth,
      height: pageStyle.unitHeight * 60,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (isStock) ...[
            Container(
              width: pageStyle.unitWidth * 317,
              height: pageStyle.unitHeight * 60,
              child: MarkaaTextButton(
                title: 'product_buy_now'.tr(),
                titleSize: pageStyle.unitFontSize * 23,
                titleColor: Colors.white,
                buttonColor: Color(0xFFFF8B00),
                borderColor: Colors.transparent,
                radius: 1,
                onPressed: () => _onBuyNow(),
                isBold: true,
              ),
            )
          ] else ...[
            Container(
              width: pageStyle.unitWidth * 317,
              height: pageStyle.unitHeight * 60,
            )
          ],
          if (isStock) ...[
            RoundImageButton(
              width: pageStyle.unitWidth * 58,
              height: pageStyle.unitHeight * 60,
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
  }

  void _onAddToCart() async {
    _addToCartController.repeat(reverse: true);
    Timer.periodic(Duration(milliseconds: 600), (timer) {
      _addToCartController.stop(canceled: true);
      timer.cancel();
    });
    await myCartChangeNotifier.addProductToCart(
        context, pageStyle, product, 1, lang);
  }

  void _onBuyNow() async {
    await myCartChangeNotifier.addProductToCart(
        context, pageStyle, product, 1, lang);
    Navigator.pushNamed(context, Routes.myCart);
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
