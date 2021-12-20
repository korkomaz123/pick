import 'package:markaa/src/change_notifier/wishlist_change_notifier.dart';
import 'package:markaa/src/components/markaa_app_bar.dart';
import 'package:markaa/src/components/markaa_bottom_bar.dart';
import 'package:markaa/src/components/markaa_side_menu.dart';
import 'package:markaa/src/components/no_available_data.dart';
import 'package:markaa/src/data/mock/mock.dart';
import 'package:markaa/src/data/models/index.dart';
import 'package:markaa/src/pages/wishlist/widgets/wishlist_product_card.dart';
import 'package:markaa/src/routes/routes.dart';
import 'package:markaa/src/theme/styles.dart';
import 'package:markaa/src/theme/theme.dart';
import 'package:markaa/src/change_notifier/my_cart_change_notifier.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:markaa/src/utils/services/action_handler.dart';
import 'package:markaa/src/utils/services/flushbar_service.dart';
import 'package:markaa/src/utils/services/progress_service.dart';
import 'package:provider/provider.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

class WishlistPage extends StatefulWidget {
  @override
  _WishlistPageState createState() => _WishlistPageState();
}

class _WishlistPageState extends State<WishlistPage> with TickerProviderStateMixin {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<AnimatedListState> listKey = GlobalKey<AnimatedListState>();
  ProgressService? progressService;
  FlushBarService? flushBarService;
  MyCartChangeNotifier? myCartChangeNotifier;
  WishlistChangeNotifier? wishlistChangeNotifier;

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
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.white,
      appBar: MarkaaAppBar(
        scaffoldKey: scaffoldKey,
        isCenter: false,
      ),
      drawer: MarkaaSideMenu(),
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
        activeItem: BottomEnum.wishlist,
      ),
    );
  }

  Widget _buildAppBar() {
    return Container(
      width: 375.w,
      height: 40.h,
      color: primarySwatchColor,
      padding: EdgeInsets.only(
        left: 10.w,
        right: 10.w,
        bottom: 10.h,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
            child: Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
              size: 20.sp,
            ),
            onTap: () => Navigator.pop(context),
          ),
          Text(
            'account_wishlist_title'.tr(),
            style: mediumTextStyle.copyWith(
              color: Colors.white,
              fontSize: 17.sp,
            ),
          ),
          SizedBox.shrink(),
        ],
      ),
    );
  }

  Widget _buildWishlistItems() {
    final keys = wishlistChangeNotifier!.wishlistItemsMap.keys.toList();
    return Expanded(
      child: ListView.builder(
        itemCount: wishlistChangeNotifier!.wishlistItemsCount,
        itemBuilder: (context, index) {
          final product = wishlistChangeNotifier!.wishlistItemsMap[keys[index]];
          return Container(
            width: 375.w,
            padding: EdgeInsets.symmetric(horizontal: 10.w),
            child: Column(
              children: [
                InkWell(
                  onTap: () => Navigator.pushNamed(
                    context,
                    Routes.product,
                    arguments: product,
                  ),
                  child: WishlistProductCard(
                    product: product!,
                    onRemoveWishlist: () => _onRemoveWishlist(product, true),
                    onAddToCart: () => _onAddToCart(product),
                  ),
                ),
                index < (wishlistChangeNotifier!.wishlistItemsCount - 1)
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
      result = await flushBarService!.showConfirmDialog(message: 'wishlist_remove_item_dialog_text');
    }
    if (result != null || !ask) {
      await wishlistChangeNotifier!.removeItemFromWishlist(user!.token, product);
    }
  }

  void _onAddToCart(ProductModel product) {
    wishlistChangeNotifier!.removeItemFromWishlist(user!.token, product);
    myCartChangeNotifier!.addProductToCart(product, 1, lang, {},
        onProcess: _onAdding, onSuccess: () => _onAddSuccess(product), onFailure: _onAddFailure);
  }

  _onAdding() {
    progressService!.addingProductProgress();
  }

  void _onAddSuccess(ProductModel product) {
    progressService!.hideProgress();
    ActionHandler.addedItemToCartSuccess(context, product);
  }

  _onAddFailure(String message) {
    progressService!.hideProgress();
    flushBarService!.showErrorDialog(message, "no_qty.svg");
  }
}
