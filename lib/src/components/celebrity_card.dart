import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:markaa/src/routes/routes.dart';

class CelebrityCard extends StatelessWidget {
  final double cardWidth;
  final double cardHeight;
  final Map<String, dynamic> celebrity;

  CelebrityCard({this.cardWidth, this.cardHeight, this.celebrity});
  String _image() {
    return celebrity['image'] ?? celebrity['cover_picture'] ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(
          context,
          Routes.infollowencerProductsPage,
          arguments: {
            "id": celebrity['entity_id'],
          },
        );
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
      // padding: EdgeInsets.symmetric(horizontal: 8.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.grey.shade200,
        image: DecorationImage(
            image: CachedNetworkImageProvider(
              _image(),
            ),
            fit: BoxFit.cover),
      ),
    );
  }
}
