import 'dart:async';

import 'package:ciga/src/components/ciga_app_bar.dart';
import 'package:ciga/src/components/ciga_bottom_bar.dart';
import 'package:ciga/src/components/ciga_side_menu.dart';
import 'package:ciga/src/config/config.dart';
import 'package:ciga/src/data/mock/mock.dart';
import 'package:ciga/src/data/models/enum.dart';
import 'package:ciga/src/data/models/index.dart';
import 'package:ciga/src/pages/wishlist/widgets/wishlist_product_card.dart';
import 'package:ciga/src/routes/routes.dart';
import 'package:ciga/src/theme/icons.dart';
import 'package:ciga/src/theme/styles.dart';
import 'package:ciga/src/theme/theme.dart';
import 'package:ciga/src/utils/animation_durations.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:isco_custom_widgets/isco_custom_widgets.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:lottie/lottie.dart';
import 'widgets/wishlist_remove_dialog.dart';

class WishlistPage extends StatefulWidget {
  @override
  _WishlistPageState createState() => _WishlistPageState();
}

class _WishlistPageState extends State<WishlistPage> with TickerProviderStateMixin {
  PageStyle pageStyle;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  GlobalKey<AnimatedListState> listKey = GlobalKey<AnimatedListState>();
  bool isDeleting = false;
  bool isAdding = false;

  @override
  Widget build(BuildContext context) {
    pageStyle = PageStyle(context, designWidth, designHeight);
    pageStyle.initializePageStyles();
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.white,
      appBar: CigaAppBar(pageStyle: pageStyle, scaffoldKey: scaffoldKey),
      drawer: CigaSideMenu(pageStyle: pageStyle),
      body: Stack(
        children: [
          Column(
            children: [
              _buildAppBar(),
              Expanded(
                child: AnimatedList(
                  key: listKey,
                  initialItemCount: products.length,
                  itemBuilder: (context, index, _) {
                    return Container(
                      width: pageStyle.deviceWidth,
                      padding: EdgeInsets.symmetric(
                        horizontal: pageStyle.unitWidth * 10,
                      ),
                      child: Column(
                        children: [
                          InkWell(
                            onTap: () => Navigator.pushNamed(
                              context,
                              Routes.product,
                              arguments: products[index],
                            ),
                            child: WishlistProductCard(
                              pageStyle: pageStyle,
                              product: products[index],
                              onRemoveWishlist: () => _onRemoveWishlist(index),
                              onAddToCart: () => _onAddToCart(index),
                            ),
                          ),
                          index < (products.length - 1) ? Divider(color: greyColor, thickness: 0.5) : SizedBox.shrink(),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
          isDeleting
              ? Material(
                  color: Colors.black.withOpacity(0),
                  child: Center(
                    child: Lottie.asset(
                      'lib/public/animations/heart-break.json',
                      width: pageStyle.unitWidth * 100,
                      height: pageStyle.unitHeight * 100,
                    ),
                  ),
                )
              : SizedBox.shrink(),
          isAdding
              ? Material(
                  color: Colors.black.withOpacity(0),
                  child: Center(
                    child: Lottie.asset(
                      'lib/public/animations/add-to-cart-shopping.json',
                      width: pageStyle.unitWidth * 200,
                      height: pageStyle.unitHeight * 200,
                    ),
                  ),
                )
              : SizedBox.shrink(),
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
            'account_wishlist_title'.tr(),
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

  void _onRemoveWishlist(int index) async {
    final result = await showDialog(
      context: context,
      builder: (context) {
        return WishlistRemoveDialog(pageStyle: pageStyle);
      },
    );
    if (result != null) {
      Timer.periodic(
        AnimationDurations.removeFavoriteItemAniDuration,
        (timer) {
          timer.cancel();
          isDeleting = false;
          setState(() {});
        },
      );
      listKey.currentState.removeItem(
        index,
        (context, animation) {
          return Container();
        },
        duration: AnimationDurations.removeFavoriteItemAniDuration,
      );
      isDeleting = true;
      setState(() {});
    }
  }

  void _onAddToCart(int index) async {
    isAdding = true;
    setState(() {});
    Timer.periodic(
      AnimationDurations.addToCartAniDuration,
      (timer) {
        timer.cancel();
        isAdding = false;
        setState(() {});
      },
    );
    listKey.currentState.removeItem(
      index,
      (context, animation) {
        return Container(
          width: pageStyle.deviceWidth,
          height: pageStyle.unitHeight * 260,
          padding: EdgeInsets.symmetric(vertical: pageStyle.unitHeight * 20),
          child: Container(
            width: pageStyle.deviceWidth,
            padding: EdgeInsets.symmetric(
              horizontal: pageStyle.unitWidth * 10,
            ),
            child: Column(
              children: [
                WishlistProductCard(
                  pageStyle: pageStyle,
                  product: products[index],
                  onRemoveWishlist: () => null,
                  onAddToCart: () => null,
                ),
                index < (products.length - 1) ? Divider(color: greyColor, thickness: 0.5) : SizedBox.shrink(),
              ],
            ),
          ),
        );
      },
      duration: Duration(seconds: 2),
    );
    _showFlashBar(products[index]);
  }

  void _showFlashBar(ProductEntity product) {
    Flushbar(
      messageText: Container(
        width: pageStyle.unitWidth * 300,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  style: boldTextStyle.copyWith(
                    color: Colors.white,
                    fontSize: pageStyle.unitFontSize * 15,
                  ),
                ),
                Text(
                  product.name,
                  style: mediumTextStyle.copyWith(
                    color: Colors.white,
                    fontSize: pageStyle.unitFontSize * 12,
                  ),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  'Cart Total',
                  style: mediumTextStyle.copyWith(
                    color: Colors.white,
                    fontSize: pageStyle.unitFontSize * 13,
                  ),
                ),
                Text(
                  'KD 460',
                  style: mediumTextStyle.copyWith(
                    color: Colors.white,
                    fontSize: pageStyle.unitFontSize * 13,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      icon: SvgPicture.asset(
        orderedSuccessIcon,
        width: pageStyle.unitWidth * 20,
        height: pageStyle.unitHeight * 20,
      ),
      duration: Duration(seconds: 3),
      leftBarIndicatorColor: Colors.blue[100],
      flushbarPosition: FlushbarPosition.TOP,
      backgroundColor: primaryColor,
    )..show(context);
  }
}
