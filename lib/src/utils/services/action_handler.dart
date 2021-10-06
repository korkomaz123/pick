import 'package:adjust_sdk/adjust.dart';
import 'package:adjust_sdk/adjust_event.dart';
import 'package:flutter/material.dart';
import 'package:markaa/src/components/custom/sliding_sheet.dart';
import 'package:markaa/src/components/markaa_cart_added_success_dialog.dart';
import 'package:markaa/src/config/config.dart';
import 'package:markaa/src/data/models/index.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

class ActionHandler {
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
          duration: Duration(milliseconds: 500),
          builder: (context, state) {
            return MarkaaCartAddedSuccessDialog(product: item);
          },
        );
      },
    );

    /// Send the tag to onesignal for adding item to cart
    // OneSignal.shared.sendTags({
    //   'cart_update': DateTime.now().microsecondsSinceEpoch,
    //   'product_name': item.name,
    //   'product_image': item.imageUrl
    // });

    /// Trigger the adjust event for adding item to cart
    AdjustEvent adjustEvent = new AdjustEvent(AdjustSDKConfig.addToCart);
    Adjust.trackEvent(adjustEvent);
  }
}
