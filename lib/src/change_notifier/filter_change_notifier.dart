import 'package:flutter/material.dart';
import 'package:markaa/src/utils/repositories/filter_repository.dart';

class FilterChangeNotifier extends ChangeNotifier {
  FilterRepository _filterRepository = FilterRepository();

  Map<String, dynamic> availableFilters = {};

  initialize() {
    availableFilters = {};
  }

  Future<void> loadFilterAttributes(
    String categoryId,
    String brandId,
    String lang,
  ) async {
    initialize();
    final result =
        await _filterRepository.getFilterAttributes(categoryId, brandId, lang);
    if (result['code'] == 'SUCCESS') {
      availableFilters = result['filter']['availablefilter'];
      result['filter']['prices']['attribute_code'] = 'price';
      availableFilters['Price'] = result['filter']['prices'];
      notifyListeners();
    }
  }
}
