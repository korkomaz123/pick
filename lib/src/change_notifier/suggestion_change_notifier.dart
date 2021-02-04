import 'package:markaa/src/data/models/product_model.dart';
import 'package:markaa/src/pages/search/bloc/search_repository.dart';
import 'package:flutter/material.dart';

class SuggestionChangeNotifier extends ChangeNotifier {
  List<ProductModel> suggestions = [];

  Future<void> getSuggestions(String query, String lang) async {
    suggestions = [];
    notifyListeners();
    final searchRepository = SearchRepository();
    suggestions = await searchRepository.getSearchSuggestion(query, lang);
    notifyListeners();
  }
}
