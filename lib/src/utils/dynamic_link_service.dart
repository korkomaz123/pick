import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:markaa/src/routes/routes.dart';
import 'package:markaa/src/data/mock/mock.dart';
import 'package:markaa/src/pages/product/bloc/product_repository.dart';

class DynamicLinkService {
  Future<Uri> productSharableLink(String productId) async {
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
    );
    var dynamicUrl = await parameters.buildUrl();
    final shortenedLink = await DynamicLinkParameters.shortenUrl(
      dynamicUrl,
      DynamicLinkParametersOptions(
        shortDynamicLinkPathLength: ShortDynamicLinkPathLength.unguessable,
      ),
    );
    return shortenedLink.shortUrl;
  }

  Future<void> retrieveDynamicLink(BuildContext context) async {
    final productRepository = context.read<ProductRepository>();
    print('start deeplink');
    try {
      final PendingDynamicLinkData data =
          await FirebaseDynamicLinks.instance.getInitialLink();
      final Uri deepLink = data?.link;
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

      FirebaseDynamicLinks.instance.onLink(
        onSuccess: (PendingDynamicLinkData dynamicLink) async {
          print('onSuccess');
          print(dynamicLink.link);
          final Uri deepLink = dynamicLink?.link;
          if (deepLink != null) {
            print(deepLink.queryParameters);
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
}
