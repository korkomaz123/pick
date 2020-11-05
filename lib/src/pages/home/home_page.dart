import 'package:ciga/src/components/ciga_page_loading_kit.dart';
import 'package:ciga/src/data/mock/mock.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isco_custom_widgets/isco_custom_widgets.dart';
import 'widgets/home_advertise.dart';
import 'widgets/home_best_deals.dart';
import 'widgets/home_discover_stores.dart';
import 'widgets/home_header_carousel.dart';
import 'widgets/home_new_arrivals.dart';
import 'widgets/home_perfumes.dart';
import 'package:ciga/src/components/ciga_app_bar.dart';
import 'package:ciga/src/components/ciga_bottom_bar.dart';
import 'package:ciga/src/components/ciga_side_menu.dart';
import 'package:ciga/src/config/config.dart';
import 'package:ciga/src/data/models/enum.dart';
import 'package:ciga/src/pages/home/bloc/home_bloc.dart';
import 'package:ciga/src/pages/home/widgets/home_explore_categories.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  PageStyle pageStyle;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  HomeBloc homeBloc;

  @override
  void initState() {
    super.initState();
    homeBloc = context.bloc<HomeBloc>();
    homeBloc.add(HomeDataFetched(lang: lang));
  }

  @override
  Widget build(BuildContext context) {
    pageStyle = PageStyle(context, designWidth, designHeight);
    pageStyle.initializePageStyles();
    return Scaffold(
      key: scaffoldKey,
      appBar: CigaAppBar(pageStyle: pageStyle, scaffoldKey: scaffoldKey),
      drawer: CigaSideMenu(pageStyle: pageStyle),
      body: BlocConsumer<HomeBloc, HomeState>(
        listener: (context, state) {},
        builder: (context, state) {
          if (state is HomeDataFetchedSuccess) {
            return SingleChildScrollView(
              child: Column(
                children: [
                  HomeHeaderCarousel(
                    pageStyle: pageStyle,
                    sliderImages: state.sliderImages,
                  ),
                  HomeBestDeals(
                    pageStyle: pageStyle,
                    bestDeals: state.bestDealsProducts,
                  ),
                  HomeNewArrivals(
                    pageStyle: pageStyle,
                    newArrivals: state.newArrivalsProducts,
                  ),
                  HomePerfumes(
                    pageStyle: pageStyle,
                    perfumes: state.perfumesProducts,
                  ),
                  HomeExploreCategories(
                    pageStyle: pageStyle,
                    categories: state.categories,
                  ),
                  SizedBox(height: pageStyle.unitHeight * 10),
                  HomeDiscoverStores(
                    pageStyle: pageStyle,
                    brands: state.brands,
                  ),
                  SizedBox(height: pageStyle.unitHeight * 10),
                  HomeAdvertise(pageStyle: pageStyle),
                  SizedBox(height: pageStyle.unitHeight * 10),
                  // HomeRecent(pageStyle: pageStyle),
                ],
              ),
            );
          } else if (state is HomeDataFetchedFailure) {
            return Center(
              child: Text(state.message),
            );
          } else {
            return Center(
              child: ChasingDotsLoadingSpinner(),
            );
          }
        },
      ),
      bottomNavigationBar: CigaBottomBar(
        pageStyle: pageStyle,
        activeItem: BottomEnum.home,
      ),
    );
  }
}
