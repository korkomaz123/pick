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
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class BrandListPage extends StatefulWidget {
  @override
  _BrandListPageState createState() => _BrandListPageState();
}

class _BrandListPageState extends State<BrandListPage> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final _refreshController = RefreshController(initialRefresh: false);

  HomeChangeNotifier _homeChangeNotifier;
  @override
  void initState() {
    super.initState();
    _homeChangeNotifier = context.read<HomeChangeNotifier>();
    _loadingData = _homeChangeNotifier.getBrandsList('brand');
  }

  void _onRefresh(HomeChangeNotifier model) async {
    await model.getBrandsList('brand');
    _refreshController.refreshCompleted();
  }

  Future _loadingData;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: backgroundColor,
      appBar: MarkaaAppBar(scaffoldKey: scaffoldKey, isCenter: false),
      drawer: MarkaaSideMenu(),
      body: Column(
        children: [
          _buildAppBar(),
          FutureBuilder(
            future: _loadingData,
            builder: (_, model) {
              if (model.connectionState == ConnectionState.waiting)
                return Expanded(
                  child: Center(
                    child: PulseLoadingSpinner(),
                  ),
                );

              return Expanded(
                child: SmartRefresher(
                  enablePullDown: true,
                  enablePullUp: false,
                  header: MaterialClassicHeader(color: primaryColor),
                  controller: _refreshController,
                  onRefresh: () => _onRefresh(_homeChangeNotifier),
                  onLoading: () => null,
                  child: ListView.builder(
                    itemBuilder: (context, index) => _buildBrandCard(_homeChangeNotifier, index),
                    itemCount: _homeChangeNotifier.sortedBrandList.length,
                  ),
                ),
              );
            },
          ),
        ],
      ),
      bottomNavigationBar: MarkaaBottomBar(
        activeItem: BottomEnum.store,
      ),
    );
  }

  Widget _buildAppBar() {
    return Container(
      width: 375.w,
      height: 40.h,
      color: primarySwatchColor,
      padding: EdgeInsets.only(left: 10.w, right: 10.w, bottom: 10.h),
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
            fontSize: 12.sp,
          ),
        ),
      ),
    );
  }

  Widget _buildBrandButton() {
    return Container(
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
            fontSize: 12.sp,
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
        width: 375.w,
        height: 58.h,
        margin: EdgeInsets.only(bottom: 10.h),
        padding: EdgeInsets.symmetric(horizontal: 10.w),
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
                fontSize: 14.sp,
              ),
            ),
            Row(
              children: [
                Text(
                  'view_all'.tr(),
                  style: mediumTextStyle.copyWith(
                    color: primaryColor,
                    fontSize: 11.sp,
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
