import 'package:markaa/src/change_notifier/filter_change_notifier.dart';
import 'package:markaa/src/change_notifier/markaa_app_change_notifier.dart';
import 'package:markaa/src/change_notifier/product_change_notifier.dart';
import 'package:markaa/src/change_notifier/scroll_chagne_notifier.dart';
import 'package:markaa/src/components/markaa_loading_widget.dart';
import 'package:markaa/src/components/product_v_card.dart';
import 'package:markaa/src/data/mock/mock.dart';
import 'package:markaa/src/data/models/index.dart';
import 'package:markaa/src/theme/styles.dart';
import 'package:markaa/src/theme/theme.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:markaa/src/utils/services/flushbar_service.dart';
import 'package:markaa/src/utils/services/progress_service.dart';
import 'package:provider/provider.dart';

import 'product_no_available.dart';

class ProductListView extends StatefulWidget {
  final List<CategoryEntity> subCategories;
  final int activeIndex;
  final GlobalKey<ScaffoldState> scaffoldKey;
  final bool isFromBrand;
  final bool isFilter;
  final BrandEntity? brand;
  final Function onChangeTab;
  final ScrollController scrollController;
  final ProductViewModeEnum viewMode;
  final String sortByItem;
  final Map<String, dynamic> filterValues;
  final double pos;

  ProductListView({
    required this.subCategories,
    required this.activeIndex,
    required this.scaffoldKey,
    required this.isFilter,
    required this.isFromBrand,
    required this.brand,
    required this.onChangeTab,
    required this.scrollController,
    required this.viewMode,
    required this.sortByItem,
    required this.filterValues,
    required this.pos,
  });

  @override
  _ProductListViewState createState() => _ProductListViewState();
}

class _ProductListViewState extends State<ProductListView> with TickerProviderStateMixin {
  late GlobalKey<ScaffoldState> scaffoldKey;
  late ProgressService progressService;
  late FlushBarService flushBarService;
  late ProductChangeNotifier productChangeNotifier;
  late ScrollChangeNotifier scrollChangeNotifier;
  late MarkaaAppChangeNotifier markaaAppChangeNotifier;
  late FilterChangeNotifier filterChangeNotifier;

  List<CategoryEntity>? subCategories;
  BrandEntity? brand;

  int page = 1;
  int currentProduct = 0;

  bool? isFromBrand;

  TabController? tabController;
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
    markaaAppChangeNotifier = context.read<MarkaaAppChangeNotifier>();
    filterChangeNotifier = context.read<FilterChangeNotifier>();

    tabController = TabController(
      length: subCategories!.length,
      initialIndex: widget.activeIndex,
      vsync: this,
    );
    tabController!.addListener(() => widget.onChangeTab(tabController!.index));
    scrollController.addListener(_onScroll);

