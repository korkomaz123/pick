import 'package:cached_network_image/cached_network_image.dart';
import 'package:markaa/src/change_notifier/filter_change_notifier.dart';
import 'package:markaa/src/change_notifier/product_change_notifier.dart';
import 'package:markaa/src/change_notifier/scroll_chagne_notifier.dart';
import 'package:markaa/src/change_notifier/category_change_notifier.dart';
import 'package:markaa/src/components/markaa_bottom_bar.dart';
import 'package:markaa/src/components/secondary_app_bar.dart';
import 'package:markaa/src/data/mock/mock.dart';
import 'package:markaa/src/data/models/index.dart';
import 'package:markaa/src/pages/filter/filter_page.dart';
import 'package:markaa/src/pages/product_list/widgets/product_sort_by_dialog.dart';
import 'package:markaa/src/theme/icons.dart';
import 'package:markaa/src/theme/styles.dart';
import 'package:markaa/src/theme/theme.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:markaa/src/utils/services/progress_service.dart';
import 'package:provider/provider.dart';
import 'package:sliding_sheet/sliding_sheet.dart';

import 'widgets/product_list_view.dart';

class ProductListPage extends StatefulWidget {
  final ProductListArguments arguments;

  ProductListPage({required this.arguments});

  @override
  _ProductListPageState createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  ScrollController scrollController = ScrollController();
  TabController? tabController;
  ProductListArguments? arguments;
  CategoryEntity? category;
  List<CategoryEntity>? subCategories;
  late String sortByItem;
  BrandEntity? brand;
  late int activeSubcategoryIndex;
  bool? isFromBrand;
  bool? isFilter;

  ProgressService? progressService;
  double scrollPosition = 0;
  ScrollChangeNotifier? scrollChangeNotifier;
  ProductChangeNotifier? productChangeNotifier;
  CategoryChangeNotifier? categoryChangeNotifier;
  late FilterChangeNotifier filterChangeNotifier;
  ProductViewModeEnum? viewMode;
  Map<String, dynamic> filterValues = {};

