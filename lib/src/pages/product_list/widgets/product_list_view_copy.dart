import 'package:ciga/src/components/product_v_card.dart';
import 'package:ciga/src/data/mock/mock.dart';
import 'package:ciga/src/data/models/brand_entity.dart';
import 'package:ciga/src/data/models/category_entity.dart';
import 'package:ciga/src/data/models/product_model.dart';
import 'package:ciga/src/pages/filter/bloc/filter_bloc.dart';
import 'package:ciga/src/pages/product_list/bloc/product_list_bloc.dart';
import 'package:ciga/src/theme/styles.dart';
import 'package:ciga/src/theme/theme.dart';
import 'package:ciga/src/utils/flushbar_service.dart';
import 'package:ciga/src/utils/progress_service.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isco_custom_widgets/isco_custom_widgets.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'product_no_available.dart';

class ProductListView extends StatefulWidget {
  final List<CategoryEntity> subCategories;
  final int activeIndex;
  final GlobalKey<ScaffoldState> scaffoldKey;
  final PageStyle pageStyle;
  final bool isFromBrand;
  final BrandEntity brand;
  final List<ProductModel> products;
  final Function onChangeTab;
  final ScrollController scrollController;

  ProductListView({
    this.subCategories,
    this.activeIndex,
    this.scaffoldKey,
    this.pageStyle,
    this.isFromBrand,
    this.brand,
    this.products,
    this.onChangeTab,
    this.scrollController,
  });

  @override
  _ProductListViewState createState() => _ProductListViewState();
}

class _ProductListViewState extends State<ProductListView>
    with TickerProviderStateMixin {
  final _refreshController = RefreshController(initialRefresh: false);
  GlobalKey<ScaffoldState> scaffoldKey;
  List<CategoryEntity> subCategories;
  Map<String, List<ProductModel>> productsMap = {};
  BrandEntity brand;
  int activeIndex;
  bool isFromBrand;
  PageStyle pageStyle;
  ProgressService progressService;
  FlushBarService flushBarService;
  TabController tabController;
  ProductListBloc productListBloc;
  FilterBloc filterBloc;
  int page = 1;
  bool isReachedMax = false;

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
    productListBloc = context.read<ProductListBloc>();
    filterBloc = context.read<FilterBloc>();
    tabController = TabController(
      length: subCategories.length,
      initialIndex: activeIndex,
      vsync: this,
    );
    tabController.addListener(() => widget.onChangeTab(tabController.index));
    _loadInitialProducts();
  }

  void _loadInitialProducts() {
    for (int i = 0; i < widget.subCategories.length; i++) {
      productsMap[widget.subCategories[i].id] = [];
    }
    if (widget.products != null) {
      productsMap[widget.subCategories[widget.activeIndex].id] =
          widget.products;
    } else {
      productsMap[widget.subCategories[widget.activeIndex].id] = [];
      if (isFromBrand) {
        productListBloc.add(BrandProductListLoaded(
          brandId: brand.optionId,
          categoryId: subCategories[activeIndex].id,
          lang: lang,
          page: 1,
        ));
      } else {
        productListBloc.add(ProductListLoaded(
          categoryId: subCategories[activeIndex].id,
          lang: lang,
          page: 1,
        ));
      }
    }
  }

  void _onRefresh() async {
    filterBloc.add(FilterInitialized());
    page = 1;
    if (isFromBrand) {
      productListBloc.add(BrandProductListLoaded(
        brandId: brand.optionId,
        categoryId: tabController.index == 0
            ? 'all'
            : subCategories[tabController.index].id,
        lang: lang,
        page: page,
      ));
    } else {
      productListBloc.add(ProductListLoaded(
        categoryId: subCategories[tabController.index].id,
        lang: lang,
        page: page,
      ));
    }
    _refreshController.refreshCompleted();
  }

  void _onLoadMore() async {
    filterBloc.add(FilterInitialized());
    page += 1;
    if (isFromBrand) {
      productListBloc.add(BrandProductListLoaded(
        brandId: brand.optionId,
        categoryId: tabController.index == 0
            ? 'all'
            : subCategories[tabController.index].id,
        lang: lang,
        page: page,
      ));
    } else {
      productListBloc.add(ProductListLoaded(
        categoryId: subCategories[tabController.index].id,
        lang: lang,
        page: page,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        subCategories.length > 1 ? _buildCategoryTabBar() : SizedBox.shrink(),
        Expanded(
          child: TabBarView(
            controller: tabController,
            children: List.generate(
              subCategories.length,
              (index) {
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
                  child: BlocConsumer<ProductListBloc, ProductListState>(
                    listener: (context, productState) {},
                    builder: (context, productState) {
                      if (productState is ProductListLoadedSuccess) {
                        if (productState.page == 1 ||
                            productState.page == null) {
                          productsMap[productState.categoryId] =
                              productState.products;
                        } else if (productState.page > 1) {
                          for (int i = 0;
                              i < productState.products.length;
                              i++) {
                            productsMap[productState.categoryId]
                                .add(productState.products[i]);
                          }
                        }
                        page = productState.page;
                        isReachedMax = productState.isReachedMax;
                        if (isReachedMax) {
                          _refreshController.loadNoData();
                        } else {
                          _refreshController.loadComplete();
                        }
                      }
                      return _buildCategoryTabView(index, productState);
                    },
                  ),
                );
              },
            ),
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
        // onTap: (index) => widget.onChangeTab(index),
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

  Widget _buildCategoryTabView(int index, ProductListState productState) {
    return BlocConsumer<FilterBloc, FilterState>(
      listener: (context, state) {
        if (state is FilteredInProcess) {
          progressService.showProgress();
        }
        if (state is FilteredSuccess) {
          progressService.hideProgress();
        }
        if (state is FilteredFailure) {
          progressService.hideProgress();
          flushBarService.showErrorMessage(pageStyle, state.message);
        }
      },
      builder: (context, state) {
        if (state is FilteredSuccess) {
          productsMap[subCategories[tabController.index].id] = state.products;
          return productsMap[subCategories[index].id].isEmpty
              ? tabController.index == index
                  ? ProductNoAvailable(pageStyle: pageStyle)
                  : SizedBox.shrink()
              : _buildProductList(index);
        }
        return productsMap[subCategories[index].id].isEmpty
            ? tabController.index == index &&
                    productState is ProductListLoadedSuccess
                ? ProductNoAvailable(pageStyle: pageStyle)
                : SizedBox.shrink()
            : _buildProductList(index);
      },
    );
  }

  Widget _buildProductList(int index) {
    List<ProductModel> products = productsMap[subCategories[index].id];
    return Wrap(
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
    );
  }
}