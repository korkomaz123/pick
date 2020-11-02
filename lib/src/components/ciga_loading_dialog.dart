import 'package:flutter/material.dart';

import 'ciga_page_loading_kit.dart';

class CigaLoadingDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black.withOpacity(0.3),
      child: Center(
        child: PouringHourLoadingSpinner(),
      ),
    );
  }
}
