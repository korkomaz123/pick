import 'package:ciga/src/config/config.dart';
import 'package:ciga/src/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:isco_custom_widgets/isco_custom_widgets.dart';
import 'package:photo_view/photo_view.dart';

class ProductImage extends StatefulWidget {
  final List<dynamic> images;

  ProductImage({this.images});

  @override
  _ProductImageState createState() => _ProductImageState();
}

class _ProductImageState extends State<ProductImage> {
  int activeIndex = 0;
  PageStyle pageStyle;
  List<dynamic> images;

  @override
  void initState() {
    super.initState();
    images = widget.images;
  }

  @override
  Widget build(BuildContext context) {
    pageStyle = PageStyle(context, designWidth, designHeight);
    pageStyle.initializePageStyles();
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              width: pageStyle.deviceWidth,
              height: pageStyle.deviceHeight,
              child: PhotoView(
                backgroundDecoration: BoxDecoration(
                  color: Colors.white,
                ),
                imageProvider: NetworkImage(images[activeIndex]),
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
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: List.generate(images.length, (index) {
                      return InkWell(
                        onTap: () => setState(() {
                          activeIndex = index;
                        }),
                        child: Container(
                          width: pageStyle.unitWidth * 120,
                          height: pageStyle.unitHeight * 120,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            image: DecorationImage(
                              image: NetworkImage(images[index]),
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
