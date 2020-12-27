import 'package:ciga/src/components/ciga_app_bar.dart';
import 'package:ciga/src/components/ciga_bottom_bar.dart';
import 'package:ciga/src/components/ciga_side_menu.dart';
import 'package:ciga/src/config/config.dart';
import 'package:ciga/src/data/mock/mock.dart';
import 'package:ciga/src/data/models/enum.dart';
import 'package:ciga/src/pages/brand_list/bloc/brand_bloc.dart';
import 'package:ciga/src/pages/category_list/bloc/category_list/category_list_bloc.dart';
import 'package:ciga/src/pages/home/widgets/home_explore_categories.dart';
import 'package:ciga/src/theme/theme.dart';
import 'package:ciga/src/utils/local_storage_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isco_custom_widgets/isco_custom_widgets.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'bloc/home_bloc.dart';
import 'widgets/home_advertise.dart';
import 'widgets/home_best_deals.dart';
import 'widgets/home_discover_stores.dart';
import 'widgets/home_header_carousel.dart';
import 'widgets/home_new_arrivals.dart';
import 'widgets/home_perfumes.dart';
import 'widgets/home_recent.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final _refreshController = RefreshController(initialRefresh: false);
  HomeBloc homeBloc;
  CategoryListBloc categoryListBloc;
  BrandBloc brandBloc;
  PageStyle pageStyle;
  LocalStorageRepository localStorageRepository;

  @override
  void initState() {
    super.initState();
    homeBloc = context.read<HomeBloc>();
    categoryListBloc = context.read<CategoryListBloc>();
    brandBloc = context.read<BrandBloc>();
    localStorageRepository = context.read<LocalStorageRepository>();
  }

  void _onRefresh() async {
    homeBloc.add(HomeSliderImagesLoaded(lang: lang));
    homeBloc.add(HomeBestDealsLoaded(lang: lang));
    homeBloc.add(HomeNewArrivalsLoaded(lang: lang));
    homeBloc.add(HomePerfumesLoaded(lang: lang));
    categoryListBloc.add(CategoryListLoaded(lang: lang));
    brandBloc.add(BrandListLoaded(lang: lang));
    homeBloc.add(HomeAdsLoaded());
    if (user?.token != null) {
      print('customer recently view');
      homeBloc.add(HomeRecentlyViewedCustomerLoaded(
        token: user.token,
        lang: lang,
      ));
    } else {
      print('guest view');
      _loadGuestViewed();
    }
    await Future.delayed(Duration(milliseconds: 1000));
    _refreshController.refreshCompleted();
  }

  void _loadGuestViewed() async {
    List<String> ids = await localStorageRepository.getRecentlyViewedIds();
    homeBloc.add(HomeRecentlyViewedGuestLoaded(ids: ids, lang: lang));
  }

  @override
  Widget build(BuildContext context) {
    pageStyle = PageStyle(context, designWidth, designHeight);
    pageStyle.initializePageStyles();
    return Scaffold(
      key: scaffoldKey,
      appBar: CigaAppBar(pageStyle: pageStyle, scaffoldKey: scaffoldKey),
      drawer: CigaSideMenu(pageStyle: pageStyle),
      body: SmartRefresher(
        enablePullDown: true,
        enablePullUp: false,
        header: MaterialClassicHeader(color: primaryColor),
        controller: _refreshController,
        onRefresh: _onRefresh,
        onLoading: () => null,
        child: NotificationListener<OverscrollIndicatorNotification>(
          onNotification: (notification) {
            notification.disallowGlow();
            return true;
          },
          child: SingleChildScrollView(
            child: Column(
              children: [
                HomeHeaderCarousel(pageStyle: pageStyle),
                HomeBestDeals(pageStyle: pageStyle),
                HomeNewArrivals(pageStyle: pageStyle),
                HomePerfumes(pageStyle: pageStyle),
                HomeExploreCategories(pageStyle: pageStyle),
                SizedBox(height: pageStyle.unitHeight * 10),
                HomeDiscoverStores(pageStyle: pageStyle),
                SizedBox(height: pageStyle.unitHeight * 10),
                HomeAdvertise(pageStyle: pageStyle),
                SizedBox(height: pageStyle.unitHeight * 10),
                HomeRecent(pageStyle: pageStyle),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: CigaBottomBar(
        pageStyle: pageStyle,
        activeItem: BottomEnum.home,
      ),
    );
  }
}
