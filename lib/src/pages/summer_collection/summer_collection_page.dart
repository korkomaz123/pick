import 'package:cached_network_image/cached_network_image.dart';
import 'package:markaa/src/change_notifier/summer_collection_notifier.dart';
import 'package:markaa/src/components/markaa_app_bar.dart';
import 'package:markaa/src/components/markaa_bottom_bar.dart';
import 'package:markaa/src/components/markaa_page_loading_kit.dart';
import 'package:markaa/src/components/markaa_side_menu.dart';
import 'package:markaa/src/data/models/enum.dart';
import 'package:markaa/src/data/models/index.dart';
import 'package:markaa/src/data/models/product_list_arguments.dart';
import 'package:markaa/src/data/models/summer_collection_entity.dart';
import 'package:markaa/src/routes/routes.dart';
import 'package:markaa/src/theme/styles.dart';
import 'package:markaa/src/theme/theme.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:markaa/src/utils/repositories/product_repository.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../preload.dart';

class SummerCollectionPage extends StatefulWidget {
  final ProductListArguments arguments;

  SummerCollectionPage({required this.arguments});

  @override
  _SummerCollectionPageState createState() => _SummerCollectionPageState();
}

class _SummerCollectionPageState extends State<SummerCollectionPage> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  final SummerCollectionNotifier _summerCollectionNotifier =
      Preload.navigatorKey!.currentContext!.read<SummerCollectionNotifier>();

  @override
  void initState() {
    _summerCollectionNotifier.getSummerCollection();
    super.initState();
  }

  _goToPage(SummerCollectionEntity item) async {
    if (item.categoryId != null) {
      final arguments = ProductListArguments(
        category: CategoryEntity(
          id: item.categoryId!,
          name: item.categoryName!,
        ),
        brand: null,
        subCategory: [],
        selectedSubCategoryIndex: 0,
        isFromBrand: false,
      );
      Navigator.pushNamed(
        Preload.navigatorKey!.currentContext!,
        Routes.productList,
        arguments: arguments,
      );
    } else if (item.brandId != null) {
      final arguments = ProductListArguments(
        category: null,
        brand: BrandEntity(
          brandLabel: item.brandLabel!,
          entityId: item.brandId,
          optionId: item.brandId!,
          brandThumbnail: item.brandLogo,
          brandImage: item.brandLogo,
        ),
        subCategory: [],
        selectedSubCategoryIndex: 0,
        isFromBrand: true,
      );
      Navigator.pushNamed(
        Preload.navigatorKey!.currentContext!,
        Routes.productList,
        arguments: arguments,
      );
    } else if (item.productId != null) {
      final product = await ProductRepository().getProduct(item.productId!);
      Navigator.pushNamed(
        Preload.navigatorKey!.currentContext!,
        Routes.product,
        arguments: product,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.white,
      appBar: MarkaaAppBar(
        scaffoldKey: scaffoldKey,
        isCenter: false,
      ),
      drawer: MarkaaSideMenu(),
      body: Stack(
        children: [
          _buildAppBar(),
          Positioned(
            top: 45.h,
            bottom: 0.h,
            left: 0.w,
            right: 0.w,
            child: Consumer<SummerCollectionNotifier>(
              builder: (_, model, __) {
                if (_summerCollectionNotifier.categories.isEmpty)
                  return Center(child: PulseLoadingSpinner());
                else
                  return GridView.count(
                    crossAxisCount: 2,
                    children: _summerCollectionNotifier.categories
                        .map(
                          (e) => InkWell(
                            onTap: () => _goToPage(e),
                            child: CachedNetworkImage(
                              imageUrl: e.imageUrl ?? '',
                              errorWidget: (_, __, ___) => Center(child: Icon(Icons.image, size: 20)),
                            ),
                          ),
                        )
                        .toList(),
                  );
              },
            ),
          )
        ],
      ),
      bottomNavigationBar: MarkaaBottomBar(
        activeItem: BottomEnum.category,
      ),
    );
  }

  Widget _buildAppBar() {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: Container(
        width: 375.w,
        height: 40.h,
        color: primarySwatchColor,
        alignment: Alignment.center,
        padding: EdgeInsets.only(
          left: 10.w,
          right: 10.w,
          bottom: 10.h,
        ),
        child: Stack(
          alignment: AlignmentDirectional.center,
          children: [
            Align(
              alignment: Alignment.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    child: Icon(
                      Icons.arrow_back_ios,
                      color: Colors.white,
                      size: 20.sp,
                    ),
                    onTap: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: Text(
                "summer_collection".tr(),
                style: mediumTextStyle.copyWith(
                  color: Colors.white,
                  fontSize: 17.sp,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
