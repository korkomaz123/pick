import 'package:ciga/src/theme/styles.dart';
import 'package:ciga/src/theme/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:isco_custom_widgets/isco_custom_widgets.dart';

class ShippingAddressRemoveDialog extends StatelessWidget {
  final PageStyle pageStyle;

  ShippingAddressRemoveDialog({this.pageStyle});

  @override
  Widget build(BuildContext context) {
    return CupertinoAlertDialog(
      title: Text(
        'remove_shipping_address_title'.tr(),
        textAlign: TextAlign.center,
        style: bookTextStyle.copyWith(
          fontSize: pageStyle.unitFontSize * 26,
          color: Colors.black,
        ),
      ),
      content: Text(
        'remove_shipping_address_subtitle'.tr(),
        textAlign: TextAlign.center,
        style: bookTextStyle.copyWith(
          fontSize: pageStyle.unitFontSize * 15,
          color: Colors.black87,
        ),
      ),
      actions: [
        FlatButton(
          onPressed: () => Navigator.pop(context, 'yes'),
          child: Text(
            'yes_button_title'.tr(),
            style: bookTextStyle.copyWith(
              fontSize: pageStyle.unitFontSize * 18,
              color: primaryColor,
            ),
          ),
        ),
        FlatButton(
          onPressed: () => Navigator.pop(context),
          child: Text(
            'no_button_title'.tr(),
            style: bookTextStyle.copyWith(
              fontSize: pageStyle.unitFontSize * 18,
              color: primaryColor,
            ),
          ),
        ),
      ],
    );
    // return Dialog(
    //   backgroundColor: primaryColor,
    //   shape: RoundedRectangleBorder(
    //     borderRadius: BorderRadius.circular(pageStyle.unitWidth * 10),
    //   ),
    //   child: Container(
    //     padding: EdgeInsets.symmetric(
    //       horizontal: pageStyle.unitWidth * 15,
    //       vertical: pageStyle.unitHeight * 20,
    //     ),
    //     child: Column(
    //       mainAxisAlignment: MainAxisAlignment.center,
    //       crossAxisAlignment: CrossAxisAlignment.center,
    //       mainAxisSize: MainAxisSize.min,
    //       children: [
    //         Text(
    //           'wishlist_remove_item_dialog_title'.tr(),
    //           textAlign: TextAlign.center,
    //           style: bookTextStyle.copyWith(
    //             fontSize: pageStyle.unitFontSize * 26,
    //             color: Colors.white,
    //           ),
    //         ),
    //         SizedBox(height: pageStyle.unitHeight * 6),
    //         Text(
    //           'wishlist_remove_item_dialog_text'.tr(),
    //           textAlign: TextAlign.center,
    //           style: bookTextStyle.copyWith(
    //             fontSize: pageStyle.unitFontSize * 15,
    //             color: Colors.white,
    //           ),
    //         ),
    //         SizedBox(height: pageStyle.unitHeight * 10),
    //         Row(
    //           mainAxisAlignment: MainAxisAlignment.center,
    //           children: [
    //             FlatButton(
    //               onPressed: () => Navigator.pop(context, 'yes'),
    //               child: Text(
    //                 'yes_button_title'.tr(),
    //                 style: bookTextStyle.copyWith(
    //                   fontSize: pageStyle.unitFontSize * 18,
    //                   color: Colors.white,
    //                 ),
    //               ),
    //             ),
    //             Container(
    //               height: 24,
    //               child: VerticalDivider(
    //                 thickness: 0.5,
    //                 color: Colors.white,
    //               ),
    //             ),
    //             FlatButton(
    //               onPressed: () => Navigator.pop(context),
    //               child: Text(
    //                 'no_button_title'.tr(),
    //                 style: bookTextStyle.copyWith(
    //                   fontSize: pageStyle.unitFontSize * 18,
    //                   color: Colors.white,
    //                 ),
    //               ),
    //             ),
    //           ],
    //         ),
    //       ],
    //     ),
    //   ),
    // );
  }
}
