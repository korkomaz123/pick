import 'package:ciga/src/data/models/product_entity.dart';
import 'package:ciga/src/data/models/review_entity.dart';
import 'package:ciga/src/pages/product/bloc/product_repository.dart';
import 'package:ciga/src/theme/styles.dart';
import 'package:ciga/src/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:isco_custom_widgets/isco_custom_widgets.dart';

class ProductReviewTotal extends StatefulWidget {
  final ProductEntity product;
  final PageStyle pageStyle;
  final Function onReviews;
  final Function onFirstReview;

  ProductReviewTotal({
    this.product,
    this.pageStyle,
    this.onReviews,
    this.onFirstReview,
  });

  @override
  _ProductReviewTotalState createState() => _ProductReviewTotalState();
}

class _ProductReviewTotalState extends State<ProductReviewTotal> {
  List<ReviewEntity> reviews = [];
  double average = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.pageStyle.deviceWidth,
      margin: EdgeInsets.only(top: widget.pageStyle.unitHeight * 10),
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
          FutureBuilder(
            future: context
                .watch<ProductRepository>()
                .getProductReviews(widget.product.productId),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                reviews = snapshot.data ?? [];
                if (reviews.isEmpty) {
                  return _buildFirstReview();
                } else {
                  double total = 0;
                  for (int i = 0; i < reviews.length; i++) {
                    total += reviews[i].ratingValue;
                  }
                  average = total / reviews.length;
                  return _buildTotalReview();
                }
              }
              return Container();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildFirstReview() {
    return Container(
      width: double.infinity,
      child: Row(
        children: [
          RatingBar(
            initialRating: 0,
            direction: Axis.horizontal,
            allowHalfRating: true,
            itemCount: 5,
            itemSize: widget.pageStyle.unitFontSize * 21,
            ratingWidget: RatingWidget(
              empty: Icon(Icons.star_border, color: Colors.grey.shade300),
              full: Icon(Icons.star, color: Colors.amber),
              half: Icon(Icons.star_half, color: Colors.amber),
            ),
            ignoreGestures: true,
            onRatingUpdate: (rating) {},
          ),
          InkWell(
            onTap: widget.onFirstReview,
            child: Text(
              'first_review'.tr(),
              style: mediumTextStyle.copyWith(
                fontSize: widget.pageStyle.unitFontSize * 16,
                color: primaryColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTotalReview() {
    return Container(
      width: double.infinity,
      child: Row(
        children: [
          RatingBar(
            initialRating: average,
            direction: Axis.horizontal,
            allowHalfRating: true,
            itemCount: 5,
            itemSize: widget.pageStyle.unitFontSize * 21,
            ratingWidget: RatingWidget(
              empty: Icon(Icons.star_border, color: Colors.grey.shade300),
              full: Icon(Icons.star, color: Colors.amber),
              half: Icon(Icons.star_half, color: Colors.amber),
            ),
            ignoreGestures: true,
            onRatingUpdate: (value) => null,
          ),
          InkWell(
            onTap: widget.onReviews,
            child: Text(
              'reviews_count'.tr().replaceFirst('0', reviews.length.toString()),
              style: mediumTextStyle.copyWith(
                fontSize: widget.pageStyle.unitFontSize * 14,
                color: primaryColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
