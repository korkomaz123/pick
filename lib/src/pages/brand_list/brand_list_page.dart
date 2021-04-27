import 'package:cached_network_image/cached_network_image.dart';
import 'package:markaa/src/change_notifier/home_change_notifier.dart';
import 'package:markaa/src/components/markaa_app_bar.dart';
import 'package:markaa/src/components/markaa_bottom_bar.dart';
import 'package:markaa/src/components/markaa_page_loading_kit.dart';
import 'package:markaa/src/components/markaa_side_menu.dart';
import 'package:markaa/src/data/mock/mock.dart';
import 'package:markaa/src/data/models/category_entity.dart';
import 'package:markaa/src/data/models/enum.dart';
import 'package:markaa/src/data/models/product_list_arguments.dart';
import 'package:markaa/src/routes/routes.dart';
import 'package:markaa/src/theme/styles.dart';
import 'package:markaa/src/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../config.dart';

class BrandListPage extends StatefulWidget {
  const BrandListPage();

  @override
  _BrandListPageState createState() => _BrandListPageState();
}

class _BrandListPageState extends State<BrandListPage> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final _refreshController = RefreshController(initialRefresh: false);

  void _onRefresh(HomeChangeNotifier _homeChangeNotifier) async {
    await _homeChangeNotifier.getBrandsList('brand');
    _refreshController.refreshCompleted();
  }

  @override
  Widget build(BuildContext context) {
    HomeChangeNotifier _homeChangeNotifier = context.read<HomeChangeNotifier>();
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: backgroundColor,
      appBar: MarkaaAppBar(pageStyle: Config.pageStyle, scaffoldKey: scaffoldKey, isCenter: false),
      drawer: MarkaaSideMenu(),
      body: Column(
        children: [
          _buildAppBar(),
          Expanded(
            child: FutureBuilder(
              future: _homeChangeNotifier.getBrandsList('brand'),
              builder: (_, snapShot) => snapShot.connectionState == ConnectionState.waiting
                  ? Center(child: CircularProgressIndicator())
                  : (_homeChangeNotifier.sortedBrandList.isEmpty
                      ? Center(
                          child: PulseLoadingSpinner(),
                        )
                      : SmartRefresher(
                          enablePullDown: true,
                          enablePullUp: false,
                          header: MaterialClassicHeader(color: primaryColor),
                          controller: _refreshController,
                          onRefresh: () => _onRefresh(_homeChangeNotifier),
                          onLoading: () => null,
                          child: SingleChildScrollView(
                            child: Column(
                              children: List.generate(
                                _homeChangeNotifier.sortedBrandList.length,
                                (index) => _buildBrandCard(_homeChangeNotifier, index),
                              ),
                            ),
                          ),
                        )),
            ),
          ),
        ],
      ),
      bottomNavigationBar: MarkaaBottomBar(
        pageStyle: Config.pageStyle,
        activeItem: BottomEnum.store,
      ),
    );
  }

  Widget _buildAppBar() {
    return Container(
      width: Config.pageStyle.deviceWidth,
      height: Config.pageStyle.unitHeight * 40,
      color: primarySwatchColor,
      padding: EdgeInsets.only(
        left: Config.pageStyle.unitWidth * 10,
        right: Config.pageStyle.unitWidth * 10,
        bottom: Config.pageStyle.unitHeight * 10,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildCategoryButton(),
          _buildBrandButton(),
        ],
      ),
    );
  }

  Widget _buildCategoryButton() {
    return Container(
      child: MaterialButton(
        onPressed: () {
          Navigator.popUntil(
            context,
            (route) => route.settings.name == Routes.home,
          );
          Navigator.pushNamed(context, Routes.categoryList);
        },
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(lang == 'en' ? 30 : 0),
            bottomLeft: Radius.circular(lang == 'en' ? 30 : 0),
            topRight: Radius.circular(lang == 'ar' ? 30 : 0),
            bottomRight: Radius.circular(lang == 'ar' ? 30 : 0),
          ),
        ),
        color: Colors.white,
        elevation: 0,
        child: Text(
          'home_categories'.tr(),
          style: mediumTextStyle.copyWith(
            color: greyColor,
            fontSize: Config.pageStyle.unitFontSize * 12,
          ),
        ),
      ),
    );
  }

  Widget _buildBrandButton() {
    return Container(
      // width: Config.pageStyle.unitWidth * 100,
      child: MaterialButton(
        onPressed: () => null,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(lang == 'ar' ? 30 : 0),
            bottomLeft: Radius.circular(lang == 'ar' ? 30 : 0),
            topRight: Radius.circular(lang == 'en' ? 30 : 0),
            bottomRight: Radius.circular(lang == 'en' ? 30 : 0),
          ),
        ),
        color: Colors.white.withOpacity(0.4),
        elevation: 0,
        child: Text(
          'brands_title'.tr(),
          style: mediumTextStyle.copyWith(
            color: Colors.white,
            fontSize: Config.pageStyle.unitFontSize * 12,
          ),
        ),
      ),
    );
  }

  Widget _buildBrandCard(HomeChangeNotifier _homeChangeNotifier, int index) {
    return InkWell(
      onTap: () {
        ProductListArguments arguments = ProductListArguments(
          category: CategoryEntity(),
          subCategory: [],
          brand: _homeChangeNotifier.sortedBrandList[index],
          selectedSubCategoryIndex: 0,
          isFromBrand: true,
        );
        Navigator.pushNamed(context, Routes.productList, arguments: arguments);
      },
      child: Container(
        width: Config.pageStyle.deviceWidth,
        height: Config.pageStyle.unitHeight * 58,
        margin: EdgeInsets.only(bottom: Config.pageStyle.unitHeight * 10),
        padding: EdgeInsets.symmetric(horizontal: Config.pageStyle.unitWidth * 10),
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CachedNetworkImage(
              imageUrl: _homeChangeNotifier.sortedBrandList[index].brandThumbnail,
              placeholder: (context, url) => Container(),
              errorWidget: (context, url, error) => Icon(Icons.error),
            ),
            Text(
              _homeChangeNotifier.sortedBrandList[index].brandLabel,
              style: mediumTextStyle.copyWith(
                color: darkColor,
                fontSize: Config.pageStyle.unitFontSize * 14,
              ),
            ),
            Row(
              children: [
                Text(
                  'view_all'.tr(),
                  style: mediumTextStyle.copyWith(
                    color: primaryColor,
                    fontSize: Config.pageStyle.unitFontSize * 11,
                  ),
                ),
                Icon(Icons.arrow_forward_ios, size: 22, color: primaryColor),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
