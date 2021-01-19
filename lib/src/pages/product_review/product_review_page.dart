import 'package:markaa/src/data/models/product_entity.dart';
import 'package:markaa/src/data/models/review_entity.dart';
import 'package:markaa/src/pages/product/bloc/product_repository.dart';
import 'package:markaa/src/routes/routes.dart';
import 'package:markaa/src/theme/styles.dart';
import 'package:markaa/src/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:markaa/src/config/config.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:isco_custom_widgets/isco_custom_widgets.dart';

class ProductReviewPage extends StatefulWidget {
  final ProductEntity product;

  ProductReviewPage({this.product});

  @override
  _ProductReviewPageState createState() => _ProductReviewPageState();
}

class _ProductReviewPageState extends State<ProductReviewPage> {
  PageStyle pageStyle;
  List<ReviewEntity> reviews = [];

  @override
  void initState() {
    super.initState();
    _getProductReviews();
  }

  void _getProductReviews() async {
    reviews = await context.read<ProductRepository>().getProductReviews(widget.product.productId);
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    pageStyle = PageStyle(context, designWidth, designHeight);
    pageStyle.initializePageStyles();
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
            size: pageStyle.unitFontSize * 18,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'product_reviews'.tr(),
          style: mediumTextStyle.copyWith(
            fontSize: pageStyle.unitFontSize * 16,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.add_circle_outline,
              color: Colors.white,
              size: pageStyle.unitFontSize * 21,
            ),
            onPressed: () => _onAddReview(),
          ),
        ],
      ),
      body: Container(
        padding: EdgeInsets.symmetric(
          vertical: pageStyle.unitHeight * 10,
          horizontal: pageStyle.unitWidth * 20,
        ),
        child: Column(
          children: reviews.map((review) => _buildProductReview(review)).toList(),
        ),
      ),
    );
  }

  Widget _buildProductReview(ReviewEntity review) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(top: pageStyle.unitHeight * 20),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                review.nickname,
                style: mediumTextStyle.copyWith(
                  fontSize: pageStyle.unitFontSize * 16,
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
                itemSize: pageStyle.unitFontSize * 18,
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
          Divider(color: darkColor, height: pageStyle.unitHeight * 4),
          Container(
            width: double.infinity,
            alignment: Alignment.centerRight,
            child: Text(
              review.createdAt,
              style: mediumTextStyle.copyWith(
                fontSize: pageStyle.unitFontSize * 9,
                color: primaryColor,
              ),
            ),
          ),
          Container(
            width: double.infinity,
            child: Text(
              review.detail,
              style: mediumTextStyle.copyWith(
                fontSize: pageStyle.unitFontSize * 14,
                color: greyColor,
                fontWeight: FontWeight.w100,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _onAddReview() async {
    await Navigator.pushNamed(
      context,
      Routes.addProductReview,
      arguments: widget.product,
    );
    _getProductReviews();
  }
}
