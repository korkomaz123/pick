import 'package:ciga/src/components/product_v_card.dart';
import 'package:ciga/src/data/mock/mock.dart';
import 'package:ciga/src/data/models/product_model.dart';
import 'package:ciga/src/pages/product/bloc/product_repository.dart';
import 'package:ciga/src/theme/styles.dart';
import 'package:ciga/src/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:isco_custom_widgets/isco_custom_widgets.dart';

class ProductRelatedItems extends StatefulWidget {
  final PageStyle pageStyle;
  final ProductModel product;

  ProductRelatedItems({this.pageStyle, this.product});

  @override
  _ProductRelatedItemsState createState() => _ProductRelatedItemsState();
}

class _ProductRelatedItemsState extends State<ProductRelatedItems> {
  PageStyle pageStyle;
  ProductModel product;

  @override
  void initState() {
    super.initState();
    pageStyle = widget.pageStyle;
    product = widget.product;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: pageStyle.deviceWidth,
      padding: EdgeInsets.symmetric(
        horizontal: pageStyle.unitWidth * 10,
        vertical: pageStyle.unitHeight * 6,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'product_related_items'.tr(),
            style: mediumTextStyle.copyWith(
              color: greyColor,
              fontSize: pageStyle.unitFontSize * 16,
            ),
          ),
          SizedBox(height: pageStyle.unitHeight * 4),
          Container(
            width: double.infinity,
            height: pageStyle.unitHeight * 260,
            child: FutureBuilder(
              future: context
                  .repository<ProductRepository>()
                  .getRelatedProducts(product.productId, lang),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: snapshot.data.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: EdgeInsets.only(
                          right: pageStyle.unitWidth * 10,
                        ),
                        child: ProductVCard(
                          cardWidth: pageStyle.unitWidth * 150,
                          cardHeight: pageStyle.unitHeight * 256,
                          product: snapshot.data[index],
                          isShoppingCart: true,
                          isWishlist: true,
                          isShare: true,
                          pageStyle: pageStyle,
                        ),
                      );
                    },
                  );
                } else {
                  return Container();
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
