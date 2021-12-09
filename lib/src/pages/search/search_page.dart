import 'package:cached_network_image/cached_network_image.dart';
import 'package:markaa/src/change_notifier/home_change_notifier.dart';
import 'package:markaa/src/change_notifier/markaa_app_change_notifier.dart';
import 'package:markaa/src/change_notifier/suggestion_change_notifier.dart';
import 'package:markaa/src/components/markaa_page_loading_kit.dart';
import 'package:markaa/src/components/no_available_data.dart';
import 'package:markaa/src/data/mock/mock.dart';
import 'package:markaa/src/data/models/brand_entity.dart';
import 'package:markaa/src/data/models/index.dart';
import 'package:markaa/src/data/models/product_list_arguments.dart';
import 'package:markaa/src/data/models/product_model.dart';
import 'package:markaa/src/routes/routes.dart';
import 'package:markaa/src/theme/styles.dart';
import 'package:markaa/src/theme/theme.dart';
import 'package:markaa/src/utils/repositories/local_storage_repository.dart';
import 'package:flutter/material.dart';
import 'package:markaa/src/utils/repositories/product_repository.dart';
import 'package:markaa/src/utils/repositories/search_repository.dart';
import 'package:markaa/src/utils/services/flushbar_service.dart';
import 'package:markaa/src/utils/services/progress_service.dart';
import 'package:provider/provider.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'widgets/search_filter_option.dart';
import 'widgets/search_product_card.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> with WidgetsBindingObserver, SingleTickerProviderStateMixin {
  TextEditingController searchController = TextEditingController();
  TabController? tabController;

  Future<List<dynamic>>? futureGenders;
  Future<List<dynamic>>? futureCategories;
  Future<List<dynamic>>? futureBrands;

  ProgressService? progressService;
  FlushBarService? flushBarService;

  dynamic selectedCategory;
  dynamic selectedBrand;
  dynamic selectedBrandName;

  List<dynamic> selectedCategories = [];
  List<dynamic> selectedBrands = [];
  List<dynamic> selectedBrandNames = [];
  List<dynamic> searchHistory = [];

  String? filterData;
  bool isFiltering = false;
  FocusNode searchNode = FocusNode();

  List<ProductModel> products = [];
  List<ProductModel> suggestions = [];

  LocalStorageRepository localStorageRepository = LocalStorageRepository();
  SearchRepository searchRepository = SearchRepository();

  SuggestionChangeNotifier? suggestionChangeNotifier;
  MarkaaAppChangeNotifier? markaaAppChangeNotifier;
  HomeChangeNotifier? homeChangeNotifier;

  @override
  void initState() {
    super.initState();
    suggestionChangeNotifier = context.read<SuggestionChangeNotifier>();
    homeChangeNotifier = context.read<HomeChangeNotifier>();
    markaaAppChangeNotifier = context.read<MarkaaAppChangeNotifier>();

    homeChangeNotifier?.getBrandsList('brand');

    futureCategories = searchRepository.getCategoryOptions(lang);
    futureBrands = searchRepository.getBrandOptions(lang);
    futureGenders = searchRepository.getGenderOptions(lang);

    progressService = ProgressService(context: context);
    flushBarService = FlushBarService(context: context);

    tabController = TabController(initialIndex: 0, length: 2, vsync: this);

    searchController.addListener(_getSuggestion);

    _getSearchHistories();

    WidgetsBinding.instance!.addPostFrameCallback((_) {
      suggestionChangeNotifier!.initializeSuggestion(false);
      searchNode.requestFocus();
    });
  }

  void _getSuggestion() async {
    if (searchController.text.isNotEmpty && searchNode.hasFocus) {
      String query = searchController.text;
      await suggestionChangeNotifier?.getSuggestions(query, lang);
      await suggestionChangeNotifier?.searchProducts(query, lang, [], []);
      markaaAppChangeNotifier!.rebuild();
    } else {
      if (suggestionChangeNotifier!.suggestions.isNotEmpty) {
        suggestionChangeNotifier!.initializeSuggestion(true);
        markaaAppChangeNotifier!.rebuild();
      }
    }
  }

  void _getSearchHistories() async {
    bool isExist = await localStorageRepository.existItem('search_history');
    searchHistory = isExist ? await localStorageRepository.getItem('search_history') : [];
    markaaAppChangeNotifier!.rebuild();
  }

  void _saveSearchHistory() async {
    int index = searchHistory.indexOf(searchController.text);
    if (index >= 0) {
      searchHistory.removeAt(index);
    }
    searchHistory.add(searchController.text);
    await localStorageRepository.setItem('search_history', searchHistory);
    markaaAppChangeNotifier!.rebuild();
  }

  void _clearSearchHistory() async {
    searchHistory.clear();
    await localStorageRepository.setItem('search_history', searchHistory);
    markaaAppChangeNotifier!.rebuild();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            size: 25.sp,
            color: primaryColor,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'search_title'.tr(),
          style: mediumTextStyle.copyWith(
            color: greyColor,
            fontSize: 36.sp,
          ),
        ),
      ),
      body: Consumer<MarkaaAppChangeNotifier>(
        builder: (_, __, ___) {
          return Container(
            width: 375.w,
            height: 812.h,
            child: Stack(
              children: [
                InkWell(
                  onTap: () => setState(() {
                    isFiltering = !isFiltering;
                  }),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        _buildSearchField(),
                        Column(
                          children: [
                            _buildTabbar(),
                            if (tabController!.index == 0) ...[
                              if (!searchNode.hasFocus) ...[_buildItemResult()]
                            ] else ...[
                              _buildBrandResult()
                            ],
                            if (!searchNode.hasFocus && searchHistory.isNotEmpty) ...[_buildSearchHistory()],
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Consumer<SuggestionChangeNotifier>(
                  builder: (_, __, ___) {
                    if (tabController!.index == 0 &&
                        searchNode.hasFocus &&
                        suggestionChangeNotifier!.suggestions.isNotEmpty) {
                      return _buildSuggestion();
                    }
                    return SizedBox.shrink();
                  },
                ),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: Consumer<MarkaaAppChangeNotifier>(
        builder: (_, __, ___) {
          if (tabController!.index == 0) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildFilterButton(),
                if (isFiltering) ...[_buildFilterOptions()],
              ],
            );
          } else {
            return Container(height: 0);
          }
        },
      ),
    );
  }

  Widget _buildTabbar() {
    return Container(
      width: 375.w,
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: darkColor,
            width: 0.5.w,
          ),
        ),
      ),
      child: TabBar(
        controller: tabController,
        indicatorWeight: 3.h,
        indicatorColor: primaryColor,
        labelColor: primaryColor,
        unselectedLabelColor: greyDarkColor,
        labelStyle: mediumTextStyle.copyWith(
          fontSize: 14.sp,
          fontWeight: FontWeight.w700,
        ),
        onTap: (index) {
          tabController!.index = index;
          if (searchNode.hasFocus) {
            searchNode.unfocus();
          }
          markaaAppChangeNotifier!.rebuild();
        },
        tabs: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 4.h),
            child: Row(
              children: [
                Text(
                  'search_items_tab_title'.tr(),
                  style: mediumTextStyle.copyWith(
                    fontSize: 14.sp,
                    color: tabController!.index == 0 ? primaryColor : greyDarkColor,
                  ),
                ),
                SizedBox(width: 4.w),
                Consumer<SuggestionChangeNotifier>(
                  builder: (_, __, ___) {
                    return Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10.w,
                        vertical: 4.h,
                      ),
                      decoration: BoxDecoration(
                        color: tabController!.index == 0 ? primaryColor : greyDarkColor,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        '${suggestionChangeNotifier?.searchedProducts?.length ?? 0}',
                        style: mediumTextStyle.copyWith(
                          fontSize: 12.sp,
                          color: Colors.white,
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 4.h),
            child: Row(
              children: [
                Text(
                  'search_brands_tab_title'.tr(),
                  style: mediumTextStyle.copyWith(
                    fontSize: 14.sp,
                    color: tabController!.index == 1 ? primaryColor : greyDarkColor,
                  ),
                ),
                SizedBox(width: 4.w),
                Consumer<HomeChangeNotifier>(
                  builder: (_, homeChangeNotifier, ___) {
                    int count = 0;
                    for (var brand in homeChangeNotifier.sortedBrandList) {
                      bool isEmpty = searchController.text.isEmpty;
                      String searchText = searchController.text.toLowerCase();
                      String brandLabel = brand.brandLabel.toString().toLowerCase();
                      if ((!isEmpty && brandLabel.contains(searchText)) && brand.productsCount! > 0) {
                        count += 1;
                      }
                    }
                    return Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 5.w,
                        vertical: 4.h,
                      ),
                      decoration: BoxDecoration(
                        color: tabController!.index == 1 ? primaryColor : greyDarkColor,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        count.toString(),
                        style: mediumTextStyle.copyWith(
                          fontSize: 12.sp,
                          color: Colors.white,
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSuggestion() {
    return Positioned(
      left: 20.w,
      right: 20.w,
      top: 135.h,
      bottom: 0,
      child: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(10.w),
          color: Colors.white,
          child: tabController!.index == 0 ? _buildProductsSuggestion() : _buildBrandsSuggestion(),
        ),
      ),
    );
  }

  Widget _buildProductsSuggestion() {
    return Consumer<SuggestionChangeNotifier>(
      builder: (ctx, notifier, _) {
        if (notifier.suggestions.isNotEmpty && searchController.text.isNotEmpty) {
          return Column(
            children: List.generate(
              notifier.suggestions.length,
              (index) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap: () async {
                        ProductModel product =
                            (await ProductRepository().getProduct(notifier.suggestions[index].productId))!;
                        Navigator.pushNamed(context, Routes.product, arguments: product);
                      },
                      child: SearchProductCard(
                        product: notifier.suggestions[index],
                      ),
                    ),
                    index < (notifier.suggestions.length - 1)
                        ? Divider(color: greyColor, thickness: 0.5)
                        : SizedBox.shrink(),
                  ],
                );
              },
            ),
          );
        }
        return Container();
      },
    );
  }

  Widget _buildBrandsSuggestion() {
    return Consumer<HomeChangeNotifier>(
      builder: (_, homeChangeNotifier, ___) {
        List<BrandEntity> brands = homeChangeNotifier.sortedBrandList;
        int rIndex = 0;
        return Column(
          children: List.generate(
            brands.length,
            (index) {
              bool isEmpty = searchController.text.isEmpty;
              String searchText = searchController.text.toLowerCase();
              String brandLabel = brands[index].brandLabel.toString().toLowerCase();
              if ((!isEmpty && brandLabel.contains(searchText)) && brands[index].productsCount! > 0) {
                rIndex += 1;
                return Column(
                  children: [
                    if (rIndex > 1) ...[
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 20.w,
                        ),
                        child: Divider(color: greyColor),
                      )
                    ],
                    InkWell(
                      onTap: () {
                        ProductListArguments arguments = ProductListArguments(
                          category: null,
                          subCategory: [],
                          brand: brands[index],
                          selectedSubCategoryIndex: 0,
                          isFromBrand: true,
                        );
                        Navigator.pushNamed(
                          context,
                          Routes.productList,
                          arguments: arguments,
                        );
                      },
                      child: Container(
                        width: 375.w,
                        height: 50.h,
                        margin: EdgeInsets.only(
                          top: 5.h,
                        ),
                        padding: EdgeInsets.symmetric(
                          horizontal: 20.w,
                        ),
                        color: Colors.white,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CachedNetworkImage(
                              imageUrl: brands[index].brandThumbnail ?? '',
                              errorWidget: (_, __, ___) => Center(child: Icon(Icons.image, size: 20)),
                            ),
                            Text(
                              brands[index].brandLabel,
                              style: mediumTextStyle.copyWith(color: darkColor, fontSize: 12.sp),
                            ),
                            Row(
                              children: [
                                Text(
                                  'view_all'.tr(),
                                  style: mediumTextStyle.copyWith(color: primaryColor, fontSize: 10.sp),
                                ),
                                Icon(Icons.arrow_forward_ios, size: 20, color: primaryColor),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              } else {
                return SizedBox.shrink();
              }
            },
          ),
        );
      },
    );
  }

  Widget _buildSearchField() {
    return Container(
      width: 375.w,
      padding: EdgeInsets.symmetric(
        horizontal: 20.w,
        vertical: 20.h,
      ),
      child: TextFormField(
        controller: searchController,
        style: mediumTextStyle.copyWith(fontSize: 19.sp),
        decoration: InputDecoration(
          border: OutlineInputBorder(borderSide: BorderSide.none),
          enabledBorder: OutlineInputBorder(borderSide: BorderSide.none),
          focusedBorder: OutlineInputBorder(borderSide: BorderSide.none),
          contentPadding: EdgeInsets.symmetric(
            vertical: 0,
            horizontal: 10.h,
          ),
          fillColor: Colors.grey.shade300,
          filled: true,
          prefixIcon: Icon(Icons.search),
          hintText: 'search_items'.tr(),
        ),
        focusNode: searchNode,
        onFieldSubmitted: (value) {
          if (value.isNotEmpty) {
            searchNode.unfocus();
          } else {
            searchNode.requestFocus();
          }
        },
        textInputAction: TextInputAction.search,
      ),
    );
  }

  Widget _buildItemResult() {
    return Container(
      width: 375.w,
      padding: EdgeInsets.symmetric(
        horizontal: 20.w,
        vertical: 20.h,
      ),
      child: Consumer<SuggestionChangeNotifier>(
        builder: (_, __, ___) {
          if (suggestionChangeNotifier!.searchedProducts == null) {
            return PulseLoadingSpinner();
          } else if (suggestionChangeNotifier!.searchedProducts!.isEmpty) {
            return Padding(
              padding: EdgeInsets.symmetric(vertical: 100.h),
              child: NoAvailableData(
                message: 'no_products_searched'.tr(),
              ),
            );
          }
          return Column(
            children: List.generate(
              suggestionChangeNotifier!.searchedProducts!.length,
              (index) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap: () async {
                        ProductModel product = (await ProductRepository()
                            .getProduct(suggestionChangeNotifier!.searchedProducts![index].productId))!;
                        Navigator.pushNamed(context, Routes.product, arguments: product);
                      },
                      child: SearchProductCard(
                        product: suggestionChangeNotifier!.searchedProducts![index],
                      ),
                    ),
                    index < (suggestionChangeNotifier!.searchedProducts!.length - 1)
                        ? Divider(color: greyColor, thickness: 0.5)
                        : SizedBox.shrink(),
                  ],
                );
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildBrandResult() {
    return Consumer<HomeChangeNotifier>(
      builder: (_, homeChangeNotifier, ___) {
        List<BrandEntity> brands = homeChangeNotifier.sortedBrandList;
        int rIndex = 0;
        return SingleChildScrollView(
          child: Column(
            children: List.generate(
              brands.length,
              (index) {
                bool isEmpty = searchController.text.isEmpty;
                String searchText = searchController.text.toLowerCase();
                String brandLabel = brands[index].brandLabel.toString().toLowerCase();
                if ((!isEmpty && brandLabel.contains(searchText)) && brands[index].productsCount! > 0) {
                  rIndex += 1;
                  return Column(
                    children: [
                      if (rIndex > 1) ...[
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20.w),
                          child: Divider(color: greyColor),
                        )
                      ],
                      InkWell(
                        onTap: () {
                          ProductListArguments arguments = ProductListArguments(
                            category: null,
                            subCategory: [],
                            brand: brands[index],
                            selectedSubCategoryIndex: 0,
                            isFromBrand: true,
                          );
                          Navigator.pushNamed(
                            context,
                            Routes.productList,
                            arguments: arguments,
                          );
                        },
                        child: Container(
                          width: 375.w,
                          height: 50.h,
                          margin: EdgeInsets.only(top: 5.h),
                          padding: EdgeInsets.symmetric(horizontal: 20.w),
                          color: Colors.white,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              CachedNetworkImage(
                                imageUrl: brands[index].brandImage ?? '',
                                errorWidget: (_, __, ___) => Center(child: Icon(Icons.image, size: 20)),
                                progressIndicatorBuilder: (_, __, ___) {
                                  return CachedNetworkImage(
                                    imageUrl: brands[index].brandThumbnail ?? '',
                                    errorWidget: (_, __, ___) => Center(child: Icon(Icons.image, size: 20)),
                                  );
                                },
                              ),
                              Text(
                                brands[index].brandLabel,
                                style: mediumTextStyle.copyWith(color: darkColor, fontSize: 12.sp),
                              ),
                              Row(
                                children: [
                                  Text(
                                    'view_all'.tr(),
                                    style: mediumTextStyle.copyWith(color: primaryColor, fontSize: 10.sp),
                                  ),
                                  Icon(Icons.arrow_forward_ios, size: 20, color: primaryColor),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                } else {
                  return SizedBox.shrink();
                }
              },
            ),
          ),
        );
      },
    );
  }

  Widget _buildFilterButton() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 30.w),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: greyColor.withOpacity(0.3),
            offset: Offset(0, 1),
            spreadRadius: 2,
          ),
        ],
      ),
      child: Row(
        children: [
          Text(
            'all'.tr(),
            style: mediumTextStyle.copyWith(
              fontSize: 19.sp,
            ),
          ),
          SizedBox(width: 20.w),
          MaterialButton(
            onPressed: () => setState(() {
              isFiltering = !isFiltering;
            }),
            child: Text(
              '+ ' + 'filter_title'.tr(),
              style: mediumTextStyle.copyWith(
                fontSize: 19.sp,
              ),
            ),
            color: Colors.grey.shade300,
            elevation: 0,
          ),
          Spacer(),
          InkWell(
            onTap: () {
              selectedCategories = [];
              selectedBrands = [];
              selectedBrandNames = [];
              markaaAppChangeNotifier!.rebuild();
              _searchProducts();
            },
            child: Text(
              'reset'.tr(),
              style: mediumTextStyle.copyWith(
                fontSize: 16.sp,
                color: primaryColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterOptions() {
    return FutureBuilder<dynamic>(
      future: futureCategories,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          List<dynamic> categories = snapshot.data;
          return FutureBuilder<dynamic>(
            future: futureBrands,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                List<dynamic> brands = snapshot.data;
                return Consumer<MarkaaAppChangeNotifier>(
                  builder: (_, __, ___) {
                    return SearchFilterOption(
                      categories: categories,
                      brands: brands,
                      genders: [],
                      selectedCategories: selectedCategories,
                      selectedBrands: selectedBrands,
                      onSelectCategory: (value) => _onSelectCategory(value),
                      onSelectBrand: (value) => _onSelectBrand(value),
                      onSelectGender: (value) => null,
                    );
                  },
                );
              } else {
                return Container();
              }
            },
          );
        } else {
          return Container();
        }
      },
    );
  }

  Widget _buildSearchHistory() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: AnimationLimiter(
        child: Column(
          children: [
            AnimationConfiguration.staggeredList(
              position: 0,
              duration: Duration(milliseconds: 375),
              child: SlideAnimation(
                verticalOffset: 50.0,
                child: FadeInAnimation(
                  child: _buildHistoryTitle(),
                ),
              ),
            ),
            SizedBox(height: 4.h),
            if (searchHistory.isNotEmpty) ...[
              AnimationConfiguration.staggeredList(
                position: 0,
                duration: Duration(milliseconds: 375),
                child: SlideAnimation(
                  verticalOffset: 50.0,
                  child: FadeInAnimation(
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(
                        horizontal: 10.w,
                        vertical: 15.h,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: List.generate(
                          searchHistory.length,
                          (index) => _buildHistoryItem(
                            searchHistory.length - index - 1,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildHistoryTitle() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'search_history_search'.tr(),
            style: mediumTextStyle.copyWith(
              fontSize: 21.sp,
              color: greyColor,
            ),
          ),
          InkWell(
            onTap: () => _clearSearchHistory(),
            child: Text(
              'search_clear_all'.tr(),
              style: mediumTextStyle.copyWith(
                color: primaryColor,
                fontSize: 15.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryItem(int index) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: () {
            searchController.text = searchHistory[index];
          },
          child: Text(
            searchHistory[index],
            style: mediumTextStyle.copyWith(
              fontSize: 15.sp,
              color: greyColor,
            ),
          ),
        ),
        if (index > 0) ...[Divider(thickness: 0.5, color: greyDarkColor)],
      ],
    );
  }

  void _onSelectCategory(dynamic value) {
    int index = selectedCategories.indexOf(value['value']);
    if (index > -1) {
      selectedCategories.removeAt(index);
    } else {
      selectedCategories.add(value['value']);
    }
    _searchProducts();
  }

  void _onSelectBrand(dynamic value) {
    int index = selectedBrands.indexOf(value['value']);
    if (index > -1) {
      selectedBrands.removeAt(index);
      selectedBrandNames.removeAt(index);
    } else {
      selectedBrands.add(value['value']);
      selectedBrandNames.add(value['label']);
    }
    _searchProducts();
    setState(() {});
  }

  void _searchProducts() {
    _saveSearchHistory();
    markaaAppChangeNotifier!.rebuild();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      suggestionChangeNotifier!.searchProducts(
        searchController.text,
        lang,
        selectedCategories,
        selectedBrandNames,
      );
    });
  }
}
