import 'package:ciga/src/change_notifier/product_change_notifier.dart';
import 'package:ciga/src/components/product_v_card.dart';
import 'package:ciga/src/data/mock/mock.dart';
import 'package:ciga/src/data/models/brand_entity.dart';
import 'package:ciga/src/data/models/category_entity.dart';
import 'package:ciga/src/data/models/index.dart';
import 'package:ciga/src/data/models/product_model.dart';
import 'package:ciga/src/theme/styles.dart';
import 'package:ciga/src/theme/theme.dart';
import 'package:ciga/src/utils/flushbar_service.dart';
import 'package:ciga/src/utils/progress_service.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:isco_custom_widgets/isco_custom_widgets.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'product_no_available.dart';

class ProductListView extends StatefulWidget {
  final List<CategoryEntity> subCategories;
  final int activeIndex;
  final GlobalKey<ScaffoldState> scaffoldKey;
  final PageStyle pageStyle;
  final bool isFromBrand;
  final BrandEntity brand;
  final Function onChangeTab;
  final ScrollController scrollController;
  final ProductViewModeEnum viewMode;
  final String sortByItem;
  final Map<String, dynamic> filterValues;

  ProductListView({
    this.subCategories,
    this.activeIndex,
    this.scaffoldKey,
    this.pageStyle,
    this.isFromBrand,
    this.brand,
    this.onChangeTab,
    this.scrollController,
    this.viewMode,
    this.sortByItem,
    this.filterValues,
  });

  @override
  _ProductListViewState createState() => _ProductListViewState();
}

