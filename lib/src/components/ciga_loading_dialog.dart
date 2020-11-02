import 'package:flutter/material.dart';

import 'ciga_page_loading_kit.dart';

class CigaLoadingDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Center(
        child: PouringHourLoadingSpinner(),
      ),
    );
  }
}
