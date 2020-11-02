import 'package:ciga/src/components/product_v_card.dart';
import 'package:ciga/src/data/mock/mock.dart';
import 'package:ciga/src/data/models/category_entity.dart';
import 'package:ciga/src/data/models/product_model.dart';
import 'package:ciga/src/pages/product/bloc/product_bloc.dart';
import 'package:ciga/src/theme/styles.dart';
import 'package:ciga/src/theme/theme.dart';
import 'package:ciga/src/utils/progress_service.dart';
import 'package:ciga/src/utils/snackbar_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:isco_custom_widgets/isco_custom_widgets.dart';

class ProductListView extends StatefulWidget {
  final List<CategoryEntity> subCategories;
  final int activeIndex;
  final GlobalKey<ScaffoldState> scaffoldKey;
  final PageStyle pageStyle;
  final Function onChangeTab;

  ProductListView({
    this.subCategories,
    this.activeIndex,
    this.scaffoldKey,
    this.pageStyle,
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
  int activeIndex;
  PageStyle pageStyle;
  ProgressService progressService;
  SnackBarService snackBarService;
  TabController tabController;
  ProductBloc productBloc;

  @override
  void initState() {
    super.initState();
    subCategories = widget.subCategories;
    activeIndex = widget.activeIndex;
    scaffoldKey = widget.scaffoldKey;
    pageStyle = widget.pageStyle;
    progressService = ProgressService(context: context);
    snackBarService = SnackBarService(
      context: context,
      scaffoldKey: widget.scaffoldKey,
    );
    tabController = TabController(
      length: subCategories.length,
      initialIndex: activeIndex,
      vsync: this,
    );
    productBloc = context.bloc<ProductBloc>();
    productBloc.add(ProductListLoaded(
      categoryId: subCategories[activeIndex].id,
      lang: lang,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProductBloc, ProductState>(
      listener: (context, productState) {
        if (productState is ProductListLoadedInProcess) {
          progressService.showProgress();
        }
        if (productState is ProductListLoadedFailure) {
          progressService.hideProgress();
          snackBarService.showErrorSnackBar(productState.message);
        }
        if (productState is ProductListLoadedSuccess) {
          progressService.hideProgress();
        }
      },
      builder: (context, productState) {
        if (productState is ProductListLoadedSuccess) {
          products = productState.products;
          return Expanded(
            child: Column(
              children: [
                _buildCategoryTabBar(),
                Expanded(child: _buildCategoryTabView()),
              ],
            ),
          );
        } else {
          return Container();
        }
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
        (index) => _buildProductList(),
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
