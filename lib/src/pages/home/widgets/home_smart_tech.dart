import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:markaa/src/components/amazing_product_card.dart';
import 'package:markaa/src/components/markaa_text_icon_button.dart';
import 'package:markaa/src/data/mock/mock.dart';
import 'package:markaa/src/data/models/brand_entity.dart';
import 'package:markaa/src/data/models/category_entity.dart';
import 'package:markaa/src/data/models/product_list_arguments.dart';
import 'package:markaa/src/data/models/product_model.dart';
import 'package:markaa/src/data/models/slider_image_entity.dart';
import 'package:markaa/src/routes/routes.dart';
import 'package:markaa/src/theme/styles.dart';
import 'package:markaa/src/theme/theme.dart';
import 'package:markaa/src/utils/repositories/product_repository.dart';
import 'package:provider/provider.dart';
import 'package:isco_custom_widgets/isco_custom_widgets.dart';
import 'package:markaa/src/change_notifier/home_change_notifier.dart';

class HomeSmartTech extends StatefulWidget {
  final PageStyle pageStyle;

  HomeSmartTech({@required this.pageStyle});

  @override
  _HomeSmartTechState createState() => _HomeSmartTechState();
}

class _HomeSmartTechState extends State<HomeSmartTech> {
  PageStyle pageStyle;
  HomeChangeNotifier homeChangeNotifier;
  ProductRepository productRepository;

  @override
  void initState() {
    super.initState();
    pageStyle = widget.pageStyle;
    productRepository = context.read<ProductRepository>();
    homeChangeNotifier = context.read<HomeChangeNotifier>();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeChangeNotifier>(
      builder: (_, model, __) {
        return Container(
          width: pageStyle.deviceWidth,
          color: Colors.white,
          child: Column(
            children: [
              if (model.smartTechTitle.isNotEmpty) ...[_buildTitle(model.smartTechTitle)],
              if (model.smartTechBanners.isNotEmpty) ...[_buildBanners(model.smartTechBanners)],
              if (model.smartTechItems.isNotEmpty) ...[_buildProducts(model.smartTechItems)],
              if (model.smartTechCategory != null) ...[_buildFooter(model.smartTechCategory, model.smartTechTitle)],
            ],
          ),
        );
      },
    );
  }

  Widget _buildTitle(String title) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: pageStyle.unitWidth * 10,
        vertical: pageStyle.unitHeight * 10,
      ),
      child: Text(
        title,
        style: mediumTextStyle.copyWith(
          fontSize: pageStyle.unitFontSize * 26,
        ),
      ),
    );
  }

  Widget _buildBanners(List<SliderImageEntity> banners) {
    return Container(
      width: double.infinity,
      child: Column(
        children: banners.map((banner) {
          return Padding(
            padding: EdgeInsets.only(bottom: pageStyle.unitHeight * 5),
            child: InkWell(
              onTap: () async {
                if (banner.categoryId != null) {
                  final arguments = ProductListArguments(
                    category: CategoryEntity(
                      id: banner.categoryId,
                      name: banner.categoryName,
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
                } else if (banner?.brand?.optionId != null) {
                  final arguments = ProductListArguments(
                    category: CategoryEntity(),
                    brand: banner.brand,
                    subCategory: [],
                    selectedSubCategoryIndex: 0,
                    isFromBrand: true,
                  );
                  Navigator.pushNamed(
                    context,
                    Routes.productList,
                    arguments: arguments,
                  );
                } else if (banner?.productId != null) {
                  final product = await productRepository.getProduct(banner.productId);
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    Routes.product,
                    (route) => route.settings.name == Routes.home,
                    arguments: product,
                  );
                }
              },
              child: Image.network(banner.bannerImage),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildProducts(List<ProductModel> list) {
    return Container(
      width: pageStyle.deviceWidth,
      padding: EdgeInsets.symmetric(vertical: pageStyle.unitHeight * 20),
      color: backgroundColor,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: list.map((item) {
            return Padding(
              padding: EdgeInsets.only(left: pageStyle.unitWidth * 8),
              child: AmazingProductCard(
                cardSize: pageStyle.unitWidth * 302,
                contentSize: pageStyle.unitWidth * 96,
                pageStyle: pageStyle,
                product: item,
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildFooter(CategoryEntity category, String title) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        vertical: widget.pageStyle.unitHeight * 4,
        horizontal: widget.pageStyle.unitWidth * 10,
      ),
      color: backgroundColor,
      child: MarkaaTextIconButton(
        onPressed: () {
          ProductListArguments arguments = ProductListArguments(
            category: category,
            subCategory: [],
            brand: BrandEntity(),
            selectedSubCategoryIndex: 0,
            isFromBrand: false,
          );
          Navigator.pushNamed(
            context,
            Routes.productList,
            arguments: arguments,
          );
        },
        title: 'view_all_smart_tech'.tr(),
        titleColor: Colors.white,
        titleSize: widget.pageStyle.unitFontSize * 18,
        icon: Icon(
          Icons.arrow_forward_ios,
          color: Colors.white,
          size: widget.pageStyle.unitFontSize * 24,
        ),
        borderColor: primaryColor,
        buttonColor: primaryColor,
        pageStyle: widget.pageStyle,
        leading: false,
      ),
    );
  }
}
