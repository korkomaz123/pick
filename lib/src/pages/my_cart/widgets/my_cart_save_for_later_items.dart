import 'package:adjust_sdk/adjust.dart';
import 'package:adjust_sdk/adjust_event.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:markaa/src/change_notifier/markaa_app_change_notifier.dart';
import 'package:markaa/src/config/config.dart';
import 'package:markaa/src/utils/services/flushbar_service.dart';
import 'package:markaa/src/utils/services/progress_service.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:markaa/src/change_notifier/my_cart_change_notifier.dart';
import 'package:markaa/src/change_notifier/wishlist_change_notifier.dart';
import 'package:markaa/src/data/mock/mock.dart';
import 'package:markaa/src/data/models/product_model.dart';
import 'package:markaa/src/theme/styles.dart';
import 'package:markaa/src/theme/theme.dart';
import 'package:markaa/src/theme/icons.dart';
import 'my_cart_remove_dialog.dart';

class MyCartSaveForLaterItems extends StatefulWidget {
  final ProgressService progressService;
  final FlushBarService flushBarService;
  final MyCartChangeNotifier myCartChangeNotifier;
  final WishlistChangeNotifier wishlistChangeNotifier;

  MyCartSaveForLaterItems({
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
  FlushBarService _flushBarService;

  @override
  void initState() {
    super.initState();

    _flushBarService = FlushBarService(context: context);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<WishlistChangeNotifier>(
      builder: (_, model, __) {
        if (model.wishlistItemsCount > 0) {
          final keys = model.wishlistItemsMap.keys.toList();
          return Container(
            width: 375.w,
            color: backgroundColor,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 375.w,
                  color: Colors.white,
                  padding: EdgeInsets.only(
                    left: 10.w,
                    right: 10.w,
                    top: 20.h,
                    bottom: 10.h,
                  ),
                  child: Text(
                    'save_for_later'.tr(),
                    style: mediumTextStyle.copyWith(
                      fontSize: 19.sp,
                      color: greyDarkColor,
                    ),
                  ),
                ),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(
                    vertical: 10.h,
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
                  width: 375.w,
                  height: 60.h,
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
      width: 180.w,
      height: 300.h,
      margin: EdgeInsets.only(left: 10.w),
      padding: EdgeInsets.all(10.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4.sp),
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
                  size: 22.sp,
                  color: greyDarkColor,
                ),
              ),
              Consumer<MarkaaAppChangeNotifier>(
                builder: (_, model, __) {
                  return InkWell(
                    onTap: () {
                      if (model.activePutInCart) {
                        model.changePutInCartStatus(false);
                        _onPutInCart(item);
                        model.changePutInCartStatus(true);
                      }
                    },
                    child: SvgPicture.asset(
                        lang == 'en' ? putInCartEnIcon : putInCartArIcon),
                  );
                },
              ),
            ],
          ),
          CachedNetworkImage(
            imageUrl: item.imageUrl,
            width: 140.w,
            height: 160.h,
            fit: BoxFit.fitHeight,
            errorWidget: (_, __, ___) {
              return Center(child: Icon(Icons.image, size: 20.sp));
            },
          ),
          Expanded(
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.only(top: 5.h),
              child: Text(
                item.name,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: mediumTextStyle.copyWith(
                  fontSize: 12.sp,
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
                fontSize: 12.sp,
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
          title: 'my_cart_remove_item_dialog_title'.tr(),
          text: 'my_cart_save_later_remove_item_dialog_text'.tr(),
        );
      },
    );
    if (result != null) {
      await widget.wishlistChangeNotifier
          .removeItemFromWishlist(user.token, item);
    }
  }

  void _onPutInCart(ProductModel item) async {
    widget.wishlistChangeNotifier.removeItemFromWishlist(user.token, item);
    widget.myCartChangeNotifier.addProductToCart(
        item, item.qtySaveForLater, lang, {},
        onSuccess: () => _onAddSuccess(item), onFailure: _onAddFailure);
  }

  void _onAddSuccess(ProductModel item) {
    _flushBarService.showAddCartMessage(item);

    AdjustEvent adjustEvent = new AdjustEvent(AdjustSDKConfig.addToCart);
    Adjust.trackEvent(adjustEvent);
  }

  _onAddFailure(String message) {
    _flushBarService.showErrorMessage(message);
  }
}
