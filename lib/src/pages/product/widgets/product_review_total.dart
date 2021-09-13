import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_svg/svg.dart';
import 'package:markaa/src/change_notifier/product_change_notifier.dart';
import 'package:markaa/src/change_notifier/product_review_change_notifier.dart';
import 'package:markaa/src/data/mock/mock.dart';
import 'package:markaa/src/data/models/product_entity.dart';
import 'package:markaa/src/routes/routes.dart';
import 'package:markaa/src/theme/styles.dart';
import 'package:markaa/src/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:markaa/src/utils/services/flushbar_service.dart';
import 'package:markaa/src/utils/services/progress_service.dart';
import 'package:provider/provider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../preload.dart';

class ProductReviewTotal extends StatefulWidget {
  final ProductEntity product;
  final Function onReviews;
  final Function onFirstReview;
  final ProgressService progressService;
  final ProductChangeNotifier model;
  ProductReviewTotal(
      {this.product,
      this.onReviews,
      this.onFirstReview,
      this.model,
      this.progressService});

  @override
  _ProductReviewTotalState createState() => _ProductReviewTotalState();
}

class _ProductReviewTotalState extends State<ProductReviewTotal> {
  double average = 0;
  ProductReviewChangeNotifier model;
  String _alarmActive = '';
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
                  // if (model.reviews.isEmpty) {
                  //   return _buildFirstReview();
                  // } else {
                  double total = 0;
                  for (int i = 0; i < model.reviews.length; i++) {
                    total += model.reviews[i].ratingValue;
                  }
                  if (total > 0)
                    average = total / model.reviews.length;
                  else
                    average = 0;
                  return _buildTotalReview(model);
                  // }
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
                  Icon(Icons.add_circle_outline,
                      color: primaryColor, size: 14.sp),
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
              onTap: () async {
                if (isStock && _alarmActive.isEmpty) {
                  if (user == null || user.email == null) {
                    Navigator.pushNamed(
                        Preload.navigatorKey.currentContext, Routes.signIn);
                    return;
                  }
                  widget.progressService.showProgress();

                  print(
                      "${widget.product.productId}_product_price_${Preload.language}");
                  FirebaseMessaging.instance.subscribeToTopic(
                      "${widget.product.productId}_product_price_${Preload.language}");
                  await widget.product
                      .requestPriceAlarm('price', widget.product.productId);
                  widget.progressService.hideProgress();
                  FlushBarService(context: context).showErrorDialog(
                      "alarm_subscribed".tr(), "../icons/price_alarm.svg");
                  _alarmActive = '_done';
                  setState(() {});
                }
              },
              child: Row(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 5.w),
                    child: SvgPicture.asset(
                      'lib/public/icons/price_alarm$_alarmActive.svg',
                      color: isStock ? null : greyColor,
                      width: 18.sp,
                    ),
                  ),
                  Text(
                    "price_alarm".tr(),
                    style: mediumTextStyle.copyWith(
                      fontSize: 11.sp,
                      fontWeight: FontWeight.bold,
                      color: isStock ? null : greyColor,
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  // Widget _buildFirstReview() {
  //   return Container(
  //     width: double.infinity,
  //     child: Row(
  //       children: [
  //         RatingBar(
  //           initialRating: 0,
  //           direction: Axis.horizontal,
  //           allowHalfRating: true,
  //           itemCount: 5,
  //           itemSize: 18.sp,
  //           ratingWidget: RatingWidget(
  //             empty: Icon(Icons.star_border, color: Colors.grey.shade300),
  //             full: Icon(Icons.star, color: Colors.amber),
  //             half: Icon(Icons.star_half, color: Colors.amber),
  //           ),
  //           ignoreGestures: true,
  //           onRatingUpdate: (rating) {},
  //         ),
  //         Text(
  //           'reviews_count'.tr().replaceFirst('0', model.reviews.length.toString()),
  //           style: mediumTextStyle.copyWith(
  //             fontSize: 12.sp,
  //             color: primaryColor,
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  bool get isStock => _checkStockAvailability();
  bool _checkStockAvailability() {
    final variant = widget.model.selectedVariant;

    if (variant != null) {
      return variant.stockQty != null && variant.stockQty > 0;
    }
    return widget.product.stockQty != null && widget.product.stockQty > 0;
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
            itemSize: 16.sp,
            ratingWidget: RatingWidget(
              empty: Icon(Icons.star_border, color: Colors.grey.shade300),
              full: Icon(Icons.star, color: Colors.amber),
              half: Icon(Icons.star_half, color: Colors.amber),
            ),
            ignoreGestures: true,
            onRatingUpdate: (value) => null,
          ),
          InkWell(
            onTap: model.reviews.length > 0
                ? widget.onReviews
                : widget.onFirstReview,
            child: Text(
              'reviews_count'
                  .tr()
                  .replaceFirst('0', model.reviews.length.toString()),
              style: mediumTextStyle.copyWith(
                fontSize: 11.sp,
                color: primaryColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
