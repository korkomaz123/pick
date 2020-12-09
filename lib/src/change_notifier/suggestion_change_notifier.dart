import 'package:ciga/src/data/models/product_model.dart';
import 'package:ciga/src/pages/search/bloc/search_repository.dart';
import 'package:flutter/material.dart';

class SuggestionChangeNotifier extends ChangeNotifier {
  List<ProductModel> suggestions = [];

  Future<void> getSuggestions(String query, String lang) async {
    suggestions = [];
    notifyListeners();
    final searchRepository = SearchRepository();
    final result = await searchRepository.getSearchSuggestion(query, lang);
    if (result['code'] == 'SUCCESS') {
      List<dynamic> suggestionList = result['products'];
      for (int i = 0; i < suggestionList.length; i++) {
        suggestions.add(ProductModel.fromJson(suggestionList[i]));
      }
    } else {
      suggestions = [];
    }
    notifyListeners();
  }
}
