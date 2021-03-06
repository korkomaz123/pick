import 'dart:async';
import 'dart:io';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:markaa/src/change_notifier/home_change_notifier.dart';
import 'package:markaa/src/change_notifier/product_change_notifier.dart';
import 'package:markaa/src/components/markaa_bottom_bar.dart';
import 'package:markaa/src/components/markaa_simple_app_bar.dart';
import 'package:markaa/src/data/models/enum.dart';
import 'package:markaa/src/data/models/slider_image_entity.dart';
import 'package:markaa/src/theme/theme.dart';
import 'package:markaa/src/utils/services/dynamic_link_service.dart';
import 'package:markaa/src/utils/services/communicator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'widgets/home_advertise.dart';
import 'widgets/home_best_deals.dart';
import 'widgets/home_best_deals_banner.dart';
import 'widgets/home_best_watches.dart';
import 'widgets/home_celebrity.dart';
import 'widgets/home_discover_stores.dart';
import 'widgets/home_featured_categories.dart';
import 'widgets/home_fragrances_banners.dart';
import 'widgets/home_grooming.dart';
import 'widgets/home_header_carousel.dart';
import 'widgets/home_mega_banner.dart';
import 'widgets/home_new_arrivals.dart';
import 'widgets/home_new_arrivals_banner.dart';
import 'widgets/home_oriental_fragrances.dart';
import 'widgets/home_perfumes.dart';
import 'widgets/home_popup_dialog.dart';
import 'widgets/home_recent.dart';
import 'widgets/home_sale_brands.dart';
import 'widgets/home_shop_by_category.dart';
import 'widgets/home_smart_tech.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver, TickerProviderStateMixin {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final ScrollController _scrollController = ScrollController();
  final DynamicLinkService _dynamicLinkService = DynamicLinkService();

  late HomeChangeNotifier _homeProvider;
  late ProductChangeNotifier _productProvider;
  late Communicator _communicator;

  late AnimationController _animationController;
  late Animation _animation;

  Future _loadHomePage() async {
    _homeProvider.loadPopup(_onShowPopup);
    _homeProvider.getSideMenu();
    Future.wait([
      _homeProvider.loadSliderImages(),
      _homeProvider.getFeaturedCategoriesList(),
      _homeProvider.loadMegaBanner(),
      _homeProvider.loadBestDeals(),
      _homeProvider.loadFaceCare(),
      _homeProvider.getBrandsOnSale(),
      _homeProvider.loadNewArrivals(),
      _homeProvider.loadExculisiveBanner(),
      _homeProvider.loadOrientalProducts(),
      _homeProvider.loadNewArrivalsBanner(),
      _homeProvider.loadFragrancesBanner(),
      _homeProvider.loadPerfumes(),
      _homeProvider.loadBestWatches(),
      _homeProvider.gethomecelebrity(),
      _homeProvider.loadGrooming(),
      _homeProvider.loadAds(),
      _homeProvider.loadSmartTech(),
      _homeProvider.getCategoriesList(),
      _homeProvider.getBrandsList('home'),
      _homeProvider.getViewedProducts(),
    ]);
  }

  void _onShowPopup(SliderImageEntity popupItem) async {
    await showDialog(
      context: context,
      builder: (context) {
        return HomePopupDialog(item: popupItem);
      },
    );
  }

  @override
  void initState() {
    WidgetsBinding.instance!.addObserver(this);

    _productProvider = context.read<ProductChangeNotifier>();
    _homeProvider = context.read<HomeChangeNotifier>();
    _communicator = Communicator(context: context);
    _communicator.subscribeToChangeNotifiers();
    _dynamicLinkService.initialDynamicLink();
    _dynamicLinkService.retrieveDynamicLink();
    _productProvider.initialize();
    _loadHomePage();

    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
      reverseDuration: const Duration(milliseconds: 300),
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(_animationController);

    _scrollController.addListener(onScroll);
  }

  bool isStickyHeader = false;
  onScroll() {
    if (!isStickyHeader && _scrollController.position.pixels >= 90) {
      isStickyHeader = true;
      _animationController.forward();
    } else if (isStickyHeader && _scrollController.position.pixels < 90) {
      isStickyHeader = false;
      _animationController.reverse();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance!.removeObserver(this);
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        exit(0);
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: scaffoldBackgroundColor,
        body: Consumer<HomeChangeNotifier>(
          builder: (_, __, ___) {
            return RefreshIndicator(
              onRefresh: () => _loadHomePage(),
              color: primaryColor,
              child: Stack(
                children: [
                  SingleChildScrollView(
                    controller: _scrollController,
                    child: Column(
                      children: [
                        MarkaaSimpleAppBar(),
                        HomeHeaderCarousel(homeChangeNotifier: _homeProvider),
                        HomeFeaturedCategories(homeChangeNotifier: _homeProvider),
                        HomeMegaBanner(homeChangeNotifier: _homeProvider),
                        HomeShopByCategory(homeChangeNotifier: _homeProvider),
                        HomeSaleBrands(homeChangeNotifier: _homeProvider),
                        HomeBestDeals(homeChangeNotifier: _homeProvider),
                        HomeFragrancesBanners(homeChangeNotifier: _homeProvider),
                        HomePerfumes(homeChangeNotifier: _homeProvider),
                        HomeOrientalFragrances(homeChangeNotifier: _homeProvider),
                        HomeCelebrity(homeChangeNotifier: _homeProvider),
                        HomeGrooming(homeChangeNotifier: _homeProvider),
                        HomeBestDealsBanner(homeChangeNotifier: _homeProvider),
                        HomeNewArrivals(homeChangeNotifier: _homeProvider),
                        HomeNewArrivalsBanner(homeChangeNotifier: _homeProvider),
                        HomeBestWatches(homeChangeNotifier: _homeProvider),
                        HomeAdvertise(homeChangeNotifier: _homeProvider),
                        HomeSmartTech(homeChangeNotifier: _homeProvider),
                        HomeDiscoverStores(homeChangeNotifier: _homeProvider),
                        HomeRecent(homeChangeNotifier: _homeProvider),
                      ],
                    ),
                  ),
                  Align(
                    alignment: Alignment.topCenter,
                    child: SizedBox(
                      width: 375.w,
                      height: ScreenUtil().statusBarHeight + 50.h,
                      child: AnimatedBuilder(
                        animation: _animationController,
                        builder: (context, child) {
                          return Opacity(
                            opacity: _animation.value,
                            child: MarkaaStickySearchBar(),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
        bottomNavigationBar: MarkaaBottomBar(activeItem: BottomEnum.home),
      ),
    );
  }
}
