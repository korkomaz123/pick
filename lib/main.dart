import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:markaa/env.dart';
import 'package:markaa/slack.dart';
import 'package:package_info_plus/package_info_plus.dart';

import 'src/routes/routes.dart';
import 'src/pages/markaa_app/markaa_app.dart';
import 'src/utils/repositories/local_storage_repository.dart';

const bool USE_FIRESTORE_EMULATOR = false;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final PackageInfo _packageInfo = await PackageInfo.fromPlatform();
  final String? _currentVersion = await LocalStorageRepository().getVersion();
  if (_packageInfo.version != _currentVersion) {
    await LocalStorageRepository().clear();
    await LocalStorageRepository().addVersion(_packageInfo.version);
  }
  ByteData data = await PlatformAssetBundle().load('lib/public/ca/lets-encrypt-r3.pem');
  SecurityContext.defaultContext.setTrustedCertificatesBytes(data.buffer.asUint8List());

  /// Firebase initialize
  await Firebase.initializeApp();
  await EasyLocalization.ensureInitialized();
  await DefaultCacheManager().emptyCache();

  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: SystemUiOverlay.values);
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  EquatableConfig.stringify = kDebugMode;
  ErrorWidget.builder = ((FlutterErrorDetails e) {
    int _errorLength = e.stack.toString().length;
    SlackChannels.send(
      '''$env ${e.exceptionAsString()} ${e.stack.toString().substring(0, _errorLength > 500 ? 500 : _errorLength)}''',
      SlackChannels.logAppErrors,
    );
    return Center(
      child: Text("Something went wrong"),
    );
  });

  if (USE_FIRESTORE_EMULATOR)
    FirebaseFirestore.instance.settings = const Settings(
      host: 'localhost:8080',
      sslEnabled: false,
      persistenceEnabled: false,
    );

  if (Platform.isIOS)
    try {
      final status = await AppTrackingTransparency.trackingAuthorizationStatus;
      if (status == TrackingStatus.notDetermined) {
        await AppTrackingTransparency.requestTrackingAuthorization();
      }
      final uuid = await AppTrackingTransparency.getAdvertisingIdentifier();
      print("uuid ==> $uuid");
    } on PlatformException {}

  final uuid = await AppTrackingTransparency.getAdvertisingIdentifier();
  print("UUID: $uuid");

  runApp(
    EasyLocalization(
      path: 'lib/public/languages',
      useOnlyLangCode: true,
      supportedLocales: [
        Locale('en', 'EN'),
        Locale('ar', 'AR'),
      ],
      saveLocale: true,
      child: MarkaaApp(home: Routes.start),
    ),
  );
}
