import 'package:markaa/src/components/markaa_page_loading_kit.dart';
import 'package:markaa/src/pages/my_cart/bloc/my_cart/my_cart_bloc.dart';
import 'package:markaa/src/theme/icons.dart';
import 'package:markaa/src/theme/styles.dart';
import 'package:markaa/src/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:isco_custom_widgets/isco_custom_widgets.dart';

class MyCartCouponCode extends StatefulWidget {
  final PageStyle pageStyle;
  final String cartId;
  final String couponCode;

  MyCartCouponCode({
    this.pageStyle,
    this.cartId,
    this.couponCode,
  });

  @override
  _MyCartCouponCodeState createState() => _MyCartCouponCodeState();
}

class _MyCartCouponCodeState extends State<MyCartCouponCode> {
  MyCartBloc myCartBloc;
  TextEditingController couponCodeController = TextEditingController();
  final _couponFormKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    myCartBloc = context.read<MyCartBloc>();
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
            BlocConsumer<MyCartBloc, MyCartState>(
              listener: (context, state) {},
              builder: (context, state) {
                if (state is CouponCodeAppliedInProcess ||
                    state is CouponCodeCancelledInProcess) {
                  return CircleLoadingSpinner();
                }
                return Container(
                  width: widget.pageStyle.unitWidth * 120,
                  height: widget.pageStyle.unitHeight * 40,
                  child: TextIconButton(
                    title: widget.couponCode.isNotEmpty
                        ? 'cancel_button_title'.tr()
                        : 'apply_button_title'.tr(),
                    iconData: Icons.check_circle_outline,
                    titleSize: widget.pageStyle.unitFontSize * 15,
                    iconSize: widget.pageStyle.unitFontSize * 20,
                    titleColor: primaryColor,
                    iconColor: primaryColor,
                    buttonColor: greyLightColor,
                    borderColor: Colors.transparent,
                    onPressed: () => _couponFormKey.currentState.validate()
                        ? widget.couponCode.isNotEmpty
                            ? myCartBloc.add(CouponCodeCancelled(
                                cartId: widget.cartId,
                                couponCode: widget.couponCode,
                              ))
                            : myCartBloc.add(CouponCodeApplied(
                                cartId: widget.cartId,
                                couponCode: couponCodeController.text,
                              ))
                        : null,
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
