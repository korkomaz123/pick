import 'package:markaa/src/components/markaa_app_bar.dart';
import 'package:markaa/src/components/markaa_bottom_bar.dart';
import 'package:markaa/src/components/markaa_side_menu.dart';
import 'package:markaa/src/config/config.dart';
import 'package:markaa/src/data/mock/mock.dart';
import 'package:markaa/src/data/models/brand_entity.dart';
import 'package:markaa/src/data/models/category_entity.dart';
import 'package:markaa/src/data/models/enum.dart';
import 'package:markaa/src/data/models/index.dart';
import 'package:markaa/src/data/models/product_list_arguments.dart';
import 'package:markaa/src/routes/routes.dart';
import 'package:markaa/src/theme/styles.dart';
import 'package:markaa/src/theme/theme.dart';
import 'package:markaa/src/utils/progress_service.dart';
import 'package:markaa/src/utils/snackbar_service.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:isco_custom_widgets/isco_custom_widgets.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'bloc/category_list/category_list_bloc.dart';

class CategoryListPage extends StatefulWidget {
  const CategoryListPage();

  @override
  _CategoryListPageState createState() => _CategoryListPageState();
}

class _CategoryListPageState extends State<CategoryListPage> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final _refreshController = RefreshController(initialRefresh: false);
  String category;
  int activeIndex;
  List<CategoryEntity> categories = [];
  PageStyle pageStyle;
  CategoryListBloc categoryListBloc;
  SnackBarService snackBarService;
  ProgressService progressService;

  @override
  void initState() {
    super.initState();
    snackBarService = SnackBarService(
      context: context,
      scaffoldKey: scaffoldKey,
    );
    progressService = ProgressService(context: context);
    categoryListBloc = context.read<CategoryListBloc>();
    categoryListBloc.add(CategoryListLoaded(lang: lang));
  }

  void _onRefresh() {
    categoryListBloc.add(CategoryListLoaded(lang: lang));
  }

  @override
  Widget build(BuildContext context) {
    pageStyle = PageStyle(context, designWidth, designHeight);
    pageStyle.initializePageStyles();
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.white,
      appBar: MarkaaAppBar(
        pageStyle: pageStyle,
        scaffoldKey: scaffoldKey,
        isCenter: false,
      ),
      drawer: MarkaaSideMenu(pageStyle: pageStyle),
      body: Column(
        children: [
          _buildAppBar(),
          BlocConsumer<CategoryListBloc, CategoryListState>(
            listener: (context, state) {
              // if (state is CategoryListLoadedInProcess) {
              //   progressService.showProgress();
              // }
              if (state is CategoryListLoadedSuccess) {
                // progressService.hideProgress();
                _refreshController.refreshCompleted();
              }
              if (state is CategoryListLoadedFailure) {
                // progressService.hideProgress();
                _refreshController.refreshCompleted();
                snackBarService.showErrorSnackBar(state.message);
              }
            },
            builder: (context, state) {
              if (state is CategoryListLoadedSuccess) {
                categories = state.categories;
              }
              return Expanded(
                child: SmartRefresher(
                  enablePullDown: true,
                  enablePullUp: false,
                  header: MaterialClassicHeader(color: primaryColor),
                  controller: _refreshController,
                  onRefresh: _onRefresh,
                  onLoading: () => null,
                  child: SingleChildScrollView(
                    child: Column(
                      children: List.generate(
                        categories.length,
                        (index) => Column(
                          children: [
                            _buildCategoryCard(categories[index]),
                            activeIndex == index
                                ? _buildSubcategoriesList(categories[index])
                                : SizedBox.shrink(),
                            SizedBox(height: pageStyle.unitHeight * 6),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
      bottomNavigationBar: MarkaaBottomBar(
        pageStyle: pageStyle,
        activeItem: BottomEnum.category,
      ),
    );
  }

  Widget _buildAppBar() {
    return Container(
      width: pageStyle.deviceWidth,
      height: pageStyle.unitHeight * 40,
      color: primarySwatchColor,
      padding: EdgeInsets.only(
        left: pageStyle.unitWidth * 10,
        right: pageStyle.unitWidth * 10,
        bottom: pageStyle.unitHeight * 10,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildCategoryButton(),
          _buildBrandButton(),
        ],
      ),
    );
  }

  Widget _buildCategoryCard(CategoryEntity category) {
    return InkWell(
      onTap: () {
        setState(() {
          if (activeIndex != categories.indexOf(category)) {
            activeIndex = categories.indexOf(category);
          } else {
            activeIndex = -1;
          }
        });
      },
      child: Container(
        width: pageStyle.deviceWidth,
        height: pageStyle.unitHeight * 128,
        child: Stack(
          children: [
            Image.network(
              category.imageUrl,
              width: pageStyle.deviceWidth,
              height: pageStyle.unitHeight * 128,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) {
                return Container(
                  width: pageStyle.deviceWidth,
                  height: pageStyle.unitHeight * 128,
                  color: Colors.grey,
                );
              },
            ),
            Align(
              alignment:
                  lang == 'en' ? Alignment.centerLeft : Alignment.centerRight,
              child: Padding(
                padding: EdgeInsets.only(
                  left: pageStyle.unitWidth * (lang == 'en' ? 31 : 150),
                  right: pageStyle.unitWidth * (lang == 'en' ? 150 : 31),
                ),
                child: Text(
                  category.name,
                  style: mediumTextStyle.copyWith(
                    fontSize: pageStyle.unitFontSize * 26,
                    color: greyDarkColor,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSubcategoriesList(CategoryEntity category) {
    return AnimationLimiter(
      child: Column(
        children: [
          AnimationConfiguration.staggeredList(
            position: 0,
            duration: Duration(milliseconds: 375),
            child: SlideAnimation(
              verticalOffset: 50.0,
              child: FadeInAnimation(
                child: InkWell(
                  onTap: () {
                    activeIndex = -1;
                    setState(() {});
                    ProductListArguments arguments = ProductListArguments(
                      category: category,
                      subCategory: [],
                      brand: BrandEntity(),
                      selectedSubCategoryIndex: 0,
                      isFromBrand: false,
                    );
                    Navigator.pushNamed(
                      context,
                      Routes.productList,
                      arguments: arguments,
                    );
                  },
                  child: Container(
                    width: pageStyle.deviceWidth,
                    color: greyLightColor,
                    margin: EdgeInsets.only(bottom: pageStyle.unitHeight),
                    padding: EdgeInsets.symmetric(
                      horizontal: pageStyle.unitWidth * 20,
                      vertical: pageStyle.unitHeight * 10,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'all'.tr(),
                          style: mediumTextStyle.copyWith(
                            color: greyColor,
                            fontSize: pageStyle.unitFontSize * 18,
                          ),
                        ),
                        Icon(
                          Icons.arrow_forward_ios,
                          size: pageStyle.unitFontSize * 22,
                          color: primaryColor,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          Column(
            children: List.generate(
              category.subCategories.length,
              (index) => AnimationConfiguration.staggeredList(
                position: (index + 1),
                duration: Duration(milliseconds: 375),
                child: SlideAnimation(
                  verticalOffset: 50.0,
                  child: FadeInAnimation(
                    child: InkWell(
                      onTap: () {
                        activeIndex = -1;
                        setState(() {});
                        ProductListArguments arguments = ProductListArguments(
                          category: category.subCategories[index],
                          subCategory: [],
                          brand: BrandEntity(),
                          selectedSubCategoryIndex: 0,
                          isFromBrand: false,
                        );
                        Navigator.pushNamed(
                          context,
                          Routes.productList,
                          arguments: arguments,
                        );
                      },
                      child: Container(
                        width: pageStyle.deviceWidth,
                        color: greyLightColor,
                        margin: EdgeInsets.only(bottom: pageStyle.unitHeight),
                        padding: EdgeInsets.symmetric(
                          horizontal: pageStyle.unitWidth * 20,
                          vertical: pageStyle.unitHeight * 10,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              category.subCategories[index].name,
                              style: mediumTextStyle.copyWith(
                                color: greyColor,
                                fontSize: pageStyle.unitFontSize * 18,
                              ),
                            ),
                            Icon(
                              Icons.arrow_forward_ios,
                              size: pageStyle.unitFontSize * 22,
                              color: primaryColor,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryButton() {
    return Container(
      // width: pageStyle.unitWidth * 100,
      child: MaterialButton(
        onPressed: () => null,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(lang == 'en' ? 30 : 0),
            bottomLeft: Radius.circular(lang == 'en' ? 30 : 0),
            topRight: Radius.circular(lang == 'ar' ? 30 : 0),
            bottomRight: Radius.circular(lang == 'ar' ? 30 : 0),
          ),
        ),
        color: Colors.white.withOpacity(0.4),
        elevation: 0,
        child: Text(
          'home_categories'.tr(),
          style: mediumTextStyle.copyWith(
            color: Colors.white,
            fontSize: pageStyle.unitFontSize * 12,
          ),
        ),
      ),
    );
  }

  Widget _buildBrandButton() {
    return Container(
      // width: pageStyle.unitWidth * 100,
      child: MaterialButton(
        onPressed: () {
          Navigator.popUntil(
            context,
            (route) => route.settings.name == Routes.home,
          );
          Navigator.pushNamed(context, Routes.brandList);
        },
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(lang == 'ar' ? 30 : 0),
            bottomLeft: Radius.circular(lang == 'ar' ? 30 : 0),
            topRight: Radius.circular(lang == 'en' ? 30 : 0),
            bottomRight: Radius.circular(lang == 'en' ? 30 : 0),
          ),
        ),
        color: Colors.white,
        elevation: 0,
        child: Text(
          'brands_title'.tr(),
          style: mediumTextStyle.copyWith(
            color: greyColor,
            fontSize: pageStyle.unitFontSize * 12,
          ),
        ),
      ),
    );
  }
}
