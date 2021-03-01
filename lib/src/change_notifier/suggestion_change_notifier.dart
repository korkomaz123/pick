import 'package:markaa/src/data/models/product_model.dart';
import 'package:markaa/src/pages/search/bloc/search_repository.dart';
import 'package:flutter/material.dart';

class SuggestionChangeNotifier extends ChangeNotifier {
  List<ProductModel> suggestions = [];
  List<ProductModel> searchedProducts = [];

  void initializeSuggestion() {
    suggestions = [];
    searchedProducts = [];
    notifyListeners();
  }

  Future<void> getSuggestions(String query, String lang) async {
    suggestions = [];
    notifyListeners();
    final searchRepository = SearchRepository();
    suggestions = await searchRepository.getSearchSuggestion(query, lang);
    notifyListeners();
  }

  Future<void> searchProducts(
    String query,
    String lang,
    List<dynamic> categories,
    List<dynamic> brands,
  ) async {
    searchedProducts = null;
    notifyListeners();
    final searchRepository = SearchRepository();
    searchedProducts =
        await searchRepository.searchProducts(query, categories, brands, lang);
    notifyListeners();
  }
}
