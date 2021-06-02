import 'package:markaa/src/change_notifier/product_review_change_notifier.dart';
import 'package:markaa/src/components/markaa_input_field.dart';
import 'package:markaa/src/components/markaa_text_button.dart';
import 'package:markaa/src/components/markaa_text_input.dart';
import 'package:markaa/src/data/mock/mock.dart';
import 'package:markaa/src/data/models/product_entity.dart';
import 'package:markaa/src/theme/styles.dart';
import 'package:markaa/src/theme/theme.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:markaa/src/utils/services/flushbar_service.dart';
import 'package:markaa/src/utils/services/progress_service.dart';

class AddProductReviewPage extends StatefulWidget {
  final ProductEntity product;

  AddProductReviewPage({this.product});

  @override
  _AddProductReviewPageState createState() => _AddProductReviewPageState();
}

class _AddProductReviewPageState extends State<AddProductReviewPage> {
  final formKey = GlobalKey<FormState>();
  double rate = 0;
  TextEditingController usernameController = TextEditingController();
  TextEditingController titleController = TextEditingController();
  TextEditingController commentController = TextEditingController();
  ProgressService progressService;
  FlushBarService flushBarService;
  ProductReviewChangeNotifier model;

  @override
  void initState() {
    super.initState();
    model = context.read<ProductReviewChangeNotifier>();
    progressService = ProgressService(context: context);
    flushBarService = FlushBarService(context: context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
          'add_review_page_title'.tr(),
          style: mediumTextStyle.copyWith(
            fontSize: 16.sp,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
      ),
      body: Container(
        width: 375.w,
        child: _buildForm(),
      ),
    );
  }

  Widget _buildForm() {
    return Form(
      key: formKey,
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(
                vertical: 4.h,
              ),
              child: Text(
                'add_review_subtitle'.tr(),
                style: mediumTextStyle.copyWith(
                  fontSize: 16.sp,
                  color: primaryColor,
                ),
              ),
            ),
            Text(
              widget.product.name,
              style: mediumTextStyle.copyWith(
                fontSize: 15.sp,
                color: greyColor,
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: 20.h),
              child: Text(
                'add_review_rate_title'.tr(),
                style: mediumTextStyle.copyWith(
                  fontSize: 12.sp,
                  color: primaryColor,
                ),
              ),
            ),
            RatingBar(
              initialRating: rate,
              minRating: 1,
              direction: Axis.horizontal,
              allowHalfRating: false,
              itemCount: 5,
              itemSize: 25.sp,
              ratingWidget: RatingWidget(
                empty: Icon(Icons.star_border, color: Colors.grey.shade300),
                full: Icon(Icons.star, color: Colors.amber),
                half: Icon(Icons.star_half, color: Colors.amber),
              ),
              onRatingUpdate: (rating) {
                rate = rating;
                setState(() {});
              },
            ),
            if (user?.token == null) ...[
              Container(
                width: 375.w,
                padding: EdgeInsets.symmetric(
                  horizontal: 20.sp,
                ),
                child: MarkaaTextInput(
                  width: double.infinity,
                  controller: usernameController,
                  fontSize: 16.sp,
                  hint: 'username'.tr(),
                  validator: (value) =>
                      value.isEmpty ? 'required_field'.tr() : null,
                  inputType: TextInputType.text,
                  padding: 0,
                ),
              )
            ],
            Container(
              width: 375.w,
              padding: EdgeInsets.symmetric(
                horizontal: 20.sp,
              ),
              child: MarkaaTextInput(
                width: double.infinity,
                controller: titleController,
                fontSize: 16.sp,
                hint: 'add_review_form_review_title'.tr(),
                validator: (value) =>
                    value.isEmpty ? 'required_field'.tr() : null,
                inputType: TextInputType.text,
                padding: 0,
              ),
            ),
            Container(
              width: 375.w,
              padding: EdgeInsets.symmetric(
                horizontal: 20.sp,
                vertical: 20.h,
              ),
              child: MarkaaInputField(
                width: double.infinity,
                controller: commentController,
                space: 10.h,
                radius: 10,
                fontSize: 16.sp,
                fontColor: greyDarkColor,
                label: 'add_review_form_review_comment'.tr(),
                labelColor: greyColor,
                labelSize: 16.sp,
                fillColor: Colors.white,
                bordered: true,
                borderColor: greyColor,
                validator: (value) =>
                    value.isEmpty ? 'required_field'.tr() : null,
                maxLines: 6,
              ),
            ),
            Container(
              width: 150.w,
              child: MarkaaTextButton(
                title: 'submit_button_title'.tr(),
                titleSize: 16.sp,
                titleColor: Colors.white,
                buttonColor: primaryColor,
                radius: 30,
                borderColor: Colors.transparent,
                onPressed: () => _onAddReview(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onAddReview() {
    if (formKey.currentState.validate()) {
      if (rate > 0) {
        model.addReview(
          widget.product.productId,
          titleController.text,
          commentController.text,
          int.parse(rate.toStringAsFixed(0)).toString(),
          user?.token ?? '',
          usernameController.text,
          _onProcess,
          _onSuccess,
          _onFailure,
        );
      } else {
        flushBarService.showSimpleErrorMessageWithImage('rating_required'.tr());
      }
    }
  }

  void _onProcess() {
    progressService.showProgress();
  }

  void _onSuccess() {
    progressService.hideProgress();
    Navigator.pop(context);
  }

  void _onFailure() {
    progressService.hideProgress();
    flushBarService.showSimpleErrorMessageWithImage('failed'.tr());
  }
}
