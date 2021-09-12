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
  int _currentProduct = 0;
  @override
  void initState() {
    super.initState();
    scrollController.addListener(() {
      _currentProduct = ((scrollController.offset ~/ 280.h).floor() * 2) + 4;
      setState(() {});
    });
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
    double currentScroll = scrollController.position.pixels;
    scrollChangeNotifier.controlBrandBar(currentScroll);
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
        Consumer<ProductChangeNotifier>(builder: (ctx, notifier, _) {
          return _buildArrowButton();
        })
      ],
    );
  }

  Widget _buildArrowButton() {
    final key =
        '${brand.optionId != null ? brand.optionId : ''}-${subCategories[widget.activeIndex].id}';

    print('key key $key');
    return AnimatedPositioned(
      right: (MediaQuery.of(context).size.width - 70.w) / 2,
      bottom: 4.h - widget.pos,
      duration: Duration(milliseconds: 500),
      child: InkWell(
        onTap: () => _onGotoTop(),
        child: Container(
          // height: 40.h,
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.w),
          alignment: Alignment.center,
          decoration: BoxDecoration(
              color: primarySwatchColor.withOpacity(0.8),
              borderRadius: BorderRadius.circular(15.w)),
          child: Center(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.keyboard_arrow_up,
                  size: 20.sp,
                  color: Colors.white70,
                ),
                if (productChangeNotifier.totalProducts[key] != null)
                  Text(
                    '${int.parse(productChangeNotifier.totalProducts[key]) > _currentProduct ? _currentProduct : productChangeNotifier.totalProducts[key]} / ${productChangeNotifier.totalProducts[key] ?? ''}',
                    style: TextStyle(
                      color: Colors.white70,
                    ),
                  ),
              ],
            ),
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
                  color: tabController.index == index
                      ? Colors.white
                      : Colors.black,
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
      shouldFooterFollowWhenNotFull: (LoadStatus mode) {
        return mode == LoadStatus.noMore;
      },
      child: SmartRefresher(
        enablePullDown: true,
        enablePullUp: true,
        header: WaterDropHeader(),
        footer: CustomFooter(
          builder: (BuildContext context, LoadStatus mode) {
            Widget body = Container();
            if (mode == LoadStatus.loading) {
              body = CupertinoActivityIndicator();
            } else if (mode == LoadStatus.noMore ||
                productChangeNotifier.isReachedMax) {
              // body = Text("No more Data");
              body = Container(
                width: 375.w,
                alignment: Alignment.center,
                padding: EdgeInsets.only(top: 10.h),
                child: Text(
                  'no_more_products'.tr(),
                  style: mediumTextStyle.copyWith(
                    fontSize: 14.sp,
                  ),
                ),
              );
            }
            return Container(
              height: 40.h,
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
          controller: scrollController,
          shrinkWrap: true,
          itemCount: (products.length / 2).ceil(),
          itemBuilder: (ctx, index) {
            int pIndex = 2 * index;
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
                    product: products[pIndex],
                    cardWidth: 187.25.w,
                    cardHeight: 280.h,
                    isShoppingCart: true,
                    isWishlist: true,
                    isShare: true,
                  ),
                ),
                Container(
                  height: 280.h,
                  child: VerticalDivider(
                    color: greyColor,
                    width: 0.5.w,
                  ),
                ),
                if (pIndex + 1 < products.length) ...[
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
                ] else ...[
                  Container(width: 187.25.w, height: 280.h),
                ],
              ],
            );
          },
        ),
      ),
    );
  }
}
