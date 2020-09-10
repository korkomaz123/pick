import 'package:ciga/src/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:isco_custom_widgets/isco_custom_widgets.dart';

class ProductImage extends StatefulWidget {
  final arguments;

  ProductImage({this.arguments});

  @override
  _ProductImageState createState() => _ProductImageState();
}

class _ProductImageState extends State<ProductImage> {
  int activeIndex = 0;

  @override
  Widget build(BuildContext context) {
    PageStyle pageStyle = widget.arguments['pageStyle'];
    return Scaffold(
      backgroundColor: Colors.white,
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
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                width: pageStyle.deviceWidth,
                padding: EdgeInsets.symmetric(
                  horizontal: pageStyle.unitWidth * 10,
                ),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: List.generate(4, (index) {
                      return InkWell(
                        onTap: () => setState(() {
                          activeIndex = index;
                        }),
                        child: Container(
                          width: pageStyle.unitWidth * 120,
                          height: pageStyle.unitHeight * 120,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage(
                                'lib/public/images/shutterstock_151558448-1.png',
                              ),
                              // fit: BoxFit.cover,
                            ),
                            border: Border.all(
                              color: activeIndex == index
                                  ? Colors.black.withOpacity(0.3)
                                  : Colors.transparent,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
