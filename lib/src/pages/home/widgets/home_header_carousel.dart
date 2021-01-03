import 'package:ciga/src/data/mock/mock.dart';
import 'package:ciga/src/data/models/slider_image_entity.dart';
import 'package:ciga/src/pages/home/bloc/home_bloc.dart';
import 'package:ciga/src/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:isco_custom_widgets/isco_custom_widgets.dart';
import 'package:shimmer/shimmer.dart';
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
          return _buildShimmer();
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
          String image = sliderImages[index].bannerImage;
          return Container(
            width: widget.pageStyle.deviceWidth,
            height: widget.pageStyle.deviceWidth * 579 / 1125,
            decoration: BoxDecoration(
              color: Colors.white,
              image: DecorationImage(
                image: NetworkImage(image),
                fit: BoxFit.fill,
              ),
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
            radius: 0,
            dotWidth: 24.0,
            dotHeight: widget.pageStyle.unitHeight * 2,
            paintStyle: PaintingStyle.fill,
            strokeWidth: 0,
            dotColor: Colors.white,
            activeDotColor: primarySwatchColor,
          ),
        ),
      ),
    );
  }

  Widget _buildShimmer() {
    return Column(
      children: [
        Container(
          width: widget.pageStyle.deviceWidth,
          height: widget.pageStyle.unitHeight * 113,
          child: Shimmer.fromColors(
            baseColor: Colors.grey.shade200,
            highlightColor: Colors.white,
            child: Container(
              width: widget.pageStyle.deviceWidth,
              height: widget.pageStyle.unitHeight * 113,
              color: Colors.white,
            ),
          ),
        ),
        Container(
          width: widget.pageStyle.deviceWidth,
          height: widget.pageStyle.unitHeight * 20,
          alignment: Alignment.center,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              3,
              (index) {
                return Shimmer.fromColors(
                  baseColor: Colors.grey.shade300,
                  highlightColor: Colors.white,
                  child: Container(
                    width: widget.pageStyle.unitWidth * 30,
                    height: widget.pageStyle.unitHeight * 4,
                    color: Colors.white,
                    margin: EdgeInsets.symmetric(horizontal: 2),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
