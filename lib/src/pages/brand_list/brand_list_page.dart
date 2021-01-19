import 'package:markaa/src/components/markaa_app_bar.dart';
import 'package:markaa/src/components/markaa_bottom_bar.dart';
import 'package:markaa/src/components/markaa_side_menu.dart';
import 'package:markaa/src/config/config.dart';
import 'package:markaa/src/data/mock/mock.dart';
import 'package:markaa/src/data/models/brand_entity.dart';
import 'package:markaa/src/data/models/category_entity.dart';
import 'package:markaa/src/data/models/enum.dart';
import 'package:markaa/src/data/models/product_list_arguments.dart';
import 'package:markaa/src/routes/routes.dart';
import 'package:markaa/src/theme/styles.dart';
import 'package:markaa/src/theme/theme.dart';
import 'package:markaa/src/utils/progress_service.dart';
import 'package:markaa/src/utils/snackbar_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:isco_custom_widgets/isco_custom_widgets.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'bloc/brand_bloc.dart';

class BrandListPage extends StatefulWidget {
  const BrandListPage();

  @override
  _BrandListPageState createState() => _BrandListPageState();
}

class _BrandListPageState extends State<BrandListPage> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final _refreshController = RefreshController(initialRefresh: false);
  List<BrandEntity> brands = [];
  PageStyle pageStyle;
  BrandBloc brandBloc;
  SnackBarService snackBarService;
  ProgressService progressService;

  @override
  void initState() {
    super.initState();
    snackBarService = SnackBarService(
      context: context,
      scaffoldKey: scaffoldKey,
    );
    progressService = ProgressService(context: context);
    brandBloc = context.read<BrandBloc>();
    brandBloc.add(BrandListLoaded(lang: lang));
  }

  void _onRefresh() async {
    brandBloc.add(BrandListLoaded(lang: lang));
    await Future.delayed(Duration(milliseconds: 1000));
    _refreshController.refreshCompleted();
  }

  @override
  Widget build(BuildContext context) {
    pageStyle = PageStyle(context, designWidth, designHeight);
    pageStyle.initializePageStyles();
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: backgroundColor,
      appBar: MarkaaAppBar(
        pageStyle: pageStyle,
        scaffoldKey: scaffoldKey,
        isCenter: false,
      ),
      drawer: MarkaaSideMenu(pageStyle: pageStyle),
      body: Column(
        children: [
          _buildAppBar(),
          BlocConsumer<BrandBloc, BrandState>(
            listener: (context, state) {
              // if (state is BrandListLoadedInProcess) {
              //   progressService.showProgress();
              // }
              // if (state is BrandListLoadedSuccess) {
              //   progressService.hideProgress();
              // }
              if (state is BrandListLoadedFailure) {
                // progressService.hideProgress();
                snackBarService.showErrorSnackBar(state.message);
              }
            },
            builder: (context, state) {
              if (state is BrandListLoadedSuccess) {
                brands = state.brands;
              }
              return Expanded(
                child: SmartRefresher(
                  enablePullDown: true,
                  enablePullUp: false,
                  header: MaterialClassicHeader(color: primaryColor),
                  controller: _refreshController,
                  onRefresh: _onRefresh,
                  onLoading: () => null,
                  child: SingleChildScrollView(
                    child: Column(
                      children: List.generate(
                        brands.length,
                        (index) => _buildBrandCard(index),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
      bottomNavigationBar: MarkaaBottomBar(
        pageStyle: pageStyle,
        activeItem: BottomEnum.store,
      ),
    );
  }

  Widget _buildAppBar() {
    return Container(
      width: pageStyle.deviceWidth,
      height: pageStyle.unitHeight * 40,
      color: primarySwatchColor,
      padding: EdgeInsets.only(
        left: pageStyle.unitWidth * 10,
        right: pageStyle.unitWidth * 10,
        bottom: pageStyle.unitHeight * 10,
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
            fontSize: pageStyle.unitFontSize * 12,
          ),
        ),
      ),
    );
  }

  Widget _buildBrandButton() {
    return Container(
      // width: pageStyle.unitWidth * 100,
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
            fontSize: pageStyle.unitFontSize * 12,
          ),
        ),
      ),
    );
  }

  Widget _buildBrandCard(int index) {
    return InkWell(
      onTap: () {
        ProductListArguments arguments = ProductListArguments(
          category: CategoryEntity(),
          subCategory: [],
          brand: brands[index],
          selectedSubCategoryIndex: 0,
          isFromBrand: true,
        );
        Navigator.pushNamed(context, Routes.productList, arguments: arguments);
      },
      child: Container(
        width: pageStyle.deviceWidth,
        height: pageStyle.unitHeight * 58,
        margin: EdgeInsets.only(bottom: pageStyle.unitHeight * 10),
        padding: EdgeInsets.symmetric(horizontal: pageStyle.unitWidth * 10),
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Image.network(brands[index].brandThumbnail),
            Text(
              brands[index].brandLabel,
              style: mediumTextStyle.copyWith(
                color: darkColor,
                fontSize: pageStyle.unitFontSize * 14,
              ),
            ),
            Row(
              children: [
                Text(
                  'view_products'.tr(),
                  style: mediumTextStyle.copyWith(
                    color: primaryColor,
                    fontSize: pageStyle.unitFontSize * 11,
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
