import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:markaa/src/theme/theme.dart';

class CigaLoadingDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black.withOpacity(0.3),
      child: Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: primaryColor,
        period: Duration(milliseconds: 2000),
        child: Center(
          child: SvgPicture.asset(
            'lib/public/icons/loading.svg',
            width: 120,
            height: 50,
          ),
        ),
      ),
    );
  }
}
