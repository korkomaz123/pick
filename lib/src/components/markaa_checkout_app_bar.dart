import 'package:markaa/src/components/markaa_checkout_stepper.dart';
import 'package:markaa/src/theme/styles.dart';
import 'package:markaa/src/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MarkaaCheckoutAppBar extends StatefulWidget
    implements PreferredSizeWidget {
  final int? currentIndex;

  MarkaaCheckoutAppBar({this.currentIndex});

  @override
  _MarkaaCheckoutAppBarState createState() => _MarkaaCheckoutAppBarState();

  @override
  Size get preferredSize => Size.fromHeight(currentIndex == null ? 60 : 120);
}

class _MarkaaCheckoutAppBarState extends State<MarkaaCheckoutAppBar> {
  List<String> steps = [
    'checkout_step_address'.tr(),
    'checkout_step_payment'.tr(),
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back_ios,
          size: 25.sp,
          color: greyColor,
        ),
        onPressed: () => Navigator.pop(context),
      ),
      title: Text(
        'checkout_title'.tr(),
        style: mediumTextStyle.copyWith(
          color: greyDarkColor,
          fontSize: 23.sp,
        ),
      ),
      bottom: PreferredSize(
        preferredSize: Size.fromHeight(widget.currentIndex == null ? 0 : 60),
        child: widget.currentIndex == null
            ? SizedBox.shrink()
            : MarkaaCheckoutStepper(
                totalSteps: steps.length,
                currentStep: widget.currentIndex!,
                items: List.generate(
                  steps.length,
                  (index) {
                    return Tab(
                      child: Text(
                        steps[index],
                        style: mediumTextStyle.copyWith(
                          color: widget.currentIndex == index
                              ? primaryColor
                              : Colors.black,
                          fontSize: 12.sp,
                        ),
                      ),
                    );
                  },
                ),
              ),
      ),
    );
  }
}
