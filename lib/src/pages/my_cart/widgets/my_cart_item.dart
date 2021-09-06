import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:markaa/preload.dart';
import 'package:markaa/src/change_notifier/markaa_app_change_notifier.dart';
import 'package:markaa/src/change_notifier/my_cart_change_notifier.dart';
import 'package:markaa/src/data/mock/mock.dart';
import 'package:markaa/src/data/models/index.dart';
import 'package:markaa/src/data/models/product_list_arguments.dart';
import 'package:markaa/src/pages/my_cart/widgets/my_cart_shop_counter.dart';
import 'package:markaa/src/routes/routes.dart';
import 'package:markaa/src/theme/icons.dart';
import 'package:markaa/src/theme/styles.dart';
import 'package:markaa/src/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:markaa/src/utils/services/string_service.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MyCartItem extends StatelessWidget {
  final CartItemEntity cartItem;
  final double discount;
  final String type;
  final String cartId;
  final Function onRemoveCartItem;
  final Function onSaveForLaterItem;
  final Function onSignIn;
  final MyCartChangeNotifier myCartChangeNotifier;

  MyCartItem({
    this.cartItem,
    this.discount,
    this.type,
    this.cartId,
    this.onRemoveCartItem,
    this.onSaveForLaterItem,
    this.onSignIn,
    this.myCartChangeNotifier,
  });

  bool get discountable => discount != 0 && type == 'percentage';

  @override
  Widget build(BuildContext context) {
    double price = StringService.roundDouble(cartItem.product.price, 3);
    double discountPrice = context
        .watch<MyCartChangeNotifier>()
        .getDiscountedPrice(cartItem, isRowPrice: false);
    bool discounted = price > discountPrice;
    return Stack(
      children: [
        Container(
          width: double.infinity,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                height: 150.h,
                alignment: Alignment.topCenter,
                child: InkWell(
                  onTap: onRemoveCartItem,
                  child: SvgPicture.asset(
                    trashIcon,
                    width: 16.w,
                    color: greyColor,
                  ),
                ),
              ),
              CachedNetworkImage(
                imageUrl: cartItem.product.imageUrl,
                width: 104.w,
                height: 150.h,
                fit: BoxFit.fitHeight,
                errorWidget: (_, __, ___) {
                  return Center(child: Icon(Icons.image, size: 20.sp));
                },
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: () {
                        if (cartItem?.product?.brandEntity?.optionId != null) {
                          ProductListArguments arguments = ProductListArguments(
                            category: CategoryEntity(),
                            subCategory: [],
                            brand: cartItem.product.brandEntity,
                            selectedSubCategoryIndex: 0,
                            isFromBrand: true,
                          );
                          Navigator.pushNamed(
                            context,
                            Routes.productList,
                            arguments: arguments,
                          );
                        }
                      },
                      child: Text(
                        cartItem?.product?.brandEntity?.brandLabel ?? '',
                        style: mediumTextStyle.copyWith(
                          color: primaryColor,
                          fontSize: 10.sp,
                        ),
                      ),
                    ),
                    Text(
                      cartItem.product.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: mediumTextStyle.copyWith(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 5.h),
                    Text(
                      cartItem.product.shortDescription,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: mediumTextStyle.copyWith(
                        color: greyColor,
                        fontSize: 12.sp,
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          discountable
                              ? '$discountPrice ${'currency'.tr()}'
                              : '$price ${'currency'.tr()}',
                          style: mediumTextStyle.copyWith(
                            fontSize: 12.sp,
                            color: greyColor,
                          ),
                        ),
                        SizedBox(width: 20.w),
                        Text(
                          discounted ? '$price ${'currency'.tr()}' : '',
                          style: mediumTextStyle.copyWith(
                            decorationStyle: TextDecorationStyle.solid,
                            decoration: TextDecoration.lineThrough,
                            decorationColor: dangerColor,
                            fontSize: 12.sp,
                            color: greyColor,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildSaveForLaterTextButton(),
                        if (cartItem.availableCount > 0) ...[
                          MyCartShopCounter(
                            cartItem: cartItem,
                            cartId: cartId,
                          ),
                        ]
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        if (cartItem.availableCount == 0) ...[_buildOutOfStock()],
        if (discounted) ...[
          Align(
            alignment: Preload.language == 'en'
                ? Alignment.topRight
                : Alignment.topLeft,
            child: Tooltip(
              message: 'coupon_apply_notice'
                  .tr()
                  .replaceFirst('[code]', myCartChangeNotifier.couponCode),
              child: Icon(Icons.help_outline, color: dangerColor, size: 20.sp),
              waitDuration: Duration(milliseconds: 100),
              showDuration: Duration(milliseconds: 3000),
            ),
          )
        ],
      ],
    );
  }

  Widget _buildSaveForLaterTextButton() {
    return Consumer<MarkaaAppChangeNotifier>(
      builder: (_, model, ___) {
        if (model.activeSaveForLater) {
          return InkWell(
            onTap: () {
              if (user?.token != null) {
                model.changeSaveForLaterStatus(false);
                onSaveForLaterItem();
                model.changeSaveForLaterStatus(true);
              } else {
                onSignIn();
              }
            },
            child: Text(
              'save_for_later'.tr(),
              style: mediumTextStyle.copyWith(
                fontSize: 12.sp,
                color: primaryColor,
              ),
            ),
          );
        } else {
          return Text(
            'save_for_later'.tr(),
            style: mediumTextStyle.copyWith(
              fontSize: 12.sp,
              color: primaryColor,
            ),
          );
        }
      },
    );
  }

  Widget _buildOutOfStock() {
    return Positioned(
      top: 50.h,
      right: 0,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 15.w,
          vertical: 5.h,
        ),
        color: primarySwatchColor.withOpacity(0.4),
        child: Text(
          'out_stock'.tr(),
          style: mediumTextStyle.copyWith(
            fontSize: 14.sp,
            color: Colors.white70,
          ),
        ),
      ),
    );
  }
}
