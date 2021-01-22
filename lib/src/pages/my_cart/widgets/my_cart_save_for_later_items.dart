import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:isco_custom_widgets/isco_custom_widgets.dart';
import 'package:markaa/src/data/mock/mock.dart';
import 'package:markaa/src/data/models/product_model.dart';
import 'package:markaa/src/pages/my_cart/bloc/my_cart/my_cart_bloc.dart';
import 'package:markaa/src/pages/my_cart/bloc/my_cart_repository.dart';
import 'package:markaa/src/pages/my_cart/bloc/save_later/save_later_bloc.dart';
import 'package:markaa/src/theme/styles.dart';
import 'package:markaa/src/theme/theme.dart';
import 'package:markaa/src/theme/icons.dart';
import 'package:markaa/src/utils/flushbar_service.dart';
import 'package:markaa/src/utils/local_storage_repository.dart';
import 'package:markaa/src/utils/progress_service.dart';

class MyCartSaveForLaterItems extends StatefulWidget {
  final PageStyle pageStyle;
  final ProgressService progressService;
  final FlushBarService flushBarService;
  final SaveLaterBloc saveLaterBloc;
  final MyCartBloc cartBloc;
  final MyCartRepository cartRepo;
  final LocalStorageRepository localRepo;

  MyCartSaveForLaterItems({
    this.pageStyle,
    this.progressService,
    this.flushBarService,
    this.saveLaterBloc,
    this.cartBloc,
    this.cartRepo,
    this.localRepo,
  });

  @override
  _MyCartSaveForLaterItemsState createState() =>
      _MyCartSaveForLaterItemsState();
}

class _MyCartSaveForLaterItemsState extends State<MyCartSaveForLaterItems> {
  String cartId = '';

  @override
  void initState() {
    super.initState();
    _getMyCartId();
  }

  void _getMyCartId() async {
    if (user?.token != null) {
      final result = await widget.cartRepo.getCartId(user.token);
      if (result['code'] == 'SUCCESS') {
        cartId = result['cartId'];
      }
    } else {
      cartId = await widget.localRepo.getCartId();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SaveLaterBloc, SaveLaterState>(
      listener: (context, state) {
        if (state is SaveLaterItemChangedSuccess) {
          if (state.product != null) {
            if (state.action == 'delete') {
              widget.cartBloc.add(MyCartItemAdded(
                cartId: cartId,
                product: state.product,
                qty: state.product.qtySaveForLater.toString(),
              ));
            } else {
              widget.cartBloc.add(MyCartItemRemoved(
                cartId: cartId,
                itemId: state.itemId,
              ));
            }
          }
          widget.saveLaterBloc.add(SaveLaterItemsLoaded(
            token: user.token,
            lang: lang,
          ));
        }
      },
      builder: (context, state) {
        if (state is SaveLaterItemsLoadedSuccess) {
          if (state.items.isNotEmpty) {
            return Container(
              width: widget.pageStyle.deviceWidth,
              color: backgroundColor,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: widget.pageStyle.deviceWidth,
                    color: Colors.white,
                    padding: EdgeInsets.only(
                      left: widget.pageStyle.unitWidth * 10,
                      right: widget.pageStyle.unitWidth * 10,
                      top: widget.pageStyle.unitHeight * 20,
                      bottom: widget.pageStyle.unitHeight * 10,
                    ),
                    child: Text(
                      'Save For Later',
                      style: mediumTextStyle.copyWith(
                        fontSize: widget.pageStyle.unitFontSize * 23,
                        color: greyDarkColor,
                      ),
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(
                      vertical: widget.pageStyle.unitHeight * 10,
                    ),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: state.items.map((item) {
                          return _buildItem(item);
                        }).toList(),
                      ),
                    ),
                  ),
                  Container(
                    width: widget.pageStyle.deviceWidth,
                    height: widget.pageStyle.unitHeight * 60,
                    color: Colors.white,
                  ),
                ],
              ),
            );
          } else {
            return Container();
          }
        }
        return Container();
      },
    );
  }

  Widget _buildItem(ProductModel item) {
    return Container(
      width: widget.pageStyle.unitWidth * 180,
      margin: EdgeInsets.only(left: widget.pageStyle.unitWidth * 10),
      padding: EdgeInsets.all(widget.pageStyle.unitWidth * 10),
      color: Colors.white,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                onTap: () => _onRemoveItem(item),
                child: Icon(
                  Icons.remove_circle_outline,
                  size: widget.pageStyle.unitFontSize * 22,
                  color: greyDarkColor,
                ),
              ),
              InkWell(
                onTap: () => _onPutInCart(item),
                child: SvgPicture.asset(
                    lang == 'en' ? putInCartEnIcon : putInCartArIcon),
              ),
            ],
          ),
          Image.network(
            item.imageUrl,
            width: widget.pageStyle.unitWidth * 140,
            height: widget.pageStyle.unitHeight * 160,
          ),
          Container(
            width: double.infinity,
            padding: EdgeInsets.only(top: widget.pageStyle.unitHeight * 5),
            child: Text(
              item.description,
              style: mediumTextStyle.copyWith(
                fontSize: widget.pageStyle.unitFontSize * 14,
              ),
            ),
          ),
          Divider(color: darkColor),
          Container(
            width: double.infinity,
            child: Text(
              item.price + 'currency'.tr(),
              style: mediumTextStyle.copyWith(
                color: greyColor,
                fontSize: widget.pageStyle.unitFontSize * 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _onRemoveItem(ProductModel item) {
    widget.saveLaterBloc.add(SaveLaterItemChanged(
      token: user.token,
      productId: item.productId,
      action: 'delete',
      qty: item.qtySaveForLater,
    ));
  }

  void _onPutInCart(ProductModel item) {
    widget.saveLaterBloc.add(SaveLaterItemChanged(
      token: user.token,
      productId: item.productId,
      action: 'delete',
      qty: item.qtySaveForLater,
      product: item,
    ));
  }
}
