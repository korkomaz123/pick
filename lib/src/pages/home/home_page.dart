import 'package:ciga/src/components/ciga_app_bar.dart';
import 'package:ciga/src/components/ciga_bottom_bar.dart';
import 'package:ciga/src/config/config.dart';
import 'package:ciga/src/data/mock/mock.dart';
import 'package:ciga/src/data/models/enum.dart';
import 'package:ciga/src/pages/home/widgets/home_top_brands.dart';
import 'package:flutter/material.dart';
import 'package:isco_custom_widgets/isco_custom_widgets.dart';

import 'widgets/home_advertise.dart';
import 'widgets/home_body_care.dart';
import 'widgets/home_discover_stores.dart';
import 'widgets/home_explore_categories.dart';
import 'widgets/home_header_carousel.dart';
import 'widgets/home_category_card.dart';
import 'widgets/home_recent.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  PageStyle pageStyle;

  @override
  Widget build(BuildContext context) {
    pageStyle = PageStyle(context, designWidth, designHeight);
    pageStyle.initializePageStyles();
    return Scaffold(
      appBar: CigaAppBar(pageStyle: pageStyle),
      body: SingleChildScrollView(
        child: Column(
          children: [
            HomeHeaderCarousel(pageStyle: pageStyle),
            Column(
              children: homeCategories
                  .map(
                    (category) => HomeCategoryCard(
                      category: category,
                      pageStyle: pageStyle,
                    ),
                  )
                  .toList(),
            ),
            HomeBodyCare(pageStyle: pageStyle),
            SizedBox(height: pageStyle.unitHeight * 10),
            HomeExploreCategories(pageStyle: pageStyle),
            SizedBox(height: pageStyle.unitHeight * 10),
            HomeDiscoverStores(pageStyle: pageStyle),
            SizedBox(height: pageStyle.unitHeight * 10),
            HomeTopBrands(pageStyle: pageStyle),
            SizedBox(height: pageStyle.unitHeight * 10),
            HomeAdvertise(pageStyle: pageStyle),
            SizedBox(height: pageStyle.unitHeight * 10),
            HomeRecent(pageStyle: pageStyle),
          ],
        ),
      ),
      bottomNavigationBar: CigaBottomBar(
        pageStyle: pageStyle,
        activeItem: BottomEnum.home,
      ),
    );
  }
}
