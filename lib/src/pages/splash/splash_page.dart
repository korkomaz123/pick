import 'dart:async';

import 'package:ciga/src/config/config.dart';
import 'package:ciga/src/routes/routes.dart';
import 'package:ciga/src/theme/icons.dart';
import 'package:ciga/src/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:isco_custom_widgets/styles/page_style.dart';

class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  PageStyle _pageStyle;

  @override
  void initState() {
    super.initState();
    Timer.periodic(Duration(seconds: 5), (timer) {
      timer.cancel();
      Navigator.pushNamedAndRemoveUntil(
        context,
        Routes.home,
        (route) => false,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    _pageStyle = PageStyle(context, designWidth, designHeight);
    _pageStyle.initializePageStyles();
    return Scaffold(
      backgroundColor: primarySwatchColor,
      body: Center(
        child: Container(
          width: _pageStyle.unitWidth * 229.01,
          height: _pageStyle.unitHeight * 129.45,
          child: SvgPicture.asset(vLogoIcon),
        ),
      ),
    );
  }
}
