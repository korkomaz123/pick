import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'config.dart';
import 'src/pages/markaa_app/markaa_app.dart';
import 'src/routes/routes.dart';

const bool USE_FIRESTORE_EMULATOR = false;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  EquatableConfig.stringify = kDebugMode;

  /// Firebase initialize
  await Firebase.initializeApp();
  if (USE_FIRESTORE_EMULATOR)
    FirebaseFirestore.instance.settings = const Settings(host: 'localhost:8080', sslEnabled: false, persistenceEnabled: false);

  //Start Loading Assets
  await Config.appOpen();

  String token = await Config.localRepo.getToken();
  print("token ====> $token");
  runApp(
    EasyLocalization(
      path: 'lib/public/languages',
      useOnlyLangCode: true,
      supportedLocales: [
        Locale('en', 'EN'),
        Locale('ar', 'AR'),
      ],
      saveLocale: true,
      child: MarkaaApp(home: token != null && token.isNotEmpty ? Routes.home : Routes.home),
    ),
  );
}
