import 'package:markaa/src/components/markaa_page_loading_kit.dart';
import 'package:markaa/src/components/markaa_text_icon_button.dart';
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
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MyCartCouponCode extends StatefulWidget {
  final String cartId;
  final Function onSignIn;

  MyCartCouponCode({required this.cartId, required this.onSignIn});

  @override
  _MyCartCouponCodeState createState() => _MyCartCouponCodeState();
}

class _MyCartCouponCodeState extends State<MyCartCouponCode> {
  final _couponFormKey = GlobalKey<FormState>();

  TextEditingController couponCodeController = TextEditingController();
  FocusNode couponNode = FocusNode();

  MyCartChangeNotifier? myCartChangeNotifier;
  FlushBarService? flushBarService;

  @override
  void initState() {
    super.initState();
    flushBarService = FlushBarService(context: context);
    myCartChangeNotifier = context.read<MyCartChangeNotifier>();
    couponCodeController.text = myCartChangeNotifier!.couponCode;

    myCartChangeNotifier!.addListener(() {
      couponCodeController.text = myCartChangeNotifier!.couponCode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _couponFormKey,
      child: Container(
        width: 375.w,
        padding: EdgeInsets.symmetric(
          horizontal: 10.w,
          vertical: 15.h,
        ),
        child: Consumer<MyCartChangeNotifier>(builder: (_, model, __) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                width: 218.w,
                child: TextFormField(
                  controller: couponCodeController,
                  style: mediumTextStyle.copyWith(
                    color: greyColor,
                    fontSize: 15.sp,
                  ),
                  focusNode: couponNode,
                  decoration: InputDecoration(
                    prefixIcon: Container(
                      margin: EdgeInsets.only(right: 20, top: 10, bottom: 10),
                      width: 20.w,
                      height: 20.h,
                      child: SvgPicture.asset(couponIcon),
                    ),
                    hintText: 'my_cart_coupon_code_hint'.tr(),
                  ),
                  validator: (value) {
                    if (value!.trim().isEmpty) return 'required_field'.tr();
                    return null;
                  },
                  readOnly: model.couponCode.isNotEmpty,
                ),
              ),
              if (model.isApplying) ...[
                Container(
                  width: 120.w,
                  height: 40.h,
                  child: PulseLoadingSpinner(),
                ),
              ] else ...[
                Container(
                  width: 120.w,
                  height: 40.h,
                  child: MarkaaTextIconButton(
                    title: model.couponCode.isNotEmpty
                        ? 'cancel_button_title'.tr()
                        : 'apply_button_title'.tr(),
                    icon: Icon(
                      Icons.check_circle_outline,
                      size: 20.sp,
                      color: primaryColor,
                    ),
                    titleSize: 15.sp,
                    titleColor: primaryColor,
                    buttonColor: greyLightColor,
                    borderColor: Colors.transparent,
                    onPressed: () {
                      if (_couponFormKey.currentState!.validate()) {
                        couponNode.unfocus();
                        if (user?.token != null) {
                          if (model.couponCode.isNotEmpty) {
                            couponCodeController.clear();
                            model.cancelCouponCode(flushBarService!);
                          } else {
                            model.applyCouponCode(
                              couponCodeController.text.trim(),
                              flushBarService!,
                            );
                          }
                        } else {
                          widget.onSignIn();
                        }
                      }
                    },
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
