import 'package:ciga/src/components/ciga_app_bar.dart';
import 'package:ciga/src/components/ciga_bottom_bar.dart';
import 'package:ciga/src/components/ciga_side_menu.dart';
import 'package:ciga/src/config/config.dart';
import 'package:ciga/src/data/models/enum.dart';
import 'package:ciga/src/data/models/index.dart';
import 'package:ciga/src/pages/product/widgets/product_more_about.dart';
import 'package:ciga/src/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:isco_custom_widgets/isco_custom_widgets.dart';

import 'widgets/product_related_items.dart';
import 'widgets/product_same_brand_products.dart';
import 'widgets/product_single_product.dart';

class ProductPage extends StatefulWidget {
  final Object arguments;

  ProductPage({this.arguments});

  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  PageStyle pageStyle;
  ProductEntity product;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    product = widget.arguments as ProductEntity;
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            ProductSingleProduct(pageStyle: pageStyle, product: product),
            ProductRelatedItems(pageStyle: pageStyle),
            ProductSameBrandProducts(pageStyle: pageStyle),
            ProductMoreAbout(pageStyle: pageStyle),
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
