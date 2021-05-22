import 'package:markaa/src/change_notifier/product_change_notifier.dart';
import 'package:markaa/src/change_notifier/scroll_chagne_notifier.dart';
import 'package:markaa/src/components/markaa_page_loading_kit.dart';
import 'package:markaa/src/components/product_v_card.dart';
import 'package:markaa/src/data/mock/mock.dart';
import 'package:markaa/src/data/models/brand_entity.dart';
import 'package:markaa/src/data/models/category_entity.dart';
import 'package:markaa/src/data/models/index.dart';
import 'package:markaa/src/data/models/product_model.dart';
import 'package:markaa/src/pages/filter/bloc/filter_bloc.dart';
import 'package:markaa/src/theme/styles.dart';
import 'package:markaa/src/theme/theme.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:markaa/src/utils/services/flushbar_service.dart';
import 'package:markaa/src/utils/services/progress_service.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'product_no_available.dart';

class ProductListView extends StatefulWidget {
  final List<CategoryEntity> subCategories;
  final int activeIndex;
  final GlobalKey<ScaffoldState> scaffoldKey;
  final bool isFromBrand;
  final bool isFilter;
  final BrandEntity brand;
  final Function onChangeTab;
  final ScrollController scrollController;
  final ProductViewModeEnum viewMode;
  final String sortByItem;
  final Map<String, dynamic> filterValues;
  final double pos;

  ProductListView({
    this.subCategories,
    this.activeIndex,
    this.scaffoldKey,
    this.isFilter,
    this.isFromBrand,
    this.brand,
    this.onChangeTab,
    this.scrollController,
    this.viewMode,
    this.sortByItem,
    this.filterValues,
    this.pos,
  });

  @override
  _ProductListViewState createState() => _ProductListViewState();
}

