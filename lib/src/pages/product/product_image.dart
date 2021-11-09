import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_swiper_null_safety/flutter_swiper_null_safety.dart';
import 'package:markaa/src/config/config.dart';
import 'package:markaa/src/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProductImage extends StatefulWidget {
  final List<dynamic> images;

  ProductImage({required this.images});

  @override
  _ProductImageState createState() => _ProductImageState();
}

class _ProductImageState extends State<ProductImage> {
  final dataKey = GlobalKey();
  int activeIndex = 0;
  List<dynamic> images = [];

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
              width: designWidth.w,
              height: designHeight.h,
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
                    imageProvider: CachedNetworkImageProvider(
                      images[activeIndex],
                      cacheKey: images[activeIndex],
                      errorListener: () => print('image loading error'),
                    ),
                    loadingBuilder: (context, downloadProgress) => Center(
                      child: CupertinoActivityIndicator(),
                    ),
                  );
                },
              ),
            ),
            InkWell(
              onTap: () => Navigator.pop(context),
              child: Container(
                margin: EdgeInsets.only(
                  top: 10.h,
                  left: 10.w,
                ),
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: greyDarkColor.withOpacity(0.3),
                ),
                child: Icon(
                  Icons.arrow_back_ios,
                  color: Colors.white,
                  size: 25.sp,
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                width: 375.w,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: List.generate(images.length, (index) {
                      return InkWell(
                        key: activeIndex == index ? dataKey : null,
                        onTap: () => _onUpdateIndex(index),
                        child: Container(
                          width: 100.w,
                          height: 100.h,
                          margin: EdgeInsets.only(
                            right: 10.w,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            image: DecorationImage(
                              image: CachedNetworkImageProvider(
                                images[index],
                                cacheKey: images[index],
                                errorListener: () =>
                                    print('image loading error'),
                              ),
                            ),
                            border: Border.all(
                              color: activeIndex == index
                                  ? primaryColor
                                  : greyColor,
                              width: 0.8.w,
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
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      Scrollable.ensureVisible(dataKey.currentContext!);
    });
  }
}
