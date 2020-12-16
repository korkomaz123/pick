import 'package:ciga/src/data/mock/mock.dart';
import 'package:ciga/src/data/models/brand_entity.dart';
import 'package:ciga/src/data/models/category_entity.dart';
import 'package:ciga/src/data/models/product_list_arguments.dart';
import 'package:ciga/src/pages/category_list/bloc/category_list/category_list_bloc.dart';
import 'package:ciga/src/routes/routes.dart';
import 'package:ciga/src/theme/styles.dart';
import 'package:ciga/src/theme/theme.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:isco_custom_widgets/isco_custom_widgets.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class HomeExploreCategories extends StatefulWidget {
  final PageStyle pageStyle;

  HomeExploreCategories({this.pageStyle});

  @override
  _HomeExploreCategoriesState createState() => _HomeExploreCategoriesState();
}

class _HomeExploreCategoriesState extends State<HomeExploreCategories> {
  int activeIndex = 0;
  List<CategoryEntity> categories = [];
  CategoryListBloc categoryListBloc;

  @override
  void initState() {
    super.initState();
    categoryListBloc = context.read<CategoryListBloc>();
    categoryListBloc.add(CategoryListLoaded(lang: lang));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.pageStyle.deviceWidth,
      height: widget.pageStyle.unitHeight * 320,
      color: Colors.white,
      padding: EdgeInsets.symmetric(vertical: widget.pageStyle.unitWidth * 15),
      child: BlocConsumer<CategoryListBloc, CategoryListState>(
        listener: (context, state) {},
        builder: (context, state) {
          if (state is CategoryListLoadedSuccess) {
            categories = state.categories;
          }
          if (categories.isNotEmpty) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTitle(),
                SizedBox(height: widget.pageStyle.unitHeight * 20),
                _buildCategorySliders(),
                _buildFooter(),
              ],
            );
          } else {
            return Container();
          }
        },
      ),
    );
  }

  Widget _buildTitle() {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: widget.pageStyle.unitWidth * 15,
      ),
      child: Text(
        'home_categories'.tr(),
        style: mediumTextStyle.copyWith(
          color: greyDarkColor,
          fontSize: widget.pageStyle.unitFontSize * 23,
        ),
      ),
    );
  }

  Widget _buildFooter() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        vertical: widget.pageStyle.unitHeight * 4,
        horizontal: widget.pageStyle.unitWidth * 15,
      ),
      child: InkWell(
        onTap: () => Navigator.pushNamed(
          context,
          Routes.categoryList,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'view_more_categories'.tr(),
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

  Widget _buildCategorySliders() {
    return Expanded(
      child: Stack(
        children: [
          Container(
            width: widget.pageStyle.deviceWidth,
            height: widget.pageStyle.unitHeight * 400,
            color: Colors.white,
            child: Swiper(
              itemCount: categories.length > 6 ? 6 : categories.length,
              autoplay: true,
              curve: Curves.easeIn,
              duration: 300,
              autoplayDelay: 5000,
              onIndexChanged: (value) {
                activeIndex = value;
                setState(() {});
              },
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    ProductListArguments arguments = ProductListArguments(
                      category: categories[index],
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
                    width: widget.pageStyle.deviceWidth,
                    // height: widget.pageStyle.unitHeight * 242,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(categories[index].imageUrl),
                        fit: BoxFit.fitWidth,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.only(
                bottom: widget.pageStyle.unitHeight * 20,
              ),
              child: SmoothIndicator(
                offset: activeIndex.toDouble(),
                count: categories.length > 6 ? 6 : categories.length,
                axisDirection: Axis.horizontal,
                effect: SlideEffect(
                  spacing: 8.0,
                  radius: 0,
                  dotWidth: 24.0,
                  dotHeight: widget.pageStyle.unitHeight * 2,
                  paintStyle: PaintingStyle.fill,
                  strokeWidth: 0,
                  dotColor: Colors.white,
                  activeDotColor: primarySwatchColor,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
