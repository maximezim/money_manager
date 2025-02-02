import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/category.dart';

class CategoryRepository {
  static final List<Category> categories = [
    Category(name: 'Food'),
    Category(name: 'Transportation'),
    Category(name: 'Entertainment'),
    Category(name: 'Utilities'),
    Category(name: 'Salary'),
  ];

  static Future<void> loadCategories() async {
    final prefs = await SharedPreferences.getInstance();
    final String? data = prefs.getString('categories');
    if (data != null) {
      final List<dynamic> jsonList = jsonDecode(data);
      categories.clear();
      categories.addAll(jsonList.map((e) => Category.fromJson(e)).toList());
    }
  }

  static Future<void> saveCategories() async {
    final prefs = await SharedPreferences.getInstance();
    final String data = jsonEncode(categories.map((e) => e.toJson()).toList());
    await prefs.setString('categories', data);
  }

  static Future<void> addCategory(Category category) async {
    categories.add(category);
    await saveCategories();
  }
}
