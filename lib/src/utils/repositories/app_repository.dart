import 'package:markaa/preload.dart';
import 'package:markaa/src/apis/api.dart';
import 'package:markaa/src/apis/endpoints.dart';
import 'package:markaa/src/apis/firebase_path.dart';
import 'package:markaa/src/config/config.dart';
import 'package:markaa/src/data/models/delivery_rule_entity.dart';
import 'package:markaa/src/data/models/payment_method_entity.dart';
import 'package:markaa/src/data/models/region_entity.dart';
import 'package:markaa/src/data/models/shipping_method_entity.dart';
import 'package:markaa/src/data/models/version_entity.dart';
import 'package:markaa/src/utils/repositories/firebase_repository.dart';

class AppRepository {
  final firebaseRepository = FirebaseRepository();

  //////////////////////////////////////////////////////////////////////////////
  /// [CHECK APP VERSION BETWEEN STORE & LOCAL VERSION]
  //////////////////////////////////////////////////////////////////////////////
  Stream<VersionEntity> checkAppVersion(bool isAndroid, [String lang = 'en']) {
    final path = FirebasePath.APP_VERSION_DOC_PATH;
    final docStream = firebaseRepository.loadDocStream(path);
    return docStream.asyncMap((data) {
      int androidStoreVersion = data['android'];
      int iOSStoreVersion = data['ios'];
      int androidMinVersion = data['androidMinVersion'];
      int iOSMinVersion = data['iosMinVersion'];
      String newVersionString = isAndroid ? data['androidVersionString'] : data['iosVersionString'];
      String title = lang == 'en' ? data['dialogTitleEn'] : data['dialogTitleAr'];
      String content = lang == 'en' ? data['dialogContentEn'] : data['dialogContentAr'];
      bool canUpdate =
          isAndroid ? androidStoreVersion > MarkaaVersion.androidVersion : iOSStoreVersion > MarkaaVersion.iOSVersion;
      bool updateMandatory =
          isAndroid ? androidMinVersion > MarkaaVersion.androidVersion : iOSMinVersion > MarkaaVersion.iOSVersion;
      String storeLink = isAndroid ? data['playStoreLink'] : data['appStoreLink'];
      final versionEntity = VersionEntity(
        canUpdate: canUpdate,
        updateMandatory: updateMandatory,
        dialogTitle: title,
        dialogContent: content.replaceFirst('###', newVersionString),
        storeLink: storeLink,
      );
      return versionEntity;
    });
  }

  //////////////////////////////////////////////////////////////////////////////
  ///
  //////////////////////////////////////////////////////////////////////////////
  Future<List<ShippingMethodEntity>> getShippingMethod() async {
    String url = EndPoints.getShippingMethod;
    final data = {'lang': Preload.language};
    final result = await Api.getMethod(url, data: data);
    if (result['code'] == 'SUCCESS') {
      List<dynamic> shippingMethodList = result['data'];
      List<ShippingMethodEntity> methods = [];
      for (int i = 0; i < shippingMethodList.length; i++) {
        methods.add(ShippingMethodEntity.fromJson(shippingMethodList[i]));
      }
      return methods;
    } else {
      return <ShippingMethodEntity>[];
    }
  }

  //////////////////////////////////////////////////////////////////////////////
  ///
  //////////////////////////////////////////////////////////////////////////////
  Future<List<PaymentMethodEntity>> getPaymentMethod() async {
    String url = EndPoints.getPaymentMethod;
    final data = {'lang': Preload.language};
    final result = await Api.getMethod(url, data: data);
    if (result['code'] == 'SUCCESS') {
      List<String> keys = (result['data'] as Map<String, dynamic>).keys.toList();
      List<PaymentMethodEntity> methods = [];
      for (int i = 0; i < keys.length; i++) {
        methods.add(PaymentMethodEntity.fromJson(result['data'][keys[i]]));
      }
      return methods;
    } else {
      return <PaymentMethodEntity>[];
    }
  }

  //////////////////////////////////////////////////////////////////////////////
  /// [GET REGIONS LIST]
  //////////////////////////////////////////////////////////////////////////////
  Future<List<RegionEntity>> getRegions([
    String countryCode = 'KW',
  ]) async {
    Map<String, dynamic> regionsList = await Api.getMethod(
      EndPoints.getRegions,
      data: {"lang": Preload.language, "country_code": countryCode},
    );
    List<RegionEntity> _regionsObjs = [];
    if (regionsList['code'] == 'SUCCESS') {
      regionsList['regions'].forEach((region) => _regionsObjs.add(RegionEntity.fromJson(region)));
    }
    return _regionsObjs;
  }

  //////////////////////////////////////////////////////////////////////////////
  ///
  //////////////////////////////////////////////////////////////////////////////
  Future<DeliveryRuleEntity?> getDeliveryRule(String lang) async {
    String url = EndPoints.getDeliveryRules;
    final params = {'lang': lang};
    final result = await Api.getMethod(url, data: params);
    if (result['code'] == 'SUCCESS') {
      return DeliveryRuleEntity.fromJson(result['data']);
    }
    return null;
  }
}
