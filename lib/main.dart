import 'dart:io';

import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:markaa/slack.dart';

import 'src/pages/markaa_app/markaa_app.dart';
import 'src/routes/routes.dart';

const bool USE_FIRESTORE_EMULATOR = false;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await EasyLocalization.ensureInitialized();
  await SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  EquatableConfig.stringify = kDebugMode;
  ErrorWidget.builder = ((FlutterErrorDetails e) {
    SlackChannels.send(e.exceptionAsString(), SlackChannels.logAppErrors);
    return Center(
      child: Text("There was an error! ${e.exception}"),
    );
  });

  /// Firebase initialize
  await Firebase.initializeApp();
  if (USE_FIRESTORE_EMULATOR)
    FirebaseFirestore.instance.settings = const Settings(
      host: 'localhost:8080',
      sslEnabled: false,
      persistenceEnabled: false,
    );

  if (Platform.isIOS)
    try {
      final TrackingStatus status = await AppTrackingTransparency.trackingAuthorizationStatus;
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