    _initLoadProducts();
  }

  @override
  void dispose() {
    tabController!.dispose();
    scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    double maxScroll = scrollController.position.maxScrollExtent;
    double currentScroll = scrollController.position.pixels;

    scrollChangeNotifier.controlBrandBar(currentScroll);

    currentProduct = ((currentScroll ~/ 280.h).floor() * 2) + 4;
    markaaAppChangeNotifier.rebuild();

    if (!productChangeNotifier.isReachedMax && (maxScroll - currentScroll <= 200)) {
      _onLoadMore();
    }
  }

  String _generateKey([CategoryEntity? category]) {
    late String key;
    if (widget.viewMode == ProductViewModeEnum.category) {
      key = '${category?.id ?? 'all'}';
    } else if (widget.viewMode == ProductViewModeEnum.brand) {
      key = '${brand?.optionId ?? ''}_${category?.id ?? 'all'}';
    } else if (widget.viewMode == ProductViewModeEnum.sort) {
      key = '${widget.sortByItem}_${brand?.optionId ?? ''}_${category?.id ?? 'all'}';
    } else if (widget.viewMode == ProductViewModeEnum.filter) {
      key = 'filter_${brand?.optionId ?? ''}_${category?.id ?? 'all'}';
    }
    return key;
  }

  void _initLoadProducts() async {
    String key = _generateKey(subCategories![widget.activeIndex]);
    WidgetsBinding.instance!.addPostFrameCallback((_) async {
      if (widget.viewMode == ProductViewModeEnum.filter) {
        await productChangeNotifier.initialLoadFilteredProducts(
          key,
          brand?.optionId ?? '',
          subCategories?[widget.activeIndex].id ?? 'all',
          widget.filterValues,
          lang,
        );
      } else if (widget.viewMode == ProductViewModeEnum.category) {
        await productChangeNotifier.initialLoadCategoryProducts(
          key,
          subCategories![widget.activeIndex].id,
          lang,
        );
      } else if (widget.viewMode == ProductViewModeEnum.brand) {
        await productChangeNotifier.initialLoadBrandProducts(
          key,
          brand!.optionId,
          subCategories?[widget.activeIndex].id ?? '',
          lang,
        );
      }
      filterChangeNotifier.loadFilterAttributes(
        subCategories?[widget.activeIndex].id ?? 'all',
        brand?.optionId ?? '',
        lang,
      );
    });
  }

  Future<void> _onRefresh() async {
    String key = _generateKey(subCategories![tabController!.index]);
    if (widget.viewMode == ProductViewModeEnum.category) {
      await productChangeNotifier.refreshCategoryProducts(
        key,
        subCategories![tabController!.index].id,
        lang,
      );
    } else if (widget.viewMode == ProductViewModeEnum.brand) {
      await productChangeNotifier.refreshBrandProducts(
        key,
        brand!.optionId,
        subCategories?[tabController!.index].id ?? 'all',
        lang,
      );
    } else if (widget.viewMode == ProductViewModeEnum.sort) {
      await productChangeNotifier.refreshSortedProducts(
        key,
        brand?.optionId ?? '',
        subCategories?[tabController!.index].id ?? 'all',
        widget.sortByItem,
        lang,
      );
    } else if (widget.viewMode == ProductViewModeEnum.filter) {
      await productChangeNotifier.refreshFilteredProducts(
        key,
        brand?.optionId ?? '',
        subCategories?[tabController!.index].id ?? 'all',
        widget.filterValues,
        lang,
      );
    }
  }

  void _onLoadMore() async {
    String key = _generateKey(subCategories![tabController!.index]);
    page = productChangeNotifier.pages[key] ?? 1;
    page += 1;

    if (widget.viewMode == ProductViewModeEnum.category) {
      await productChangeNotifier.loadMoreCategoryProducts(
        key,
        page,
        subCategories![tabController!.index].id,
        lang,
      );
    } else if (widget.viewMode == ProductViewModeEnum.brand) {
      await productChangeNotifier.loadMoreBrandProducts(
        key,
        page,
        brand!.optionId,
        subCategories?[tabController!.index].id ?? 'all',
        lang,
      );
    } else if (widget.viewMode == ProductViewModeEnum.sort) {
      await productChangeNotifier.loadMoreSortedProducts(
        key,
        page,
        brand?.optionId ?? '',
        subCategories?[tabController!.index].id ?? 'all',
        widget.sortByItem,
        lang,
      );
    } else if (widget.viewMode == ProductViewModeEnum.filter) {
      await productChangeNotifier.loadMoreFilteredProducts(
        key,
        page,
        brand?.optionId ?? '',
        subCategories?[tabController!.index].id ?? 'all',
        widget.filterValues,
        lang,
      );
    }
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
    tabController!.index = widget.activeIndex;
    return Stack(
      children: [
        Column(
          children: [
            if (subCategories!.length > 1) ...[_buildCategoryTabBar()],
            Expanded(
              child: TabBarView(
                controller: tabController,
                children: subCategories!.map((cat) {
                  return Consumer<ProductChangeNotifier>(
                    builder: (ctx, notifier, _) {
                      String index = _generateKey(cat);
                      if (!productChangeNotifier.data!.containsKey(index) ||
                          productChangeNotifier.data![index] == null) {
                        return MarkaaLoadingWidget(child: ProductNoAvailable());
                      } else if (productChangeNotifier.data![index]!.isEmpty) {
                        return ProductNoAvailable();
                      } else {
                        return Column(
                          children: [
                            Expanded(
                              child: _buildPList(productChangeNotifier.data![index]!),
                            ),
                            if (productChangeNotifier.isLoading) ...[
                              LinearProgressIndicator(
                                backgroundColor: Colors.white,
                                color: primarySwatchColor.withOpacity(0.6),
                              )
                            ],
                          ],
                        );
                      }
                    },
                  );
                }).toList(),
              ),
            ),
          ],
        ),
        Consumer<MarkaaAppChangeNotifier>(
          builder: (ctx, notifier, _) {
            return _buildArrowButton();
          },
        )
      ],
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
          borderRadius: BorderRadius.circular(20),
        ),
        unselectedLabelColor: primaryColor,
        labelColor: Colors.white,
        isScrollable: true,
        tabs: List.generate(
          subCategories!.length,
          (index) {
            return Tab(
              child: Text(
                index == 0 ? 'all'.tr() : subCategories![index].name,
                style: mediumTextStyle.copyWith(
                  fontSize: 14.sp,
                  color: tabController!.index == index ? Colors.white : Colors.black,
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildPList(List<ProductModel> products) {
    return RefreshIndicator(
      onRefresh: _onRefresh,
      color: primaryColor,
      backgroundColor: Colors.white,
      child: ListView.builder(
        controller: scrollController,
        shrinkWrap: true,
        itemCount: (products.length / 2).ceil(),
        itemBuilder: (ctx, index) {
          int pIndex = 2 * index;
          return Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: greyColor, width: 0.5.w),
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
                    child: VerticalDivider(color: greyColor, width: 0.5.w),
                  ),
                  if (pIndex + 1 < products.length) ...[
                    Container(
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(color: greyColor, width: 0.5.w),
                        ),
                      ),
                      child: ProductVCard(
                        product: products[pIndex + 1],
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
              ),
              if (productChangeNotifier.isReachedMax && (pIndex + 2 >= products.length)) ...[
                Container(
                  width: 375.w,
                  alignment: Alignment.center,
                  padding: EdgeInsets.only(top: 20.h),
                  child: Text(
                    'no_more_products'.tr(),
                    style: mediumTextStyle.copyWith(
                      fontSize: 14.sp,
                    ),
                  ),
                )
              ],
            ],
          );
        },
      ),
    );
  }

  Widget _buildArrowButton() {
    String key = _generateKey(subCategories![tabController!.index]);
    return AnimatedPositioned(
      left: 120.w,
      right: 120.w,
      bottom: 5.h - widget.pos,
      duration: Duration(milliseconds: 500),
      child: InkWell(
        onTap: () => _onGotoTop(),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 5.w),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: primarySwatchColor.withOpacity(0.8),
            borderRadius: BorderRadius.circular(15.w),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.keyboard_arrow_up,
                size: 20.sp,
                color: Colors.white70,
              ),
              if (productChangeNotifier.totalProducts[key] != null) ...[
                Text(
                  '${int.parse(productChangeNotifier.totalProducts[key]) > currentProduct ? currentProduct : productChangeNotifier.totalProducts[key]} / ${productChangeNotifier.totalProducts[key] ?? ''}',
                  style: TextStyle(color: Colors.white70),
                )
              ],
            ],
          ),
        ),
      ),
    );
  }
}
