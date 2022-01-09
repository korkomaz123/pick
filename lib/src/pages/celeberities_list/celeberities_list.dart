import 'package:markaa/src/apis/api.dart';
import 'package:markaa/src/apis/endpoints.dart';
import 'package:markaa/src/components/celebrity_card.dart';
import 'package:markaa/src/components/markaa_app_bar.dart';
import 'package:markaa/src/components/markaa_bottom_bar.dart';
import 'package:markaa/src/components/markaa_page_loading_kit.dart';
import 'package:markaa/src/components/markaa_side_menu.dart';
import 'package:markaa/src/data/mock/mock.dart';
import 'package:markaa/src/data/models/enum.dart';
import 'package:markaa/src/data/models/index.dart';
import 'package:markaa/src/theme/styles.dart';
import 'package:markaa/src/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CelebritiesListPage extends StatefulWidget {
  final dynamic arguments;

  CelebritiesListPage({this.arguments});

  @override
  _CelebritiesListPageState createState() => _CelebritiesListPageState();
}

class _CelebritiesListPageState extends State<CelebritiesListPage> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  List<dynamic> allCelebritiesList = [];
  bool isLoading = true;

  void getAllCelebrities() async {
    allCelebritiesList = [];
    setState(() => isLoading = true);
    final result = await Api.getMethod(EndPoints.getAllCelebrities, data: {'lang': lang}, extra: {"refresh": true});
    if (result['code'] == 'SUCCESS') allCelebritiesList = result['celebrities'];
    setState(() => isLoading = false);
  }

  @override
  void initState() {
    super.initState();
    getAllCelebrities();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.white,
      appBar: MarkaaAppBar(scaffoldKey: scaffoldKey, isCenter: false),
      drawer: MarkaaSideMenu(),
      body: Stack(
        children: [
          if (isLoading)
            Center(child: PulseLoadingSpinner())
          else
            GridView.builder(
              itemCount: allCelebritiesList.length,
              padding: EdgeInsets.symmetric(vertical: 20.h),
              itemBuilder: (ctx, index) {
                return Container(
                  padding: const EdgeInsets.all(3.0),
                  child: CelebrityCard(
                    celebrity: allCelebritiesList[index],
                    cardWidth: 187.25.w,
                    cardHeight: 280.h,
                  ),
                );
              },
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, childAspectRatio: 3 / 4),
            ),
          _buildAppBar(),
        ],
      ),
      bottomNavigationBar: MarkaaBottomBar(activeItem: BottomEnum.home),
    );
  }

  Widget _buildAppBar() {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: Container(
        width: 375.w,
        height: 40.h,
        color: primarySwatchColor,
        alignment: Alignment.center,
        padding: EdgeInsets.only(left: 10.w, right: 10.w, bottom: 10.h),
        child: Stack(
          alignment: AlignmentDirectional.center,
          children: [
            Align(
              alignment: Alignment.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    child: Icon(Icons.arrow_back_ios, color: Colors.white, size: 20.sp),
                    onTap: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: Text(
                widget.arguments['title'],
                style: mediumTextStyle.copyWith(color: Colors.white, fontSize: 17.sp),
              ),
            )
          ],
        ),
      ),
    );
  }
}
