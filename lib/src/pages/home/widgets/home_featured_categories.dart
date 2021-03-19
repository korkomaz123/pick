import 'package:flutter/material.dart';
import 'package:markaa/src/data/mock/mock.dart';
import 'package:markaa/src/data/models/brand_entity.dart';
import 'package:markaa/src/data/models/product_list_arguments.dart';
import 'package:markaa/src/routes/routes.dart';
import 'package:markaa/src/theme/styles.dart';
import 'package:markaa/src/theme/theme.dart';
import 'package:provider/provider.dart';
import 'package:isco_custom_widgets/isco_custom_widgets.dart';
import 'package:markaa/src/change_notifier/category_change_notifier.dart';

class HomeFeaturedCategories extends StatefulWidget {
  final PageStyle pageStyle;

  HomeFeaturedCategories({this.pageStyle});

  @override
  _HomeFeaturedCategoriesState createState() => _HomeFeaturedCategoriesState();
}

class _HomeFeaturedCategoriesState extends State<HomeFeaturedCategories> {
  CategoryChangeNotifier categoryChangeNotifier;

  @override
  void initState() {
    super.initState();
    categoryChangeNotifier = context.read<CategoryChangeNotifier>();
    categoryChangeNotifier.getFeaturedCategoriesList(lang);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.pageStyle.deviceWidth,
      padding: EdgeInsets.symmetric(
        vertical: widget.pageStyle.unitHeight * 15,
      ),
      child: Consumer<CategoryChangeNotifier>(
        builder: (_, model, __) {
          if (model.featuredCategories.isNotEmpty) {
            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: model.featuredCategories.map((category) {
                  return Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: widget.pageStyle.unitWidth * 5,
                    ),
                    child: Column(
                      children: [
                        InkWell(
                          onTap: () {
                            ProductListArguments arguments =
                                ProductListArguments(
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
                            width: widget.pageStyle.unitWidth * 70,
                            height: widget.pageStyle.unitWidth * 70,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: NetworkImage(category.imageUrl),
                                fit: BoxFit.cover,
                              ),
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: primaryColor,
                                width: widget.pageStyle.unitWidth * 2,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: widget.pageStyle.unitHeight * 5),
                        Container(
                          width: widget.pageStyle.unitWidth * 75,
                          child: Text(
                            category.name,
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            style: mediumTextStyle.copyWith(
                              fontSize: widget.pageStyle.unitFontSize * 10,
                              color: greyDarkColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            );
          }
          return Container();
        },
      ),
    );
  }
}
