import 'package:cached_network_image/cached_network_image.dart';
import 'package:markaa/src/change_notifier/product_change_notifier.dart';
import 'package:markaa/src/change_notifier/scroll_chagne_notifier.dart';
import 'package:markaa/src/change_notifier/category_change_notifier.dart';
import 'package:markaa/src/components/markaa_app_bar.dart';
import 'package:markaa/src/components/markaa_bottom_bar.dart';
import 'package:markaa/src/components/markaa_side_menu.dart';
import 'package:markaa/src/data/mock/mock.dart';
import 'package:markaa/src/data/models/brand_entity.dart';
import 'package:markaa/src/data/models/enum.dart';
import 'package:markaa/src/data/models/index.dart';
import 'package:markaa/src/data/models/product_list_arguments.dart';
import 'package:markaa/src/pages/filter/bloc/filter_bloc.dart';
import 'package:markaa/src/pages/filter/filter_page.dart';
import 'package:markaa/src/pages/product_list/widgets/product_sort_by_dialog.dart';
import 'package:markaa/src/theme/icons.dart';
import 'package:markaa/src/theme/styles.dart';
import 'package:markaa/src/theme/theme.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:markaa/src/utils/services/progress_service.dart';
import 'package:markaa/src/utils/services/snackbar_service.dart';
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
  ProductListArguments arguments;
  CategoryEntity category;
  List<CategoryEntity> subCategories;
  String sortByItem;
  BrandEntity brand;
  int activeSubcategoryIndex;
  bool isFromBrand;
  bool isFilter;
  FilterBloc filterBloc;
  ProgressService progressService;
  SnackBarService snackBarService;
  double scrollPosition = 0;
  ScrollChangeNotifier scrollChangeNotifier;
  ProductChangeNotifier productChangeNotifier;
  CategoryChangeNotifier categoryChangeNotifier;
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
    scrollChangeNotifier = context.read<ScrollChangeNotifier>();
    productChangeNotifier = context.read<ProductChangeNotifier>();
    categoryChangeNotifier = context.read<CategoryChangeNotifier>();
    filterBloc = context.read<FilterBloc>();
    categoryChangeNotifier.initialSubCategories();
    if (isFromBrand) {
      viewMode = ProductViewModeEnum.brand;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        scrollChangeNotifier.initialize();
        categoryChangeNotifier.getBrandSubCategories(brand.optionId, lang);
      });
    } else {
      viewMode = ProductViewModeEnum.category;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        scrollChangeNotifier.initialize();
        categoryChangeNotifier.getSubCategories(category.id, lang);
      });
    }
    progressService = ProgressService(context: context);
    snackBarService = SnackBarService(
      context: context,
      scaffoldKey: scaffoldKey,
    );
    scrollController.addListener(_onScrolling);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.white,
      appBar: MarkaaAppBar(
        scaffoldKey: scaffoldKey,
        isCenter: false,
      ),
      drawer: MarkaaSideMenu(),
      body: Stack(
        children: [
          if (isFromBrand) ...[_buildBrandBar()],
          Consumer<CategoryChangeNotifier>(
            builder: (_, model, ___) {
              if (model.subCategories == null) {
                return Container();
              }
              if (isFromBrand) {
                subCategories = [CategoryEntity(id: 'all')];
              } else {
                subCategories = [category];
              }
              subCategories.addAll(model.subCategories);
              if (subCategories.length > activeSubcategoryIndex) {
                return Consumer<ScrollChangeNotifier>(
                  builder: (ctx, scrollNotifier, child) {
                    double extra = scrollChangeNotifier.showBrandBar ? 0 : 75;
                    double pos = !scrollChangeNotifier.showScrollBar ? 40 : 0;
                    return AnimatedPositioned(
                      top: isFromBrand ? 120.h - extra : 45.h,
                      left: 0,
                      right: 0,
                      bottom: 0,
                      duration: Duration(milliseconds: 500),
                      child: ProductListView(
                        subCategories: subCategories,
                        activeIndex: activeSubcategoryIndex,
                        scaffoldKey: scaffoldKey,
                        isFromBrand: isFromBrand,
                        isFilter: isFilter,
                        brand: brand,
                        onChangeTab: (index) => _onChangeTab(index),
                        scrollController: scrollController,
                        viewMode: viewMode,
                        sortByItem: sortByItem,
                        filterValues: filterValues,
                        pos: pos,
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
      bottomNavigationBar: MarkaaBottomBar(
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
        width: 375.w,
        height: 40.h,
        color: primarySwatchColor,
        alignment: Alignment.center,
        padding: EdgeInsets.only(
          left: 10.w,
          right: 10.w,
          bottom: 10.h,
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
                      size: 20.sp,
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
                          size: 25.sp,
                        ),
                      ),
                      SizedBox(width: 10.w),
                      InkWell(
                        onTap: () => _showFilterDialog(),
                        child: Container(
                          width: 20.w,
                          height: 17.h,
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
                  fontSize: 17.sp,
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
          top: 40.h - extra,
          left: 0,
          right: 0,
          duration: Duration(milliseconds: 500),
          child: Container(
            width: 375.w,
            height: 80.h,
            margin: EdgeInsets.only(bottom: 8.h),
            alignment: Alignment.center,
            color: Colors.white,
            child: CachedNetworkImage(
              imageUrl: brand.brandThumbnail,
              width: 120.w,
              height: 60.h,
              fit: BoxFit.fitHeight,
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
          minPrice: filterValues.containsKey('minPrice') ? filterValues['minPrice'] : null,
          maxPrice: filterValues.containsKey('maxPrice') ? filterValues['maxPrice'] : null,
          selectedCategories: filterValues.containsKey('selectedCategories') ? filterValues['selectedCategories'] : [],
          selectedGenders: filterValues.containsKey('selectedGenders') ? filterValues['selectedGenders'] : [],
          selectedValues: filterValues.containsKey('selectedValues') ? filterValues['selectedValues'] : {},
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
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        scrollChangeNotifier.initialize();
        await productChangeNotifier.initialLoadFilteredProducts(
          brand.optionId,
          subCategories[activeSubcategoryIndex].id,
          filterValues,
          lang,
        );
      });
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
          return ProductSortByDialog();
        },
      );
    });
    if (result != null && sortByItem != result) {
      sortByItem = result;
      if (sortByItem == 'default') {
        if (isFromBrand) {
          viewMode = ProductViewModeEnum.brand;
        } else {
          viewMode = ProductViewModeEnum.category;
        }
      } else {
        viewMode = ProductViewModeEnum.sort;
      }
      setState(() {});
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        scrollChangeNotifier.initialize();
        if (viewMode == ProductViewModeEnum.category) {
          await productChangeNotifier.initialLoadCategoryProducts(
            subCategories[activeSubcategoryIndex].id,
            lang,
          );
        } else if (viewMode == ProductViewModeEnum.brand) {
          await productChangeNotifier.initialLoadBrandProducts(
            brand.optionId,
            subCategories[activeSubcategoryIndex].id,
            lang,
          );
        } else {
          await productChangeNotifier.initialLoadSortedProducts(
            brand.optionId ?? '',
            subCategories[activeSubcategoryIndex].id,
            sortByItem,
            lang,
          );
        }
      });
    }
  }

  void _onChangeTab(int index) async {
    activeSubcategoryIndex = index;
    if (isFromBrand)
      viewMode = ProductViewModeEnum.brand;
    else
      viewMode = ProductViewModeEnum.category;
    setState(() {});
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      scrollChangeNotifier.initialize();
      if (viewMode == ProductViewModeEnum.category) {
        await productChangeNotifier.initialLoadCategoryProducts(
          subCategories[index].id,
          lang,
        );
      } else if (viewMode == ProductViewModeEnum.brand) {
        await productChangeNotifier.initialLoadBrandProducts(
          brand.optionId,
          subCategories[index].id,
          lang,
        );
      }
      filterValues = {};
      filterBloc.add(FilterAttributesLoaded(
        categoryId: subCategories[index].id == 'all' ? null : subCategories[index].id,
        brandId: brand.optionId,
        lang: lang,
      ));
    });
  }

  void _onScrolling() {
    double pos = scrollController.position.pixels;
    scrollChangeNotifier.controlBrandBar(pos);
  }
}
