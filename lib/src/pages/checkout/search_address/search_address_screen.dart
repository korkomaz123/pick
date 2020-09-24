import 'package:ciga/src/change_notifier/place_change_notifier.dart';
import 'package:ciga/src/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'search_address_view.dart';

class SearchAddressScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var bloc = Provider.of<PlaceChangeNotifier>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        title: Text(
          "checkout_search_address_title".tr(),
          style: TextStyle(color: greyDarkColor),
        ),
        iconTheme: IconThemeData(color: greyDarkColor),
      ),
      body: NotificationListener<OverscrollIndicatorNotification>(
        onNotification: (overScroll) {
          overScroll.disallowGlow();
          return false;
        },
        child: SearchAddressView(placeChangeNotifier: bloc),
      ),
    );
  }
}
