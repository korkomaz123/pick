import 'package:ciga/src/change_notifier/product_change_notifier.dart';
import 'package:ciga/src/change_notifier/scroll_chagne_notifier.dart';
import 'package:ciga/src/components/ciga_app_bar.dart';
import 'package:ciga/src/components/ciga_bottom_bar.dart';
import 'package:ciga/src/components/ciga_side_menu.dart';
import 'package:ciga/src/config/config.dart';
import 'package:ciga/src/data/mock/mock.dart';
import 'package:ciga/src/data/models/brand_entity.dart';
import 'package:ciga/src/data/models/enum.dart';
import 'package:ciga/src/data/models/index.dart';
import 'package:ciga/src/data/models/product_list_arguments.dart';
import 'package:ciga/src/pages/category_list/bloc/category/category_bloc.dart';
import 'package:ciga/src/pages/filter/filter_page.dart';
// import 'package:ciga/src/pages/filter/filter_page.dart';
import 'package:ciga/src/pages/product_list/widgets/product_sort_by_dialog.dart';
import 'package:ciga/src/theme/icons.dart';
// import 'package:ciga/src/theme/icons.dart';
import 'package:ciga/src/theme/styles.dart';
import 'package:ciga/src/theme/theme.dart';
import 'package:ciga/src/utils/progress_service.dart';
import 'package:ciga/src/utils/snackbar_service.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
// import 'package:flutter_svg/flutter_svg.dart';
import 'package:isco_custom_widgets/isco_custom_widgets.dart';
import 'package:provider/provider.dart';
import 'package:sliding_sheet/sliding_sheet.dart';

import 'widgets/product_list_view.dart';

class ProductListPage extends StatefulWidget {
  final ProductListArguments arguments;

  ProductListPage({this.arguments});

  @override
  _ProductListPageState createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  ScrollController scrollController = ScrollController();
  TabController tabController;
  PageStyle pageStyle;
  ProductListArguments arguments;
  CategoryEntity category;
  List<CategoryEntity> subCategories;
  String sortByItem;
  BrandEntity brand;
  int activeSubcategoryIndex;
  bool isFromBrand;
  CategoryBloc categoryBloc;
  ProgressService progressService;
  SnackBarService snackBarService;
  double scrollPosition = 0;
  ScrollChangeNotifier scrollChangeNotifier;
  ProductChangeNotifier productChangeNotifier;
  ProductViewModeEnum viewMode;
  Map<String, dynamic> filterValues = {};

  @override
  void initState() {
    super.initState();
    sortByItem = '';
    arguments = widget.arguments;
    category = arguments.category;
    brand = arguments.brand;
    activeSubcategoryIndex = arguments.selectedSubCategoryIndex;
    isFromBrand = arguments.isFromBrand;
    subCategories = [category];
    categoryBloc = context.read<CategoryBloc>();
    scrollChangeNotifier = context.read<ScrollChangeNotifier>();
    productChangeNotifier = context.read<ProductChangeNotifier>();
    if (isFromBrand) {
      viewMode = ProductViewModeEnum.brand;
      categoryBloc.add(BrandSubCategoriesLoaded(
        brandId: brand.optionId,
        lang: lang,
      ));
    } else {
      viewMode = ProductViewModeEnum.category;
      categoryBloc.add(CategorySubCategoriesLoaded(
        categoryId: category.id,
        lang: lang,
      ));
    }
    progressService = ProgressService(context: context);
    snackBarService = SnackBarService(
      context: context,
      scaffoldKey: scaffoldKey,
    );
    scrollController.addListener(_onScrolling);
  }

