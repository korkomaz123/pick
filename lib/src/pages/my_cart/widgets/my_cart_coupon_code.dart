import 'package:markaa/src/components/markaa_page_loading_kit.dart';
import 'package:markaa/src/data/mock/mock.dart';
import 'package:markaa/src/theme/icons.dart';
import 'package:markaa/src/theme/styles.dart';
import 'package:markaa/src/theme/theme.dart';
import 'package:markaa/src/change_notifier/my_cart_change_notifier.dart';
import 'package:flutter/material.dart';
import 'package:markaa/src/utils/services/flushbar_service.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:isco_custom_widgets/isco_custom_widgets.dart';

class MyCartCouponCode extends StatefulWidget {
  final PageStyle pageStyle;
  final String cartId;
  final Function onSignIn;

  MyCartCouponCode({
    this.pageStyle,
    this.cartId,
    this.onSignIn,
  });

  @override
  _MyCartCouponCodeState createState() => _MyCartCouponCodeState();
}

class _MyCartCouponCodeState extends State<MyCartCouponCode> {
  TextEditingController couponCodeController = TextEditingController();
  FocusNode couponNode = FocusNode();
  final _couponFormKey = GlobalKey<FormState>();
  MyCartChangeNotifier myCartChangeNotifier;
  FlushBarService flushBarService;

  @override
  void initState() {
    super.initState();
    flushBarService = FlushBarService(context: context);
    myCartChangeNotifier = context.read<MyCartChangeNotifier>();
    couponCodeController.text = myCartChangeNotifier.couponCode;
  }

  @override
  Widget build(BuildContext context) {
    if (myCartChangeNotifier.couponCode.isNotEmpty &&
        couponCodeController.text.isEmpty) {
      couponCodeController.text = myCartChangeNotifier.couponCode;
    }
    return Form(
      key: _couponFormKey,
      child: Container(
        width: widget.pageStyle.deviceWidth,
        padding: EdgeInsets.symmetric(
          horizontal: widget.pageStyle.unitWidth * 10,
          vertical: widget.pageStyle.unitHeight * 15,
        ),
        child: Consumer<MyCartChangeNotifier>(builder: (_, model, __) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                width: widget.pageStyle.unitWidth * 218,
                child: TextFormField(
                  controller: couponCodeController,
                  style: mediumTextStyle.copyWith(
                    color: greyColor,
                    fontSize: widget.pageStyle.unitFontSize * 15,
                  ),
                  focusNode: couponNode,
                  decoration: InputDecoration(
                    prefixIcon: Container(
                      margin: EdgeInsets.only(right: 20, top: 10, bottom: 10),
                      width: widget.pageStyle.unitWidth * 20,
                      height: widget.pageStyle.unitHeight * 20,
                      child: SvgPicture.asset(couponIcon),
                    ),
                    hintText: 'my_cart_coupon_code_hint'.tr(),
                  ),
                  validator: (value) =>
                      value.isEmpty ? 'required_field'.tr() : null,
                  readOnly: model.couponCode.isNotEmpty,
                ),
              ),
              if (model.isApplying) ...[
                Container(
                  width: widget.pageStyle.unitWidth * 120,
                  height: widget.pageStyle.unitHeight * 40,
                  child: CircleLoadingSpinner(),
                ),
              ] else ...[
                Container(
                  width: widget.pageStyle.unitWidth * 120,
                  height: widget.pageStyle.unitHeight * 40,
                  child: TextIconButton(
                    title: model.couponCode.isNotEmpty
                        ? 'cancel_button_title'.tr()
                        : 'apply_button_title'.tr(),
                    iconData: Icons.check_circle_outline,
                    titleSize: widget.pageStyle.unitFontSize * 15,
                    iconSize: widget.pageStyle.unitFontSize * 20,
                    titleColor: primaryColor,
                    iconColor: primaryColor,
                    buttonColor: greyLightColor,
                    borderColor: Colors.transparent,
                    onPressed: () {
                      if (_couponFormKey.currentState.validate()) {
                        couponNode.unfocus();
                        if (user?.token != null) {
                          if (model.couponCode.isNotEmpty) {
                            couponCodeController.clear();
                            model.cancelCouponCode(
                              flushBarService,
                              widget.pageStyle,
                            );
                          } else {
                            model.applyCouponCode(
                              deviceId ?? '',
                              user?.token ?? '',
                              couponCodeController.text,
                              flushBarService,
                              widget.pageStyle,
                            );
                          }
                        } else {
                          widget.onSignIn();
                        }
                      }
                    },
                    itemSpace: widget.pageStyle.unitWidth * 4,
                  ),
                ),
              ],
            ],
          );
        }),
      ),
    );
  }
}
