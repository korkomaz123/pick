import 'package:markaa/src/data/mock/mock.dart';
import 'package:markaa/src/data/models/brand_entity.dart';
import 'package:markaa/src/data/models/index.dart';
import 'package:markaa/src/data/models/product_list_arguments.dart';
import 'package:markaa/src/pages/home/bloc/home_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isco_custom_widgets/isco_custom_widgets.dart';
import 'package:markaa/src/routes/routes.dart';

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
    homeBloc.add(HomeAdsLoaded(lang: lang));
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeBloc, HomeState>(
      listener: (context, state) {},
      builder: (context, state) {
        if (state.ads != null) {
          return InkWell(
            onTap: () {
              if (state.ads.categoryId != null) {
                final arguments = ProductListArguments(
                  category: CategoryEntity(
                    id: state.ads.categoryId,
                    name: state.ads.categoryName,
                  ),
                  brand: BrandEntity(),
                  subCategory: [],
                  selectedSubCategoryIndex: 0,
                  isFromBrand: false,
                );
                Navigator.pushNamed(
                  context,
                  Routes.productList,
                  arguments: arguments,
                );
              } else if (state?.ads?.brand?.optionId != null) {
                final arguments = ProductListArguments(
                  category: CategoryEntity(),
                  brand: state.ads.brand,
                  subCategory: [],
                  selectedSubCategoryIndex: 0,
                  isFromBrand: true,
                );
                Navigator.pushNamed(
                  context,
                  Routes.productList,
                  arguments: arguments,
                );
              }
            },
            child: Image.network(state.ads.bannerImage),
          );
        }
        return Container();
      },
    );
  }
}
