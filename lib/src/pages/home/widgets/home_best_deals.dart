import 'package:ciga/src/data/mock/mock.dart';
import 'package:ciga/src/data/models/brand_entity.dart';
import 'package:ciga/src/data/models/index.dart';
import 'package:ciga/src/data/models/product_list_arguments.dart';
import 'package:ciga/src/data/models/product_model.dart';
import 'package:ciga/src/pages/home/bloc/home_bloc.dart';
import 'package:ciga/src/routes/routes.dart';
import 'package:ciga/src/theme/styles.dart';
import 'package:ciga/src/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isco_custom_widgets/isco_custom_widgets.dart';
import 'package:shimmer/shimmer.dart';
import 'home_products_carousel.dart';

class HomeBestDeals extends StatefulWidget {
  final PageStyle pageStyle;

  HomeBestDeals({this.pageStyle});

  @override
  _HomeBestDealsState createState() => _HomeBestDealsState();
}

class _HomeBestDealsState extends State<HomeBestDeals> {
  CategoryEntity bestDeals = homeCategories[0];
  List<ProductModel> bestDealsProducts;
  HomeBloc homeBloc;

  @override
  void initState() {
    super.initState();
    homeBloc = context.bloc<HomeBloc>();
    homeBloc.add(HomeBestDealsLoaded(lang: lang));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.pageStyle.deviceWidth,
      height: widget.pageStyle.unitHeight * 420,
      padding: EdgeInsets.all(widget.pageStyle.unitWidth * 8),
      margin: EdgeInsets.only(bottom: widget.pageStyle.unitHeight * 10),
      color: Colors.white,
      child: BlocConsumer<HomeBloc, HomeState>(
        listener: (context, state) {},
        builder: (context, state) {
          bestDealsProducts = state.bestDealsProducts;
          if (bestDealsProducts.isNotEmpty) {
            return Column(
              children: [
                _buildHeadline(),
                HomeProductsCarousel(
                  pageStyle: widget.pageStyle,
                  products: bestDealsProducts,
                ),
                Divider(
                  height: widget.pageStyle.unitHeight * 4,
                  thickness: widget.pageStyle.unitHeight * 1.5,
                  color: greyColor.withOpacity(0.4),
                ),
                _buildFooter(context),
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
            'home_best_deals'.tr(),
            style: mediumTextStyle.copyWith(
              fontSize: widget.pageStyle.unitFontSize * 23,
              color: greyDarkColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: widget.pageStyle.unitHeight * 4),
      child: InkWell(
        onTap: () {
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
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'view_all'.tr(),
              style: mediumTextStyle.copyWith(
                fontSize: widget.pageStyle.unitFontSize * 15,
                color: primaryColor,
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: primaryColor,
              size: widget.pageStyle.unitFontSize * 15,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShimmer() {
    return Container(
      width: widget.pageStyle.deviceWidth,
      padding: EdgeInsets.all(widget.pageStyle.unitWidth * 10),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Shimmer.fromColors(
            baseColor: Colors.grey.shade300,
            highlightColor: Colors.white,
            child: Text(
              'home_best_deals'.tr(),
              style: boldTextStyle.copyWith(
                fontSize: widget.pageStyle.unitFontSize * 23,
                color: greyDarkColor,
              ),
            ),
          ),
          SizedBox(height: widget.pageStyle.unitHeight * 40),
          Shimmer.fromColors(
            baseColor: Colors.grey.shade300,
            highlightColor: Colors.white,
            child: Center(
              child: Container(
                width: widget.pageStyle.unitWidth * 220,
                height: widget.pageStyle.unitWidth * 160,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  color: Colors.white,
                ),
              ),
            ),
          ),
          SizedBox(height: widget.pageStyle.unitHeight * 20),
          Shimmer.fromColors(
            baseColor: Colors.grey.shade300,
            highlightColor: Colors.white,
            child: Center(
              child: Container(
                width: double.infinity,
                height: widget.pageStyle.unitWidth * 60,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  color: Colors.white,
                ),
              ),
            ),
          ),
          SizedBox(height: widget.pageStyle.unitHeight * 20),
          Container(
            width: double.infinity,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                3,
                (index) {
                  return Shimmer.fromColors(
                    baseColor: Colors.grey.shade300,
                    highlightColor: Colors.white,
                    child: Container(
                      width: widget.pageStyle.unitWidth * 10,
                      height: widget.pageStyle.unitWidth * 10,
                      margin: EdgeInsets.symmetric(horizontal: 4),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
