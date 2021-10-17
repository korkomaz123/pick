import 'package:markaa/src/apis/firebase_path.dart';
import 'package:markaa/src/config/config.dart';
import 'package:markaa/src/data/models/version_entity.dart';
import 'package:markaa/src/utils/repositories/firebase_repository.dart';

class AppRepository {
  final firebaseRepository = FirebaseRepository();

  //////////////////////////////////////////////////////////////////////////////
  /// [CHECK APP VERSION BETWEEN STORE & LOCAL VERSION]
  //////////////////////////////////////////////////////////////////////////////
  Future<VersionEntity> checkAppVersion(
    bool isAndroid, [
    String lang = 'en',
  ]) async {
    final path = FirebasePath.APP_VERSION_DOC_PATH;
    final doc = await firebaseRepository.loadDoc(path);
    final data = doc.data() as Map<String, dynamic>;
    int androidStoreVersion = data['android'];
    int iOSStoreVersion = data['ios'];
    int androidMinVersion = data['androidMinVersion'];
    int iOSMinVersion = data['iosMinVersion'];
    String newVersionString =
        isAndroid ? data['androidVersionString'] : data['iosVersionString'];
    String title = lang == 'en' ? data['dialogTitleEn'] : data['dialogTitleAr'];
    String content =
        lang == 'en' ? data['dialogContentEn'] : data['dialogContentAr'];
    bool canUpdate = isAndroid
        ? androidStoreVersion > MarkaaVersion.androidVersion
        : iOSStoreVersion > MarkaaVersion.iOSVersion;
    bool updateMandatory = isAndroid
        ? androidMinVersion > MarkaaVersion.androidVersion
        : iOSMinVersion > MarkaaVersion.iOSVersion;
    String storeLink = isAndroid ? data['playStoreLink'] : data['appStoreLink'];
    final versionEntity = VersionEntity(
      canUpdate: canUpdate,
      updateMandatory: updateMandatory,
      dialogTitle: title,
      dialogContent: content.replaceFirst('###', newVersionString),
      storeLink: storeLink,
    );
    return versionEntity;
  }
}
