import 'dart:convert';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:markaa/preload.dart';
import 'package:markaa/src/data/mock/mock.dart';
import 'package:markaa/src/data/models/index.dart';
import 'package:markaa/src/routes/routes.dart';
import 'package:markaa/src/utils/repositories/brand_repository.dart';
import 'package:markaa/src/utils/repositories/category_repository.dart';
import 'package:markaa/src/utils/repositories/product_repository.dart';
import 'package:markaa/src/utils/repositories/setting_repository.dart';
import 'package:markaa/src/utils/services/flushbar_service.dart';

AndroidNotificationChannel channel = AndroidNotificationChannel(
  'high_importance_channel', // id
  'High Importance Notifications', // title
  'This channel is used for important notifications.', // description
  importance: Importance.max,
);

final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

class NotificationSetup {
  final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
  final SettingRepository settingRepository = SettingRepository();
  final ProductRepository productRepository = ProductRepository();
  final BrandRepository brandRepository = BrandRepository();
  final CategoryRepository categoryRepository = CategoryRepository();

  void init() {
    _configureMessaging();
    _initializeLocalNotification();
  }

  void _configureMessaging() async {
    await firebaseMessaging.setForegroundNotificationPresentationOptions(
        alert: true, badge: true, sound: true);
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

    // FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    //   _onForegroundMessage(message);
    // });
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      _onLaunchMessage(message.data);
    });
    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage? message) {
      _onLaunchMessage(message?.data ?? {});
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

  void _initializeLocalNotification() async {
    var initializationSettingsAndroid =
        AndroidInitializationSettings('launcher_icon');
    var initializationSettingsIOS = IOSInitializationSettings(
      onDidReceiveLocalNotification: onDidReceiveLocalNotification,
    );
    var initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );
    flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onSelectNotification: onSelectNotification,
    );
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }

  Future onSelectNotification(String? payload) async {
    if (payload != null) {
      debugPrint('FCM NOTIFICATION PAYLOAD: ' + payload);
      await _onLaunchMessage(jsonDecode(payload));
    }
  }

  Future onDidReceiveLocalNotification(
    int? id,
    String? title,
    String? body,
    String? payload,
  ) async {
    showDialog(
      context: Preload.navigatorKey!.currentContext!,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: Text(title!),
        content: Text(body!),
        actions: [
          CupertinoDialogAction(
            isDefaultAction: true,
            child: Text('Ok okay okay'),
            onPressed: () {
              Navigator.pushNamed(context, Routes.categoryList);
            },
          )
        ],
      ),
    );
  }

  // Future<void> _onForegroundMessage(RemoteMessage message) async {
  //   print('on foreground notification');
  //   print(message.data);
  //   await flutterLocalNotificationsPlugin.show(
  //     message.hashCode,
  //     message.data['title'],
  //     message.data['body'],
  //     NotificationDetails(
  //       android: AndroidNotificationDetails(
  //         channel.id,
  //         channel.name,
  //         channel.description,
  //       ),
  //       iOS: IOSNotificationDetails(),
  //     ),
  //     payload: jsonEncode(message.data),
  //   );
  // }

  Future<dynamic> _onLaunchMessage(Map<String, dynamic>? message) async {
    try {
      if (message != null) {
        FlushBarService(context: Preload.navigatorKey!.currentContext!)
            .showErrorDialog(jsonEncode(message));
        Map<dynamic, dynamic> data = message;
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
      } else {
        print('RECEIVED WITH NULL DATA FROM FCM NOTIFICATION');
      }
    } catch (e) {
      print('LAUNCH MESSAGE HANDLER CATCH ERROR: $e');
    }
  }
}
