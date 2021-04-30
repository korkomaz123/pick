import 'package:markaa/src/change_notifier/home_change_notifier.dart';
import 'package:markaa/src/data/mock/mock.dart';
import 'package:markaa/src/data/models/brand_entity.dart';
import 'package:markaa/src/data/models/index.dart';
import 'package:markaa/src/data/models/product_list_arguments.dart';
import 'package:markaa/src/data/models/slider_image_entity.dart';
import 'package:markaa/src/routes/routes.dart';
import 'package:markaa/src/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:markaa/src/utils/repositories/product_repository.dart';
import 'package:provider/provider.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class HomeHeaderCarousel extends StatefulWidget {
  final HomeChangeNotifier model;

  HomeHeaderCarousel({this.model});

  @override
  _HomeHeaderCarouselState createState() => _HomeHeaderCarouselState();
}

class _HomeHeaderCarouselState extends State<HomeHeaderCarousel> {
  int activeIndex = 0;
  List<SliderImageEntity> sliderImages;
  HomeChangeNotifier model;
  ProductRepository productRepository;

  @override
  void initState() {
    super.initState();
    productRepository = context.read<ProductRepository>();
    model = widget.model;
    sliderImages = model.sliderImages;
  }

  @override
  Widget build(BuildContext context) {
    if (sliderImages.isNotEmpty) {
      return Container(
        width: 375.w,
        height: 375.w * 579 / 1125,
        child: Stack(
          children: [
            _buildImageSlider(),
            _buildIndicator(),
          ],
        ),
      );
    } else {
      return Container(
        width: 375.w,
        height: 375.w * 579 / 1125,
      );
    }
  }

  Widget _buildImageSlider() {
    return Container(
      width: 375.w,
      height: 375.w * 579 / 1125,
      child: Swiper(
        itemCount: sliderImages.length,
        autoplay: true,
        curve: Curves.easeInOutCubic,
        onIndexChanged: (value) {
          activeIndex = value;
          setState(() {});
        },
        itemBuilder: (context, index) {
          final banner = sliderImages[index];
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
                    await productRepository.getProduct(banner.productId, lang);
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  Routes.product,
                  (route) => route.settings.name == Routes.home,
                  arguments: product,
                );
              }
            },
            child: Image.network(
              banner.bannerImage,
              width: 375.w,
              height: 375.w * 579 / 1125,
              fit: BoxFit.fill,
            ),
          );
        },
      ),
    );
  }

  Widget _buildIndicator() {
    return Positioned(
      bottom: 20.h,
      left: 0,
      right: 0,
      child: Center(
        child: SmoothIndicator(
          offset: activeIndex.toDouble(),
          count: sliderImages.length,
          axisDirection: Axis.horizontal,
          effect: SlideEffect(
            spacing: 8.0,
            radius: 10,
            dotWidth: 375.w / (sliderImages.length * 3),
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
