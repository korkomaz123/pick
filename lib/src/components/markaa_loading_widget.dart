import 'dart:async';

import 'package:flutter/material.dart';

import 'markaa_page_loading_kit.dart';

class MarkaaLoadingWidget extends StatefulWidget {
  final Widget? child;

  const MarkaaLoadingWidget({Key? key, this.child}) : super(key: key);

  @override
  _MarkaaLoadingWidgetState createState() => _MarkaaLoadingWidgetState();
}

class _MarkaaLoadingWidgetState extends State<MarkaaLoadingWidget> {
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    Timer.periodic(Duration(seconds: 5), (_) {
      isLoading = false;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!isLoading) return widget.child ?? Container();
    return Center(child: PulseLoadingSpinner());
  }
}
