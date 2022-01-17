import 'package:adjust_sdk/adjust.dart';
import 'package:adjust_sdk/adjust_event.dart';
import 'package:flutter/material.dart';
import 'package:markaa/src/config/config.dart';
import 'package:markaa/src/data/mock/mock.dart';
import 'package:markaa/src/data/models/index.dart';
import 'package:markaa/src/components/markaa_cart_added_success_dialog.dart';
import 'package:markaa/src/routes/routes.dart';
import 'package:markaa/src/utils/repositories/product_repository.dart';

import 'package:top_sliding_sheet/top_sliding_sheet.dart';

class ActionHandler {
  static final ProductRepository _productRepository = ProductRepository();

  static addedItemToCartSuccess(BuildContext context, ProductModel item) {
    /// Display the top slider dialog
    showSlidingTopSheet(
      context,
      builder: (_) {
        return SlidingSheetDialog(
          color: Colors.white,
          elevation: 2,
          cornerRadius: 0,
          snapSpec: const SnapSpec(
            snap: true,
            snappings: [1],
            positioning: SnapPositioning.relativeToSheetHeight,
          ),
          shadowColor: Colors.black12,
          duration: Duration(milliseconds: 500),
          builder: (context, state) {
            return MarkaaCartAddedSuccessDialog(product: item);
          },
        );
      },
    );

    /// Trigger the adjust event for adding item to cart
    AdjustEvent adjustEvent = new AdjustEvent(AdjustSDKConfig.addToCart);
    Adjust.trackEvent(adjustEvent);
  }

  static onClickBanner(SliderImageEntity banner, BuildContext context) async {
    if (banner.categoryId != null) {
      final arguments = ProductListArguments(
        category: CategoryEntity(
          id: banner.categoryId!,
          name: banner.categoryName!,
        ),
        brand: null,
        subCategory: [],
        selectedSubCategoryIndex: 0,
        isFromBrand: false,
      );
      Navigator.pushNamed(context, Routes.productList, arguments: arguments);
    } else if (banner.brand != null) {
      final arguments = ProductListArguments(
        category: null,
        brand: banner.brand,
        subCategory: [],
        selectedSubCategoryIndex: 0,
        isFromBrand: true,
      );
      Navigator.pushNamed(context, Routes.productList, arguments: arguments);
    } else if (banner.productId != null) {
      final product = await _productRepository.getProduct(banner.productId!);
      Navigator.pushNamedAndRemoveUntil(
        context,
        Routes.product,
        (route) => route.settings.name == Routes.home,
        arguments: product,
      );
    } else if (banner.page != null) {
      String id = banner.page!;
      if (id == 'home') {
        Navigator.popUntil(
          context,
          (route) => route.settings.name == Routes.home,
        );
      } else if (id == 'category') {
        Navigator.pushNamed(context, Routes.categoryList);
      } else if (id == 'brand') {
        Navigator.pushNamed(context, Routes.brandList);
      } else if (id == 'cart') {
        Navigator.pushNamed(context, Routes.myCart);
      } else if (id == 'search') {
        Navigator.pushNamed(context, Routes.search);
      } else if (id == 'account') {
        if (user != null) {
          Navigator.pushNamed(context, Routes.account);
        } else {
          Navigator.pushNamed(context, Routes.signIn);
        }
      } else if (id == 'wishlist') {
        if (user != null) {
          Navigator.pushNamed(context, Routes.wishlist);
        } else {
          Navigator.pushNamed(context, Routes.signIn);
        }
      } else if (id == 'order_history') {
        if (user != null) {
          Navigator.pushNamed(context, Routes.orderHistory);
        } else {
          Navigator.pushNamed(context, Routes.signIn);
        }
      } else if (id == 'terms') {
        Navigator.pushNamed(context, Routes.terms);
      } else if (id == 'contact_us') {
        Navigator.pushNamed(context, Routes.contactUs);
      } else if (id == 'shipping_address') {
        if (user != null) {
          Navigator.pushNamed(context, Routes.shippingAddress, arguments: false);
        } else {
          Navigator.pushNamed(context, Routes.signIn);
        }
      } else if (id == 'wallet') {
        if (user != null) {
          Navigator.pushNamed(context, Routes.myWallet);
        } else {
          Navigator.pushNamed(context, Routes.signIn);
        }
      }
    }
  }
}
