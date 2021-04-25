import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:markaa/src/components/markaa_text_icon_button.dart';
import 'package:markaa/src/components/product_card.dart';
import 'package:markaa/src/data/models/brand_entity.dart';
import 'package:markaa/src/data/models/category_entity.dart';
import 'package:markaa/src/data/models/product_list_arguments.dart';
import 'package:markaa/src/data/models/product_model.dart';
import 'package:markaa/src/routes/routes.dart';
import 'package:markaa/src/theme/styles.dart';
import 'package:markaa/src/theme/theme.dart';
import 'package:provider/provider.dart';
import 'package:isco_custom_widgets/isco_custom_widgets.dart';
import 'package:markaa/src/change_notifier/home_change_notifier.dart';

class HomeGrooming extends StatefulWidget {
  final PageStyle pageStyle;

  HomeGrooming({@required this.pageStyle});

  @override
  _HomeGroomingState createState() => _HomeGroomingState();
}

class _HomeGroomingState extends State<HomeGrooming> {
  PageStyle pageStyle;
  HomeChangeNotifier homeChangeNotifier;

  @override
  void initState() {
    super.initState();
    pageStyle = widget.pageStyle;
    homeChangeNotifier = context.read<HomeChangeNotifier>();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeChangeNotifier>(
      builder: (_, model, __) {
        return Container(
          width: pageStyle.deviceWidth,
          color: Colors.white,
          child: Column(
            children: [
              if (model.groomingTitle.isNotEmpty) ...[
                _buildTitle(model.groomingTitle)
              ],
              if (model.groomingCategories.isNotEmpty) ...[
                _buildCategories(model.groomingCategories)
              ],
              if (model.groomingItems.isNotEmpty) ...[
                _buildProducts(model.groomingItems)
              ],
              if (model.groomingCategory != null) ...[
                _buildFooter(model.groomingCategory, model.groomingTitle)
              ],
            ],
          ),
        );
      },
    );
  }

  Widget _buildTitle(String title) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: pageStyle.unitWidth * 10,
        vertical: pageStyle.unitHeight * 10,
      ),
      child: Text(
        title,
        style: mediumTextStyle.copyWith(
          fontSize: pageStyle.unitFontSize * 26,
        ),
      ),
    );
  }

  Widget _buildCategories(List<CategoryEntity> categories) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: pageStyle.unitHeight * 10),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: categories.map((category) {
            return InkWell(
              onTap: () {
                if (category?.id != null) {
                  final arguments = ProductListArguments(
                    category: category,
                    brand: BrandEntity(),
                    subCategory: [],
                    selectedSubCategoryIndex: 0,
                    isFromBrand: false,
                  );
                  Navigator.pushNamed(
                    context,
                    Routes.productList,
                    arguments: arguments,
                  );
                }
              },
              child: Container(
                width: pageStyle.unitWidth * 151,
                height: pageStyle.unitHeight * 276,
                margin: EdgeInsets.only(right: pageStyle.unitWidth * 5),
                padding: EdgeInsets.only(bottom: pageStyle.unitHeight * 10),
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(category.imageUrl),
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.circular(
                    pageStyle.unitFontSize * 10,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildProducts(List<ProductModel> list) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: pageStyle.unitHeight * 5),
      color: backgroundColor,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: list.map((item) {
            int index = list.indexOf(item);
            return Container(
              padding: EdgeInsets.only(
                left: pageStyle.unitWidth * (index > 0 ? 2 : 0),
                bottom: pageStyle.unitHeight * 3,
              ),
              child: ProductCard(
                cardWidth: widget.pageStyle.unitWidth * 120,
                cardHeight: widget.pageStyle.unitWidth * 175,
                product: item,
                isWishlist: true,
                pageStyle: widget.pageStyle,
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildFooter(CategoryEntity category, String title) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        vertical: widget.pageStyle.unitHeight * 4,
        horizontal: widget.pageStyle.unitWidth * 10,
      ),
      child: MarkaaTextIconButton(
        onPressed: () {
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
        title: 'view_all_grooming'.tr(),
        titleColor: Colors.white,
        titleSize: widget.pageStyle.unitFontSize * 18,
        icon: Icon(
          Icons.arrow_forward_ios,
          color: Colors.white,
          size: widget.pageStyle.unitFontSize * 24,
        ),
        borderColor: primaryColor,
        buttonColor: primaryColor,
        pageStyle: widget.pageStyle,
        leading: false,
      ),
    );
  }
}
