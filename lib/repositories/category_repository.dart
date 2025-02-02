import '../models/category.dart';

class CategoryRepository {
  static final List<Category> categories = [
    Category(name: 'Food'),
    Category(name: 'Transportation'),
    Category(name: 'Entertainment'),
    Category(name: 'Utilities'),
    Category(name: 'Salary'),
  ];

  static void addCategory(Category category) {
    categories.add(category);
  }
}
