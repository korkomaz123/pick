import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:markaa/src/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

import '../../../config.dart';

class ProductImage extends StatefulWidget {
  final List<dynamic> images;

  ProductImage({this.images});

  @override
  _ProductImageState createState() => _ProductImageState();
}

class _ProductImageState extends State<ProductImage> {
  final dataKey = GlobalKey();
  int activeIndex = 0;
  List<dynamic> images;

  @override
  void initState() {
    super.initState();
    images = widget.images;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              width: Config.pageStyle.deviceWidth,
              height: Config.pageStyle.deviceHeight,
              child: Swiper(
                itemCount: images.length,
                autoplay: false,
                curve: Curves.easeIn,
                duration: 300,
                autoplayDelay: 5000,
                onIndexChanged: (value) => _onUpdateIndex(value),
                itemBuilder: (context, index) {
                  return PhotoView(
                    backgroundDecoration: BoxDecoration(color: Colors.white),
                    imageProvider: CachedNetworkImageProvider(images[activeIndex]),
                    loadingBuilder: (context, downloadProgress) =>
                        Center(child: CircularProgressIndicator(value: downloadProgress.cumulativeBytesLoaded / downloadProgress.expectedTotalBytes)),
                  );
                },
              ),
            ),
            InkWell(
              onTap: () => Navigator.pop(context),
              child: Container(
                margin: EdgeInsets.only(
                  top: Config.pageStyle.unitHeight * 10,
                  left: Config.pageStyle.unitWidth * 10,
                ),
                padding: EdgeInsets.all(Config.pageStyle.unitWidth * 8),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: greyDarkColor.withOpacity(0.3),
                ),
                child: Icon(
                  Icons.arrow_back_ios,
                  color: Colors.white,
                  size: Config.pageStyle.unitFontSize * 25,
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                width: Config.pageStyle.deviceWidth,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: List.generate(images.length, (index) {
                      return InkWell(
                        key: activeIndex == index ? dataKey : null,
                        onTap: () => _onUpdateIndex(index),
                        child: Container(
                          width: Config.pageStyle.unitWidth * 100,
                          height: Config.pageStyle.unitHeight * 100,
                          margin: EdgeInsets.only(
                            right: Config.pageStyle.unitWidth * 10,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            image: DecorationImage(
                              image: NetworkImage(images[index]),
                            ),
                            border: Border.all(
                              color: activeIndex == index ? primaryColor : greyColor,
                              width: Config.pageStyle.unitWidth * 0.8,
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

  void _onUpdateIndex(int newIndex) {
    setState(() {
      activeIndex = newIndex;
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Scrollable.ensureVisible(dataKey.currentContext);
    });
  }
}
