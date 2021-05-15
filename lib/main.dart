import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';

import 'preload.dart';
import 'src/pages/markaa_app/markaa_app.dart';
import 'src/routes/routes.dart';
import 'src/utils/repositories/local_storage_repository.dart';

const bool USE_FIRESTORE_EMULATOR = false;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await EasyLocalization.ensureInitialized();
  await SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  EquatableConfig.stringify = kDebugMode;
  ErrorWidget.builder = ((FlutterErrorDetails e) {
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

  String _page = Routes.start;
  // await LocalStorageRepository().removeItem('usage');

  bool isExist = await LocalStorageRepository().existItem('usage');
  String token = await Preload.localRepo.getToken();

  if (isExist) {
    //Start Loading Assets
    await Preload.appOpen();
    _page = token != null && token.isNotEmpty ? Routes.home : Routes.home;
  }
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
      child: Phoenix(child: MarkaaApp(home: _page)),
    ),
  );
}
