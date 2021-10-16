// ignore: import_of_legacy_library_into_null_safe
import 'package:auto_size_text/auto_size_text.dart';
import 'package:markaa/src/change_notifier/home_change_notifier.dart';
import 'package:markaa/src/components/celebrity_card.dart';
import 'package:markaa/src/components/markaa_text_button.dart';
import 'package:markaa/src/routes/routes.dart';
import 'package:markaa/src/theme/styles.dart';
import 'package:markaa/src/theme/theme.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../preload.dart';

class HomeCelebrity extends StatelessWidget {
  final HomeChangeNotifier homeChangeNotifier;

  HomeCelebrity({required this.homeChangeNotifier});

  @override
  Widget build(BuildContext context) {
    if (homeChangeNotifier.celebrityItems.isNotEmpty) {
      return Consumer<HomeChangeNotifier>(
        builder: (_, __, ___) {
          return Container(
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 5.h),
            margin: EdgeInsets.only(bottom: 10.h),
            color: Colors.white,
            child: Column(
              children: [
                _buildHeadline(),
                _buildProductsList(),
              ],
            ),
          );
        },
      );
    } else {
      return Container();
    }
  }

  Widget _buildHeadline() {
    return Container(
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: AutoSizeText(
              homeChangeNotifier.celebrityTitle,
              maxLines: 1,
              style: mediumTextStyle.copyWith(
                fontSize: 26.sp,
                color: greyDarkColor,
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 2.w),
            height: 30.h,
            child: MarkaaTextButton(
              title: 'view_all'.tr(),
              titleSize: Preload.language == 'en' ? 12.sp : 10.sp,
              titleColor: primaryColor,
              buttonColor: Colors.white,
              borderColor: primaryColor,
              borderWidth: Preload.language == 'en' ? 1 : 0.5,
              radius: 0,
              onPressed: () {
                Navigator.pushNamed(
                  Preload.navigatorKey!.currentContext!,
                  Routes.celebritiesList,
                  arguments: {'title': homeChangeNotifier.celebrityTitle},
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductsList() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(top: 10.h, bottom: 5.h),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: List.generate(
            homeChangeNotifier.celebrityItems.length,
            (index) {
              return Container(
                margin: EdgeInsets.all(2.w),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.grey.shade300,
                    width: 0.5.w,
                  ),
                ),
                child: CelebrityCard(
                  cardWidth: 100.w,
                  cardHeight: 200.h,
                  celebrity: homeChangeNotifier.celebrityItems[index],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
