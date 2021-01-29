import 'package:markaa/src/components/markaa_checkout_stepper.dart';
import 'package:markaa/src/routes/routes.dart';
import 'package:markaa/src/theme/styles.dart';
import 'package:markaa/src/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:isco_custom_widgets/isco_custom_widgets.dart';

class MarkaaCheckoutAppBar extends StatefulWidget
    implements PreferredSizeWidget {
  final PageStyle pageStyle;
  final int currentIndex;

  MarkaaCheckoutAppBar({this.pageStyle, this.currentIndex});

  @override
  _MarkaaCheckoutAppBarState createState() => _MarkaaCheckoutAppBarState();

  @override
  Size get preferredSize => Size.fromHeight(currentIndex == null ? 60 : 120);
}

class _MarkaaCheckoutAppBarState extends State<MarkaaCheckoutAppBar> {
  PageStyle pageStyle;
  List<String> steps = [
    'checkout_step_address'.tr(),
    'checkout_step_shipping'.tr(),
    'checkout_step_review'.tr(),
    'checkout_step_payment'.tr(),
  ];

  @override
  void initState() {
    super.initState();
    pageStyle = widget.pageStyle;
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back_ios,
          size: pageStyle.unitFontSize * 25,
          color: greyColor,
        ),
        onPressed: () => Navigator.pop(context),
      ),
      title: Text(
        'checkout_title'.tr(),
        style: mediumTextStyle.copyWith(
          color: greyDarkColor,
          fontSize: pageStyle.unitFontSize * 23,
        ),
      ),
      actions: [
        Padding(
          padding: EdgeInsets.only(right: pageStyle.unitWidth * 8),
          child: IconButton(
            icon: Icon(
              Icons.close,
              size: pageStyle.unitFontSize * 25,
              color: greyColor,
            ),
            onPressed: () {
              Navigator.popUntil(
                context,
                (route) => route.settings.name == Routes.home,
              );
            },
          ),
        ),
      ],
      bottom: PreferredSize(
        preferredSize: Size.fromHeight(widget.currentIndex == null ? 0 : 60),
        child: widget.currentIndex == null
            ? SizedBox.shrink()
            : MarkaaCheckoutStepper(
                totalSteps: 4,
                currentStep: widget.currentIndex,
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
                          fontSize: pageStyle.unitFontSize * 12,
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