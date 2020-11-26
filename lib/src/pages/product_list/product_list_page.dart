import 'package:ciga/src/components/ciga_side_menu.dart';
import 'package:ciga/src/components/ciga_app_bar.dart';
import 'package:ciga/src/components/ciga_bottom_bar.dart';
import 'package:ciga/src/config/config.dart';
import 'package:ciga/src/data/mock/mock.dart';
import 'package:ciga/src/data/models/brand_entity.dart';
import 'package:ciga/src/data/models/enum.dart';
import 'package:ciga/src/data/models/index.dart';
import 'package:ciga/src/data/models/product_list_arguments.dart';
import 'package:ciga/src/data/models/product_model.dart';
import 'package:ciga/src/pages/category_list/bloc/category/category_bloc.dart';
import 'package:ciga/src/pages/filter/filter_page.dart';
import 'package:ciga/src/pages/product_list/widgets/product_sort_by_dialog.dart';
import 'package:ciga/src/theme/icons.dart';
import 'package:ciga/src/theme/styles.dart';
import 'package:ciga/src/theme/theme.dart';
import 'package:ciga/src/utils/progress_service.dart';
import 'package:ciga/src/utils/snackbar_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isco_custom_widgets/isco_custom_widgets.dart';
import 'package:sliding_sheet/sliding_sheet.dart';

import 'bloc/product_list_bloc.dart';
import 'widgets/product_list_view.dart';

class ProductListPage extends StatefulWidget {
  final ProductListArguments arguments;

  ProductListPage({this.arguments});

  @override
  _ProductListPageState createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  PageStyle pageStyle;
  ProductListArguments arguments;
  CategoryEntity category;
  List<CategoryEntity> subCategories;
  List<ProductModel> products;
  String sortByItem;
  BrandEntity brand;
  int activeSubcategoryIndex;
  bool isFromBrand;
  String selectedCategory;
  TabController tabController;
  CategoryBloc categoryBloc;
  ProductListBloc productListBloc;
  ProgressService progressService;
  SnackBarService snackBarService;

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
    selectedCategory = subCategories[activeSubcategoryIndex].name;

    productListBloc = context.bloc<ProductListBloc>();
    categoryBloc = context.bloc<CategoryBloc>();
    if (isFromBrand) {
      categoryBloc.add(BrandSubCategoriesLoaded(
        brandId: brand.optionId,
        lang: lang,
      ));
    } else {
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
  }

  @override
  void dispose() {
    productListBloc.add(ProductListInitialized());
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
      appBar: CigaAppBar(pageStyle: pageStyle, scaffoldKey: scaffoldKey),
      drawer: CigaSideMenu(pageStyle: pageStyle),
      body: Column(
        children: [
          _buildAppBar(),
          isFromBrand ? _buildBrandBar() : SizedBox.shrink(),
          BlocConsumer<CategoryBloc, CategoryState>(
            listener: (context, categoryState) {
              // if (categoryState is CategorySubCategoriesLoadedInProcess) {
              //   progressService.showProgress();
              // }
              // if (categoryState is CategorySubCategoriesLoadedSuccess) {
              //   progressService.hideProgress();
              // }
              // if (categoryState is CategorySubCategoriesLoadedFailure) {
              //   progressService.hideProgress();
              //   snackBarService.showErrorSnackBar(categoryState.message);
              // }
            },
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
                return ProductListView(
                  subCategories: subCategories,
                  activeIndex: widget.arguments.selectedSubCategoryIndex,
                  scaffoldKey: scaffoldKey,
                  pageStyle: pageStyle,
                  isFromBrand: isFromBrand,
                  brand: brand,
                  products: products,
                  onChangeTab: (index) => _onChangeTab(index),
                );
              } else {
                return Container();
              }
            },
          ),
        ],
      ),
      bottomNavigationBar: CigaBottomBar(
        pageStyle: pageStyle,
        activeItem: BottomEnum.category,
      ),
    );
  }

  Widget _buildAppBar() {
    return Container(
      width: pageStyle.deviceWidth,
      height: pageStyle.unitHeight * 60,
      color: primarySwatchColor,
      padding: EdgeInsets.symmetric(horizontal: pageStyle.unitWidth * 10),
      child: Stack(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: Icon(
                  Icons.arrow_back_ios,
                  color: Colors.white,
                  size: pageStyle.unitFontSize * 20,
                ),
                onPressed: () => Navigator.pop(context),
              ),
              isFromBrand
                  ? SizedBox.shrink()
                  : Row(
                      children: [
                        IconButton(
                          onPressed: () => _onSortBy(),
                          icon: Icon(
                            Icons.sort,
                            color: Colors.white,
                            size: pageStyle.unitFontSize * 25,
                          ),
                        ),
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
          Align(
            alignment: Alignment.center,
            child: Text(
              isFromBrand ? brand.brandLabel : category.name,
              style: boldTextStyle.copyWith(
                color: Colors.white,
                fontSize: pageStyle.unitFontSize * 17,
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildBrandBar() {
    return Container(
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
    );
  }

  void _showFilterDialog() async {
    final result = await showDialog(
      context: context,
      useSafeArea: false,
      builder: (context) {
        return FilterPage(categoryId: subCategories[activeSubcategoryIndex].id);
      },
    );
    if (result != null) {
      products = result as List<ProductModel>;
      setState(() {});
    }
  }

  void _onSortBy() async {
    print('///////////////////// // /// / // // ');
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
        sortByItem = result;
        productListBloc.add(ProductListSorted(
          categoryId: subCategories[activeSubcategoryIndex].id,
          lang: lang,
          sortItem: result,
        ));
      }
    }
  }

  void _onChangeTab(int index) {
    print('/// tab changed $index ///');

    activeSubcategoryIndex = index;
    if (isFromBrand) {
      productListBloc.add(BrandProductListLoaded(
        brandId: brand.optionId,
        categoryId: subCategories[index].id,
        lang: lang,
      ));
    } else {
      productListBloc.add(ProductListLoaded(
        categoryId: subCategories[index].id,
        lang: lang,
      ));
    }
  }
}
