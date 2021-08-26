import 'package:flutter/material.dart';
import 'package:markaa/preload.dart';
import 'package:markaa/src/data/models/index.dart';
import 'package:markaa/src/data/models/product_model.dart';
import 'package:markaa/src/utils/repositories/category_repository.dart';
import 'package:markaa/src/utils/repositories/product_repository.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:markaa/src/routes/routes.dart';

class DynamicLinkService {
  final ProductRepository productRepository = ProductRepository();
  final CategoryRepository categoryRepository = CategoryRepository();

  Future<Uri> productSharableLink(ProductModel product) async {
    final productId = product.productId;
    final imageUrl = product.imageUrl;
    final name = product.name;
    final shortDescription = product.shortDescription;
    final DynamicLinkParameters parameters = DynamicLinkParameters(
      uriPrefix: 'https://markaa.page.link',
      link: Uri.parse(
          'https://markaa.page.link.com/product?id=$productId&target="product"'),
      androidParameters: AndroidParameters(
        packageName: 'com.app.markaa',
        minimumVersion: 1,
      ),
      iosParameters: IosParameters(
        bundleId: 'com.markaa.shop',
        minimumVersion: '1',
        appStoreId: '1549591755',
      ),
      socialMetaTagParameters: SocialMetaTagParameters(
        imageUrl: Uri.parse(imageUrl),
        title: name,
        description: shortDescription,
      ),
    );
    var dynamicUrl = await parameters.buildUrl();
    final shortenedLink = await DynamicLinkParameters.shortenUrl(
      dynamicUrl,
      DynamicLinkParametersOptions(
        shortDynamicLinkPathLength: ShortDynamicLinkPathLength.short,
      ),
    );
    return shortenedLink.shortUrl;
  }

  Future<void> retrieveDynamicLink() async {
    try {
      FirebaseDynamicLinks.instance.onLink(
        onSuccess: (PendingDynamicLinkData dynamicLink) async {
          final Uri deepLink = dynamicLink?.link;
          if (deepLink != null) {
            if (deepLink.queryParameters.containsKey('id')) {
              dynamicLinkHandler(deepLink);
            }
          }
        },
      );
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> initialDynamicLink() async {
    try {
      PendingDynamicLinkData dynamicLink =
          await FirebaseDynamicLinks.instance.getInitialLink();
      final Uri deepLink = dynamicLink?.link;
      if (deepLink != null) {
        if (deepLink.queryParameters.containsKey('id')) {
          dynamicLinkHandler(deepLink);
        }
      }
    } catch (e) {
      print(e.toString());
    }
  }

  dynamicLinkHandler(Uri deepLink) async {
    String id = deepLink.queryParameters['id'];
    String target = deepLink.queryParameters.containsKey('target')
        ? deepLink.queryParameters['target']
        : 'product';
    if (target == 'product') {
      final product = await productRepository.getProduct(id);
      Navigator.pushNamedAndRemoveUntil(
        Preload.navigatorKey.currentContext,
        Routes.product,
        (route) => route.settings.name == Routes.home,
        arguments: product,
      );
    } else if (target == 'category') {
      final category =
          await categoryRepository.getCategory(id, Preload.language);
      ProductListArguments arguments = ProductListArguments(
        category: category,
        subCategory: [],
        brand: BrandEntity(),
        selectedSubCategoryIndex: 0,
        isFromBrand: false,
      );
      Navigator.pushNamed(
        Preload.navigatorKey.currentContext,
        Routes.productList,
        arguments: arguments,
      );
    }
  }
}
