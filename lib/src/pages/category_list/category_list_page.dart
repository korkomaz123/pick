import 'package:ciga/src/components/ciga_app_bar.dart';
import 'package:ciga/src/components/ciga_bottom_bar.dart';
import 'package:ciga/src/components/ciga_side_menu.dart';
import 'package:ciga/src/config/config.dart';
import 'package:ciga/src/data/mock/mock.dart';
import 'package:ciga/src/data/models/brand_entity.dart';
import 'package:ciga/src/data/models/category_entity.dart';
import 'package:ciga/src/data/models/enum.dart';
import 'package:ciga/src/data/models/index.dart';
import 'package:ciga/src/data/models/product_list_arguments.dart';
import 'package:ciga/src/routes/routes.dart';
import 'package:ciga/src/theme/styles.dart';
import 'package:ciga/src/theme/theme.dart';
import 'package:ciga/src/utils/snackbar_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:isco_custom_widgets/isco_custom_widgets.dart';

import 'bloc/category_bloc.dart';

class CategoryListPage extends StatefulWidget {
  final List<CategoryEntity> categories;

  CategoryListPage({this.categories});

  @override
  _CategoryListPageState createState() => _CategoryListPageState();
}

class _CategoryListPageState extends State<CategoryListPage> {
  PageStyle pageStyle;
  String category;
  int activeIndex;
  List<CategoryEntity> categories;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  CategoryBloc categoryBloc;
  SnackBarService snackBarService;

  @override
  void initState() {
    super.initState();
    categories = widget.categories;
    snackBarService = SnackBarService(
      context: context,
      scaffoldKey: scaffoldKey,
    );
    categoryBloc = context.bloc<CategoryBloc>();
    if (categories == null) {
      categoryBloc.add(CategoryListLoaded(lang: lang));
    }
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
          categories != null
              ? Expanded(
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
                )
              : BlocConsumer<CategoryBloc, CategoryState>(
                  listener: (context, state) {
                    if (state is CategoryListLoadedFailure) {
                      snackBarService.showErrorSnackBar(state.message);
                    }
                  },
                  builder: (context, state) {
                    if (state is CategoryListLoadedSuccess) {
                      categories = state.categories;
                      return Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            children: List.generate(
                              categories.length,
                              (index) => Column(
                                children: [
                                  _buildCategoryCard(categories[index]),
                                  activeIndex == index
                                      ? _buildSubcategoriesList(
                                          categories[index])
                                      : SizedBox.shrink(),
                                  SizedBox(height: pageStyle.unitHeight * 6),
                                ],
                              ),
                            ),
                          ),
                        ),
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
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(category.imageUrl),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  Widget _buildSubcategoriesList(CategoryEntity category) {
    return AnimationLimiter(
      child: Column(
        children: List.generate(
          category.subCategories.length,
          (index) => AnimationConfiguration.staggeredList(
            position: index,
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
                      subCategory: category.subCategories,
                      brand: BrandEntity(),
                      selectedSubCategoryIndex: index,
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
    );
  }

  Widget _buildCategoryButton() {
    return Container(
      width: pageStyle.unitWidth * 100,
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
          style: boldTextStyle.copyWith(
            color: Colors.white,
            fontSize: pageStyle.unitFontSize * 12,
          ),
        ),
      ),
    );
  }

  Widget _buildBrandButton() {
    return Container(
      width: pageStyle.unitWidth * 100,
      child: MaterialButton(
        onPressed: () => Navigator.pushReplacementNamed(
          context,
          Routes.brandList,
        ),
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
          style: boldTextStyle.copyWith(
            color: greyColor,
            fontSize: pageStyle.unitFontSize * 12,
          ),
        ),
      ),
    );
  }
}
