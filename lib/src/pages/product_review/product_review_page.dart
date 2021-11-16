import 'package:markaa/src/change_notifier/product_review_change_notifier.dart';
import 'package:markaa/src/data/models/product_entity.dart';
import 'package:markaa/src/data/models/review_entity.dart';
import 'package:markaa/src/routes/routes.dart';
import 'package:markaa/src/theme/styles.dart';
import 'package:markaa/src/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProductReviewPage extends StatefulWidget {
  final ProductEntity product;

  ProductReviewPage({required this.product});

  @override
  _ProductReviewPageState createState() => _ProductReviewPageState();
}

class _ProductReviewPageState extends State<ProductReviewPage> {
  List<ReviewEntity> reviews = [];
  ProductReviewChangeNotifier? model;

  @override
  void initState() {
    super.initState();
    model = context.read<ProductReviewChangeNotifier>();
    model!.getProductReviews(widget.product.productId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
            size: 18.sp,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'product_reviews'.tr(),
          style: mediumTextStyle.copyWith(
            fontSize: 16.sp,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.add_circle_outline,
              color: Colors.white,
              size: 21.sp,
            ),
            onPressed: () => _onAddReview(),
          ),
        ],
      ),
      body: Container(
        padding: EdgeInsets.symmetric(
          vertical: 10.h,
          horizontal: 20.w,
        ),
        child: Consumer<ProductReviewChangeNotifier>(
          builder: (_, __, ___) {
            return Column(
              children: model!.reviews
                  .map((review) => _buildProductReview(review))
                  .toList(),
            );
          },
        ),
      ),
    );
  }

  Widget _buildProductReview(ReviewEntity review) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(top: 20.h),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                review.nickname,
                style: mediumTextStyle.copyWith(
                  fontSize: 16.sp,
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
                itemSize: 18.sp,
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
          Divider(color: darkColor, height: 4.h),
          Container(
            width: double.infinity,
            alignment: Alignment.centerRight,
            child: Text(
              review.createdAt,
              style: mediumTextStyle.copyWith(
                fontSize: 9.sp,
                color: primaryColor,
              ),
            ),
          ),
          Container(
            width: double.infinity,
            child: Text(
              review.detail,
              style: mediumTextStyle.copyWith(
                fontSize: 14.sp,
                color: greyColor,
                fontWeight: FontWeight.w100,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _onAddReview() {
    Navigator.pushNamed(
      context,
      Routes.addProductReview,
      arguments: widget.product,
    );
  }
}
