import 'package:markaa/src/data/models/product_model.dart';
import 'package:markaa/src/theme/icons.dart';
import 'package:markaa/src/theme/styles.dart';
import 'package:markaa/src/theme/theme.dart';
import 'package:markaa/src/change_notifier/my_cart_change_notifier.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:isco_custom_widgets/isco_custom_widgets.dart';

class FlushBarService {
  final BuildContext context;

  FlushBarService({this.context});

  void showAddCartMessage(PageStyle pageStyle, ProductModel product) {
    Flushbar(
      margin: EdgeInsets.symmetric(
        horizontal: pageStyle.unitWidth * 10,
        vertical: pageStyle.unitHeight * 5,
      ),
      borderRadius: pageStyle.unitFontSize * 10,
      messageText: Container(
        width: pageStyle.unitWidth * 300,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                product.name,
                style: mediumTextStyle.copyWith(
                  color: primaryColor,
                  fontSize: pageStyle.unitFontSize * 15,
                ),
              ),
            ),
            Consumer<MyCartChangeNotifier>(builder: (_, model, ___) {
              return Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'cart_total'.tr(),
                      style: mediumTextStyle.copyWith(
                        color: primaryColor,
                        fontSize: pageStyle.unitFontSize * 13,
                      ),
                    ),
                    Text(
                      'currency'.tr() +
                          ' ${model.cartTotalPrice.toStringAsFixed(3)}',
                      style: mediumTextStyle.copyWith(
                        color: primaryColor,
                        fontSize: pageStyle.unitFontSize * 13,
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
      icon: SvgPicture.asset(
        orderedSuccessIcon,
        width: pageStyle.unitWidth * 20,
        height: pageStyle.unitHeight * 20,
      ),
      duration: Duration(seconds: 3),
      flushbarPosition: FlushbarPosition.TOP,
      backgroundColor: Colors.white,
    )..show(context);
  }

  void showErrorMessage(PageStyle pageStyle, String message) {
    Flushbar(
      messageText: Text(
        message,
        style: mediumTextStyle.copyWith(
          color: Colors.white,
          fontSize: pageStyle.unitFontSize * 15,
        ),
      ),
      icon: Icon(Icons.error, color: Colors.white),
      duration: Duration(seconds: 3),
      leftBarIndicatorColor: dangerColor.withOpacity(0.6),
      flushbarPosition: FlushbarPosition.BOTTOM,
      backgroundColor: dangerColor,
    )..show(context);
  }

  void showSuccessMessage(PageStyle pageStyle, String message) {
    Flushbar(
      messageText: Text(
        message,
        style: mediumTextStyle.copyWith(
          color: Colors.white,
          fontSize: pageStyle.unitFontSize * 15,
        ),
      ),
      icon: Icon(Icons.check, color: Colors.white),
      duration: Duration(seconds: 3),
      leftBarIndicatorColor: succeedColor.withOpacity(0.6),
      flushbarPosition: FlushbarPosition.BOTTOM,
      backgroundColor: succeedColor,
    )..show(context);
  }

  void showInformMessage(PageStyle pageStyle, String message) {
    Flushbar(
      messageText: Text(
        message,
        style: mediumTextStyle.copyWith(
          color: Colors.white,
          fontSize: pageStyle.unitFontSize * 15,
        ),
      ),
      icon: Icon(Icons.info, color: Colors.white),
      duration: Duration(seconds: 3),
      leftBarIndicatorColor: primarySwatchColor.withOpacity(0.6),
      flushbarPosition: FlushbarPosition.BOTTOM,
      backgroundColor: primarySwatchColor,
    )..show(context);
  }
}