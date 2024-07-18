import 'package:flutter/material.dart';
import 'package:seventh_project/data/dummy_data.dart';
import 'package:seventh_project/models/category.dart';
import 'package:seventh_project/screen/meals.dart';
import 'package:seventh_project/widgets/category_grid_item.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({
    super.key,
  });

  void _selectCategory(BuildContext context, Category category) {
    final getData = dummyMeals
        .where((meal) => meal.categories.contains(category.id))
        .toList();

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => MealScreen(
          meals: getData,
          title: category.title,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GridView(
      padding: const EdgeInsets.all(24.0),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 20.0,
        crossAxisSpacing: 20.0,
        childAspectRatio: 3 / 2,
      ),
      children: [
        for (final Category in availableCategories)
          CategoryGridItem(
            category: Category,
            onSelectCategory: () {
              _selectCategory(context, Category);
            },
          ),
      ],
    );
  }
}
