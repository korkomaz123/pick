import 'package:ciga/src/data/mock/mock.dart';
import 'package:ciga/src/theme/styles.dart';
import 'package:ciga/src/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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
        color: Colors.white,
        padding: EdgeInsets.only(top: pageStyle.unitHeight * 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
                      child: Row(
                        children: [
                          Icon(
                            FontAwesomeIcons.solidCircle,
                            color: greyColor,
                            size: pageStyle.unitFontSize * 10,
                          ),
                          SizedBox(width: pageStyle.unitWidth * 6),
                          Text(
                            sortByList[index],
                            style: mediumTextStyle.copyWith(
                              color: greyColor,
                              fontSize: pageStyle.unitFontSize * 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  index < (sortByList.length - 1)
                      ? Divider(thickness: 0.8, color: greyColor)
                      : SizedBox.shrink(),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
