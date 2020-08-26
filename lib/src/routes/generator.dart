import 'package:ciga/src/pages/brand_list/brand_list_page.dart';
import 'package:ciga/src/pages/category_list/category_list_page.dart';
import 'package:ciga/src/pages/home/home_page.dart';
import 'package:ciga/src/pages/product_list/product_list_page.dart';
import 'package:ciga/src/pages/splash/splash_page.dart';
import 'package:ciga/src/pages/store_list/store_list_page.dart';
import 'package:flutter/material.dart';

import 'routes.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final Object params = settings.arguments;
    switch (settings.name) {
      case Routes.start:
        return MaterialPageRoute(builder: (context) => SplashPage());
      case Routes.home:
        return MaterialPageRoute(builder: (context) => HomePage());
      case Routes.productList:
        return MaterialPageRoute(
          builder: (context) => ProductListPage(arguments: params),
        );
      case Routes.categoryList:
        return MaterialPageRoute(builder: (context) => CategoryListPage());
      case Routes.storeList:
        return MaterialPageRoute(builder: (context) => StoreListPage());
      case Routes.brandList:
        return MaterialPageRoute(builder: (context) => BrandListPage());
      default:
        return MaterialPageRoute(builder: (context) => SplashPage());
    }
  }
}
