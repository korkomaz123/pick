import 'package:ciga/src/components/ciga_app_bar.dart';
import 'package:ciga/src/components/ciga_bottom_bar.dart';
import 'package:ciga/src/components/ciga_side_menu.dart';
import 'package:ciga/src/config/config.dart';
import 'package:ciga/src/data/mock/mock.dart';
import 'package:ciga/src/data/models/category_entity.dart';
import 'package:ciga/src/data/models/enum.dart';
import 'package:ciga/src/data/models/index.dart';
import 'package:ciga/src/data/models/product_list_arguments.dart';
import 'package:ciga/src/routes/routes.dart';
import 'package:ciga/src/theme/styles.dart';
import 'package:ciga/src/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:isco_custom_widgets/isco_custom_widgets.dart';

class CategoryListPage extends StatefulWidget {
  @override
  _CategoryListPageState createState() => _CategoryListPageState();
}

class _CategoryListPageState extends State<CategoryListPage> {
  PageStyle pageStyle;
  String category;
  int activeIndex;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

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
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: List.generate(
                  allCategories.length,
                  (index) => Column(
                    children: [
                      _buildCategoryCard(allCategories[index]),
                      activeIndex == index
                          ? _buildSubcategoriesList(allCategories[index])
                          : SizedBox.shrink(),
                      SizedBox(height: pageStyle.unitHeight * 6),
                    ],
                  ),
                ),
              ),
            ),
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
          if (activeIndex != allCategories.indexOf(category)) {
            activeIndex = allCategories.indexOf(category);
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
            image: AssetImage(category.imageUrl),
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
            duration: const Duration(milliseconds: 375),
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
                      store: StoreEntity(),
                      selectedSubCategoryIndex: index,
                      isFromStore: false,
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
            topLeft: Radius.circular(
              EasyLocalization.of(context).locale.languageCode == 'en' ? 30 : 0,
            ),
            bottomLeft: Radius.circular(
              EasyLocalization.of(context).locale.languageCode == 'en' ? 30 : 0,
            ),
            topRight: Radius.circular(
              EasyLocalization.of(context).locale.languageCode == 'ar' ? 30 : 0,
            ),
            bottomRight: Radius.circular(
              EasyLocalization.of(context).locale.languageCode == 'ar' ? 30 : 0,
            ),
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
          Routes.storeList,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(
              EasyLocalization.of(context).locale.languageCode == 'ar' ? 30 : 0,
            ),
            bottomLeft: Radius.circular(
              EasyLocalization.of(context).locale.languageCode == 'ar' ? 30 : 0,
            ),
            topRight: Radius.circular(
              EasyLocalization.of(context).locale.languageCode == 'en' ? 30 : 0,
            ),
            bottomRight: Radius.circular(
              EasyLocalization.of(context).locale.languageCode == 'en' ? 30 : 0,
            ),
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