class _ProductListViewState extends State<ProductListView>
    with TickerProviderStateMixin {
  GlobalKey<ScaffoldState> scaffoldKey;
  List<CategoryEntity> subCategories;
  BrandEntity brand;
  bool isFromBrand;
  ProgressService progressService;
  FlushBarService flushBarService;
  TabController tabController;
  int page = 1;
  ProductChangeNotifier productChangeNotifier;
  ScrollChangeNotifier scrollChangeNotifier;
  FilterBloc filterBloc;
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    subCategories = widget.subCategories;
    scaffoldKey = widget.scaffoldKey;
    isFromBrand = widget.isFromBrand;
    brand = widget.brand;
    progressService = ProgressService(context: context);
    flushBarService = FlushBarService(context: context);
    productChangeNotifier = context.read<ProductChangeNotifier>();
    scrollChangeNotifier = context.read<ScrollChangeNotifier>();
    filterBloc = context.read<FilterBloc>();
    _initLoadProducts();
    tabController = TabController(
      length: subCategories.length,
      initialIndex: widget.activeIndex,
      vsync: this,
    );
    tabController.addListener(() {
      widget.onChangeTab(tabController.index);
    });
    scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    // double maxScroll = scrollController.position.maxScrollExtent;
    // double currentScroll = scrollController.position.pixels;
    // scrollChangeNotifier.controlBrandBar(currentScroll);
    // if (!productChangeNotifier.isReachedMax && (maxScroll - currentScroll <= 200)) {
    //   _onLoadMore();
    // }
  }

  void _initLoadProducts() async {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (widget.viewMode == ProductViewModeEnum.filter) {
        await productChangeNotifier.initialLoadFilteredProducts(
          brand.optionId,
          subCategories[widget.activeIndex].id,
          widget.filterValues,
          lang,
        );
      } else if (widget.viewMode == ProductViewModeEnum.category) {
        await productChangeNotifier.initialLoadCategoryProducts(
          subCategories[widget.activeIndex].id,
          lang,
        );
      } else if (widget.viewMode == ProductViewModeEnum.brand) {
        await productChangeNotifier.initialLoadBrandProducts(
          brand.optionId,
          subCategories[widget.activeIndex].id,
          lang,
        );
      }
      filterBloc.add(FilterAttributesLoaded(
        categoryId: subCategories[widget.activeIndex].id == 'all'
            ? null
            : subCategories[widget.activeIndex].id,
        brandId: brand.optionId,
        lang: lang,
      ));
    });
  }

  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  bool isStillRefresh = false;
  Future<void> _onRefresh() async {
    if (isStillRefresh == true) return;
    isStillRefresh = true;
    if (widget.viewMode == ProductViewModeEnum.category) {
      await productChangeNotifier.refreshCategoryProducts(
        subCategories[tabController.index].id,
        lang,
      );
    } else if (widget.viewMode == ProductViewModeEnum.brand) {
      await productChangeNotifier.refreshBrandProducts(
        brand.optionId,
        subCategories[tabController.index].id,
        lang,
      );
    } else if (widget.viewMode == ProductViewModeEnum.sort) {
      await productChangeNotifier.refreshSortedProducts(
        brand.optionId ?? '',
        (subCategories[tabController.index].id ?? ''),
        widget.sortByItem,
        lang,
      );
    } else if (widget.viewMode == ProductViewModeEnum.filter) {
      await productChangeNotifier.refreshFilteredProducts(
        brand.optionId,
        subCategories[tabController.index].id,
        widget.filterValues,
        lang,
      );
    }
    isStillRefresh = false;
    _refreshController.refreshCompleted();
  }

  void _onLoadMore() async {
    if (isStillRefresh == true) return;
    isStillRefresh = true;
    if (widget.viewMode == ProductViewModeEnum.category) {
      page = productChangeNotifier.pages[subCategories[tabController.index].id];
      page += 1;
      await productChangeNotifier.loadMoreCategoryProducts(
        page,
        subCategories[tabController.index].id,
        lang,
      );
    } else if (widget.viewMode == ProductViewModeEnum.brand) {
      page = productChangeNotifier
          .pages[brand.optionId + '_' + subCategories[tabController.index].id];
      page += 1;
      await productChangeNotifier.loadMoreBrandProducts(
        page,
        brand.optionId ?? '',
        subCategories[tabController.index].id,
        lang,
      );
    } else if (widget.viewMode == ProductViewModeEnum.sort) {
      page = productChangeNotifier.pages[widget.sortByItem +
          '_' +
          (brand.optionId ?? '') +
          '_' +
          (subCategories[tabController.index].id ?? '')];
      page += 1;
      await productChangeNotifier.loadMoreSortedProducts(
        page,
        brand.optionId,
        subCategories[tabController.index].id,
        widget.sortByItem,
        lang,
      );
    } else if (widget.viewMode == ProductViewModeEnum.filter) {
      page = productChangeNotifier.pages['filter_' +
          (brand.optionId ?? '') +
          '_' +
          (subCategories[tabController.index].id ?? '')];
      page += 1;
      await productChangeNotifier.loadMoreFilteredProducts(
        page,
        brand.optionId,
        subCategories[tabController.index].id,
        widget.filterValues,
        lang,
      );
    }
    isStillRefresh = false;
    _refreshController.loadComplete();
  }

  void _onGotoTop() {
    scrollController.animateTo(
      0,
      duration: Duration(milliseconds: 500),
      curve: Curves.easeIn,
    );
  }

  @override
  Widget build(BuildContext context) {
    tabController.index = widget.activeIndex;
    return Stack(
      children: [
        Column(
          children: [
            subCategories.length > 1
                ? _buildCategoryTabBar()
                : SizedBox.shrink(),
            Expanded(
              child: TabBarView(
                controller: tabController,
                children: subCategories.map((cat) {
                  return Consumer<ProductChangeNotifier>(
                    builder: (ctx, notifier, _) {
                      String index;
                      if (widget.viewMode == ProductViewModeEnum.category) {
                        index = cat.id;
                      } else if (widget.viewMode == ProductViewModeEnum.brand) {
                        index = brand.optionId + '_' + cat.id;
                      } else if (widget.viewMode == ProductViewModeEnum.sort) {
                        index = widget.sortByItem +
                            '_' +
                            (brand.optionId ?? '') +
                            '_' +
                            (cat.id ?? '');
                      } else if (widget.viewMode ==
                          ProductViewModeEnum.filter) {
                        index = 'filter_' +
                            (brand.optionId ?? '') +
                            '_' +
                            (cat.id ?? 'all');
                      }
                      if (!productChangeNotifier.data.containsKey(index) ||
                          productChangeNotifier.data[index] == null) {
                        return //Container();
                            Center(child: PulseLoadingSpinner());
                      } else if (productChangeNotifier.data[index].isEmpty) {
                        return ProductNoAvailable();
                      } else {
                        return _buildProductList(
                            productChangeNotifier.data[index]);
                      }
                    },
                  );
                }).toList(),
              ),
            ),
          ],
        ),
        _buildArrowButton(),
      ],
    );
  }

  Widget _buildArrowButton() {
    return AnimatedPositioned(
      right: 4.w,
      bottom: 4.h - widget.pos,
      duration: Duration(milliseconds: 500),
      child: InkWell(
        onTap: () => _onGotoTop(),
        child: Container(
          width: 40.h,
          height: 40.h,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: primarySwatchColor.withOpacity(0.8),
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.keyboard_arrow_up,
            size: 30.sp,
            color: Colors.white70,
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryTabBar() {
    return Container(
      width: 375.w,
      height: 50.h,
      color: Colors.white,
      padding: EdgeInsets.symmetric(vertical: 10.h),
      child: TabBar(
        controller: tabController,
        indicator: BoxDecoration(
          color: primaryColor,
          borderRadius: BorderRadius.circular(30),
        ),
        unselectedLabelColor: greyDarkColor,
        labelColor: Colors.white,
        isScrollable: true,
        tabs: List.generate(
          subCategories.length,
          (index) {
            return Tab(
              child: Text(
                index == 0 ? 'all'.tr() : subCategories[index].name,
                style: mediumTextStyle.copyWith(
                  fontSize: 14.sp,
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildProductList(List<ProductModel> products) {
    return RefreshConfiguration(
      footerTriggerDistance: 2500,
      child: SmartRefresher(
        enablePullDown: true,
        enablePullUp: true,
        header: WaterDropHeader(),
        footer: CustomFooter(
          builder: (BuildContext context, LoadStatus mode) {
            Widget body;
            if (mode == LoadStatus.idle) {
              // body = Text("pull up load");
              body = Container();
            } else if (mode == LoadStatus.loading) {
              body = CupertinoActivityIndicator();
            } else if (mode == LoadStatus.failed) {
              // body = Text("Load Failed!Click retry!");
              body = Container();
            } else if (mode == LoadStatus.canLoading) {
              // body = Text("release to load more");
              body = Container();
            } else {
              // body = Text("No more Data");
              body = Container();
            }
            return Container(
              height: 55.0,
              child: Center(child: body),
            );
          },
        ),
        controller: _refreshController,
        onRefresh: _onRefresh,
        onLoading: () {
          print('onLoading');
          _onLoadMore();
        },
        child: ListView.builder(
          // controller: scrollController,
          shrinkWrap: true,
          itemCount: (products.length / 2).ceil() + 1,
          itemBuilder: (ctx, index) {
            if (index >= (products.length / 2).ceil()) {
              if (productChangeNotifier.isReachedMax) {
                return Container(
                  width: 375.w,
                  alignment: Alignment.center,
                  padding: EdgeInsets.only(
                    top: 10.h,
                  ),
                  child: Text(
                    'no_more_products'.tr(),
                    style: mediumTextStyle.copyWith(
                      fontSize: 14.sp,
                    ),
                  ),
                );
              } else {
                return Container(); //RippleLoadingSpinner();
              }
            } else {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: greyColor,
                          width: 0.5.w,
                        ),
                      ),
                    ),
                    child: ProductVCard(
                      product: products[2 * index],
                      cardWidth: 187.25.w,
                      cardHeight: 280.h,
                      isShoppingCart: true,
                      isWishlist: true,
                      isShare: true,
                    ),
                  ),
                  if (index * 2 <= products.length - 2) ...[
                    Container(
                      height: 280.h,
                      child: VerticalDivider(
                        color: greyColor,
                        width: 0.5.w,
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: greyColor,
                            width: 0.5.w,
                          ),
                        ),
                      ),
                      child: ProductVCard(
                        product: products[2 * index + 1],
                        cardWidth: 187.25.w,
                        cardHeight: 280.h,
                        isShoppingCart: true,
                        isWishlist: true,
                        isShare: true,
                      ),
                    ),
                  ]
                ],
              );
            }
          },
        ),
      ),
    );
  }
}
