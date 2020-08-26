import 'package:ciga/src/routes/routes.dart';
import 'package:ciga/src/theme/strings.dart';
import 'package:ciga/src/theme/styles.dart';
import 'package:ciga/src/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:isco_custom_widgets/isco_custom_widgets.dart';

class HomeExploreCategories extends StatelessWidget {
  final PageStyle pageStyle;

  HomeExploreCategories({this.pageStyle});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: pageStyle.deviceWidth,
      height: pageStyle.unitHeight * 570,
      color: Colors.white,
      padding: EdgeInsets.all(pageStyle.unitWidth * 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            exploreCategoriesTitle,
            style: mediumTextStyle.copyWith(
              color: greyDarkColor,
              fontSize: pageStyle.unitFontSize * 23,
            ),
          ),
          SizedBox(height: pageStyle.unitHeight * 20),
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: pageStyle.unitWidth * 20,
              mainAxisSpacing: pageStyle.unitWidth * 15,
              childAspectRatio: 0.9,
              children: List.generate(
                4,
                (index) => Container(
                  width: pageStyle.unitWidth * 158,
                  height: pageStyle.unitHeight * 193,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(
                        'lib/public/images/shutterstock_667109086@3x.png',
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                  alignment: Alignment.bottomLeft,
                  padding: EdgeInsets.all(pageStyle.unitWidth * 8),
                  child: Text(
                    'Category Name',
                    style: boldTextStyle.copyWith(
                      color: Colors.white,
                      fontSize: pageStyle.unitFontSize * 23,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Divider(
            height: pageStyle.unitHeight * 4,
            thickness: pageStyle.unitHeight * 1.5,
            color: greyColor.withOpacity(0.4),
          ),
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: pageStyle.unitHeight * 4),
            child: InkWell(
              onTap: () => Navigator.pushNamed(context, Routes.categoryList),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    seeAllTitle,
                    style: mediumTextStyle.copyWith(
                      fontSize: pageStyle.unitFontSize * 15,
                      color: primaryColor,
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    color: primaryColor,
                    size: pageStyle.unitFontSize * 15,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
