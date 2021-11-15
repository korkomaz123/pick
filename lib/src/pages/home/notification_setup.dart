import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:markaa/preload.dart';
import 'package:markaa/src/data/mock/mock.dart';
import 'package:markaa/src/data/models/index.dart';
import 'package:markaa/src/routes/routes.dart';
import 'package:markaa/src/utils/repositories/brand_repository.dart';
import 'package:markaa/src/utils/repositories/category_repository.dart';
import 'package:markaa/src/utils/repositories/product_repository.dart';
import 'package:markaa/src/utils/repositories/setting_repository.dart';

class NotificationSetup {
  final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
  final SettingRepository settingRepository = SettingRepository();
  final ProductRepository productRepository = ProductRepository();
  final BrandRepository brandRepository = BrandRepository();
  final CategoryRepository categoryRepository = CategoryRepository();

  void init() async {
    await firebaseMessaging.setForegroundNotificationPresentationOptions(alert: true, badge: true, sound: true);
    NotificationSettings settings = await firebaseMessaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    print('User granted permission: ${settings.authorizationStatus}');
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('onMessage >>>> ');
      onLaunchMessageHandler(message.data);
    });
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('onMessageOpenedApp >>>> ');
      onLaunchMessageHandler(message.data);
    });

    FirebaseMessaging.onBackgroundMessage((RemoteMessage message) async {
      print("Handling a background message: ${message.messageId}");
    });
    FirebaseMessaging.instance.getInitialMessage().then((RemoteMessage? message) {
      print('getInitialMessage >>>> ');

      if (message != null) onLaunchMessageHandler(message.data);
    });
    if (user != null) await updateFcmDeviceToken();
  }

  Future updateFcmDeviceToken() async {
    String? deviceToken = await firebaseMessaging.getToken();
    if (user != null) {
      await settingRepository.updateFcmDeviceToken(
        user!.token,
        Platform.isAndroid ? deviceToken ?? '' : '',
        Platform.isIOS ? deviceToken ?? '' : '',
        Platform.isAndroid ? lang : '',
        Platform.isIOS ? lang : '',
      );
    }
  }

  Future<dynamic> onLaunchMessageHandler(Map<String, dynamic> data) async {
    try {
      print('onLaunchMessageHandler');
      int target = int.parse(data['target']);
      if (target != 0) {
        String id = data['id'];
        if (target == 1) {
          final product = await productRepository.getProduct(id);
          Navigator.pushNamed(
            Preload.navigatorKey!.currentContext!,
            Routes.product,
            arguments: product,
          );
        } else if (target == 2) {
          final category = await categoryRepository.getCategory(id, lang);
          if (category != null) {
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
          }
        } else if (target == 3) {
          final brand = await brandRepository.getBrand(id, lang);
          if (brand != null) {
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
          }
        }
      }
    } catch (e) {
      print('LAUNCH MESSAGE HANDLER CATCH ERROR: $e');
    }
  }
}
