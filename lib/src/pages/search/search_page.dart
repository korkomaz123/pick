import 'package:ciga/src/config/config.dart';
import 'package:ciga/src/data/mock/mock.dart';
import 'package:ciga/src/data/models/product_model.dart';
import 'package:ciga/src/pages/search/bloc/search_bloc.dart';
import 'package:ciga/src/pages/search/bloc/search_repository.dart';
import 'package:ciga/src/routes/routes.dart';
import 'package:ciga/src/theme/styles.dart';
import 'package:ciga/src/theme/theme.dart';
import 'package:ciga/src/utils/flushbar_service.dart';
import 'package:ciga/src/utils/progress_service.dart';
import 'package:flutter/material.dart';
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

class _SearchPageState extends State<SearchPage> {
  PageStyle pageStyle;
  TextEditingController searchController = TextEditingController();
  List<String> searchHistory = ['Arab Perfumes', 'Asia Perfumes', 'Body care'];
  Future<List<dynamic>> futureGenders;
  String filterData;
  Future<List<dynamic>> futureCategories;
  Future<List<dynamic>> futureBrands;
  SearchBloc searchBloc;
  ProgressService progressService;
  FlushBarService flushBarService;
  List<dynamic> selectedCategories = [];
  List<dynamic> selectedBrands = [];
  List<dynamic> selectedGenders = [];
  bool isFiltering = false;
  FocusNode searchNode = FocusNode();
  List<ProductModel> products = [];

  @override
  void initState() {
    super.initState();
    final searchRepository = context.repository<SearchRepository>();
    futureCategories = searchRepository.getCategoryOptions(lang);
    futureBrands = searchRepository.getBrandOptions(lang);
    futureGenders = searchRepository.getGenderOptions(lang);
    progressService = ProgressService(context: context);
    flushBarService = FlushBarService(context: context);
    searchBloc = context.bloc<SearchBloc>();
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
          style: boldTextStyle.copyWith(
            color: greyColor,
            fontSize: pageStyle.unitFontSize * 40,
          ),
        ),
      ),
      body: BlocConsumer<SearchBloc, SearchState>(
        listener: (context, state) {
          if (state is SearchedInProcess) {
            progressService.showProgress();
          }
          if (state is SearchedSuccess) {
            progressService.hideProgress();
          }
          if (state is SearchedFailure) {
            progressService.hideProgress();
            flushBarService.showErrorMessage(pageStyle, state.message);
          }
        },
        builder: (context, state) {
          if (state is SearchedSuccess) {
            products = state.products;
          }
          return SingleChildScrollView(
            child: Column(
              children: [
                _buildSearchField(),
                products.isNotEmpty ? _buildResult() : SizedBox.shrink(),
                _buildFilterButton(),
                isFiltering ? _buildFilterOptions() : _buildSearchHistory(),
              ],
            ),
          );
        },
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
        style: bookTextStyle.copyWith(fontSize: pageStyle.unitFontSize * 19),
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
          searchBloc.add(Searched(
            query: searchController.text,
            categories: selectedCategories,
            brands: selectedBrands,
            genders: selectedGenders,
            lang: lang,
          ));
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
      child: Column(
        children: List.generate(
          products.length,
          (index) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InkWell(
                  onTap: () => Navigator.pushNamed(
                    context,
                    Routes.product,
                    arguments: products[index],
                  ),
                  child: SearchProductCard(
                    pageStyle: pageStyle,
                    product: products[index],
                  ),
                ),
                index < (products.length - 1)
                    ? Divider(color: greyColor, thickness: 0.5)
                    : SizedBox.shrink(),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildFilterButton() {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: pageStyle.unitWidth * 30,
        vertical: pageStyle.unitHeight * 20,
      ),
      child: Row(
        children: [
          Text(
            'all'.tr(),
            style: bookTextStyle.copyWith(
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
              style: bookTextStyle.copyWith(
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
                return FutureBuilder(
                  future: futureGenders,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      List<dynamic> genders = snapshot.data;
                      return SearchFilterOption(
                        pageStyle: pageStyle,
                        categories: categories,
                        brands: brands,
                        genders: genders,
                        selectedCategories: selectedCategories,
                        selectedBrands: selectedBrands,
                        selectedGenders: selectedGenders,
                        onSelectCategory: (value) => _onSelectCategory(value),
                        onSelectBrand: (value) => _onSelectBrand(value),
                        onSelectGender: (value) => _onSelectGender(value),
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
            searchHistory.isNotEmpty
                ? AnimationConfiguration.staggeredList(
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
                              (index) => _buildHistoryItem(index),
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                : SizedBox.shrink(),
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
            style: boldTextStyle.copyWith(
              fontSize: pageStyle.unitFontSize * 21,
              color: greyColor,
            ),
          ),
          InkWell(
            onTap: () => setState(() {
              searchHistory = [];
            }),
            child: Text(
              'search_clear_all'.tr(),
              style: bookTextStyle.copyWith(
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
          onTap: () => setState(() {
            filterData = searchHistory[index];
          }),
          child: Text(
            searchHistory[index],
            style: mediumTextStyle.copyWith(
              fontSize: pageStyle.unitFontSize * 15,
              color: greyColor,
            ),
          ),
        ),
        index < (searchHistory.length - 1)
            ? Divider(
                thickness: 0.5,
                color: greyDarkColor,
              )
            : SizedBox.shrink(),
      ],
    );
  }

  void _onSelectCategory(dynamic value) {
    if (selectedCategories.contains(value['value'])) {
      selectedCategories.remove(value['value']);
    } else {
      selectedCategories.add(value['value']);
    }
    setState(() {});
  }

  void _onSelectBrand(dynamic value) {
    if (selectedBrands.contains(value['value'])) {
      selectedBrands.remove(value['value']);
    } else {
      selectedBrands.add(value['value']);
    }
    setState(() {});
  }

  void _onSelectGender(dynamic value) {
    if (selectedGenders.contains(value['value'])) {
      selectedGenders.remove(value['value']);
    } else {
      selectedGenders.add(value['value']);
    }
    setState(() {});
  }
}
