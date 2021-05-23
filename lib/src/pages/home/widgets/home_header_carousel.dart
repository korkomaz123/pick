import 'package:cached_network_image/cached_network_image.dart';
import 'package:markaa/src/change_notifier/home_change_notifier.dart';
import 'package:markaa/src/config/config.dart';
import 'package:markaa/src/data/models/brand_entity.dart';
import 'package:markaa/src/data/models/index.dart';
import 'package:markaa/src/data/models/product_list_arguments.dart';
import 'package:markaa/src/routes/routes.dart';
import 'package:markaa/src/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:markaa/src/utils/repositories/product_repository.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class HomeHeaderCarousel extends StatefulWidget {
  final HomeChangeNotifier homeChangeNotifier;
  HomeHeaderCarousel({@required this.homeChangeNotifier});
  @override
  _HomeHeaderCarouselState createState() => _HomeHeaderCarouselState();
}

class _HomeHeaderCarouselState extends State<HomeHeaderCarousel> {
  int activeIndex = 0;
  final ProductRepository productRepository = ProductRepository();

  @override
  Widget build(BuildContext context) {
    if (widget?.homeChangeNotifier?.sliderImages == null ||
        widget.homeChangeNotifier.sliderImages.isEmpty) {
      return Container();
    }
    return Stack(
      children: [
        _buildImageSlider(),
        _buildIndicator(),
      ],
    );
  }

  Widget _buildImageSlider() {
    return Swiper(
      itemCount: widget.homeChangeNotifier.sliderImages.length,
      autoplay: true,
      curve: Curves.easeInOutCubic,
      onIndexChanged: (value) => setState(() => activeIndex = value),
      itemBuilder: (context, index) {
        final banner = widget.homeChangeNotifier.sliderImages[index];
        return InkWell(
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
              final product =
                  await productRepository.getProduct(banner.productId);
              Navigator.pushNamedAndRemoveUntil(
                context,
                Routes.product,
                (route) => route.settings.name == Routes.home,
                arguments: product,
              );
            }
          },
          child: CachedNetworkImage(
            width: designWidth.w,
            height: designWidth.w * 579 / 1125,
            imageUrl: banner.bannerImage,
            fit: BoxFit.fill,
            errorWidget: (context, url, error) =>
                Center(child: Icon(Icons.image, size: 20)),
          ),
        );
      },
    );
  }

  Widget _buildIndicator() {
    return Positioned(
      bottom: 20.w,
      left: 0,
      right: 0,
      child: Center(
        child: SmoothIndicator(
          offset: activeIndex.toDouble(),
          count: widget.homeChangeNotifier.sliderImages.length,
          axisDirection: Axis.horizontal,
          effect: SlideEffect(
            spacing: 8.0,
            radius: 10,
            dotWidth: designWidth.w /
                (widget.homeChangeNotifier.sliderImages.length * 3),
            dotHeight: 3.h,
            paintStyle: PaintingStyle.fill,
            strokeWidth: 0,
            dotColor: Colors.white,
            activeDotColor: primarySwatchColor,
          ),
        ),
      ),
    );
  }
}
