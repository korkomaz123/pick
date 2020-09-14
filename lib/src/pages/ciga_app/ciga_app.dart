import 'package:provider/provider.dart';
import 'package:ciga/src/bloc/place_bloc.dart';
import 'package:ciga/src/routes/generator.dart';
import 'package:ciga/src/theme/theme.dart';
import 'package:cross_local_storage/cross_local_storage.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cupertino_back_gesture/cupertino_back_gesture.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class CigaApp extends StatelessWidget {
  CigaApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<PlaceBloc>(
      create: (context) => PlaceBloc(),
      child: CigaAppView(),
    );
  }
}

class CigaAppView extends StatefulWidget {
  @override
  _CigaAppViewState createState() => _CigaAppViewState();
}

class _CigaAppViewState extends State<CigaAppView> {
  final _navigatorKey = GlobalKey<NavigatorState>();

  // NavigatorState get _navigator => _navigatorKey.currentState;

  LocalStorageInterface localStorage;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BackGestureWidthTheme(
      backGestureWidth: BackGestureWidth.fraction(1 / 2),
      child: MaterialApp(
        navigatorKey: _navigatorKey,
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          EasyLocalization.of(context).delegate,
          const FallbackCupertinoLocalisationsDelegate(),
        ],
        supportedLocales: EasyLocalization.of(context).supportedLocales,
        locale: EasyLocalization.of(context).locale,
        debugShowCheckedModeBanner: false,
        theme: cigaAppTheme,
        initialRoute: '/',
        onGenerateRoute: (settings) {
          return RouteGenerator.generateRoute(settings);
        },
      ),
    );
  }
}

class FallbackCupertinoLocalisationsDelegate
    extends LocalizationsDelegate<CupertinoLocalizations> {
  const FallbackCupertinoLocalisationsDelegate();

  @override
  bool isSupported(Locale locale) => true;

  @override
  Future<CupertinoLocalizations> load(Locale locale) =>
      DefaultCupertinoLocalizations.load(locale);

  @override
  bool shouldReload(FallbackCupertinoLocalisationsDelegate old) => false;
}
