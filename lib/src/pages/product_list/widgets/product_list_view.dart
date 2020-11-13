import 'package:ciga/src/components/product_v_card.dart';
import 'package:ciga/src/data/mock/mock.dart';
import 'package:ciga/src/data/models/brand_entity.dart';
import 'package:ciga/src/data/models/category_entity.dart';
import 'package:ciga/src/data/models/product_model.dart';
import 'package:ciga/src/pages/product_list/bloc/product_list_bloc.dart';
import 'package:ciga/src/theme/styles.dart';
import 'package:ciga/src/theme/theme.dart';
import 'package:ciga/src/utils/flushbar_service.dart';
import 'package:ciga/src/utils/progress_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:isco_custom_widgets/isco_custom_widgets.dart';

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

  ProductListView({
    this.subCategories,
    this.activeIndex,
    this.scaffoldKey,
    this.pageStyle,
    this.isFromBrand,
    this.brand,
    this.products,
    this.onChangeTab,
  });

  @override
  _ProductListViewState createState() => _ProductListViewState();
}

class _ProductListViewState extends State<ProductListView>
    with TickerProviderStateMixin {
  GlobalKey<ScaffoldState> scaffoldKey;
  List<CategoryEntity> subCategories;
  List<ProductModel> products;
  BrandEntity brand;
  int activeIndex;
  bool isFromBrand;
  PageStyle pageStyle;
  ProgressService progressService;
  FlushBarService flushBarService;
  TabController tabController;
  ProductListBloc productListBloc;

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
    tabController = TabController(
      length: subCategories.length,
      initialIndex: activeIndex,
      vsync: this,
    );
    tabController.addListener(() => widget.onChangeTab(tabController.index));
    productListBloc = context.bloc<ProductListBloc>();
    if (widget.products != null) {
      products = widget.products;
    } else {
      products = [];
      if (isFromBrand) {
        print('/// isFromBrand ///');
        productListBloc.add(BrandProductListLoaded(
          brandId: brand.optionId,
          categoryId: activeIndex == 0 ? 'all' : subCategories[activeIndex].id,
          lang: lang,
        ));
      } else {
        print('/// isFromCategory ///');
        productListBloc.add(ProductListLoaded(
          categoryId: subCategories[activeIndex].id,
          lang: lang,
        ));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProductListBloc, ProductListState>(
      listener: (context, productState) {
        if (productState is ProductListLoadedInProcess) {
          progressService.showProgress();
        }
        if (productState is ProductListLoadedFailure) {
          progressService.hideProgress();
          flushBarService.showErrorMessage(pageStyle, productState.message);
        }
        if (productState is ProductListLoadedSuccess) {
          progressService.hideProgress();
        }
      },
      builder: (context, productState) {
        if (productState is ProductListLoadedSuccess) {
          products = productState.products;
        }
        return Expanded(
          child: Column(
            children: [
              subCategories.length > 1
                  ? _buildCategoryTabBar()
                  : SizedBox.shrink(),
              Expanded(child: _buildCategoryTabView()),
            ],
          ),
        );
      },
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
        onTap: (index) => widget.onChangeTab(index),
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

  Widget _buildCategoryTabView() {
    return TabBarView(
      controller: tabController,
      children: List.generate(
        subCategories.length,
        (index) => products.isEmpty
            ? ProductNoAvailable(pageStyle: pageStyle)
            : _buildProductList(),
      ),
    );
  }

  Widget _buildProductList() {
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