class _ProductListViewState extends State<ProductListView>
    with TickerProviderStateMixin {
  final _refreshController = RefreshController(initialRefresh: false);
  GlobalKey<ScaffoldState> scaffoldKey;
  List<CategoryEntity> subCategories;
  BrandEntity brand;
  int activeIndex;
  bool isFromBrand;
  PageStyle pageStyle;
  ProgressService progressService;
  FlushBarService flushBarService;
  TabController tabController;
  int page = 1;
  bool isReachedMax = false;
  ProductChangeNotifier productChangeNotifier;

  @override
  void initState() {
    super.initState();
    subCategories = widget.subCategories;
    activeIndex = widget.activeIndex;
    scaffoldKey = widget.scaffoldKey;
    pageStyle = widget.pageStyle;
    isFromBrand = widget.isFromBrand;
    brand = widget.brand;
    progressService = ProgressService(context: context);
    flushBarService = FlushBarService(context: context);
    productChangeNotifier = context.read<ProductChangeNotifier>();
    _initLoadProducts();
    tabController = TabController(
      length: subCategories.length,
      initialIndex: activeIndex,
      vsync: this,
    );
    tabController.addListener(() => widget.onChangeTab(tabController.index));
  }

  void _initLoadProducts() async {
    print('//// initial load ////');
    if (widget.viewMode == ProductViewModeEnum.category) {
      await productChangeNotifier.initialLoadCategoryProducts(
        subCategories[activeIndex].id,
      );
    } else if (widget.viewMode == ProductViewModeEnum.brand) {
      await productChangeNotifier.initialLoadBrandProducts(
        brand.optionId,
        subCategories[activeIndex].id,
      );
    }
    //  else if (widget.viewMode == ProductViewModeEnum.sort) {
    //   await productChangeNotifier.initialLoadSortedProducts(
    //     brand.optionId ?? '',
    //     subCategories[activeIndex].id,
    //     widget.sortByItem,
    //   );
    // } else if (widget.viewMode == ProductViewModeEnum.filter) {
    //   await productChangeNotifier.initialLoadFilteredProducts(
    //     brand.optionId,
    //     subCategories[tabController.index].id,
    //     widget.filterValues,
    //   );
    // }
  }

  void _onRefresh() async {
    print('///// refresh ////');
    if (widget.viewMode == ProductViewModeEnum.category) {
      await productChangeNotifier.refreshCategoryProducts(
        subCategories[tabController.index].id,
      );
    } else if (widget.viewMode == ProductViewModeEnum.brand) {
      await productChangeNotifier.refreshBrandProducts(
        brand.optionId,
        subCategories[tabController.index].id,
      );
    } else if (widget.viewMode == ProductViewModeEnum.sort) {
      await productChangeNotifier.refreshSortedProducts(
        brand.optionId ?? '',
        (subCategories[tabController.index].id ?? ''),
        widget.sortByItem,
      );
    } else if (widget.viewMode == ProductViewModeEnum.filter) {
      await productChangeNotifier.refreshFilteredProducts(
        brand.optionId,
        subCategories[tabController.index].id,
        widget.filterValues,
      );
    }
    _refreshController.refreshCompleted();
  }

  void _onLoadMore() async {
    print('///// load more ////');
    if (widget.viewMode == ProductViewModeEnum.category) {
      page = productChangeNotifier.pages[subCategories[tabController.index].id];
      page += 1;
      await productChangeNotifier.loadMoreCategoryProducts(
        page,
        subCategories[tabController.index].id,
      );
    } else if (widget.viewMode == ProductViewModeEnum.brand) {
      page = productChangeNotifier
          .pages[brand.optionId + '_' + subCategories[tabController.index].id];
      page += 1;
      await productChangeNotifier.loadMoreBrandProducts(
        page,
        brand.optionId ?? '',
        subCategories[tabController.index].id,
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
      );
    }
    _refreshController.loadComplete();
  }

  @override
  Widget build(BuildContext context) {
    print('/////////// build ////////////');
    return Column(
      children: [
        subCategories.length > 1 ? _buildCategoryTabBar() : SizedBox.shrink(),
        Expanded(
          child: TabBarView(
            controller: tabController,
            children: subCategories.map((cat) {
              return SmartRefresher(
                enablePullDown: true,
                enablePullUp: page != null && !isReachedMax,
                header: MaterialClassicHeader(color: primaryColor),
                controller: _refreshController,
                scrollController: widget.scrollController,
                onRefresh: _onRefresh,
                onLoading: page != null && !isReachedMax ? _onLoadMore : null,
                footer: CustomFooter(
                  builder: (BuildContext context, LoadStatus mode) {
                    return SizedBox.shrink();
                  },
                ),
                child: Consumer<ProductChangeNotifier>(
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
                    } else if (widget.viewMode == ProductViewModeEnum.filter) {
                      index = 'filter_' +
                          (brand.optionId ?? '') +
                          '_' +
                          (cat.id ?? '');
                    }
                    print('reload');
                    print(index);

                    if (!productChangeNotifier.data.containsKey(index) ||
                        productChangeNotifier.data[index] == null) {
                      return Container();
                    } else if (productChangeNotifier.data[index].isEmpty) {
                      return ProductNoAvailable(pageStyle: pageStyle);
                    } else {
                      return _buildProductList(
                          productChangeNotifier.data[index]);
                    }
                  },
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryTabBar() {
    return Container(
      width: pageStyle.deviceWidth,
      height: pageStyle.unitHeight * 50,
      color: Colors.white,
      padding: EdgeInsets.symmetric(vertical: pageStyle.unitHeight * 10),
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
                  fontSize: pageStyle.unitFontSize * 14,
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildProductList(List<ProductModel> products) {
    return SingleChildScrollView(
      child: Wrap(
        alignment: WrapAlignment.spaceBetween,
        children: List.generate(
          products.length,
          (index) {
            return Container(
              decoration: BoxDecoration(
                border: Border(
                  right: lang == 'en' && index % 2 == 0
                      ? BorderSide(
                          color: greyColor,
                          width: pageStyle.unitWidth * 0.5,
                        )
                      : BorderSide.none,
                  left: lang == 'ar' && index % 2 == 0
                      ? BorderSide(
                          color: greyColor,
                          width: pageStyle.unitWidth * 0.5,
                        )
                      : BorderSide.none,
                  bottom: BorderSide(
                    color: greyColor,
                    width: pageStyle.unitWidth * 0.5,
                  ),
                ),
              ),
              child: ProductVCard(
                pageStyle: pageStyle,
                product: products[index],
                cardWidth: pageStyle.unitWidth * 186,
                cardHeight: pageStyle.unitHeight * 253,
                isShoppingCart: true,
                isWishlist: true,
                isShare: true,
              ),
            );
          },
        ),
      ),
    );
  }
}
