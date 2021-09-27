import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:markaa/src/routes/routes.dart';

class CelebrityCard extends StatefulWidget {
  final double cardWidth;
  final double cardHeight;
  final Map<String, dynamic> celebrity;

  CelebrityCard({
    this.cardWidth,
    this.cardHeight,
    this.celebrity,
  });

  @override
  _CelebrityCardState createState() => _CelebrityCardState();
}

class _CelebrityCardState extends State<CelebrityCard> with TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(
          context,
          Routes.product,
          arguments: widget.celebrity,
        );
      },
      child: Container(
        width: widget.cardWidth,
        height: widget.cardHeight,
        child: _buildProductCard(),
      ),
    );
  }

  Widget _buildProductCard() {
    return Container(
      width: widget.cardWidth,
      height: widget.cardHeight,
      color: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: 8.w),
      child: CachedNetworkImage(
        imageUrl: widget.celebrity['image'],
        width: widget.cardWidth,
        height: widget.cardHeight * 0.63,
        fit: BoxFit.cover,
        errorWidget: (context, url, error) {
          return Center(child: Icon(Icons.image, size: 20.sp));
        },
      ),
    );
  }
}
