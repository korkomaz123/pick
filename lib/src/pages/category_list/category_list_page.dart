import 'package:cached_network_image/cached_network_image.dart';
import 'package:markaa/src/change_notifier/category_change_notifier.dart';
import 'package:markaa/src/change_notifier/home_change_notifier.dart';
import 'package:markaa/src/components/markaa_app_bar.dart';
import 'package:markaa/src/components/markaa_bottom_bar.dart';
import 'package:markaa/src/data/mock/mock.dart';
import 'package:markaa/src/data/models/index.dart';
import 'package:markaa/src/routes/routes.dart';
import 'package:markaa/src/theme/styles.dart';
import 'package:markaa/src/theme/theme.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:markaa/src/utils/services/progress_service.dart';
import 'package:provider/provider.dart';

import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CategoryListPage extends StatefulWidget {
  const CategoryListPage();

  @override
  _CategoryListPageState createState() => _CategoryListPageState();
}

class _CategoryListPageState extends State<CategoryListPage> with WidgetsBindingObserver {
  final dataKey = GlobalKey();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  String? category;
  int? activeIndex;
  List<CategoryEntity> categories = [];
  CategoryChangeNotifier? categoryChangeNotifier;
  ProgressService? progressService;

  @override
  void initState() {
    super.initState();
    progressService = ProgressService(context: context);
    context.read<HomeChangeNotifier>().getCategoriesList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.white,
      appBar: MarkaaAppBar(scaffoldKey: scaffoldKey, isCenter: false),
      body: Consumer<HomeChangeNotifier>(
        builder: (_, _homeChangeNotifier, ___) {
          categories = _homeChangeNotifier.categories;
          return SingleChildScrollView(
            child: Column(
              children: List.generate(
                categories.length,
                (index) => Column(
                  children: [
                    Container(
                      key: activeIndex == index ? dataKey : null,
                      child: _buildCategoryCard(categories[index]),
                    ),
                    if (activeIndex == index) ...[_buildSubcategoriesList(categories[index])],
                    SizedBox(height: 6.h),
                  ],
                ),
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: MarkaaBottomBar(activeItem: BottomEnum.category),
    );
  }

  Widget _buildCategoryCard(CategoryEntity category) {
    return InkWell(
      onTap: () {
        setState(() {
          if (activeIndex != categories.indexOf(category)) {
            activeIndex = categories.indexOf(category);
          } else {
            activeIndex = -1;
          }
        });
        WidgetsBinding.instance!.addPostFrameCallback((_) {
          if (dataKey.currentContext != null) {
            Scrollable.ensureVisible(dataKey.currentContext!);
          }
        });
      },
      child: Container(
        width: 375.w,
        height: 128.h,
        child: Stack(
          children: [
            CachedNetworkImage(
              imageUrl: category.imageUrl ?? '',
              imageBuilder: (context, imageProvider) => Container(
                width: 375.w,
                height: 128.h,
                decoration: BoxDecoration(
                  image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
                ),
              ),
              placeholder: (context, url) => Container(width: 375.w, height: 128.h),
              errorWidget: (context, url, error) => Icon(Icons.error),
            ),
            Align(
              alignment: lang == 'en' ? Alignment.centerLeft : Alignment.centerRight,
              child: Padding(
                padding: EdgeInsets.only(
                  left: lang == 'en' ? 31.w : 150.w,
                  right: lang == 'en' ? 150.w : 31.w,
                ),
                child: Text(
                  category.name,
                  style: mediumTextStyle.copyWith(fontSize: 26.sp, color: greyDarkColor),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSubcategoriesList(CategoryEntity category) {
    return AnimationLimiter(
      child: Column(
        children: [
          AnimationConfiguration.staggeredList(
            position: 0,
            duration: Duration(milliseconds: 375),
            child: SlideAnimation(
              verticalOffset: 50.0,
              child: FadeInAnimation(
                child: InkWell(
                  onTap: () {
                    activeIndex = -1;
                    setState(() {});
                    ProductListArguments arguments = ProductListArguments(
                      category: category,
                      subCategory: [],
                      brand: null,
                      selectedSubCategoryIndex: 0,
                      isFromBrand: false,
                    );
                    Navigator.pushNamed(context, Routes.productList, arguments: arguments);
                  },
                  child: Container(
                    width: 375.w,
                    color: greyLightColor,
                    margin: EdgeInsets.only(bottom: 1.h),
                    padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'all'.tr(),
                          style: mediumTextStyle.copyWith(color: greyColor, fontSize: 18.sp),
                        ),
                        Icon(Icons.arrow_forward_ios, size: 22.sp, color: primaryColor),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          Column(
            children: List.generate(
              category.subCategories!.length,
              (index) => AnimationConfiguration.staggeredList(
                position: (index + 1),
                duration: Duration(milliseconds: 375),
                child: SlideAnimation(
                  verticalOffset: 50.0,
                  child: FadeInAnimation(
                    child: InkWell(
                      onTap: () {
                        activeIndex = -1;
                        setState(() {});
                        ProductListArguments arguments = ProductListArguments(
                          category: category,
                          subCategory: [],
                          brand: null,
                          selectedSubCategoryIndex: index + 1,
                          isFromBrand: false,
                        );
                        Navigator.pushNamed(context, Routes.productList, arguments: arguments);
                      },
                      child: Container(
                        width: 375.w,
                        color: greyLightColor,
                        margin: EdgeInsets.only(bottom: 1.h),
                        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              category.subCategories![index].name,
                              style: mediumTextStyle.copyWith(color: greyColor, fontSize: 18.sp),
                            ),
                            Icon(Icons.arrow_forward_ios, size: 22.sp, color: primaryColor),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
