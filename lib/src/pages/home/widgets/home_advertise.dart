import 'package:markaa/src/pages/home/bloc/home_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isco_custom_widgets/isco_custom_widgets.dart';

class HomeAdvertise extends StatefulWidget {
  final PageStyle pageStyle;

  HomeAdvertise({this.pageStyle});

  @override
  _HomeAdvertiseState createState() => _HomeAdvertiseState();
}

class _HomeAdvertiseState extends State<HomeAdvertise> {
  HomeBloc homeBloc;
  String ads;

  @override
  void initState() {
    super.initState();
    homeBloc = context.read<HomeBloc>();
    homeBloc.add(HomeAdsLoaded());
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeBloc, HomeState>(
      listener: (context, state) {},
      builder: (context, state) {
        ads = state.ads;
        return ads.isNotEmpty ? Image.network(ads) : Container();
      },
    );
  }
}
