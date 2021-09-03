import 'package:easy_localization/easy_localization.dart';
import 'package:markaa/src/change_notifier/product_review_change_notifier.dart';
import 'package:markaa/src/data/models/product_entity.dart';
import 'package:markaa/src/data/models/review_entity.dart';
import 'package:markaa/src/theme/styles.dart';
import 'package:markaa/src/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProductReview extends StatelessWidget {
  final ProductEntity product;

  ProductReview({this.product});
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Consumer<ProductReviewChangeNotifier>(
        builder: (_, model, ___) {
          if (model.reviews.isNotEmpty) {
            return Container(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Column(
                children: model.reviews
                    .map((review) => _buildProductReview(review))
                    .toList(),
              ),
            );
          }
          return Container(
            color: greyColor.withOpacity(0.1),
            margin: EdgeInsets.all(10.w),
            width: double.infinity,
            padding: EdgeInsets.all(10.w),
            child: Center(
              child: Text("no_reviews".tr(), style: mediumTextStyle),
            ),
          );
        },
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
                  fontSize: 14.sp,
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
                onRatingUpdate: (rating) {},
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
                fontSize: 12.sp,
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
