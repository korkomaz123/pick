import 'package:markaa/src/data/models/product_entity.dart';
import 'package:markaa/src/data/models/review_entity.dart';
import 'package:markaa/src/pages/product/bloc/product_repository.dart';
import 'package:markaa/src/theme/styles.dart';
import 'package:markaa/src/theme/theme.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:isco_custom_widgets/isco_custom_widgets.dart';

class ProductReview extends StatefulWidget {
  final ProductEntity product;
  final PageStyle pageStyle;

  ProductReview({this.product, this.pageStyle});

  @override
  _ProductReviewState createState() => _ProductReviewState();
}

class _ProductReviewState extends State<ProductReview> {
  List<ReviewEntity> reviews = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: context
          .watch<ProductRepository>()
          .getProductReviews(widget.product.productId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          reviews = snapshot.data ?? [];
          if (reviews.isNotEmpty) {
            return Container(
              width: widget.pageStyle.deviceWidth,
              margin: EdgeInsets.only(
                top: widget.pageStyle.unitHeight * 10,
              ),
              padding: EdgeInsets.symmetric(
                horizontal: widget.pageStyle.unitWidth * 20,
                vertical: widget.pageStyle.unitHeight * 20,
              ),
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'product_reviews'.tr(),
                    style: mediumTextStyle.copyWith(
                      fontSize: widget.pageStyle.unitFontSize * 19,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Column(
                    children: reviews
                        .map((review) => _buildProductReview(review))
                        .toList(),
                  ),
                ],
              ),
            );
          }
          return Container();
        }
        return Container();
      },
    );
  }

  Widget _buildProductReview(ReviewEntity review) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(top: widget.pageStyle.unitHeight * 20),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                review.nickname,
                style: mediumTextStyle.copyWith(
                  fontSize: widget.pageStyle.unitFontSize * 16,
                  fontWeight: FontWeight.w700,
                  color: greyColor,
                ),
              ),
              RatingBar(
                initialRating: review.ratingValue,
                minRating: 1,
                direction: Axis.horizontal,
                allowHalfRating: true,
                itemCount: 5,
                itemSize: widget.pageStyle.unitFontSize * 18,
                ratingWidget: RatingWidget(
                  empty: Icon(Icons.star_border, color: Colors.grey.shade300),
                  full: Icon(Icons.star, color: Colors.amber),
                  half: Icon(Icons.star_half, color: Colors.amber),
                ),
                ignoreGestures: true,
                onRatingUpdate: (rating) {
                  print(rating);
                },
              ),
            ],
          ),
          Divider(color: darkColor, height: widget.pageStyle.unitHeight * 4),
          Container(
            width: double.infinity,
            alignment: Alignment.centerRight,
            child: Text(
              review.createdAt,
              style: mediumTextStyle.copyWith(
                fontSize: widget.pageStyle.unitFontSize * 9,
                color: primaryColor,
              ),
            ),
          ),
          Container(
            width: double.infinity,
            child: Text(
              review.detail,
              style: mediumTextStyle.copyWith(
                fontSize: widget.pageStyle.unitFontSize * 14,
                color: greyColor,
                fontWeight: FontWeight.w100,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
