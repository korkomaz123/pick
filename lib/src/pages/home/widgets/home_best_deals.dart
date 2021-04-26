import 'package:markaa/src/change_notifier/home_change_notifier.dart';
import 'package:markaa/src/components/markaa_text_button.dart';
import 'package:markaa/src/components/product_v_card.dart';
import 'package:markaa/src/data/mock/mock.dart';
import 'package:markaa/src/data/models/brand_entity.dart';
import 'package:markaa/src/data/models/index.dart';
import 'package:markaa/src/data/models/product_list_arguments.dart';
import 'package:markaa/src/data/models/product_model.dart';
import 'package:markaa/src/routes/routes.dart';
import 'package:markaa/src/theme/styles.dart';
import 'package:markaa/src/theme/theme.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:isco_custom_widgets/isco_custom_widgets.dart';

class HomeBestDeals extends StatefulWidget {
  final PageStyle pageStyle;

  HomeBestDeals({this.pageStyle});

  @override
  _HomeBestDealsState createState() => _HomeBestDealsState();
}

class _HomeBestDealsState extends State<HomeBestDeals> {
  CategoryEntity bestDeals = homeCategories[0];
  List<ProductModel> bestDealsProducts;
  String title;
  HomeChangeNotifier homeChangeNotifier;

  @override
  void initState() {
    super.initState();
    homeChangeNotifier = context.read<HomeChangeNotifier>();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.pageStyle.deviceWidth,
      height: widget.pageStyle.unitHeight * 380,
      padding: EdgeInsets.all(widget.pageStyle.unitWidth * 8),
      margin: EdgeInsets.only(bottom: widget.pageStyle.unitHeight * 10),
      color: Colors.white,
      child: Consumer<HomeChangeNotifier>(
        builder: (_, model, __) {
          bestDealsProducts = model.bestDealsProducts;
          title = model.bestDealsTitle;
          if (bestDealsProducts.isNotEmpty) {
            return Column(
              children: [
                _buildHeadline(),
                _buildProductsList(model.bestDealsProducts),
              ],
            );
          } else {
            return Container();
          }
        },
      ),
    );
  }

  Widget _buildHeadline() {
    return Container(
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title ?? '',
            style: mediumTextStyle.copyWith(
              fontSize: widget.pageStyle.unitFontSize * 26,
              color: greyDarkColor,
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(
                horizontal: widget.pageStyle.unitWidth * 5),
            height: widget.pageStyle.unitHeight * 30,
            child: MarkaaTextButton(
              title: 'view_all'.tr(),
              titleSize: widget.pageStyle.unitFontSize * 15,
              titleColor: primaryColor,
              buttonColor: Colors.white,
              borderColor: primaryColor,
              radius: 0,
              onPressed: () {
                ProductListArguments arguments = ProductListArguments(
                  category: homeCategories[0],
                  subCategory: homeCategories[0].subCategories,
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
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductsList(List<ProductModel> list) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(
        top: widget.pageStyle.unitHeight * 10,
        bottom: widget.pageStyle.unitHeight * 10,
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: list.map((item) {
            return Container(
              margin: EdgeInsets.only(left: widget.pageStyle.unitWidth * 5),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.grey.shade300,
                  width: widget.pageStyle.unitWidth,
                ),
              ),
              child: ProductVCard(
                cardWidth: widget.pageStyle.unitWidth * 170,
                cardHeight: widget.pageStyle.unitHeight * 280,
                product: item,
                isShoppingCart: true,
                isLine: true,
                isMinor: true,
                isWishlist: true,
                isShare: false,
                pageStyle: widget.pageStyle,
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
