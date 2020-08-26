import 'package:ciga/src/theme/strings.dart';
import 'package:ciga/src/theme/styles.dart';
import 'package:ciga/src/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:isco_custom_widgets/isco_custom_widgets.dart';

class HomeBodyCare extends StatelessWidget {
  final PageStyle pageStyle;

  HomeBodyCare({this.pageStyle});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: pageStyle.deviceWidth,
      height: pageStyle.unitHeight * 282,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('lib/public/images/shutterstock_1068767300@3x.png'),
          fit: BoxFit.cover,
        ),
      ),
      padding: EdgeInsets.symmetric(
        horizontal: pageStyle.unitWidth * 20,
        vertical: pageStyle.unitHeight * 30,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            bodyCareTitle,
            style: mediumTextStyle.copyWith(
              color: Colors.white,
              fontSize: pageStyle.unitFontSize * 23,
            ),
          ),
          Text(
            'Lorem ipsum dolor sit amet,\nLorem ipsum…',
            style: mediumTextStyle.copyWith(
              color: greyDarkColor,
              fontSize: pageStyle.unitFontSize * 10,
            ),
          ),
          Expanded(
            child: Container(
              alignment: Alignment.bottomLeft,
              child: TextButton(
                title: seeAllTitle,
                titleSize: pageStyle.unitFontSize * 18,
                titleColor: Colors.white,
                buttonColor: Colors.transparent,
                borderColor: Colors.white,
                onPressed: () => null,
              ),
            ),
          )
        ],
      ),
    );
  }
}
