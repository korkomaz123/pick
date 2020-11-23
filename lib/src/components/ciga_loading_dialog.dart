import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CigaLoadingDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Center(
        child: SvgPicture.asset('lib/public/icons/loading.svg'),
      ),
    );
  }
}
