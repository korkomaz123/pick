import 'package:ciga/src/theme/icons.dart';
import 'package:ciga/src/theme/styles.dart';
import 'package:ciga/src/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:isco_custom_widgets/isco_custom_widgets.dart';

class MyCartCouponCode extends StatefulWidget {
  final PageStyle pageStyle;
  final TextEditingController controller;

  MyCartCouponCode({this.pageStyle, this.controller});

  @override
  _MyCartCouponCodeState createState() => _MyCartCouponCodeState();
}

class _MyCartCouponCodeState extends State<MyCartCouponCode> {
  @override
  Widget build(BuildContext context) {
    return Container(
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
              controller: widget.controller,
              style: boldTextStyle.copyWith(
                color: greyColor,
                fontSize: widget.pageStyle.unitFontSize * 15,
              ),
              decoration: InputDecoration(
                prefixIcon: Container(
                  margin: EdgeInsets.only(top: 10, right: 10),
                  width: widget.pageStyle.unitWidth * 20,
                  height: widget.pageStyle.unitHeight * 20,
                  child: SvgPicture.asset(couponIcon),
                ),
                hintText: 'my_cart_coupon_code_hint'.tr(),
              ),
            ),
          ),
          Container(
            width: widget.pageStyle.unitWidth * 110,
            height: widget.pageStyle.unitHeight * 40,
            child: TextIconButton(
              title: 'apply_button_title'.tr(),
              iconData: Icons.check_circle_outline,
              titleSize: widget.pageStyle.unitFontSize * 15,
              iconSize: widget.pageStyle.unitFontSize * 20,
              titleColor: primaryColor,
              iconColor: primaryColor,
              buttonColor: greyLightColor,
              borderColor: Colors.transparent,
              onPressed: () => null,
              itemSpace: widget.pageStyle.unitWidth * 4,
            ),
          ),
        ],
      ),
    );
  }
}
