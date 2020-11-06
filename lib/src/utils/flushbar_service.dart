import 'package:ciga/src/data/models/product_model.dart';
import 'package:ciga/src/theme/icons.dart';
import 'package:ciga/src/theme/styles.dart';
import 'package:ciga/src/theme/theme.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:isco_custom_widgets/isco_custom_widgets.dart';

class FlushBarService {
  final BuildContext context;

  FlushBarService({this.context});

  void showAddCartMessage(PageStyle pageStyle, ProductModel product) {
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

  void showErrorMessage(PageStyle pageStyle, String message) {
    Flushbar(
      messageText: Text(
        message,
        style: boldTextStyle.copyWith(
          color: Colors.white,
          fontSize: pageStyle.unitFontSize * 15,
        ),
      ),
      icon: Icon(Icons.error, color: Colors.white),
      duration: Duration(seconds: 3),
      leftBarIndicatorColor: dangerColor.withOpacity(0.6),
      flushbarPosition: FlushbarPosition.TOP,
      backgroundColor: dangerColor,
    )..show(context);
  }
}