  @override
  void dispose() {
    categoryBloc.add(CategoryInitialized());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    pageStyle = PageStyle(context, designWidth, designHeight);
    pageStyle.initializePageStyles();
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.white,
      appBar: CigaAppBar(
        pageStyle: pageStyle,
        scaffoldKey: scaffoldKey,
        isCenter: false,
      ),
      drawer: CigaSideMenu(pageStyle: pageStyle),
      body: Stack(
        children: [
          isFromBrand
              ? _buildBrandBar()
              : Positioned(
                  top: 0,
                  left: 0,
                  right: pageStyle.deviceWidth,
                  child: Container(),
                ),
          BlocConsumer<CategoryBloc, CategoryState>(
            listener: (context, categoryState) {},
            builder: (context, categoryState) {
              if (categoryState is CategorySubCategoriesLoadedSuccess) {
                if (isFromBrand) {
                  subCategories = [CategoryEntity(id: 'all')];
                } else {
                  subCategories = [category];
                }
                for (int i = 0; i < categoryState.subCategories.length; i++) {
                  subCategories.add(categoryState.subCategories[i]);
                }
                return Consumer<ScrollChangeNotifier>(
                  builder: (ctx, scrollNotifier, child) {
                    double extra = scrollChangeNotifier.showBrandBar ? 0 : 75;
                    return AnimatedPositioned(
                      top: isFromBrand
                          ? pageStyle.unitHeight * 120 - extra
                          : pageStyle.unitHeight * 45,
                      left: 0,
                      right: 0,
                      bottom: 0,
                      duration: Duration(milliseconds: 500),
                      child: ProductListView(
                        subCategories: subCategories,
                        activeIndex: activeSubcategoryIndex,
                        scaffoldKey: scaffoldKey,
                        pageStyle: pageStyle,
                        isFromBrand: isFromBrand,
                        brand: brand,
                        onChangeTab: (index) => _onChangeTab(index),
                        scrollController: scrollController,
                        viewMode: viewMode,
                        sortByItem: sortByItem,
                        filterValues: filterValues,
                      ),
                    );
                  },
                );
              } else {
                return Container();
              }
            },
          ),
          _buildAppBar(),
        ],
      ),
      bottomNavigationBar: CigaBottomBar(
        pageStyle: pageStyle,
        activeItem: isFromBrand ? BottomEnum.store : BottomEnum.category,
      ),
    );
  }

  Widget _buildAppBar() {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: Container(
        width: pageStyle.deviceWidth,
        height: pageStyle.unitHeight * 40,
        color: primarySwatchColor,
        alignment: Alignment.center,
        padding: EdgeInsets.only(
          left: pageStyle.unitWidth * 10,
          right: pageStyle.unitWidth * 10,
          bottom: pageStyle.unitHeight * 10,
        ),
        child: Stack(
          alignment: AlignmentDirectional.center,
          children: [
            Align(
              alignment: Alignment.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    child: Icon(
                      Icons.arrow_back_ios,
                      color: Colors.white,
                      size: pageStyle.unitFontSize * 20,
                    ),
                    onTap: () => Navigator.pop(context),
                  ),
                  Row(
                    children: [
                      InkWell(
                        onTap: () => _onSortBy(),
                        child: Icon(
                          Icons.sort,
                          color: Colors.white,
                          size: pageStyle.unitFontSize * 25,
                        ),
                      ),
                      SizedBox(width: pageStyle.unitWidth * 10),
                      InkWell(
                        onTap: () => _showFilterDialog(),
                        child: Container(
                          width: pageStyle.unitWidth * 20,
                          height: pageStyle.unitHeight * 17,
                          child: SvgPicture.asset(filterIcon),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: Text(
                isFromBrand
                    ? brand.brandLabel
                    : ['41', '42', '43'].contains(category.id)
                        ? category.name.tr()
                        : category.name,
                style: mediumTextStyle.copyWith(
                  color: Colors.white,
                  fontSize: pageStyle.unitFontSize * 17,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildBrandBar() {
    return Consumer<ScrollChangeNotifier>(
      builder: (ctx, notifier, child) {
        double extra = scrollChangeNotifier.showBrandBar ? 0 : 40;
        return AnimatedPositioned(
          top: pageStyle.unitHeight * 40 - extra,
          left: 0,
          right: 0,
          duration: Duration(milliseconds: 500),
          child: Container(
            width: pageStyle.deviceWidth,
            height: pageStyle.unitHeight * 80,
            margin: EdgeInsets.only(bottom: pageStyle.unitHeight * 8),
            alignment: Alignment.center,
            color: Colors.white,
            child: Image.network(
              brand.brandThumbnail,
              width: pageStyle.unitWidth * 120,
              height: pageStyle.unitHeight * 60,
              fit: BoxFit.cover,
            ),
          ),
        );
      },
    );
  }

  void _showFilterDialog() async {
    final result = await showDialog(
      context: context,
      useSafeArea: false,
      builder: (context) {
        return FilterPage(
          categoryId: subCategories[activeSubcategoryIndex].id,
          brandId: brand.optionId,
          minPrice: filterValues.containsKey('minPrice')
              ? filterValues['minPrice']
              : null,
          maxPrice: filterValues.containsKey('maxPrice')
              ? filterValues['maxPrice']
              : null,
          selectedCategories: filterValues.containsKey('selectedCategories')
              ? filterValues['selectedCategories']
              : [],
          selectedGenders: filterValues.containsKey('selectedGenders')
              ? filterValues['selectedGenders']
              : [],
          selectedValues: filterValues.containsKey('selectedValues')
              ? filterValues['selectedValues']
              : {},
        );
      },
    );
    if (result != null) {
      filterValues = result;
      viewMode = ProductViewModeEnum.filter;
      if (filterValues['selectedCategories'].isNotEmpty) {
        activeSubcategoryIndex = 0;
      }
      setState(() {});
      await productChangeNotifier.initialLoadFilteredProducts(
        brand.optionId,
        subCategories[activeSubcategoryIndex].id,
        filterValues,
      );
    }
  }

  void _onSortBy() async {
    final result = await showSlidingBottomSheet(context, builder: (context) {
      return SlidingSheetDialog(
        elevation: 8,
        cornerRadius: 10,
        snapSpec: SnapSpec(
          snap: true,
          snappings: [0.8],
          positioning: SnapPositioning.relativeToAvailableSpace,
        ),
        duration: Duration(milliseconds: 300),
        builder: (context, state) {
          return ProductSortByDialog(pageStyle: pageStyle);
        },
      );
    });
    if (result != null) {
      if (sortByItem != result) {
        if (sortByItem == 'default') {
          if (isFromBrand) {
            viewMode = ProductViewModeEnum.brand;
          } else {
            viewMode = ProductViewModeEnum.category;
          }
        } else {
          viewMode = ProductViewModeEnum.sort;
        }
        sortByItem = result;
        setState(() {});
        await productChangeNotifier.initialLoadSortedProducts(
          brand.optionId ?? '',
          subCategories[0].id,
          sortByItem,
        );
      }
    }
  }

  void _onChangeTab(int index) async {
    print('//// change tab ///');
    activeSubcategoryIndex = index;
    if (viewMode == ProductViewModeEnum.category) {
      await productChangeNotifier.initialLoadCategoryProducts(
        subCategories[index].id,
      );
    } else if (viewMode == ProductViewModeEnum.brand) {
      await productChangeNotifier.initialLoadBrandProducts(
        brand.optionId,
        subCategories[index].id,
      );
    }
  }

  void _onScrolling() {
    if (isFromBrand) {
      double pos = scrollController.position.pixels;
      scrollChangeNotifier.controlBrandBar(pos);
    }
  }
}
