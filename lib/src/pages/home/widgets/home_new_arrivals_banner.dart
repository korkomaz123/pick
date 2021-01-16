import 'package:ciga/src/data/mock/mock.dart';
import 'package:ciga/src/data/models/brand_entity.dart';
import 'package:ciga/src/data/models/index.dart';
import 'package:ciga/src/data/models/product_list_arguments.dart';
import 'package:ciga/src/data/models/slider_image_entity.dart';
import 'package:ciga/src/pages/home/bloc/home_bloc.dart';
import 'package:ciga/src/routes/routes.dart';
import 'package:ciga/src/theme/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:isco_custom_widgets/isco_custom_widgets.dart';

class HomeNewArrivalsBanner extends StatefulWidget {
  final PageStyle pageStyle;

  HomeNewArrivalsBanner({this.pageStyle});

  @override
  _HomeNewArrivalsBannerState createState() => _HomeNewArrivalsBannerState();
}

class _HomeNewArrivalsBannerState extends State<HomeNewArrivalsBanner> {
  HomeBloc homeBloc;

  @override
  void initState() {
    super.initState();
    homeBloc = context.read<HomeBloc>();
    homeBloc.add(HomeNewArrivalsBannersLoaded(lang: lang));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        if (state.newArrivalsBanners.isNotEmpty) {
          return Container(
            width: widget.pageStyle.deviceWidth,
            color: Colors.white,
            margin: EdgeInsets.only(bottom: widget.pageStyle.unitHeight * 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(
                    horizontal: widget.pageStyle.unitWidth * 10,
                    vertical: widget.pageStyle.unitHeight * 10,
                  ),
                  child: Text(
                    state.newArrivalsBannerTitle,
                    style: mediumTextStyle.copyWith(
                      fontSize: widget.pageStyle.unitFontSize * 26,
                    ),
                  ),
                ),
                Container(
                  width: widget.pageStyle.deviceWidth,
                  height: widget.pageStyle.deviceWidth * 373 / 1125,
                  child: Swiper(
                    itemCount: state.newArrivalsBanners.length,
                    autoplay: false,
                    curve: Curves.easeInOutCubic,
                    loop: false,
                    itemBuilder: (context, index) {
                      final banner = state.newArrivalsBanners[index];
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
                          }
                        },
                        child: Container(
                          width: widget.pageStyle.deviceWidth,
                          height: widget.pageStyle.deviceWidth * 373 / 1125,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            image: DecorationImage(
                              image: NetworkImage(banner.bannerImage),
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        } else {
          return Container();
        }
      },
    );
  }
}
