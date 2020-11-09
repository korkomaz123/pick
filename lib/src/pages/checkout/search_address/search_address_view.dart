import 'package:ciga/src/change_notifier/place_change_notifier.dart';
import 'package:ciga/src/theme/styles.dart';
import 'package:ciga/src/theme/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class SearchAddressView extends StatefulWidget {
  final PlaceChangeNotifier placeChangeNotifier;
  SearchAddressView({this.placeChangeNotifier});

  @override
  _SearchAddressViewState createState() => _SearchAddressViewState();
}

class _SearchAddressViewState extends State<SearchAddressView> {
  String valueFrom, valueTo;
  bool checkAutoFocus = false, inputFrom = false, inputTo = false;
  FocusNode nodeFrom = FocusNode();
  FocusNode nodeTo = FocusNode();
  String formLocation;
  String toLocation;

  @override
  void initState() {
    super.initState();
    formLocation = widget?.placeChangeNotifier?.formLocation?.name;
  }

  navigator() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: <Widget>[
          _buildForm(widget?.placeChangeNotifier),
          Container(
            height: 20,
            color: Color(0xfff5f5f5),
          ),
          widget?.placeChangeNotifier?.listPlace != null
              ? Expanded(
                  child: ListView.separated(
                    shrinkWrap: true,
                    itemCount: widget?.placeChangeNotifier?.listPlace?.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(
                          widget?.placeChangeNotifier?.listPlace[index]?.name,
                        ),
                        subtitle: Text(
                          widget?.placeChangeNotifier?.listPlace[index]
                                  ?.formattedAddress ??
                              '',
                        ),
                        onTap: () {
                          widget?.placeChangeNotifier
                              ?.selectLocation(
                                  widget?.placeChangeNotifier?.listPlace[index])
                              ?.then((_) {
                            toLocation = widget
                                ?.placeChangeNotifier?.locationSelect?.name;
                            FocusScope.of(context).requestFocus(nodeTo);
                            navigator();
                          });
                        },
                      );
                    },
                    separatorBuilder: (context, index) => Divider(
                      height: 1,
                      color: greyColor.withOpacity(0.5),
                    ),
                  ),
                )
              : Container(),
        ],
      ),
    );
  }

  Widget _buildForm(PlaceChangeNotifier placeChangeNotifier) {
    return Container(
      padding: EdgeInsets.only(bottom: 20.0),
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Expanded(flex: 1, child: Icon(Icons.location_on, color: dangerColor)),
          Expanded(
            flex: 5,
            child: Form(
              child: TextField(
                style: mediumTextStyle,
                autofocus: true,
                focusNode: nodeTo,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: "checkout_search_address_title".tr(),
                  hintStyle: TextStyle(color: greyColor, fontSize: 14),
                  contentPadding: EdgeInsets.only(top: 15.0),
                ),
                controller: TextEditingController.fromValue(
                  TextEditingValue(
                    text: toLocation != null ? toLocation : '',
                    selection: TextSelection.collapsed(
                      offset: toLocation != null ? toLocation?.length : 0,
                    ),
                  ),
                ),
                onChanged: (String value) async {
                  toLocation = value;
                  await placeChangeNotifier?.search(value);
                },
                onTap: () {
                  setState(() {
                    inputTo = true;
                    inputFrom = false;
                  });
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
