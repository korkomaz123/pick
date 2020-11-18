import 'package:ciga/src/components/ciga_app_bar.dart';
import 'package:ciga/src/components/ciga_bottom_bar.dart';
import 'package:ciga/src/components/ciga_side_menu.dart';
import 'package:ciga/src/config/config.dart';
import 'package:ciga/src/data/mock/mock.dart';
import 'package:ciga/src/data/models/enum.dart';
import 'package:ciga/src/data/models/index.dart';
import 'package:ciga/src/data/models/product_model.dart';
import 'package:ciga/src/pages/product/bloc/product_bloc.dart';
import 'package:ciga/src/pages/product/widgets/product_more_about.dart';
import 'package:ciga/src/theme/theme.dart';
import 'package:ciga/src/utils/progress_service.dart';
import 'package:ciga/src/utils/snackbar_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isco_custom_widgets/isco_custom_widgets.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'widgets/product_related_items.dart';
import 'widgets/product_same_brand_products.dart';
import 'widgets/product_single_product.dart';

class ProductPage extends StatefulWidget {
  final Object arguments;

  ProductPage({this.arguments});

  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final _refreshController = RefreshController(initialRefresh: false);
  PageStyle pageStyle;
  ProductModel product;
  ProductBloc productBloc;
  ProgressService progressService;
  SnackBarService snackBarService;

  @override
  void initState() {
    super.initState();
    product = widget.arguments as ProductModel;
    progressService = ProgressService(context: context);
    snackBarService = SnackBarService(
      context: context,
      scaffoldKey: scaffoldKey,
    );
    productBloc = context.bloc<ProductBloc>();
    productBloc.add(ProductDetailsLoaded(
      productId: product.productId,
      lang: lang,
    ));
  }

  @override
  void dispose() {
    productBloc.add(ProductInitialized());
    super.dispose();
  }

  void _onRefresh() async {
    productBloc.add(ProductDetailsLoaded(
      productId: product.productId,
      lang: lang,
    ));
  }

  @override
  Widget build(BuildContext context) {
    pageStyle = PageStyle(context, designWidth, designHeight);
    pageStyle.initializePageStyles();
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: backgroundColor,
      appBar: CigaAppBar(pageStyle: pageStyle, scaffoldKey: scaffoldKey),
      drawer: CigaSideMenu(pageStyle: pageStyle),
      body: BlocConsumer<ProductBloc, ProductState>(
        listener: (context, state) {
          if (state is ProductDetailsLoadedInProcess) {
            progressService.showProgress();
          }
          if (state is ProductDetailsLoadedSuccess) {
            progressService.hideProgress();
            _refreshController.refreshCompleted();
          }
          if (state is ProductDetailsLoadedFailure) {
            progressService.hideProgress();
            snackBarService.showErrorSnackBar(state.message);
            _refreshController.refreshCompleted();
          }
        },
        builder: (context, state) {
          if (state is ProductDetailsLoadedSuccess) {
            return SmartRefresher(
              enablePullDown: true,
              enablePullUp: false,
              header: MaterialClassicHeader(color: primaryColor),
              controller: _refreshController,
              onRefresh: _onRefresh,
              onLoading: () => null,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    ProductSingleProduct(
                      pageStyle: pageStyle,
                      product: product,
                      productEntity: state.productEntity,
                    ),
                    ProductRelatedItems(
                      pageStyle: pageStyle,
                      product: product,
                    ),
                    ProductSameBrandProducts(
                      pageStyle: pageStyle,
                      product: product,
                    ),
                    ProductMoreAbout(
                      pageStyle: pageStyle,
                      productEntity: state.productEntity,
                    ),
                  ],
                ),
              ),
            );
          } else {
            return Container(color: Colors.white);
          }
        },
      ),
      bottomNavigationBar: CigaBottomBar(
        pageStyle: pageStyle,
        activeItem: BottomEnum.home,
      ),
    );
  }
}
