import 'package:markaa/src/theme/icons.dart';
import 'package:markaa/src/theme/styles.dart';
import 'package:markaa/src/theme/theme.dart';
import 'package:markaa/src/change_notifier/my_cart_change_notifier.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:isco_custom_widgets/isco_custom_widgets.dart';

class MyCartCouponCode extends StatefulWidget {
  final PageStyle pageStyle;
  final String cartId;

  MyCartCouponCode({
    this.pageStyle,
    this.cartId,
  });

  @override
  _MyCartCouponCodeState createState() => _MyCartCouponCodeState();
}

class _MyCartCouponCodeState extends State<MyCartCouponCode> {
  TextEditingController couponCodeController = TextEditingController();
  final _couponFormKey = GlobalKey<FormState>();
  MyCartChangeNotifier myCartChangeNotifier;

  @override
  void initState() {
    super.initState();
    myCartChangeNotifier = context.read<MyCartChangeNotifier>();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _couponFormKey,
      child: Container(
        width: widget.pageStyle.deviceWidth,
        padding: EdgeInsets.symmetric(
          horizontal: widget.pageStyle.unitWidth * 10,
          vertical: widget.pageStyle.unitHeight * 15,
        ),
        child: Row(
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
              ),
            ),
            Consumer<MyCartChangeNotifier>(
              builder: (_, model, __) {
                return Container(
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
                        if (model.couponCode.isNotEmpty) {
                          model.cancelCouponCode();
                        } else {
                          model.applyCouponCode(couponCodeController.text);
                        }
                      }
                    },
                    itemSpace: widget.pageStyle.unitWidth * 4,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
