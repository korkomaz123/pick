import 'package:ciga/src/components/product_v_card.dart';
import 'package:ciga/src/components/ciga_app_bar.dart';
import 'package:ciga/src/components/ciga_bottom_bar.dart';
import 'package:ciga/src/config/config.dart';
import 'package:ciga/src/data/mock/mock.dart';
import 'package:ciga/src/data/models/enum.dart';
import 'package:ciga/src/pages/filter/filter_page.dart';
import 'package:ciga/src/pages/home/widgets/home_advertise.dart';
import 'package:ciga/src/theme/icons.dart';
import 'package:ciga/src/theme/styles.dart';
import 'package:ciga/src/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:isco_custom_widgets/isco_custom_widgets.dart';

class ProductListPage extends StatefulWidget {
  final arguments;

  ProductListPage({this.arguments});

  @override
  _ProductListPageState createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
  PageStyle pageStyle;
  String category;
  int categoryIndex;

  @override
  void initState() {
    super.initState();
    categoryIndex = widget.arguments as int ?? 0;
    category = topCategoryItems.elementAt(categoryIndex);
  }

  @override
  Widget build(BuildContext context) {
    pageStyle = PageStyle(context, designWidth, designHeight);
    pageStyle.initializePageStyles();
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: CigaAppBar(pageStyle: pageStyle),
      body: Column(
        children: [
          _buildAppBar(),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _buildCategoryBar(),
                  _buildProductList(),
                  _buildLoadMoreButton(),
                  SizedBox(height: pageStyle.unitHeight * 10),
                  HomeAdvertise(pageStyle: pageStyle),
                  SizedBox(height: pageStyle.unitHeight * 10)
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: CigaBottomBar(
        pageStyle: pageStyle,
        activeItem: BottomEnum.home,
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
            'Best Deals',
            style: boldTextStyle.copyWith(
              color: Colors.white,
              fontSize: pageStyle.unitFontSize * 17,
            ),
          ),
          Row(
            children: [
              IconButton(
                onPressed: () => null,
                icon: Icon(
                  Icons.sort,
                  color: Colors.white,
                  size: pageStyle.unitFontSize * 25,
                ),
              ),
              InkWell(
                onTap: () => _showFilterDialog(),
                child: Container(
                  width: pageStyle.unitWidth * 20,
                  height: pageStyle.unitHeight * 17,
                  child: SvgPicture.asset(filterIcon),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryBar() {
    return Container(
      width: pageStyle.deviceWidth,
      height: pageStyle.unitHeight * 60,
      color: Colors.white,
      child: SelectOptionCustomCustom(
        items: topCategoryItems,
        value: category,
        titleSize: pageStyle.unitFontSize * 18,
        itemSpace: pageStyle.unitWidth * 0,
        radius: pageStyle.unitWidth * 20,
        selectedColor: primaryColor,
        unSelectedColor: Colors.white,
        selectedBorderColor: Colors.white,
        unSelectedBorderColor: Colors.white,
        selectedTitleColor: Colors.white,
        unSelectedTitleColor: primaryColor,
        listStyle: true,
        onTap: (value) {
          if (category != value) {
            setState(() {
              category = value;
            });
          }
        },
      ),
    );
  }

  Widget _buildProductList() {
    return Wrap(
      alignment: WrapAlignment.spaceBetween,
      spacing: pageStyle.unitWidth * 2,
      runSpacing: pageStyle.unitHeight * 2,
      children: List.generate(
        20,
        (index) {
          return ProductVCard(
            pageStyle: pageStyle,
            product: homeCategories[0].products[1],
            cardWidth: pageStyle.unitWidth * 186,
            cardHeight: pageStyle.unitHeight * 253,
            isShoppingCart: true,
            isWishlist: true,
          );
        },
      ),
    );
  }

  Widget _buildLoadMoreButton() {
    return Container(
      color: Colors.white,
      width: pageStyle.deviceWidth,
      margin: EdgeInsets.only(top: pageStyle.unitHeight * 1.5),
      padding: EdgeInsets.symmetric(
        horizontal: pageStyle.deviceWidth * 0.3,
        vertical: pageStyle.unitHeight * 10,
      ),
      child: TextButton(
        title: 'Load More',
        titleSize: pageStyle.unitFontSize * 22,
        titleColor: Colors.white,
        buttonColor: primaryColor,
        borderColor: primaryColor,
        onPressed: () => null,
      ),
    );
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      useSafeArea: false,
      builder: (context) {
        return FilterPage();
      },
    );
  }
}
