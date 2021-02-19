import 'package:markaa/src/change_notifier/wishlist_change_notifier.dart';
import 'package:markaa/src/components/markaa_app_bar.dart';
import 'package:markaa/src/components/markaa_bottom_bar.dart';
import 'package:markaa/src/components/markaa_side_menu.dart';
import 'package:markaa/src/components/no_available_data.dart';
import 'package:markaa/src/config/config.dart';
import 'package:markaa/src/data/mock/mock.dart';
import 'package:markaa/src/data/models/enum.dart';
import 'package:markaa/src/data/models/index.dart';
import 'package:markaa/src/data/models/product_model.dart';
import 'package:markaa/src/pages/wishlist/widgets/wishlist_product_card.dart';
import 'package:markaa/src/routes/routes.dart';
import 'package:markaa/src/theme/styles.dart';
import 'package:markaa/src/theme/theme.dart';
import 'package:markaa/src/utils/flushbar_service.dart';
import 'package:markaa/src/utils/progress_service.dart';
import 'package:markaa/src/change_notifier/my_cart_change_notifier.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isco_custom_widgets/isco_custom_widgets.dart';

import 'widgets/wishlist_remove_dialog.dart';

class WishlistPage extends StatefulWidget {
  @override
  _WishlistPageState createState() => _WishlistPageState();
}

class _WishlistPageState extends State<WishlistPage>
    with TickerProviderStateMixin {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<AnimatedListState> listKey = GlobalKey<AnimatedListState>();
  PageStyle pageStyle;
  ProgressService progressService;
  FlushBarService flushBarService;
  MyCartChangeNotifier myCartChangeNotifier;
  WishlistChangeNotifier wishlistChangeNotifier;

  @override
  void initState() {
    super.initState();
    progressService = ProgressService(context: context);
    flushBarService = FlushBarService(context: context);
    myCartChangeNotifier = context.read<MyCartChangeNotifier>();
    wishlistChangeNotifier = context.read<WishlistChangeNotifier>();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    pageStyle = PageStyle(context, designWidth, designHeight);
    pageStyle.initializePageStyles();
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.white,
      appBar: MarkaaAppBar(
        pageStyle: pageStyle,
        scaffoldKey: scaffoldKey,
        isCenter: false,
      ),
      drawer: MarkaaSideMenu(pageStyle: pageStyle),
      body: Stack(
        children: [
          Column(
            children: [
              _buildAppBar(),
              Consumer<WishlistChangeNotifier>(
                builder: (_, model, ___) {
                  if (model.wishlistItemsCount > 0) {
                    return _buildWishlistItems();
                  } else {
                    return Expanded(
                      child: NoAvailableData(
                        pageStyle: pageStyle,
                        message: 'wishlist_empty',
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        ],
      ),
      bottomNavigationBar: MarkaaBottomBar(
        pageStyle: pageStyle,
        activeItem: BottomEnum.wishlist,
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
            style: mediumTextStyle.copyWith(
              color: Colors.white,
              fontSize: pageStyle.unitFontSize * 17,
            ),
          ),
          SizedBox.shrink(),
        ],
      ),
    );
  }

  Widget _buildWishlistItems() {
    final keys = wishlistChangeNotifier.wishlistItemsMap.keys.toList();
    return Expanded(
      child: ListView.builder(
        itemCount: wishlistChangeNotifier.wishlistItemsCount,
        itemBuilder: (context, index) {
          final product = wishlistChangeNotifier.wishlistItemsMap[keys[index]];
          return Container(
            width: pageStyle.deviceWidth,
            padding: EdgeInsets.symmetric(horizontal: pageStyle.unitWidth * 10),
            child: Column(
              children: [
                InkWell(
                  onTap: () => Navigator.pushNamed(
                    context,
                    Routes.product,
                    arguments: product,
                  ),
                  child: WishlistProductCard(
                    pageStyle: pageStyle,
                    product: product,
                    onRemoveWishlist: () => _onRemoveWishlist(product, true),
                    onAddToCart: () => _onAddToCart(product),
                  ),
                ),
                index < (wishlistChangeNotifier.wishlistItemsCount - 1)
                    ? Divider(color: greyColor, thickness: 0.5)
                    : SizedBox.shrink(),
              ],
            ),
          );
        },
      ),
    );
  }

  void _onRemoveWishlist(ProductModel product, bool ask) async {
    var result;
    if (ask) {
      result = await showDialog(
        context: context,
        builder: (context) {
          return WishlistRemoveDialog(pageStyle: pageStyle);
        },
      );
    }
    if (result != null || !ask) {
      await wishlistChangeNotifier.removeItemFromWishlist(
          user.token, product.productId);
    }
  }

  void _onAddToCart(ProductModel product) async {
    await wishlistChangeNotifier.removeItemFromWishlist(
        user.token, product.productId);
    await myCartChangeNotifier.addProductToCart(context, pageStyle, product, 1);
  }
}
