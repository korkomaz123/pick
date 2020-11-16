import 'package:flutter/material.dart';

class CigaLoadingDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black.withOpacity(0.5),
      child: Center(
        child: Image.asset(
          'lib/public/images/loading/loading.gif',
          width: 160,
          height: 60,
        ),
      ),
    );
  }
}
