import 'package:ciga/src/theme/styles.dart';
import 'package:ciga/src/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:isco_custom_widgets/isco_custom_widgets.dart';

class ProductMoreAbout extends StatelessWidget {
  final PageStyle pageStyle;

  ProductMoreAbout({this.pageStyle});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: pageStyle.deviceWidth,
      padding: EdgeInsets.symmetric(
        horizontal: pageStyle.unitWidth * 20,
        vertical: pageStyle.unitHeight * 30,
      ),
      margin: EdgeInsets.only(top: pageStyle.unitHeight * 10),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'More About Product',
            style: boldTextStyle.copyWith(
              color: greyDarkColor,
              fontSize: pageStyle.unitFontSize * 19,
            ),
          ),
          SizedBox(height: pageStyle.unitFontSize * 4),
          Text(
            'Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi architecto beatae vitae dicta sunt explicabo.',
            style: boldTextStyle.copyWith(
              color: greyColor,
              fontSize: pageStyle.unitFontSize * 12,
            ),
          ),
          SizedBox(height: pageStyle.unitFontSize * 15),
          Text(
            'Reviews',
            style: boldTextStyle.copyWith(
              color: greyDarkColor,
              fontSize: pageStyle.unitFontSize * 19,
            ),
          ),
          SizedBox(height: pageStyle.unitFontSize * 4),
          Text(
            'But I must explain to you how all this mistaken idea of denouncing pleasure and praising pain was born and I will give you a complete account of the system, and expound the actual teachings of the great explorer of the truth, the master-builder of human happiness.',
            style: bookTextStyle.copyWith(
              color: greyColor,
              fontSize: pageStyle.unitFontSize * 12,
            ),
          ),
        ],
      ),
    );
  }
}
