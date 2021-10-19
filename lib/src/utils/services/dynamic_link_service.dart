import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:markaa/preload.dart';
import 'package:markaa/src/data/models/index.dart';
import 'package:markaa/src/data/models/product_model.dart';
import 'package:markaa/src/utils/repositories/brand_repository.dart';
import 'package:markaa/src/utils/repositories/category_repository.dart';
import 'package:markaa/src/utils/repositories/product_repository.dart';
import 'package:markaa/src/change_notifier/my_cart_change_notifier.dart';
import 'package:markaa/src/routes/routes.dart';

import 'flushbar_service.dart';

class DynamicLinkService {
  final ProductRepository productRepository = ProductRepository();
  final CategoryRepository categoryRepository = CategoryRepository();
  final BrandRepository brandRepository = BrandRepository();

  Future<Uri> productSharableLink(ProductModel product) async {
    final productId = product.productId;
    final imageUrl = product.imageUrl;
    final name = product.name;
    final shortDescription = product.shortDescription;
    final DynamicLinkParameters parameters = DynamicLinkParameters(
      uriPrefix: 'https://markaa.page.link',
      link: Uri.parse(
          'https://markaa.page.link.com/product?id=$productId&target=product'),
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
        onSuccess: (PendingDynamicLinkData? dynamicLink) async {
          final Uri deepLink = dynamicLink!.link;
          if (deepLink.queryParameters.containsKey('id')) {
            dynamicLinkHandler(deepLink);
          }
        },
      );
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> initialDynamicLink() async {
    try {
      PendingDynamicLinkData? dynamicLink =
          await FirebaseDynamicLinks.instance.getInitialLink();
      final Uri deepLink = dynamicLink!.link;
      if (deepLink.queryParameters.containsKey('id')) {
        dynamicLinkHandler(deepLink);
      }
    } catch (e) {
      print(e.toString());
    }
  }

  dynamicLinkHandler(Uri deepLink) async {
    try {
      String id = deepLink.queryParameters['id']!;
      String target = deepLink.queryParameters['target']!;
      if (target == 'product') {
        final product = await productRepository.getProduct(id);
        Navigator.pushNamedAndRemoveUntil(
          Preload.navigatorKey!.currentContext!,
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
          brand: null,
          selectedSubCategoryIndex: 0,
          isFromBrand: false,
        );
        Navigator.pushNamed(
          Preload.navigatorKey!.currentContext!,
          Routes.productList,
          arguments: arguments,
        );
      } else if (target == 'brand') {
        final brand = await brandRepository.getBrand(id, Preload.language);
        ProductListArguments arguments = ProductListArguments(
          category: null,
          subCategory: [],
          brand: brand,
          selectedSubCategoryIndex: 0,
          isFromBrand: true,
        );
        Navigator.pushNamed(
          Preload.navigatorKey!.currentContext!,
          Routes.productList,
          arguments: arguments,
        );
      } else if (target == 'page') {
        if (id == 'home') {
          Navigator.popUntil(
            Preload.navigatorKey!.currentContext!,
            (route) => route.settings.name == Routes.home,
          );
        }
      } else if (target == 'cart') {
        Navigator.pushNamed(
          Preload.navigatorKey!.currentContext!,
          Routes.myCart,
        );
      } else if (target == 'coupon') {
        String code = deepLink.queryParameters['code']!;
        final context = Preload.navigatorKey!.currentContext;
        final cartModel = context!.read<MyCartChangeNotifier>();
        final flushBarService = FlushBarService(context: context);
        cartModel.applyCouponCode(code, flushBarService);
        Navigator.popUntil(
          context,
          (route) => route.settings.name == Routes.myCart,
        );
      } else if (target == 'celebrity') {
        Navigator.pushNamed(
          Preload.navigatorKey!.currentContext!,
          Routes.infollowencerProductsPage,
          arguments: {"id": id.toString()},
        );
      }
    } catch (e) {
      print('DYNAMIC LINK HANDLER ERROR: $e');
    }
  }

  Future<Uri> expandShortUrl(String shortUrl) async {
    Request req = Request("Get", Uri.parse(shortUrl))..followRedirects = false;
    Client baseClient = Client();
    StreamedResponse response = await baseClient.send(req);
    Uri redirectUri = Uri.parse(response.headers['location']!);
    return redirectUri;
  }
}
