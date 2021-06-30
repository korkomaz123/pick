import 'package:markaa/src/change_notifier/product_review_change_notifier.dart';
import 'package:markaa/src/data/models/product_entity.dart';
import 'package:markaa/src/theme/styles.dart';
import 'package:markaa/src/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProductReviewTotal extends StatefulWidget {
  final ProductEntity product;
  final Function onReviews;
  final Function onFirstReview;

  ProductReviewTotal({
    this.product,
    this.onReviews,
    this.onFirstReview,
  });

  @override
  _ProductReviewTotalState createState() => _ProductReviewTotalState();
}

class _ProductReviewTotalState extends State<ProductReviewTotal> {
  double average = 0;
  ProductReviewChangeNotifier model;

  @override
  void initState() {
    super.initState();
    model = context.read<ProductReviewChangeNotifier>();
    model.getProductReviews(widget.product.productId);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(top: 5.h),
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      color: Colors.white,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 10.w),
              child: Consumer<ProductReviewChangeNotifier>(
                builder: (_, __, ___) {
                  if (model.reviews.isEmpty) {
                    return _buildFirstReview();
                  } else {
                    double total = 0;
                    for (int i = 0; i < model.reviews.length; i++) {
                      total += model.reviews[i].ratingValue;
                    }
                    average = total / model.reviews.length;
                    return _buildTotalReview(model);
                  }
                },
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(vertical: 10.w, horizontal: 5.w),
            child: InkWell(
              onTap: widget.onFirstReview,
              child: Row(
                children: [
                  Icon(Icons.add_circle_outline, color: primaryColor, size: 14.sp),
                  SizedBox(width: 5.w),
                  Text(
                    'add_your_review'.tr(),
                    style: mediumTextStyle.copyWith(fontSize: 11.sp),
                  )
                ],
              ),
            ),
          ),
          Container(color: backgroundColor, width: 2.w, height: 40.h),
          Container(
            padding: EdgeInsets.symmetric(vertical: 10.w),
            child: InkWell(
              onTap: () {},
              child: Row(
                children: [
                  Icon(Icons.notifications_outlined, color: primaryColor),
                  Text("price_alarm".tr(), style: TextStyle(fontSize: 10.sp, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          )
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
            itemSize: 21.sp,
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
    );
  }

  Widget _buildTotalReview(ProductReviewChangeNotifier model) {
    return Container(
      width: double.infinity,
      child: Row(
        children: [
          RatingBar(
            initialRating: average,
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
            onRatingUpdate: (value) => null,
          ),
          InkWell(
            onTap: widget.onReviews,
            child: Text(
              'reviews_count'.tr().replaceFirst('0', model.reviews.length.toString()),
              style: mediumTextStyle.copyWith(
                fontSize: 12.sp,
                color: primaryColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
