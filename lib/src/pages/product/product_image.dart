import 'package:ciga/src/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:isco_custom_widgets/isco_custom_widgets.dart';

class ProductImage extends StatelessWidget {
  final arguments;

  ProductImage({this.arguments});

  @override
  Widget build(BuildContext context) {
    PageStyle pageStyle = arguments['pageStyle'];
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              width: pageStyle.deviceWidth,
              height: pageStyle.deviceHeight,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(
                    'lib/public/images/shutterstock_151558448-1.png',
                  ),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            InkWell(
              onTap: () => Navigator.pop(context),
              child: Container(
                margin: EdgeInsets.only(
                  top: pageStyle.unitHeight * 10,
                  left: pageStyle.unitWidth * 10,
                ),
                padding: EdgeInsets.all(pageStyle.unitWidth * 8),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: greyDarkColor.withOpacity(0.3),
                ),
                child: Icon(
                  Icons.arrow_back_ios,
                  color: Colors.white,
                  size: pageStyle.unitFontSize * 25,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
