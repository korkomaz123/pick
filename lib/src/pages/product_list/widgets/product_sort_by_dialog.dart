import 'package:ciga/src/data/mock/mock.dart';
import 'package:ciga/src/theme/styles.dart';
import 'package:ciga/src/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:isco_custom_widgets/isco_custom_widgets.dart';

class ProductSortByDialog extends StatelessWidget {
  final PageStyle pageStyle;

  ProductSortByDialog({this.pageStyle});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        width: pageStyle.deviceWidth,
        color: Color(0xFFE9E9E9),
        padding: EdgeInsets.only(top: pageStyle.unitHeight * 15),
        child: Column(
          children: [
            Container(
              width: pageStyle.deviceWidth,
              padding: EdgeInsets.symmetric(
                horizontal: pageStyle.unitWidth * 10,
                vertical: pageStyle.unitHeight * 4,
              ),
              alignment: Alignment.center,
              child: Text(
                "sort".tr(),
                textAlign: TextAlign.center,
                style: mediumTextStyle.copyWith(
                  color: primaryColor,
                  fontSize: pageStyle.unitFontSize * 26,
                ),
              ),
            ),
            Divider(
              thickness: 0.8,
              color: greyColor.withOpacity(0.6),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: List.generate(
                sortByList.length,
                (index) {
                  return Column(
                    children: [
                      InkWell(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          width: pageStyle.deviceWidth,
                          padding: EdgeInsets.symmetric(
                            horizontal: pageStyle.unitWidth * 10,
                            vertical: pageStyle.unitHeight * 4,
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            sortByList[index],
                            textAlign: TextAlign.center,
                            style: mediumTextStyle.copyWith(
                              color: primaryColor,
                              fontSize: pageStyle.unitFontSize * 16,
                            ),
                          ),
                        ),
                      ),
                      index < (sortByList.length - 1)
                          ? Divider(
                              thickness: 0.8,
                              color: greyColor.withOpacity(0.6),
                            )
                          : SizedBox.shrink(),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
