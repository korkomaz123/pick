import 'package:markaa/src/change_notifier/product_review_change_notifier.dart';
import 'package:markaa/src/components/markaa_input_field.dart';
import 'package:markaa/src/components/markaa_text_button.dart';
import 'package:markaa/src/components/markaa_text_input.dart';
import 'package:markaa/src/config/config.dart';
import 'package:markaa/src/data/mock/mock.dart';
import 'package:markaa/src/data/models/product_entity.dart';
import 'package:markaa/src/theme/styles.dart';
import 'package:markaa/src/theme/theme.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:isco_custom_widgets/isco_custom_widgets.dart';
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
  PageStyle pageStyle;
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
    pageStyle = PageStyle(context, designWidth, designHeight);
    pageStyle.initializePageStyles();
    return Scaffold(
      backgroundColor: Colors.white,
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
          'add_review_page_title'.tr(),
          style: mediumTextStyle.copyWith(
            fontSize: pageStyle.unitFontSize * 16,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
      ),
      body: Container(
        width: pageStyle.deviceWidth,
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
                vertical: pageStyle.unitHeight * 4,
              ),
              child: Text(
                'add_review_subtitle'.tr(),
                style: mediumTextStyle.copyWith(
                  fontSize: pageStyle.unitFontSize * 16,
                  color: primaryColor,
                ),
              ),
            ),
            Text(
              widget.product.name,
              style: mediumTextStyle.copyWith(
                fontSize: pageStyle.unitFontSize * 15,
                color: greyColor,
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: pageStyle.unitHeight * 20),
              child: Text(
                'add_review_rate_title'.tr(),
                style: mediumTextStyle.copyWith(
                  fontSize: pageStyle.unitFontSize * 12,
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
              itemSize: pageStyle.unitFontSize * 25,
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
                width: pageStyle.deviceWidth,
                padding: EdgeInsets.symmetric(
                  horizontal: pageStyle.unitFontSize * 20,
                ),
                child: MarkaaTextInput(
                  width: double.infinity,
                  controller: usernameController,
                  fontSize: pageStyle.unitFontSize * 16,
                  hint: 'username'.tr(),
                  validator: (value) =>
                      value.isEmpty ? 'required_field'.tr() : null,
                  inputType: TextInputType.text,
                  padding: 0,
                ),
              )
            ],
            Container(
              width: pageStyle.deviceWidth,
              padding: EdgeInsets.symmetric(
                horizontal: pageStyle.unitFontSize * 20,
              ),
              child: MarkaaTextInput(
                width: double.infinity,
                controller: titleController,
                fontSize: pageStyle.unitFontSize * 16,
                hint: 'add_review_form_review_title'.tr(),
                validator: (value) =>
                    value.isEmpty ? 'required_field'.tr() : null,
                inputType: TextInputType.text,
                padding: 0,
              ),
            ),
            Container(
              width: pageStyle.deviceWidth,
              padding: EdgeInsets.symmetric(
                horizontal: pageStyle.unitFontSize * 20,
                vertical: pageStyle.unitHeight * 20,
              ),
              child: MarkaaInputField(
                width: double.infinity,
                controller: commentController,
                space: pageStyle.unitHeight * 10,
                radius: 10,
                fontSize: pageStyle.unitFontSize * 16,
                fontColor: greyDarkColor,
                label: 'add_review_form_review_comment'.tr(),
                labelColor: greyColor,
                labelSize: pageStyle.unitFontSize * 16,
                fillColor: Colors.white,
                bordered: true,
                borderColor: greyColor,
                validator: (value) =>
                    value.isEmpty ? 'required_field'.tr() : null,
                maxLines: 6,
              ),
            ),
            Container(
              width: pageStyle.unitWidth * 150,
              child: MarkaaTextButton(
                title: 'submit_button_title'.tr(),
                titleSize: pageStyle.unitFontSize * 16,
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
        flushBarService.showErrorMessage(pageStyle, 'rating_required'.tr());
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
    flushBarService.showErrorMessage(pageStyle, 'failed'.tr());
  }
}
