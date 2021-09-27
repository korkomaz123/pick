import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:markaa/src/routes/routes.dart';

class CelebrityCard extends StatelessWidget {
  final double cardWidth;
  final double cardHeight;
  final String image;
  final Map<String, dynamic> celebrity;

  CelebrityCard({this.cardWidth, this.cardHeight, this.celebrity, this.image});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        //entity_id
        // Navigator.pushNamed(
        //   context,
        //   Routes.product,
        //   arguments: celebrity,
        // );
      },
      child: Container(
        width: cardWidth,
        height: cardHeight,
        child: _buildProductCard(),
      ),
    );
  }

  Widget _buildProductCard() {
    return Container(
      width: cardWidth,
      height: cardHeight,
      color: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: 8.w),
      child: CachedNetworkImage(
        progressIndicatorBuilder: (_, __, ___) {
          return Center(child: CircularProgressIndicator());
        },
        imageUrl: image,
        width: cardWidth,
        height: cardHeight * 0.63,
        fadeInDuration: Duration.zero,
        fit: BoxFit.cover,
        errorWidget: (context, url, error) {
          return Center(child: Icon(Icons.image, size: 20.sp));
        },
      ),
    );
  }
}
