import 'package:ciga/src/bloc/place_bloc.dart';
import 'package:ciga/src/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'search_address_view.dart';

class SearchAddressScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var bloc = Provider.of<PlaceBloc>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        title: Text(
          "Search address",
          style: TextStyle(color: greyDarkColor),
        ),
        iconTheme: IconThemeData(color: greyDarkColor),
      ),
      body: NotificationListener<OverscrollIndicatorNotification>(
        onNotification: (overScroll) {
          overScroll.disallowGlow();
          return false;
        },
        child: SearchAddressView(placeBloc: bloc),
      ),
    );
  }
}
