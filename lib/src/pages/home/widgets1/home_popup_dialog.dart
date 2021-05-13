import 'package:flutter/material.dart';
import 'package:markaa/src/data/mock/mock.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:markaa/src/routes/routes.dart';
import 'package:markaa/src/data/models/brand_entity.dart';
import 'package:markaa/src/data/models/category_entity.dart';
import 'package:markaa/src/data/models/product_list_arguments.dart';
import 'package:markaa/src/data/models/slider_image_entity.dart';
import 'package:markaa/src/utils/repositories/product_repository.dart';

class HomePopupDialog extends StatefulWidget {
  final SliderImageEntity item;

  HomePopupDialog({this.item});

  @override
  _HomePopupDialogState createState() => _HomePopupDialogState();
}

class _HomePopupDialogState extends State<HomePopupDialog>
    with WidgetsBindingObserver {
  ProductRepository productRepository = ProductRepository();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Material(
        color: Colors.black.withOpacity(0.3),
        child: Container(
          alignment: Alignment.center,
          padding: EdgeInsets.symmetric(horizontal: 30.w),
          child: Stack(
            children: [
              Padding(
                padding: EdgeInsets.all(10.w),
                child: InkWell(
                  onTap: () async {
                    if (widget.item.categoryId != null) {
                      final arguments = ProductListArguments(
                        category: CategoryEntity(
                          id: widget.item.categoryId,
                          name: widget.item.categoryName,
                        ),
                        brand: BrandEntity(),
                        subCategory: [],
                        selectedSubCategoryIndex: 0,
                        isFromBrand: false,
                      );
                      Navigator.pushNamed(
                        context,
                        Routes.productList,
                        arguments: arguments,
                      );
                    } else if (widget.item?.brand?.optionId != null) {
                      final arguments = ProductListArguments(
                        category: CategoryEntity(),
                        brand: widget.item.brand,
                        subCategory: [],
                        selectedSubCategoryIndex: 0,
                        isFromBrand: true,
                      );
                      Navigator.pushNamed(
                        context,
                        Routes.productList,
                        arguments: arguments,
                      );
                    } else if (widget.item?.productId != null) {
                      final product = await productRepository
                          .getProduct(widget.item.productId);
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        Routes.product,
                        (route) => route.settings.name == Routes.home,
                        arguments: product,
                      );
                    }
                  },
                  child: Image.network(widget.item.bannerImage),
                ),
              ),
              if (lang == 'en') ...[
                Positioned(
                  top: 0,
                  right: 0,
                  child: InkWell(
                    onTap: () => Navigator.pop(context),
                    child: SvgPicture.asset('lib/public/icons/close.svg'),
                  ),
                ),
              ] else ...[
                Positioned(
                  top: 0,
                  left: 0,
                  child: InkWell(
                    onTap: () => Navigator.pop(context),
                    child: SvgPicture.asset('lib/public/icons/close.svg'),
                  ),
                ),
              ]
            ],
          ),
        ),
      ),
    );
  }
}
