import 'package:markaa/src/components/markaa_bottom_bar.dart';
import 'package:markaa/src/components/markaa_page_loading_kit.dart';
import 'package:markaa/src/components/secondary_app_bar.dart';
import 'package:markaa/src/data/mock/mock.dart';
import 'package:markaa/src/data/models/enum.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:markaa/src/utils/repositories/setting_repository.dart';

class TermsPage extends StatefulWidget {
  @override
  _TermsPageState createState() => _TermsPageState();
}

class _TermsPageState extends State<TermsPage> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.white,
      appBar: SecondaryAppBar(title: 'account_terms_title'.tr()),
      body: _buildAboutUsView(),
      bottomNavigationBar: MarkaaBottomBar(
        activeItem: BottomEnum.account,
      ),
    );
  }

  Widget _buildAboutUsView() {
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(15.w),
            child: FutureBuilder<dynamic>(
              future: SettingRepository().getTerms(lang),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return Html(data: snapshot.data['data']['html']);
                } else {
                  return Center(
                    child: PulseLoadingSpinner(),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
