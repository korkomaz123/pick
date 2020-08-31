import 'package:ciga/src/bloc/place_bloc.dart';
import 'package:ciga/src/theme/styles.dart';
import 'package:ciga/src/theme/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SearchAddressView extends StatefulWidget {
  final PlaceBloc placeBloc;
  SearchAddressView({this.placeBloc});

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
    formLocation = widget?.placeBloc?.formLocation?.name;
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
          buildForm(widget?.placeBloc),
          Container(
            height: 20,
            color: Color(0xfff5f5f5),
          ),
          widget?.placeBloc?.listPlace != null
              ? Expanded(
                  child: ListView.separated(
                    shrinkWrap: true,
                    itemCount: widget?.placeBloc?.listPlace?.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(widget?.placeBloc?.listPlace[index].name),
                        subtitle: Text(
                          widget?.placeBloc?.listPlace[index].formattedAddress,
                        ),
                        onTap: () {
                          widget?.placeBloc
                              ?.selectLocation(
                                  widget?.placeBloc?.listPlace[index])
                              ?.then((_) {
                            toLocation =
                                widget?.placeBloc?.locationSelect?.name;
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
              : addressDefault(),
        ],
      ),
    );
  }

  Widget buildForm(PlaceBloc placeBloc) {
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
                  hintText: "Search Address",
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
                  await placeBloc?.search(value);
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

  Widget addressDefault() {
    return Container(
      color: Color(0xfff5f5f5),
      padding: EdgeInsets.only(left: 20, right: 20, bottom: 20),
      child: Row(
        children: <Widget>[
          GestureDetector(
            onTap: () {},
            child: Material(
              elevation: 1.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(30.0)),
              ),
              child: Container(
                padding: EdgeInsets.all(15.0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Icon(Icons.home, color: greyColor),
                    SizedBox(width: 10),
                    Text(
                      "Home",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          SizedBox(width: 10),
          GestureDetector(
            onTap: () {},
            child: Material(
              elevation: 1.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(30.0)),
              ),
              child: Container(
                padding: EdgeInsets.all(15.0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Icon(
                      Icons.work,
                      color: greyColor,
                    ),
                    SizedBox(width: 10),
                    Text(
                      "Company",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
