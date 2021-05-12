// import 'dart:convert';
// import 'dart:io';

// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:markaa/src/config/config.dart';
// import 'package:markaa/src/data/mock/mock.dart';
// import 'package:markaa/src/data/models/brand_entity.dart';
// import 'package:markaa/src/data/models/category_entity.dart';
// import 'package:markaa/src/data/models/product_list_arguments.dart';
// import 'package:markaa/src/routes/routes.dart';
// import 'package:markaa/src/utils/repositories/brand_repository.dart';
// import 'package:markaa/src/utils/repositories/category_repository.dart';
// import 'package:markaa/src/utils/repositories/product_repository.dart';
// import 'package:markaa/src/utils/repositories/setting_repository.dart';

// const AndroidNotificationChannel channel = AndroidNotificationChannel(
//   'high_importance_channel', // id
//   'High Importance Notifications', // title
//   'This channel is used for important notifications.', // description
//   importance: Importance.max,
// );

// final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

// class NotificationSetup {
//   final BuildContext context;
//   final FirebaseMessaging firebaseMessaging;
//   final ProductRepository productRepository;
//   final CategoryRepository categoryRepository;
//   final BrandRepository brandRepository;
//   final SettingRepository settingRepository;

//   NotificationSetup({
//     @required this.context,
//     @required this.firebaseMessaging,
//     @required this.productRepository,
//     @required this.categoryRepository,
//     @required this.brandRepository,
//     @required this.settingRepository,
//   });

//   void initializeLocalNotification() async {
//     var initializationSettingsAndroid =
//         AndroidInitializationSettings('launcher_icon');
//     var initializationSettingsIOS = IOSInitializationSettings(
//       onDidReceiveLocalNotification: onDidReceiveLocalNotification,
//     );
//     var initializationSettings = InitializationSettings(
//       android: initializationSettingsAndroid,
//       iOS: initializationSettingsIOS,
//     );
//     flutterLocalNotificationsPlugin.initialize(
//       initializationSettings,
//       onSelectNotification: onSelectNotification,
//     );
//     await flutterLocalNotificationsPlugin
//         .resolvePlatformSpecificImplementation<
//             AndroidFlutterLocalNotificationsPlugin>()
//         ?.createNotificationChannel(channel);
//   }

//   Future onSelectNotification(String payload) async {
//     if (payload != null) {
//       debugPrint('notification payload: ' + payload);
//       await _onLaunchMessage(jsonDecode(payload));
//     }
//   }

//   Future onDidReceiveLocalNotification(
//     int id,
//     String title,
//     String body,
//     String payload,
//   ) async {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) => CupertinoAlertDialog(
//         title: Text(title),
//         content: Text(body),
//         actions: [
//           CupertinoDialogAction(
//             isDefaultAction: true,
//             child: Text('Ok okay okay'),
//             onPressed: () {
//               Navigator.pushNamed(context, Routes.categoryList);
//             },
//           )
//         ],
//       ),
//     );
//   }

//   void configureMessaging() async {
//     firebaseMessaging.configure(
//       onMessage: _onForegroundMessage,
//       onResume: _onLaunchMessage,
//       onLaunch: _onLaunchMessage,
//       onBackgroundMessage: _onBackgroundMessageHandler,
//     );
//     firebaseMessaging.requestNotificationPermissions(IosNotificationSettings(
//       sound: true,
//       badge: true,
//       alert: true,
//       provisional: true,
//     ));
//     firebaseMessaging.onIosSettingsRegistered.listen(
//       (IosNotificationSettings settings) {
//         print("Settings registered: $settings");
//       },
//     );
//     firebaseMessaging.getToken().then((String token) async {
//       deviceToken = token;
//       if (user?.token != null) {
//         await settingRepository.updateFcmDeviceToken(
//           user.token,
//           Platform.isAndroid ? token : '',
//           Platform.isIOS ? token : '',
//           Platform.isAndroid ? lang : '',
//           Platform.isIOS ? lang : '',
//         );
//       }
//     });
//     String topic = lang == 'en'
//         ? MarkaaNotificationChannels.enChannel
//         : MarkaaNotificationChannels.arChannel;
//     await firebaseMessaging.subscribeToTopic(topic);
//   }

//   static Future<dynamic> _onBackgroundMessageHandler(
//     Map<String, dynamic> message,
//   ) async {
//     await flutterLocalNotificationsPlugin.show(
//       message.hashCode,
//       message['notification']['title'],
//       message['notification']['body'],
//       NotificationDetails(
//         AndroidNotificationDetails(
//           channel.id,
//           channel.name,
//           channel.description,
//         ),
//         IOSNotificationDetails(),
//       ),
//       payload: jsonEncode(message),
//     );
//   }

//   Future<dynamic> _onForegroundMessage(Map<String, dynamic> message) async {
//     await flutterLocalNotificationsPlugin.show(
//       message.hashCode,
//       Platform.isAndroid ? message['notification']['title'] : message['title'],
//       Platform.isAndroid ? message['notification']['body'] : message['body'],
//       NotificationDetails(
//         AndroidNotificationDetails(
//           channel.id,
//           channel.name,
//           channel.description,
//         ),
//         IOSNotificationDetails(),
//       ),
//       payload: jsonEncode(message),
//     );
//   }

//   Future<dynamic> _onLaunchMessage(Map<String, dynamic> message) async {
//     try {
//       Map<dynamic, dynamic> data =
//           Platform.isAndroid ? message['data'] : message;
//       int target = int.parse(data['target']);
//       if (target != 0) {
//         String id = data['id'];
//         if (target == 1) {
//           final product = await productRepository.getProduct(id, lang);
//           Navigator.pushNamed(context, Routes.product, arguments: product);
//         } else if (target == 2) {
//           final category = await categoryRepository.getCategory(id, lang);
//           if (category != null) {
//             ProductListArguments arguments = ProductListArguments(
//               category: category,
//               subCategory: [],
//               brand: BrandEntity(),
//               selectedSubCategoryIndex: 0,
//               isFromBrand: false,
//             );
//             Navigator.pushNamed(
//               context,
//               Routes.productList,
//               arguments: arguments,
//             );
//           }
//         } else if (target == 3) {
//           final brand = await brandRepository.getBrand(id, lang);
//           if (brand != null) {
//             ProductListArguments arguments = ProductListArguments(
//               category: CategoryEntity(),
//               subCategory: [],
//               brand: brand,
//               selectedSubCategoryIndex: 0,
//               isFromBrand: true,
//             );
//             Navigator.pushNamed(
//               context,
//               Routes.productList,
//               arguments: arguments,
//             );
//           }
//         }
//       }
//     } catch (e) {
//       print('catch error $e');
//     }
//   }
// }
