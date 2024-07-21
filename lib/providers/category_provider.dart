import 'package:flutter/material.dart';
import 'package:shamo/models/category_model.dart';
import 'package:shamo/services/category_service.dart';

class CategoryProvider with ChangeNotifier {
  List<CategoryModel> _category = [];

  List<CategoryModel> get category => _category;

  set setCategory(List<CategoryModel> newValue) {
    _category = newValue;
    notifyListeners();
  }

  getCategory() async {
    try {
      List<CategoryModel> category = await CategoryService().getCategory();
      _category = category;
    } catch (e) {
      print(e);
    }
  }
}
