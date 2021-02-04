import 'package:flutter/material.dart';
import 'package:markaa/src/data/models/product_model.dart';
import 'package:provider/provider.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:markaa/src/routes/routes.dart';
import 'package:markaa/src/data/mock/mock.dart';
import 'package:markaa/src/pages/product/bloc/product_repository.dart';

class DynamicLinkService {
  Future<Uri> productSharableLink(ProductModel product) async {
    final productId = product.productId;
    final imageUrl = product.imageUrl;
    final name = product.name;
    final shortDescription = product.shortDescription;
    final DynamicLinkParameters parameters = DynamicLinkParameters(
      uriPrefix: 'https://markaa.page.link',
      link: Uri.parse('https://markaa.page.link.com/product?id=$productId'),
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
    // final shortenedLink = await DynamicLinkParameters.shortenUrl(
    //   dynamicUrl,
    //   DynamicLinkParametersOptions(
    //     shortDynamicLinkPathLength: ShortDynamicLinkPathLength.short,
    //   ),
    // );
    return dynamicUrl;
  }

  Future<void> retrieveDynamicLink(BuildContext context) async {
    final productRepository = context.read<ProductRepository>();
    try {
      FirebaseDynamicLinks.instance.onLink(
        onSuccess: (PendingDynamicLinkData dynamicLink) async {
          final Uri deepLink = dynamicLink?.link;
          if (deepLink != null) {
            if (deepLink.queryParameters.containsKey('id')) {
              String id = deepLink.queryParameters['id'];
              final product = await productRepository.getProduct(id, lang);
              Navigator.pushNamedAndRemoveUntil(
                context,
                Routes.product,
                (route) => route.settings.name == Routes.home,
                arguments: product,
              );
            }
          }
        },
      );
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> initialDynamicLink(BuildContext context) async {
    final productRepository = context.read<ProductRepository>();
    try {
      PendingDynamicLinkData dynamicLink =
          await FirebaseDynamicLinks.instance.getInitialLink();
      final Uri deepLink = dynamicLink?.link;
      if (deepLink != null) {
        if (deepLink.queryParameters.containsKey('id')) {
          String id = deepLink.queryParameters['id'];
          final product = await productRepository.getProduct(id, lang);
          Navigator.pushNamedAndRemoveUntil(
            context,
            Routes.product,
            (route) => route.settings.name == Routes.home,
            arguments: product,
          );
        }
      }
    } catch (e) {
      print(e.toString());
    }
  }
}
