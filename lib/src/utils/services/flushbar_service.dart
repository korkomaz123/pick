import 'package:cool_alert/cool_alert.dart';
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
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FlushBarService {
  final BuildContext context;

  FlushBarService({this.context});

  void showAddCartMessage(ProductModel product) {
    Flushbar(
      margin: EdgeInsets.symmetric(
        horizontal: 10.w,
        vertical: 5.h,
      ),
      borderRadius: 10.sp,
      messageText: Container(
        width: 300.w,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                product.name,
                style: mediumTextStyle.copyWith(
                  color: primaryColor,
                  fontSize: 15.sp,
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
                        fontSize: 13.sp,
                      ),
                    ),
                    Text(
                      'currency'.tr() + ' ${model.cartTotalPrice.toStringAsFixed(3)}',
                      style: mediumTextStyle.copyWith(
                        color: primaryColor,
                        fontSize: 13.sp,
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
        width: 20.w,
        height: 20.h,
      ),
      duration: Duration(seconds: 3),
      flushbarPosition: FlushbarPosition.TOP,
      backgroundColor: Colors.white,
      boxShadows: [
        BoxShadow(
          blurRadius: 3.h,
          spreadRadius: 1.h,
          offset: Offset(0, 1),
          color: greyLightColor,
        ),
      ],
    )..show(context);
  }

  showSimpleErrorMessageWithImage(String message, String image) {
    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        children: [
          Container(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [Image.asset("lib/public/images/$image"), SizedBox(width: 10.w), Text(message)],
              ),
            ),
          ),
          Center(child: RaisedButton(color: Colors.white, onPressed: Navigator.of(context).pop, child: Text("close".tr())))
        ],
      ),
    );
  }

  void showErrorMessage(String message) {
    CoolAlert.show(
      context: context,
      type: CoolAlertType.error,
      title: 'error'.tr(),
      text: message,
      confirmBtnText: 'close'.tr(),
      confirmBtnColor: primaryColor,
      borderRadius: 2.sp,
    );
    // Flushbar(
    //   messageText: Text(
    //     message,
    //     style: mediumTextStyle.copyWith(
    //       color: Colors.white,
    //       fontSize: 15.sp,
    //     ),
    //   ),
    //   icon: Icon(Icons.error, color: Colors.white),
    //   animationDuration: Duration(milliseconds: 1000),
    //   duration: Duration(seconds: 3),
    //   leftBarIndicatorColor: dangerColor.withOpacity(0.6),
    //   flushbarPosition: FlushbarPosition.BOTTOM,
    //   backgroundColor: dangerColor,
    //   forwardAnimationCurve: Curves.easeInOut,
    // )..show(context);
  }

  void showSuccessMessage(String message) {
    Flushbar(
      messageText: Text(
        message,
        style: mediumTextStyle.copyWith(
          color: Colors.white,
          fontSize: 15.sp,
        ),
      ),
      icon: Icon(Icons.check, color: Colors.white),
      duration: Duration(seconds: 3),
      leftBarIndicatorColor: succeedColor.withOpacity(0.6),
      flushbarPosition: FlushbarPosition.BOTTOM,
      backgroundColor: succeedColor,
    )..show(context);
  }

  void showInformMessage(String message) {
    Flushbar(
      messageText: Text(
        message,
        style: mediumTextStyle.copyWith(
          color: Colors.white,
          fontSize: 15.sp,
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
