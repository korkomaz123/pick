import 'package:ciga/src/data/models/category_entity.dart';
import 'package:ciga/src/routes/routes.dart';
import 'package:ciga/src/theme/styles.dart';
import 'package:ciga/src/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:isco_custom_widgets/isco_custom_widgets.dart';

class HomeCategoryCard extends StatelessWidget {
  final PageStyle pageStyle;
  final CategoryEntity category;

  HomeCategoryCard({this.pageStyle, this.category});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: pageStyle.deviceWidth,
      height: pageStyle.unitHeight * 282,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('lib/public/images/shutterstock_1068767300@3x.png'),
          fit: BoxFit.cover,
        ),
      ),
      padding: EdgeInsets.symmetric(
        horizontal: pageStyle.unitWidth * 20,
        vertical: pageStyle.unitHeight * 30,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            category.name,
            style: mediumTextStyle.copyWith(
              color: Colors.white,
              fontSize: pageStyle.unitFontSize * 23,
            ),
          ),
          Text(
            'Lorem ipsum dolor sit amet,\nLorem ipsum…',
            style: mediumTextStyle.copyWith(
              color: greyDarkColor,
              fontSize: pageStyle.unitFontSize * 10,
            ),
          ),
          Expanded(
            child: Container(
              alignment: Alignment.bottomLeft,
              child: TextButton(
                title: 'view_all'.tr(),
                titleSize: pageStyle.unitFontSize * 18,
                titleColor: Colors.white,
                buttonColor: Colors.transparent,
                borderColor: Colors.white,
                onPressed: () => Navigator.pushNamed(
                  context,
                  Routes.categoryList,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
