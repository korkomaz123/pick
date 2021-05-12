import 'package:flutter/material.dart';

//Common

Map<int, Color> markaaColor = {
  50: Color(0xFF0C5EED),
  100: Color(0xFF0C5EED),
  200: Color(0xFF0C5EED),
  300: Color(0xFF0C5EED),
  400: Color(0xFF0C5EED),
  500: Color(0xFF0C5EED),
  600: Color(0xFF0C5EED),
  700: Color(0xFF0C5EED),
  800: Color(0xFF0C5EED),
  900: Color(0xFF0C5EED)
};

MaterialColor markaaMaterialColor = MaterialColor(0xFF0C5EED, markaaColor);

final ThemeData markaaAppTheme = ThemeData(
  primarySwatch: markaaMaterialColor,
  primaryColor: Color(0xFF287EF2),
  accentColor: Color(0xFFB4C9FA),
  primaryTextTheme: TextTheme(headline6: TextStyle(color: Colors.black)),
  appBarTheme: AppBarTheme(
    color: markaaMaterialColor,
    iconTheme: IconThemeData(color: Colors.white),
  ),
  textSelectionTheme: TextSelectionThemeData(
    selectionColor: Colors.grey[400],
    cursorColor: Colors.orange,
    selectionHandleColor: Colors.orange,
  ),
);

/// App Colors
const Color primarySwatchColor = Color(0xFF0C5EED);
const Color primaryColor = Color(0xFF287EF2);
const Color accentColor = Color(0xFFB4C9FA);
const Color backgroundColor = Color(0xFFEDEDED);
const Color filterBackgroundColor = Color(0xFFFFFFFF);
const Color bottomBarColor = Color(0xFFDDDDDD);
const Color badgeColor = Color(0xFFFF2929);
const Color darkColor = Color(0xFF4A4A4A);
const Color greyDarkColor = Color(0xFF4B4B4B);
const Color greyColor = Color(0xFF838383);
const Color succeedColor = Color(0xFF2E9017);
const Color favoriteColor = Color(0xFFFF5757);
const Color dangerColor = Color(0xFFC10000);
const Color greyLightColor = Color(0xFFEAEAEA);
const Color orangeColor = Color(0xFFFF800A);
