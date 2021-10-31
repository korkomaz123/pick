import 'package:adjust_sdk/adjust.dart';
import 'package:adjust_sdk/adjust_event.dart';
import 'package:flutter/material.dart';
import 'package:markaa/src/config/config.dart';
import 'package:markaa/src/data/models/index.dart';
import 'package:markaa/src/components/markaa_cart_added_success_dialog.dart';

import 'package:top_sliding_sheet/top_sliding_sheet.dart';

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
}
