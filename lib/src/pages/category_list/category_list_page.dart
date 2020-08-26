import 'package:ciga/src/components/siga_app_bar.dart';
import 'package:ciga/src/components/siga_bottom_bar.dart';
import 'package:ciga/src/config/config.dart';
import 'package:ciga/src/data/mock/mock.dart';
import 'package:ciga/src/data/models/category_entity.dart';
import 'package:ciga/src/data/models/enum.dart';
import 'package:ciga/src/routes/routes.dart';
import 'package:ciga/src/theme/styles.dart';
import 'package:ciga/src/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:isco_custom_widgets/isco_custom_widgets.dart';

class CategoryListPage extends StatefulWidget {
  @override
  _CategoryListPageState createState() => _CategoryListPageState();
}

class _CategoryListPageState extends State<CategoryListPage> {
  PageStyle pageStyle;
  String category;
  int activeIndex;

  @override
  Widget build(BuildContext context) {
    pageStyle = PageStyle(context, designWidth, designHeight);
    pageStyle.initializePageStyles();
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: SigaAppBar(pageStyle: pageStyle),
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
                          ? _buildSubcategoriesList()
                          : SizedBox.shrink(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: SigaBottomBar(
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
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
            child: Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
              size: pageStyle.unitFontSize * 20,
            ),
            onTap: () => Navigator.pop(context),
          ),
          Text(
            'Categories',
            style: boldTextStyle.copyWith(
              color: Colors.white,
              fontSize: pageStyle.unitFontSize * 17,
            ),
          ),
          SizedBox.shrink(),
        ],
      ),
    );
  }

  Widget _buildCategoryCard(CategoryEntity category) {
    return InkWell(
      onLongPress: () {
        setState(() {
          activeIndex = allCategories.indexOf(category);
        });
      },
      onTap: () => Navigator.pushNamed(context, Routes.productList),
      child: Container(
        width: pageStyle.deviceWidth,
        height: pageStyle.unitHeight * 128,
        margin: EdgeInsets.only(bottom: pageStyle.unitHeight * 6),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(category.imageUrl),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  Widget _buildSubcategoriesList() {
    return Column(
      children: List.generate(
        topCategoryItems.length,
        (index) => InkWell(
          onTap: () => Navigator.pushNamed(
            context,
            Routes.productList,
            arguments: index,
          ),
          child: Container(
            width: pageStyle.deviceWidth,
            color: Colors.white,
            margin: EdgeInsets.only(bottom: pageStyle.unitHeight),
            padding: EdgeInsets.symmetric(
              horizontal: pageStyle.unitWidth * 20,
              vertical: pageStyle.unitHeight * 10,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  topCategoryItems[index],
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
    );
  }
}
