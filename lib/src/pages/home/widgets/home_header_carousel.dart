import 'package:markaa/src/data/mock/mock.dart';
import 'package:markaa/src/data/models/brand_entity.dart';
import 'package:markaa/src/data/models/index.dart';
import 'package:markaa/src/data/models/product_list_arguments.dart';
import 'package:markaa/src/data/models/slider_image_entity.dart';
import 'package:markaa/src/pages/home/bloc/home_bloc.dart';
import 'package:markaa/src/routes/routes.dart';
import 'package:markaa/src/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:isco_custom_widgets/isco_custom_widgets.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class HomeHeaderCarousel extends StatefulWidget {
  final PageStyle pageStyle;

  HomeHeaderCarousel({this.pageStyle});

  @override
  _HomeHeaderCarouselState createState() => _HomeHeaderCarouselState();
}

class _HomeHeaderCarouselState extends State<HomeHeaderCarousel> {
  int activeIndex = 0;
  List<SliderImageEntity> sliderImages;
  HomeBloc homeBloc;

  @override
  void initState() {
    super.initState();
    homeBloc = context.read<HomeBloc>();
    homeBloc.add(HomeSliderImagesLoaded(lang: lang));
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeBloc, HomeState>(
      listener: (context, state) {},
      builder: (context, state) {
        sliderImages = state.sliderImages;
        if (sliderImages.isNotEmpty) {
          return Container(
            width: widget.pageStyle.deviceWidth,
            height: widget.pageStyle.deviceWidth * 579 / 1125,
            child: Stack(
              children: [
                _buildImageSlider(),
                _buildIndicator(),
              ],
            ),
          );
        } else {
          return Container(
            width: widget.pageStyle.deviceWidth,
            height: widget.pageStyle.deviceWidth * 579 / 1125,
          );
        }
      },
    );
  }

  Widget _buildImageSlider() {
    return Container(
      width: widget.pageStyle.deviceWidth,
      height: widget.pageStyle.deviceWidth * 579 / 1125,
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
            onTap: () {
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
                Navigator.pushNamed(
                  context,
                  Routes.brandList,
                  arguments: banner.brand,
                );
              }
            },
            child: Image.network(
              banner.bannerImage,
              width: widget.pageStyle.deviceWidth,
              height: widget.pageStyle.deviceWidth * 579 / 1125,
              fit: BoxFit.fill,
            ),
          );
        },
      ),
    );
  }

  Widget _buildIndicator() {
    return Positioned(
      bottom: widget.pageStyle.unitWidth * 20,
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
            dotWidth: widget.pageStyle.deviceWidth / (sliderImages.length * 3),
            dotHeight: widget.pageStyle.unitHeight * 3,
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
