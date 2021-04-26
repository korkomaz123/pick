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
import 'package:isco_custom_widgets/isco_custom_widgets.dart';
import 'package:markaa/src/utils/services/flushbar_service.dart';
import 'package:markaa/src/utils/services/progress_service.dart';
import 'package:provider/provider.dart';

import 'product_no_available.dart';

class ProductListView extends StatefulWidget {
  final List<CategoryEntity> subCategories;
  final int activeIndex;
  final GlobalKey<ScaffoldState> scaffoldKey;
  final PageStyle pageStyle;
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
    this.pageStyle,
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
  PageStyle pageStyle;
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
    pageStyle = widget.pageStyle;
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
    double maxScroll = scrollController.position.maxScrollExtent;
    double currentScroll = scrollController.position.pixels;
    scrollChangeNotifier.controlBrandBar(currentScroll);
    if (!productChangeNotifier.isReachedMax &&
        (maxScroll - currentScroll <= 200)) {
      _onLoadMore();
    }
  }

  void _initLoadProducts() async {
    print('//// initial load ////');
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

  Future<void> _onRefresh() async {
    print('///// refresh ////');
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
  }

  void _onLoadMore() async {
    print('///// load more ////');
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
                        return Center(child: PulseLoadingSpinner());
                      } else if (productChangeNotifier.data[index].isEmpty) {
                        return ProductNoAvailable(pageStyle: pageStyle);
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
      right: pageStyle.unitWidth * 4,
      bottom: pageStyle.unitHeight * 4 - widget.pos,
      duration: Duration(milliseconds: 500),
      child: InkWell(
        onTap: () => _onGotoTop(),
        child: Container(
          width: pageStyle.unitHeight * 40,
          height: pageStyle.unitHeight * 40,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: primarySwatchColor.withOpacity(0.8),
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.keyboard_arrow_up,
            size: pageStyle.unitFontSize * 30,
            color: Colors.white70,
          ),
        ),
      ),
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
    return RefreshIndicator(
      onRefresh: _onRefresh,
      backgroundColor: Colors.white,
      color: primaryColor,
      child: ListView.builder(
        controller: scrollController,
        shrinkWrap: true,
        itemCount: (products.length / 2).ceil() + 1,
        itemBuilder: (ctx, index) {
          if (index >= (products.length / 2).ceil()) {
            if (productChangeNotifier.isReachedMax) {
              return Container(
                width: pageStyle.deviceWidth,
                alignment: Alignment.center,
                padding: EdgeInsets.only(
                  top: pageStyle.unitHeight * 10,
                ),
                child: Text(
                  'no_more_products'.tr(),
                  style: mediumTextStyle.copyWith(
                    fontSize: pageStyle.unitFontSize * 14,
                  ),
                ),
              );
            } else {
              return RippleLoadingSpinner();
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
                        width: pageStyle.unitWidth * 0.5,
                      ),
                    ),
                  ),
                  child: ProductVCard(
                    pageStyle: pageStyle,
                    product: products[2 * index],
                    cardWidth: pageStyle.unitWidth * 187.25,
                    cardHeight: pageStyle.unitHeight * 280,
                    isShoppingCart: true,
                    isWishlist: true,
                    isShare: true,
                  ),
                ),
                if (index * 2 <= products.length - 2) ...[
                  Container(
                    height: pageStyle.unitHeight * 280,
                    child: VerticalDivider(
                      color: greyColor,
                      width: pageStyle.unitWidth * 0.5,
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: greyColor,
                          width: pageStyle.unitWidth * 0.5,
                        ),
                      ),
                    ),
                    child: ProductVCard(
                      pageStyle: pageStyle,
                      product: products[2 * index + 1],
                      cardWidth: pageStyle.unitWidth * 187.25,
                      cardHeight: pageStyle.unitHeight * 280,
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
    );
  }
}
