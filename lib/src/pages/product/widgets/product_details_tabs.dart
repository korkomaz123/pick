import 'package:markaa/src/change_notifier/product_change_notifier.dart';
import 'package:markaa/src/data/models/index.dart';
import 'package:markaa/src/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'product_configurable_options.dart';
import 'product_more_about.dart';
import 'product_review.dart';

class ProductDetailsTabs extends StatelessWidget {
  final ProductEntity productEntity;
  final ProductChangeNotifier model;
  final TabController tabController;
  ProductDetailsTabs({this.productEntity, this.model, this.tabController});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 0.w),
      margin: EdgeInsets.only(top: 10.h),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          TabBar(
            labelPadding: EdgeInsets.all(0),
            unselectedLabelColor: Colors.black,
            labelColor: primaryColor,
            indicatorColor: primaryColor,
            tabs: [
              Tab(text: "more_details".tr()),
              if (productEntity.typeId == 'configurable') Tab(text: "specifications".tr()),
              Tab(text: "product_reviews".tr()),
            ],
            controller: tabController,
            indicatorSize: TabBarIndicatorSize.tab,
          ),
          Container(
            height: MediaQuery.of(context).size.height / 2.8,
            child: TabBarView(
              children: [
                ProductMoreAbout(productEntity: productEntity),
                if (productEntity.typeId == 'configurable')
                  ProductConfigurableOptions(
                    productEntity: productEntity,
                    model: model,
                  ),
                ProductReview(product: productEntity),
              ],
              controller: tabController,
            ),
          ),
        ],
      ),
    );
  }
}
