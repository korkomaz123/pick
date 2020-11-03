import 'package:ciga/src/config/config.dart';
import 'package:ciga/src/data/mock/mock.dart';
import 'package:ciga/src/data/models/brand_entity.dart';
import 'package:ciga/src/data/models/category_entity.dart';
import 'package:ciga/src/pages/brand_list/bloc/brand_repository.dart';
import 'package:ciga/src/pages/category_list/bloc/category_repository.dart';
import 'package:ciga/src/routes/routes.dart';
import 'package:ciga/src/theme/styles.dart';
import 'package:ciga/src/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isco_custom_widgets/isco_custom_widgets.dart';
import 'package:sliding_sheet/sliding_sheet.dart';
import 'package:easy_localization/easy_localization.dart';
import 'widgets/search_filter_dialog.dart';
import 'widgets/search_product_card.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  PageStyle pageStyle;
  TextEditingController searchController = TextEditingController();
  List<String> searchHistory = ['Arab Perfumes', 'Asia Perfumes', 'Body care'];
  String filterData;
  Future<List<CategoryEntity>> futureCategories;
  Future<List<BrandEntity>> futureBrands;

  @override
  void initState() {
    super.initState();
    futureCategories =
        context.repository<CategoryRepository>().getAllCategories(lang);
    futureBrands = context.repository<BrandRepository>().getAllBrands();
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildSearchField(),
            filterData != null ? _buildResult() : SizedBox.shrink(),
            _buildFilterButton(),
            SizedBox(height: pageStyle.unitHeight * 100),
            _buildSearchHistory(),
          ],
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
            onPressed: () => _onShowFilterBottomSheetDialog(),
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

  Widget _buildSearchHistory() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: pageStyle.unitWidth * 20),
      child: Column(
        children: [
          Container(
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
          ),
          SizedBox(height: pageStyle.unitHeight * 4),
          searchHistory.isNotEmpty
              ? Container(
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
                      (index) {
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
                      },
                    ),
                  ),
                )
              : SizedBox.shrink(),
        ],
      ),
    );
  }

  void _onShowFilterBottomSheetDialog() async {
    final result = await showSlidingBottomSheet(context, builder: (context) {
      return SlidingSheetDialog(
        elevation: 8,
        cornerRadius: 16,
        snapSpec: SnapSpec(
          snap: true,
          snappings: [0.8],
          positioning: SnapPositioning.relativeToAvailableSpace,
        ),
        builder: (context, state) {
          return FutureBuilder(
            future: futureCategories,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                List<CategoryEntity> categories = snapshot.data;
                return FutureBuilder(
                  future: futureBrands,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      List<BrandEntity> brands = snapshot.data;
                      return SearchFilterDialog(
                        pageStyle: pageStyle,
                        categories: categories,
                        brands: brands,
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
        },
      );
    });
    if (result != null) {
      setState(() {
        filterData = result;
      });
    }
  }
}
