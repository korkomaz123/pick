import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:markaa/src/change_notifier/brand_change_notifier.dart';
import 'package:markaa/src/change_notifier/category_change_notifier.dart';
import 'package:markaa/src/change_notifier/home_change_notifier.dart';
import 'package:markaa/src/change_notifier/my_cart_change_notifier.dart';
import 'package:markaa/src/change_notifier/product_change_notifier.dart';
import 'package:markaa/src/components/markaa_app_bar.dart';
import 'package:markaa/src/components/markaa_bottom_bar.dart';
import 'package:markaa/src/components/markaa_side_menu.dart';
import 'package:markaa/src/data/mock/mock.dart';
import 'package:markaa/src/data/models/enum.dart';
import 'package:markaa/src/data/models/slider_image_entity.dart';
import 'package:markaa/src/pages/home/widgets/home_explore_categories.dart';
import 'package:markaa/src/theme/theme.dart';
import 'package:markaa/src/utils/repositories/brand_repository.dart';
import 'package:markaa/src/utils/repositories/category_repository.dart';
import 'package:markaa/src/utils/repositories/local_storage_repository.dart';
import 'package:markaa/src/utils/repositories/product_repository.dart';
import 'package:markaa/src/utils/repositories/setting_repository.dart';
import 'package:markaa/src/utils/services/dynamic_link_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:adjust_sdk/adjust.dart';

import 'widgets/home_featured_categories.dart';
import 'widgets/home_advertise.dart';
import 'widgets/home_best_deals.dart';
import 'widgets/home_best_deals_banner.dart';
import 'widgets/home_new_arrivals_banner.dart';
import 'widgets/home_discover_stores.dart';
import 'widgets/home_header_carousel.dart';
import 'widgets/home_new_arrivals.dart';
import 'widgets/home_perfumes.dart';
import 'widgets/home_recent.dart';
import 'widgets/home_popup_dialog.dart';
import 'widgets/home_mega_banner.dart';
import 'widgets/home_exculisive_banner.dart';
import 'widgets/home_oriental_fragrances.dart';
import 'widgets/home_fragrances_banners.dart';
import 'widgets/home_best_watches.dart';
import 'widgets/home_grooming.dart';
import 'widgets/home_smart_tech.dart';

