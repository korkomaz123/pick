import 'package:ciga/src/components/ciga_app_bar.dart';
import 'package:ciga/src/components/ciga_bottom_bar.dart';
import 'package:ciga/src/components/ciga_side_menu.dart';
import 'package:ciga/src/config/config.dart';
import 'package:ciga/src/data/mock/mock.dart';
import 'package:ciga/src/data/models/brand_entity.dart';
import 'package:ciga/src/data/models/category_entity.dart';
import 'package:ciga/src/data/models/enum.dart';
import 'package:ciga/src/data/models/product_list_arguments.dart';
import 'package:ciga/src/routes/routes.dart';
import 'package:ciga/src/theme/styles.dart';
import 'package:ciga/src/theme/theme.dart';
import 'package:ciga/src/utils/progress_service.dart';
import 'package:ciga/src/utils/snackbar_service.dart';
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
    brandBloc = context.bloc<BrandBloc>();
    brandBloc.add(BrandListLoaded());
  }

  void _onRefresh() async {
    brandBloc.add(BrandListLoaded());
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
      appBar: CigaAppBar(pageStyle: pageStyle, scaffoldKey: scaffoldKey),
      drawer: CigaSideMenu(pageStyle: pageStyle),
      body: Column(
        children: [
          _buildAppBar(),
          BlocConsumer<BrandBloc, BrandState>(
            listener: (context, state) {
              if (state is BrandListLoadedInProcess) {
                progressService.showProgress();
              }
              if (state is BrandListLoadedSuccess) {
                progressService.hideProgress();
              }
              if (state is BrandListLoadedFailure) {
                progressService.hideProgress();
                snackBarService.showErrorSnackBar(state.message);
              }
            },
            builder: (context, state) {
              if (state is BrandListLoadedSuccess) {
                brands = state.brands;
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
              } else {
                return Expanded(child: Container(color: Colors.white));
              }
            },
          ),
        ],
      ),
      bottomNavigationBar: CigaBottomBar(
        pageStyle: pageStyle,
        activeItem: BottomEnum.store,
      ),
    );
  }

  Widget _buildAppBar() {
    return Container(
      width: pageStyle.deviceWidth,
      height: pageStyle.unitHeight * 60,
      color: primarySwatchColor,
      padding: EdgeInsets.symmetric(horizontal: pageStyle.unitWidth * 10),
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
      width: pageStyle.unitWidth * 100,
      child: MaterialButton(
        onPressed: () => Navigator.pushReplacementNamed(
          context,
          Routes.categoryList,
        ),
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
          style: boldTextStyle.copyWith(
            color: greyColor,
            fontSize: pageStyle.unitFontSize * 12,
          ),
        ),
      ),
    );
  }

  Widget _buildBrandButton() {
    return Container(
      width: pageStyle.unitWidth * 100,
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
          style: boldTextStyle.copyWith(
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
                  style: bookTextStyle.copyWith(
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
