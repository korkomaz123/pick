import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:isco_custom_widgets/isco_custom_widgets.dart';
import 'package:markaa/src/change_notifier/my_cart_change_notifier.dart';
import 'package:markaa/src/change_notifier/wishlist_change_notifier.dart';
import 'package:markaa/src/data/mock/mock.dart';
import 'package:markaa/src/data/models/product_model.dart';
import 'package:markaa/src/theme/styles.dart';
import 'package:markaa/src/theme/theme.dart';
import 'package:markaa/src/theme/icons.dart';
import 'package:markaa/src/utils/flushbar_service.dart';
import 'package:markaa/src/utils/progress_service.dart';
import 'my_cart_remove_dialog.dart';

class MyCartSaveForLaterItems extends StatefulWidget {
  final PageStyle pageStyle;
  final ProgressService progressService;
  final FlushBarService flushBarService;
  final MyCartChangeNotifier myCartChangeNotifier;
  final WishlistChangeNotifier wishlistChangeNotifier;

  MyCartSaveForLaterItems({
    this.pageStyle,
    this.progressService,
    this.flushBarService,
    this.myCartChangeNotifier,
    this.wishlistChangeNotifier,
  });

  @override
  _MyCartSaveForLaterItemsState createState() =>
      _MyCartSaveForLaterItemsState();
}

class _MyCartSaveForLaterItemsState extends State<MyCartSaveForLaterItems> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<WishlistChangeNotifier>(
      builder: (_, model, __) {
        if (model.wishlistItemsCount > 0) {
          final keys = model.wishlistItemsMap.keys.toList();
          return Container(
            width: widget.pageStyle.deviceWidth,
            color: backgroundColor,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: widget.pageStyle.deviceWidth,
                  color: Colors.white,
                  padding: EdgeInsets.only(
                    left: widget.pageStyle.unitWidth * 10,
                    right: widget.pageStyle.unitWidth * 10,
                    top: widget.pageStyle.unitHeight * 20,
                    bottom: widget.pageStyle.unitHeight * 10,
                  ),
                  child: Text(
                    'save_for_later'.tr(),
                    style: mediumTextStyle.copyWith(
                      fontSize: widget.pageStyle.unitFontSize * 19,
                      color: greyDarkColor,
                    ),
                  ),
                ),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(
                    vertical: widget.pageStyle.unitHeight * 10,
                  ),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: List.generate(
                        model.wishlistItemsCount,
                        (index) {
                          final item = model.wishlistItemsMap[keys[index]];
                          return _buildItem(item);
                        },
                      ),
                    ),
                  ),
                ),
                Container(
                  width: widget.pageStyle.deviceWidth,
                  height: widget.pageStyle.unitHeight * 60,
                  color: Colors.white,
                ),
              ],
            ),
          );
        }
        return Container();
      },
    );
  }

  Widget _buildItem(ProductModel item) {
    return Container(
      width: widget.pageStyle.unitWidth * 180,
      height: widget.pageStyle.unitHeight * 300,
      margin: EdgeInsets.only(left: widget.pageStyle.unitWidth * 10),
      padding: EdgeInsets.all(widget.pageStyle.unitWidth * 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(widget.pageStyle.unitFontSize * 4),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                onTap: () => _onRemoveItem(item),
                child: Icon(
                  Icons.remove_circle_outline,
                  size: widget.pageStyle.unitFontSize * 22,
                  color: greyDarkColor,
                ),
              ),
              InkWell(
                onTap: () => _onPutInCart(item),
                child: SvgPicture.asset(
                    lang == 'en' ? putInCartEnIcon : putInCartArIcon),
              ),
            ],
          ),
          Image.network(
            item.imageUrl,
            width: widget.pageStyle.unitWidth * 140,
            height: widget.pageStyle.unitHeight * 160,
            fit: BoxFit.fitHeight,
          ),
          Expanded(
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.only(top: widget.pageStyle.unitHeight * 5),
              child: Text(
                item.name,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: mediumTextStyle.copyWith(
                  fontSize: widget.pageStyle.unitFontSize * 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          Divider(color: darkColor),
          Container(
            width: double.infinity,
            child: Text(
              item.price + 'currency'.tr(),
              style: mediumTextStyle.copyWith(
                color: greyColor,
                fontSize: widget.pageStyle.unitFontSize * 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _onRemoveItem(ProductModel item) async {
    final result = await showDialog(
      context: context,
      builder: (context) {
        return MyCartRemoveDialog(
          pageStyle: widget.pageStyle,
          title: 'my_cart_remove_item_dialog_title'.tr(),
          text: 'my_cart_save_later_remove_item_dialog_text'.tr(),
        );
      },
    );
    if (result != null) {
      await widget.wishlistChangeNotifier
          .removeItemFromWishlist(user.token, item.productId);
    }
  }

  void _onPutInCart(ProductModel item) async {
    await widget.wishlistChangeNotifier
        .removeItemFromWishlist(user.token, item.productId);
    await widget.myCartChangeNotifier.addProductToCart(
        context, widget.pageStyle, item, item.qtySaveForLater);
  }
}
