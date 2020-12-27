import 'package:ciga/src/components/product_v_card.dart';
import 'package:ciga/src/data/mock/mock.dart';
import 'package:ciga/src/data/models/brand_entity.dart';
import 'package:ciga/src/data/models/index.dart';
import 'package:ciga/src/data/models/product_list_arguments.dart';
import 'package:ciga/src/data/models/product_model.dart';
import 'package:ciga/src/pages/home/bloc/home_bloc.dart';
import 'package:ciga/src/routes/routes.dart';
import 'package:ciga/src/theme/styles.dart';
import 'package:ciga/src/theme/theme.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isco_custom_widgets/isco_custom_widgets.dart';

class HomePerfumes extends StatefulWidget {
  final PageStyle pageStyle;

  HomePerfumes({this.pageStyle});

  @override
  _HomePerfumesState createState() => _HomePerfumesState();
}

class _HomePerfumesState extends State<HomePerfumes> {
  CategoryEntity perfumes = homeCategories[2];
  List<ProductModel> perfumesProducts;
  String title;
  HomeBloc homeBloc;

  @override
  void initState() {
    super.initState();
    homeBloc = context.read<HomeBloc>();
    homeBloc.add(HomePerfumesLoaded(lang: lang));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.pageStyle.deviceWidth,
      padding: EdgeInsets.all(widget.pageStyle.unitWidth * 8),
      margin: EdgeInsets.only(bottom: widget.pageStyle.unitHeight * 10),
      color: Colors.white,
      child: BlocConsumer<HomeBloc, HomeState>(
        listener: (context, state) {},
        builder: (context, state) {
          perfumesProducts = state.perfumesProducts;
          title = state.perfumesTitle;
          if (perfumesProducts.isNotEmpty) {
            return Column(
              children: [
                _buildHeadline(),
                _buildProductView(),
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
            title ?? '',
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
            category: homeCategories[2],
            subCategory: homeCategories[2].subCategories,
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

  Widget _buildProductView() {
    return Container(
      width: widget.pageStyle.deviceWidth,
      height: widget.pageStyle.unitHeight * 500,
      child: Row(
        children: [
          ProductVCard(
            cardWidth: widget.pageStyle.unitWidth * 170,
            cardHeight: widget.pageStyle.unitHeight * 360,
            product: perfumesProducts[0],
            pageStyle: widget.pageStyle,
            isShoppingCart: true,
            isWishlist: true,
            isShare: true,
          ),
          Padding(
            padding: EdgeInsets.only(
              top: widget.pageStyle.unitHeight * 2,
            ),
            child: VerticalDivider(
              width: widget.pageStyle.unitWidth * 4,
              thickness: widget.pageStyle.unitWidth * 1,
              color: greyColor.withOpacity(0.4),
            ),
          ),
          Column(
            children: [
              ProductVCard(
                cardWidth: widget.pageStyle.unitWidth * 170,
                cardHeight: widget.pageStyle.unitHeight * 236,
                product: perfumesProducts[1],
                pageStyle: widget.pageStyle,
                isShoppingCart: true,
                isWishlist: true,
                isShare: true,
              ),
              Container(
                width: widget.pageStyle.unitWidth * 170,
                child: Divider(color: greyColor, thickness: 0.5),
              ),
              ProductVCard(
                cardWidth: widget.pageStyle.unitWidth * 170,
                cardHeight: widget.pageStyle.unitHeight * 236,
                product: perfumesProducts[2],
                pageStyle: widget.pageStyle,
                isShoppingCart: true,
                isWishlist: true,
                isShare: true,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
