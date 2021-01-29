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
      link: Uri.parse('https://markaa.page.link.com/?id=$productId'),
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

    return dynamicUrl;
  }

  Future<void> retrieveDynamicLink(BuildContext context) async {
    final productRepository = context.read<ProductRepository>();
    try {
      final PendingDynamicLinkData data =
          await FirebaseDynamicLinks.instance.getInitialLink();
      final Uri deepLink = data?.link;

      if (deepLink != null) {
        if (deepLink.queryParameters.containsKey('id')) {
          String id = deepLink.queryParameters['id'];
          final product = await productRepository.getProduct(id, lang);
          Navigator.pushNamed(context, Routes.product, arguments: product);
        }
      }

      FirebaseDynamicLinks.instance.onLink(
        onSuccess: (PendingDynamicLinkData dynamicLink) async {
          print(dynamicLink.toString());
        },
      );
    } catch (e) {
      print(e.toString());
    }
  }
}
