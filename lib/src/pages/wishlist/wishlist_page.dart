import 'package:ciga/src/components/ciga_app_bar.dart';
import 'package:ciga/src/components/ciga_bottom_bar.dart';
import 'package:ciga/src/components/ciga_side_menu.dart';
import 'package:ciga/src/config/config.dart';
import 'package:ciga/src/data/mock/mock.dart';
import 'package:ciga/src/data/models/enum.dart';
import 'package:ciga/src/data/models/index.dart';
import 'package:ciga/src/pages/wishlist/widgets/wishlist_product_card.dart';
import 'package:ciga/src/theme/styles.dart';
import 'package:ciga/src/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:isco_custom_widgets/isco_custom_widgets.dart';

import 'widgets/wishlist_remove_dialog.dart';

class WishlistPage extends StatefulWidget {
  @override
  _WishlistPageState createState() => _WishlistPageState();
}

class _WishlistPageState extends State<WishlistPage> {
  PageStyle pageStyle;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    pageStyle = PageStyle(context, designWidth, designHeight);
    pageStyle.initializePageStyles();
    return Scaffold(
      key: scaffoldKey,
      appBar: CigaAppBar(pageStyle: pageStyle, scaffoldKey: scaffoldKey),
      drawer: CigaSideMenu(pageStyle: pageStyle),
      body: Column(
        children: [
          _buildAppBar(),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: List.generate(
                  products.length,
                  (index) {
                    return Container(
                      width: pageStyle.deviceWidth,
                      padding: EdgeInsets.symmetric(
                        horizontal: pageStyle.unitWidth * 10,
                      ),
                      child: Column(
                        children: [
                          WishlistProductCard(
                            pageStyle: pageStyle,
                            product: products[index],
                            onRemoveWishlist: () =>
                                _onRemoveWishlist(products[index]),
                          ),
                          index < (products.length - 1)
                              ? Divider(color: greyColor, thickness: 0.5)
                              : SizedBox.shrink(),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: CigaBottomBar(
        pageStyle: pageStyle,
        activeItem: BottomEnum.wishlist,
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
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
            child: Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
              size: pageStyle.unitFontSize * 20,
            ),
            onTap: () => Navigator.pop(context),
          ),
          Text(
            'My Wishlist',
            style: boldTextStyle.copyWith(
              color: Colors.white,
              fontSize: pageStyle.unitFontSize * 17,
            ),
          ),
          SizedBox.shrink(),
        ],
      ),
    );
  }

  void _onRemoveWishlist(ProductEntity product) async {
    final result = await showDialog(
      context: context,
      builder: (context) {
        return WishlistRemoveDialog(pageStyle: pageStyle);
      },
    );
  }
}
