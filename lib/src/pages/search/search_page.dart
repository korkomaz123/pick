import 'package:markaa/src/change_notifier/markaa_app_change_notifier.dart';
import 'package:markaa/src/change_notifier/suggestion_change_notifier.dart';
import 'package:markaa/src/components/markaa_page_loading_kit.dart';
import 'package:markaa/src/config/config.dart';
import 'package:markaa/src/data/mock/mock.dart';
import 'package:markaa/src/data/models/product_model.dart';
import 'package:markaa/src/pages/search/bloc/search_bloc.dart';
import 'package:markaa/src/pages/search/bloc/search_repository.dart';
import 'package:markaa/src/routes/routes.dart';
import 'package:markaa/src/theme/styles.dart';
import 'package:markaa/src/theme/theme.dart';
import 'package:markaa/src/utils/flushbar_service.dart';
import 'package:markaa/src/utils/local_storage_repository.dart';
import 'package:markaa/src/utils/progress_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:isco_custom_widgets/isco_custom_widgets.dart';
import 'package:easy_localization/easy_localization.dart';
import 'widgets/search_filter_option.dart';
import 'widgets/search_product_card.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> with WidgetsBindingObserver {
  PageStyle pageStyle;
  TextEditingController searchController = TextEditingController();
  List<dynamic> searchHistory = [];
  Future<List<dynamic>> futureGenders;
  String filterData;
  Future<List<dynamic>> futureCategories;
  Future<List<dynamic>> futureBrands;
  SearchBloc searchBloc;
  ProgressService progressService;
  FlushBarService flushBarService;
  dynamic selectedCategory;
  dynamic selectedBrand;
  dynamic selectedBrandName;
  bool isFiltering = false;
  FocusNode searchNode = FocusNode();
  List<ProductModel> products = [];
  List<ProductModel> suggestions = [];
  LocalStorageRepository localStorageRepository;
  SearchRepository searchRepository;
  SuggestionChangeNotifier suggestionChangeNotifier;
  MarkaaAppChangeNotifier markaaAppChangeNotifier;

  @override
  void initState() {
    super.initState();
    suggestionChangeNotifier = context.read<SuggestionChangeNotifier>();
    searchRepository = context.read<SearchRepository>();
    localStorageRepository = context.read<LocalStorageRepository>();
    futureCategories = searchRepository.getCategoryOptions(lang);
    futureBrands = searchRepository.getBrandOptions(lang);
    futureGenders = searchRepository.getGenderOptions(lang);
    progressService = ProgressService(context: context);
    flushBarService = FlushBarService(context: context);
    searchBloc = context.read<SearchBloc>();
    markaaAppChangeNotifier = context.read<MarkaaAppChangeNotifier>();
    searchController.addListener(_getSuggestion);
    _getSearchHistories();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      searchNode.requestFocus();
    });
  }

  void _getSuggestion() async {
    if (searchController.text.isNotEmpty && searchNode.hasFocus) {
      String query = searchController.text;
      await suggestionChangeNotifier?.getSuggestions(query, lang);
    }
  }

  void _getSearchHistories() async {
    bool isExist = await localStorageRepository.existItem('search_history');
    searchHistory =
        isExist ? await localStorageRepository.getItem('search_history') : [];
    setState(() {});
  }

  void _saveSearchHistory() async {
    int index = searchHistory.indexOf(searchController.text);
    if (index >= 0) {
      searchHistory.removeAt(index);
    }
    searchHistory.add(searchController.text);
    await localStorageRepository.setItem('search_history', searchHistory);
    setState(() {});
  }

  void _clearSearchHistory() async {
    searchHistory.clear();
    await localStorageRepository.setItem('search_history', searchHistory);
    setState(() {});
  }

  @override
  void dispose() {
    searchBloc.add(SearchInitialized());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    pageStyle = PageStyle(context, designWidth, designHeight);
    pageStyle.initializePageStyles();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            size: pageStyle.unitFontSize * 25,
            color: primaryColor,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'search_title'.tr(),
          style: mediumTextStyle.copyWith(
            color: greyColor,
            fontSize: pageStyle.unitFontSize * 36,
          ),
        ),
      ),
      body: Container(
        width: pageStyle.deviceWidth,
        height: pageStyle.deviceHeight,
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
                    if (!searchNode.hasFocus) ...[_buildResult()],
                    if (!isFiltering && searchHistory.isNotEmpty) ...[
                      _buildSearchHistory()
                    ],
                  ],
                ),
              ),
            ),
            if (searchNode.hasFocus) ...[_buildSuggestion()],
          ],
        ),
      ),
      bottomSheet: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildFilterButton(),
          if (isFiltering) ...[_buildFilterOptions()],
        ],
      ),
    );
  }

  Widget _buildSuggestion() {
    return Positioned(
      left: pageStyle.unitWidth * 20,
      right: pageStyle.unitWidth * 20,
      top: pageStyle.unitHeight * 70,
      bottom: 0,
      child: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(pageStyle.unitWidth * 10),
          color: Colors.white,
          child: Consumer<SuggestionChangeNotifier>(
            builder: (ctx, notifier, _) {
              if (notifier.suggestions.isNotEmpty &&
                  searchController.text.isNotEmpty) {
                return Column(
                  children: List.generate(
                    notifier.suggestions.length,
                    (index) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          InkWell(
                            onTap: () => Navigator.pushNamed(
                              context,
                              Routes.product,
                              arguments: notifier.suggestions[index],
                            ),
                            child: SearchProductCard(
                              pageStyle: pageStyle,
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
          ),
        ),
      ),
    );
  }

  Widget _buildSearchField() {
    return Container(
      width: pageStyle.deviceWidth,
      padding: EdgeInsets.symmetric(
        horizontal: pageStyle.unitWidth * 20,
        vertical: pageStyle.unitHeight * 20,
      ),
      child: TextFormField(
        controller: searchController,
        style: mediumTextStyle.copyWith(fontSize: pageStyle.unitFontSize * 19),
        decoration: InputDecoration(
          border: OutlineInputBorder(borderSide: BorderSide.none),
          enabledBorder: OutlineInputBorder(borderSide: BorderSide.none),
          focusedBorder: OutlineInputBorder(borderSide: BorderSide.none),
          contentPadding: EdgeInsets.symmetric(
            vertical: 0,
            horizontal: pageStyle.unitHeight * 10,
          ),
          fillColor: Colors.grey.shade300,
          filled: true,
          prefixIcon: Icon(Icons.search),
          hintText: 'search_items'.tr(),
        ),
        focusNode: searchNode,
        onFieldSubmitted: (value) {
          searchNode.unfocus();
          _searchProducts();
        },
        textInputAction: TextInputAction.search,
      ),
    );
  }

  Widget _buildResult() {
    return Container(
      width: pageStyle.deviceWidth,
      padding: EdgeInsets.symmetric(
        horizontal: pageStyle.unitWidth * 20,
        vertical: pageStyle.unitHeight * 20,
      ),
      child: Consumer<SuggestionChangeNotifier>(
        builder: (_, __, ___) {
          if (suggestionChangeNotifier.searchedProducts == null) {
            return PulseLoadingSpinner();
          }
          return Column(
            children: List.generate(
              suggestionChangeNotifier.searchedProducts.length,
              (index) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap: () => Navigator.pushNamed(
                        context,
                        Routes.product,
                        arguments:
                            suggestionChangeNotifier.searchedProducts[index],
                      ),
                      child: SearchProductCard(
                        pageStyle: pageStyle,
                        product:
                            suggestionChangeNotifier.searchedProducts[index],
                      ),
                    ),
                    index <
                            (suggestionChangeNotifier.searchedProducts.length -
                                1)
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

  Widget _buildFilterButton() {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: pageStyle.unitWidth * 30,
      ),
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
              fontSize: pageStyle.unitFontSize * 19,
            ),
          ),
          SizedBox(width: pageStyle.unitWidth * 20),
          MaterialButton(
            onPressed: () => setState(() {
              isFiltering = !isFiltering;
            }),
            child: Text(
              '+ ' + 'filter_title'.tr(),
              style: mediumTextStyle.copyWith(
                fontSize: pageStyle.unitFontSize * 19,
              ),
            ),
            color: Colors.grey.shade300,
            elevation: 0,
          ),
        ],
      ),
    );
  }

  Widget _buildFilterOptions() {
    return FutureBuilder(
      future: futureCategories,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          List<dynamic> categories = snapshot.data;
          return FutureBuilder(
            future: futureBrands,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                List<dynamic> brands = snapshot.data;
                return Consumer<MarkaaAppChangeNotifier>(
                  builder: (_, __, ___) {
                    return SearchFilterOption(
                      pageStyle: pageStyle,
                      categories: categories,
                      brands: brands,
                      genders: [],
                      selectedCategory: selectedCategory,
                      selectedBrand: selectedBrand,
                      onSelectCategory: (value) => _onSelectCategory(value),
                      onSelectBrand: (value) => _onSelectBrand(value),
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
      padding: EdgeInsets.symmetric(horizontal: pageStyle.unitWidth * 20),
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
            SizedBox(height: pageStyle.unitHeight * 4),
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
                        horizontal: pageStyle.unitWidth * 10,
                        vertical: pageStyle.unitHeight * 15,
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
      padding: EdgeInsets.symmetric(horizontal: pageStyle.unitWidth * 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'search_history_search'.tr(),
            style: mediumTextStyle.copyWith(
              fontSize: pageStyle.unitFontSize * 21,
              color: greyColor,
            ),
          ),
          InkWell(
            onTap: () => _clearSearchHistory(),
            child: Text(
              'search_clear_all'.tr(),
              style: mediumTextStyle.copyWith(
                color: primaryColor,
                fontSize: pageStyle.unitFontSize * 15,
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
              fontSize: pageStyle.unitFontSize * 15,
              color: greyColor,
            ),
          ),
        ),
        if (index > 0) ...[Divider(thickness: 0.5, color: greyDarkColor)],
      ],
    );
  }

  void _onSelectCategory(dynamic value) {
    selectedCategory = value['value'];
    _searchProducts();
  }

  void _onSelectBrand(dynamic value) {
    selectedBrand = value['value'];
    selectedBrandName = value['label'];
    _searchProducts();
    setState(() {});
  }

  void _searchProducts() {
    _saveSearchHistory();
    markaaAppChangeNotifier.rebuild();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      suggestionChangeNotifier.searchProducts(
        searchController.text,
        lang,
        selectedCategory,
        selectedBrandName,
      );
    });
  }
}