  @override
  void initState() {
    super.initState();
    sortByItem = 'default';
    arguments = widget.arguments;
    category = arguments!.category;
    brand = arguments!.brand;
    activeSubcategoryIndex = arguments!.selectedSubCategoryIndex;
    isFromBrand = arguments!.isFromBrand;
    subCategories = category != null ? [category!] : [];

    scrollChangeNotifier = context.read<ScrollChangeNotifier>();
    productChangeNotifier = context.read<ProductChangeNotifier>();
    categoryChangeNotifier = context.read<CategoryChangeNotifier>();
    filterChangeNotifier = context.read<FilterChangeNotifier>();
    categoryChangeNotifier!.initialSubCategories();

    if (isFromBrand!) {
      viewMode = ProductViewModeEnum.brand;
      WidgetsBinding.instance!.addPostFrameCallback((_) {
        scrollChangeNotifier!.initialize();
        categoryChangeNotifier!.getBrandSubCategories(brand!.optionId, lang);
      });
    } else {
      viewMode = ProductViewModeEnum.category;
      WidgetsBinding.instance!.addPostFrameCallback((_) {
        scrollChangeNotifier!.initialize();
        categoryChangeNotifier!.getSubCategories(category!.id, lang);
      });
    }
    progressService = ProgressService(context: context);

    scrollController.addListener(_onScrolling);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: backgroundColor,
      appBar: SecondaryAppBar(),
      body: Stack(
        children: [
          if (isFromBrand!) ...[
            _buildBrandBar()
          ] else ...[
            _buildAppBar(),
          ],
          Consumer<CategoryChangeNotifier>(
            builder: (_, model, ___) {
              if (!model.isLoading) {
                if (model.subCategories == null) {
                  return Container();
                }
                if (isFromBrand!) {
                  subCategories = [CategoryEntity(id: 'all', name: 'all'.tr())];
                } else {
                  subCategories = [category!];
                }
                subCategories!.addAll(model.subCategories!);
                if (subCategories!.length > activeSubcategoryIndex) {
                  return Consumer<ScrollChangeNotifier>(
                    builder: (ctx, scrollNotifier, child) {
                      double extra = scrollChangeNotifier!.showBrandBar ? 0 : 70.h;
                      double pos = !scrollChangeNotifier!.showScrollBar ? 40 : 0;
                      return AnimatedPositioned(
                        top: isFromBrand! ? 70.h - extra : 30.h,
                        left: 0,
                        right: 0,
                        bottom: 0,
                        duration: Duration(milliseconds: 500),
                        child: ProductListView(
                          subCategories: subCategories ?? [],
                          activeIndex: activeSubcategoryIndex,
                          scaffoldKey: scaffoldKey,
                          isFromBrand: isFromBrand ?? false,
                          isFilter: isFilter ?? false,
                          brand: brand,
                          onChangeTab: (index) => _onChangeTab(index),
                          scrollController: scrollController,
                          viewMode: viewMode!,
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
              } else {
                return Container();
              }
            },
          ),
        ],
      ),
      bottomNavigationBar: MarkaaBottomBar(
        activeItem: isFromBrand! ? BottomEnum.store : BottomEnum.category,
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
        height: 30.h,
        color: Colors.white,
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(horizontal: 10.w),
        child: Stack(
          alignment: AlignmentDirectional.center,
          children: [
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  InkWell(
                    onTap: () => _onSortBy(),
                    child: Icon(Icons.sort, color: primarySwatchColor, size: 25.sp),
                  ),
                  SizedBox(width: 10.w),
                  InkWell(
                    onTap: () => _showFilterDialog(),
                    child: Container(
                      width: 20.w,
                      height: 17.h,
                      child: SvgPicture.asset(filterIcon, color: primarySwatchColor),
                    ),
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: Text(
                isFromBrand!
                    ? brand!.brandLabel
                    : ['41', '42', '43'].contains(category!.id)
                        ? category!.name.tr()
                        : category!.name,
                style: mediumTextStyle.copyWith(
                  color: primaryColor,
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
        double extra = scrollChangeNotifier!.showBrandBar ? 0 : 40;
        return AnimatedPositioned(
          top: 0 - extra,
          left: 0,
          right: 0,
          duration: Duration(milliseconds: 350),
          child: Container(
            width: 375.w,
            height: 70.h,
            alignment: Alignment.center,
            color: Colors.white,
            padding: EdgeInsets.symmetric(horizontal: 10.w),
            child: Stack(
              children: [
                Center(
                  child: CachedNetworkImage(
                    imageUrl: brand?.brandImage ?? '',
                    width: 120.w,
                    height: 60.h,
                    fit: BoxFit.fitHeight,
                    errorWidget: (_, __, ___) => Center(child: Icon(Icons.image, size: 20)),
                    progressIndicatorBuilder: (_, __, ___) {
                      return CachedNetworkImage(
                        imageUrl: brand?.brandThumbnail ?? '',
                        width: 120.w,
                        height: 60.h,
                        fit: BoxFit.fitHeight,
                        errorWidget: (_, __, ___) => Center(child: Icon(Icons.image, size: 20)),
                      );
                    },
                  ),
                ),
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      InkWell(
                        onTap: () => _onSortBy(),
                        child: Icon(Icons.sort, color: primarySwatchColor, size: 25.sp),
                      ),
                      SizedBox(width: 10.w),
                      InkWell(
                        onTap: () => _showFilterDialog(),
                        child: Container(
                          width: 20.w,
                          height: 17.h,
                          child: SvgPicture.asset(filterIcon, color: primarySwatchColor),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
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
          categoryId: subCategories?[activeSubcategoryIndex].id ?? 'all',
          brandId: brand?.optionId ?? '',
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
      WidgetsBinding.instance!.addPostFrameCallback((_) async {
        scrollChangeNotifier!.initialize();
        String key = _generateKey(subCategories![activeSubcategoryIndex]);
        await productChangeNotifier!.initialLoadFilteredProducts(
          key,
          brand?.optionId ?? '',
          subCategories?[activeSubcategoryIndex].id ?? 'all',
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
          return ProductSortByDialog(value: sortByItem);
        },
      );
    });
    if (result != null && sortByItem != result) {
      sortByItem = result;
      if (sortByItem == 'default' || sortByItem.isEmpty) {
        if (isFromBrand!) {
          viewMode = ProductViewModeEnum.brand;
        } else {
          viewMode = ProductViewModeEnum.category;
        }
      } else {
        viewMode = ProductViewModeEnum.sort;
      }
      setState(() {});
      WidgetsBinding.instance!.addPostFrameCallback((_) async {
        scrollChangeNotifier!.initialize();
        String key = _generateKey(subCategories![activeSubcategoryIndex]);
        if (viewMode == ProductViewModeEnum.category) {
          await productChangeNotifier!.initialLoadCategoryProducts(
            key,
            subCategories![activeSubcategoryIndex].id,
            lang,
          );
        } else if (viewMode == ProductViewModeEnum.brand) {
          await productChangeNotifier!.initialLoadBrandProducts(
            key,
            brand!.optionId,
            subCategories?[activeSubcategoryIndex].id ?? 'all',
            lang,
          );
        } else {
          await productChangeNotifier!.initialLoadSortedProducts(
            key,
            brand?.optionId ?? '',
            subCategories?[activeSubcategoryIndex].id ?? 'all',
            sortByItem,
            lang,
          );
        }
      });
    }
  }

  void _onChangeTab(int index) async {
    activeSubcategoryIndex = index;
    if (sortByItem == 'default') {
      if (isFromBrand!) {
        viewMode = ProductViewModeEnum.brand;
      } else {
        viewMode = ProductViewModeEnum.category;
      }
    } else {
      viewMode = ProductViewModeEnum.sort;
    }
    setState(() {});
    WidgetsBinding.instance!.addPostFrameCallback((_) async {
      scrollChangeNotifier!.initialize();
      String key = _generateKey(subCategories![index]);
      if (viewMode == ProductViewModeEnum.category) {
        await productChangeNotifier!.initialLoadCategoryProducts(
          key,
          subCategories![index].id,
          lang,
        );
      } else if (viewMode == ProductViewModeEnum.brand) {
        await productChangeNotifier!.initialLoadBrandProducts(
          key,
          brand!.optionId,
          subCategories![index].id,
          lang,
        );
      } else {
        await productChangeNotifier!.initialLoadSortedProducts(
          key,
          brand?.optionId ?? '',
          subCategories![activeSubcategoryIndex].id,
          sortByItem,
          lang,
        );
      }
      filterValues = {};
      filterChangeNotifier.loadFilterAttributes(
        subCategories![index].id,
        brand?.optionId ?? '',
        lang,
      );
    });
  }

  void _onScrolling() {
    double pos = scrollController.position.pixels;
    scrollChangeNotifier!.controlBrandBar(pos);
  }

  String _generateKey([CategoryEntity? category]) {
    late String key;
    if (viewMode == ProductViewModeEnum.category) {
      key = '${category?.id ?? 'all'}';
    } else if (viewMode == ProductViewModeEnum.brand) {
      key = '${brand?.optionId ?? ''}_${category?.id ?? 'all'}';
    } else if (viewMode == ProductViewModeEnum.sort) {
      key = '${sortByItem}_${brand?.optionId ?? ''}_${category?.id ?? 'all'}';
    } else if (viewMode == ProductViewModeEnum.filter) {
      key = 'filter_${brand?.optionId ?? ''}_${category?.id ?? 'all'}';
    }
    return key;
  }
}
