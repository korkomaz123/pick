import 'package:ciga/src/data/mock/mock.dart';
import 'package:ciga/src/data/models/user_entity.dart';
import 'package:ciga/src/pages/home/bloc/home_bloc.dart';
import 'package:ciga/src/pages/home/bloc/home_repository.dart';
import 'package:ciga/src/pages/sign_in/bloc/sign_in_bloc.dart';
import 'package:ciga/src/pages/sign_in/bloc/sign_in_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:ciga/src/change_notifier/place_change_notifier.dart';
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

  final HomeRepository homeRepository = HomeRepository();
  final SignInRepository signInRepository = SignInRepository();

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
      value: homeRepository,
      child: RepositoryProvider.value(
        value: signInRepository,
        child: ChangeNotifierProvider<PlaceChangeNotifier>(
          create: (context) => PlaceChangeNotifier(),
          child: MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (context) => HomeBloc(
                  homeRepository: homeRepository,
                ),
              ),
              BlocProvider(
                create: (context) => SignInBloc(
                  signInRepository: signInRepository,
                ),
              ),
            ],
            child: CigaAppView(),
          ),
        ),
      ),
    );
  }
}

class CigaAppView extends StatefulWidget {
  @override
  _CigaAppViewState createState() => _CigaAppViewState();
}

class _CigaAppViewState extends State<CigaAppView> {
  final _navigatorKey = GlobalKey<NavigatorState>();

  LocalStorageInterface localStorage;

  @override
  void initState() {
    super.initState();
    _getCurrentUser();
  }

  void _getCurrentUser() async {
    localStorage = await LocalStorage.getInstance();
    String token = localStorage.getString('token') != null
        ? localStorage.getString('token')
        : '';
    if (token.isNotEmpty) {
      final signInRepo = context.repository<SignInRepository>();
      final result = await signInRepo.getCurrentUser(token);
      if (result['code'] == 'SUCCESS') {
        result['data']['customer']['token'] = token;
        user = UserEntity.fromJson(result['data']['customer']);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    lang = EasyLocalization.of(context).locale.languageCode;
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
