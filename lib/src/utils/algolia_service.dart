import 'package:algolia/algolia.dart';
import 'package:markaa/src/config/config.dart';

class AlgoliaService {
  static final Algolia algolia = Algolia.init(
    applicationId: AlgoliaConfig.appId,
    apiKey: AlgoliaConfig.apiKey,
  );
}