import 'adjust_setup.dart';
import 'notification_setup.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  NotificationSetup notificationSetup;

  HomeChangeNotifier homeChangeNotifier;
  BrandChangeNotifier brandChangeNotifier;
  CategoryChangeNotifier categoryChangeNotifier;
  ProductChangeNotifier productChangeNotifier;
  MyCartChangeNotifier myCartChangeNotifier;

  LocalStorageRepository localStorageRepository;
  SettingRepository settingRepository;
  ProductRepository productRepository;
  CategoryRepository categoryRepository;
  BrandRepository brandRepository;

  Timer timerLink;
  DynamicLinkService dynamicLinkService = DynamicLinkService();

  int loadingIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    homeChangeNotifier = context.read<HomeChangeNotifier>();
    brandChangeNotifier = context.read<BrandChangeNotifier>();
    categoryChangeNotifier = context.read<CategoryChangeNotifier>();
    productChangeNotifier = context.read<ProductChangeNotifier>();
    myCartChangeNotifier = context.read<MyCartChangeNotifier>();
    localStorageRepository = context.read<LocalStorageRepository>();
    settingRepository = context.read<SettingRepository>();
    productRepository = context.read<ProductRepository>();
    categoryRepository = context.read<CategoryRepository>();
    brandRepository = context.read<BrandRepository>();
    productChangeNotifier.initialize();
    homeChangeNotifier.loadPopup(lang, _onShowPopup);

    AdjustSetup.setupAdjustSDK();

    notificationSetup = NotificationSetup(
      context: context,
      firebaseMessaging: FirebaseMessaging(),
      productRepository: productRepository,
      categoryRepository: categoryRepository,
      brandRepository: brandRepository,
      settingRepository: settingRepository,
    );
    notificationSetup.initializeLocalNotification();
    notificationSetup.configureMessaging();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      dynamicLinkService.initialDynamicLink(context);
    });
  }

  void _onShowPopup(SliderImageEntity popupItem) async {
    await showDialog(
      context: context,
      builder: (context) {
        return HomePopupDialog(item: popupItem);
      },
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.inactive:
        break;
      case AppLifecycleState.resumed:
        Adjust.onResume();
        timerLink = new Timer(
          const Duration(milliseconds: 1000),
          () {
            dynamicLinkService.retrieveDynamicLink(context);
          },
        );
        break;
      case AppLifecycleState.paused:
        Adjust.onPause();
        break;
      case AppLifecycleState.detached:
        break;
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    if (timerLink != null) {
      timerLink.cancel();
    }
    super.dispose();
  }

  Future<void> _onRefresh() async {}

  Future<dynamic> loadRecentViews() async {
    if (user?.token != null) {
      await homeChangeNotifier.loadRecentlyViewedCustomer(user.token, lang);
    } else {
      List<String> ids = await localStorageRepository.getRecentlyViewedIds();
      await homeChangeNotifier.loadRecentlyViewedGuest(ids, lang);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: MarkaaAppBar(scaffoldKey: scaffoldKey),
      drawer: MarkaaSideMenu(),
      body: RefreshIndicator(
        onRefresh: _onRefresh,
        backgroundColor: Colors.white,
        color: primaryColor,
        child: NotificationListener<OverscrollIndicatorNotification>(
          onNotification: (notification) {
            notification.disallowGlow();
            return true;
          },
          child: ListView.builder(
            itemCount: 1,
            itemBuilder: (ctx, index) {
              return Column(
                children: [
                  FutureBuilder(
                    future: homeChangeNotifier.loadSliderImages(lang),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        return HomeHeaderCarousel(model: homeChangeNotifier);
                      } else {
                        return Container();
                      }
                    },
                  ),
                  FutureBuilder(
                    future:
                        categoryChangeNotifier.getFeaturedCategoriesList(lang),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        return HomeFeaturedCategories(
                            model: categoryChangeNotifier);
                      } else {
                        return Container();
                      }
                    },
                  ),
                  FutureBuilder(
                    future: homeChangeNotifier.loadMegaBanner(lang),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        return HomeMegaBanner(model: homeChangeNotifier);
                      } else {
                        return Container();
                      }
                    },
                  ),
                  FutureBuilder(
                    future: homeChangeNotifier.loadBestDeals(lang),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        return HomeBestDeals(model: homeChangeNotifier);
                      } else {
                        return Container();
                      }
                    },
                  ),
                  FutureBuilder(
                    future: homeChangeNotifier.loadBestDealsBanner(lang),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        return HomeBestDealsBanner(model: homeChangeNotifier);
                      } else {
                        return Container();
                      }
                    },
                  ),
                  FutureBuilder(
                    future: homeChangeNotifier.loadNewArrivals(lang),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        return HomeNewArrivals(model: homeChangeNotifier);
                      } else {
                        return Container();
                      }
                    },
                  ),
                  FutureBuilder(
                    future: homeChangeNotifier.loadExculisiveBanner(lang),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        return HomeExculisiveBanner(model: homeChangeNotifier);
                      } else {
                        return Container();
                      }
                    },
                  ),
                  FutureBuilder(
                    future: homeChangeNotifier.loadOrientalProducts(lang),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        return HomeOrientalFragrances(
                            model: homeChangeNotifier);
                      } else {
                        return Container();
                      }
                    },
                  ),
                  FutureBuilder(
                    future: homeChangeNotifier.loadNewArrivalsBanner(lang),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        return HomeNewArrivalsBanner(model: homeChangeNotifier);
                      } else {
                        return Container();
                      }
                    },
                  ),
                  FutureBuilder(
                    future: homeChangeNotifier.loadFragrancesBanner(lang),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        return HomeFragrancesBanners(model: homeChangeNotifier);
                      } else {
                        return Container();
                      }
                    },
                  ),
                  FutureBuilder(
                    future: homeChangeNotifier.loadPerfumes(lang),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        return HomePerfumes(model: homeChangeNotifier);
                      } else {
                        return Container();
                      }
                    },
                  ),
                  FutureBuilder(
                    future: homeChangeNotifier.loadBestWatches(lang),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        return HomeBestWatches(model: homeChangeNotifier);
                      } else {
                        return Container();
                      }
                    },
                  ),
                  FutureBuilder(
                    future: homeChangeNotifier.loadGrooming(lang),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        return HomeGrooming(model: homeChangeNotifier);
                      } else {
                        return Container();
                      }
                    },
                  ),
                  FutureBuilder(
                    future: homeChangeNotifier.loadAds(lang),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        return HomeAdvertise(model: homeChangeNotifier);
                      } else {
                        return Container();
                      }
                    },
                  ),
                  FutureBuilder(
                    future: homeChangeNotifier.loadSmartTech(lang),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        return HomeSmartTech(model: homeChangeNotifier);
                      } else {
                        return Container();
                      }
                    },
                  ),
                  SizedBox(height: 10.h),
                  FutureBuilder(
                    future: categoryChangeNotifier.getCategoriesList(lang),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        return HomeExploreCategories(
                            model: categoryChangeNotifier);
                      } else {
                        return Container();
                      }
                    },
                  ),
                  SizedBox(height: 10.h),
                  FutureBuilder(
                    future: brandChangeNotifier.getBrandsList(lang, 'home'),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        return HomeDiscoverStores(model: brandChangeNotifier);
                      } else {
                        return Container();
                      }
                    },
                  ),
                  SizedBox(height: 10.h),
                  FutureBuilder(
                    future: loadRecentViews(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        return HomeRecent(model: homeChangeNotifier);
                      } else {
                        return Container();
                      }
                    },
                  ),
                ],
              );
            },
          ),
        ),
      ),
      bottomNavigationBar: MarkaaBottomBar(activeItem: BottomEnum.home),
    );
  }
}
