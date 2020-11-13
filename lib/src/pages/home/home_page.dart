import 'package:flutter/material.dart';
import 'package:isco_custom_widgets/isco_custom_widgets.dart';
import 'widgets/home_advertise.dart';
import 'widgets/home_best_deals.dart';
import 'widgets/home_discover_stores.dart';
import 'widgets/home_header_carousel.dart';
import 'widgets/home_new_arrivals.dart';
import 'widgets/home_perfumes.dart';
import 'package:ciga/src/components/ciga_app_bar.dart';
import 'package:ciga/src/components/ciga_bottom_bar.dart';
import 'package:ciga/src/components/ciga_side_menu.dart';
import 'package:ciga/src/config/config.dart';
import 'package:ciga/src/data/models/enum.dart';
import 'package:ciga/src/pages/home/widgets/home_explore_categories.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  PageStyle pageStyle;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    pageStyle = PageStyle(context, designWidth, designHeight);
    pageStyle.initializePageStyles();
    return Scaffold(
      key: scaffoldKey,
      appBar: CigaAppBar(pageStyle: pageStyle, scaffoldKey: scaffoldKey),
      drawer: CigaSideMenu(pageStyle: pageStyle),
      body: SingleChildScrollView(
        child: Column(
          children: [
            HomeHeaderCarousel(pageStyle: pageStyle),
            HomeBestDeals(pageStyle: pageStyle),
            HomeNewArrivals(pageStyle: pageStyle),
            HomePerfumes(pageStyle: pageStyle),
            HomeExploreCategories(pageStyle: pageStyle),
            SizedBox(height: pageStyle.unitHeight * 10),
            HomeDiscoverStores(pageStyle: pageStyle),
            SizedBox(height: pageStyle.unitHeight * 10),
            HomeAdvertise(pageStyle: pageStyle),
            SizedBox(height: pageStyle.unitHeight * 10),
            // HomeRecent(pageStyle: pageStyle),
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
