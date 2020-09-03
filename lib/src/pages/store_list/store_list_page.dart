import 'package:ciga/src/components/ciga_app_bar.dart';
import 'package:ciga/src/components/ciga_bottom_bar.dart';
import 'package:ciga/src/components/ciga_side_menu.dart';
import 'package:ciga/src/config/config.dart';
import 'package:ciga/src/data/mock/mock.dart';
import 'package:ciga/src/data/models/enum.dart';
import 'package:ciga/src/data/models/index.dart';
import 'package:ciga/src/data/models/product_list_arguments.dart';
import 'package:ciga/src/routes/routes.dart';
import 'package:ciga/src/theme/styles.dart';
import 'package:ciga/src/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:isco_custom_widgets/isco_custom_widgets.dart';

class StoreListPage extends StatefulWidget {
  @override
  _StoreListPageState createState() => _StoreListPageState();
}

class _StoreListPageState extends State<StoreListPage> {
  PageStyle pageStyle;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

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
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: List.generate(
                  stores.length,
                  (index) => _buildStoreCard(stores[index]),
                ),
              ),
            ),
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
          _buildStoreButton(),
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
            topLeft: Radius.circular(
              EasyLocalization.of(context).locale.languageCode == 'en' ? 30 : 0,
            ),
            bottomLeft: Radius.circular(
              EasyLocalization.of(context).locale.languageCode == 'en' ? 30 : 0,
            ),
            topRight: Radius.circular(
              EasyLocalization.of(context).locale.languageCode == 'ar' ? 30 : 0,
            ),
            bottomRight: Radius.circular(
              EasyLocalization.of(context).locale.languageCode == 'ar' ? 30 : 0,
            ),
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

  Widget _buildStoreButton() {
    return Container(
      width: pageStyle.unitWidth * 100,
      child: MaterialButton(
        onPressed: () => null,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(
              EasyLocalization.of(context).locale.languageCode == 'ar' ? 30 : 0,
            ),
            bottomLeft: Radius.circular(
              EasyLocalization.of(context).locale.languageCode == 'ar' ? 30 : 0,
            ),
            topRight: Radius.circular(
              EasyLocalization.of(context).locale.languageCode == 'en' ? 30 : 0,
            ),
            bottomRight: Radius.circular(
              EasyLocalization.of(context).locale.languageCode == 'en' ? 30 : 0,
            ),
          ),
        ),
        color: Colors.white.withOpacity(0.4),
        elevation: 0,
        child: Text(
          'bottom_store'.tr(),
          style: boldTextStyle.copyWith(
            color: Colors.white,
            fontSize: pageStyle.unitFontSize * 12,
          ),
        ),
      ),
    );
  }

  Widget _buildStoreCard(StoreEntity store) {
    return InkWell(
      onTap: () {
        ProductListArguments arguments = ProductListArguments(
          category: CategoryEntity(),
          subCategory: subCategories,
          store: store,
          selectedSubCategoryIndex: 0,
          isFromStore: true,
        );
        Navigator.pushNamed(
          context,
          Routes.productList,
          arguments: arguments,
        );
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
            Image.asset(store.imageUrl),
            Text(
              store.name,
              style: mediumTextStyle.copyWith(
                color: greyColor,
                fontSize: pageStyle.unitFontSize * 13,
              ),
            ),
            Row(
              children: [
                Text(
                  'store_visit_store'.tr(),
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
