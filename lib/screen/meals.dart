import 'package:flutter/material.dart';
import 'package:seventh_project/models/meal.dart';
import 'package:seventh_project/screen/meal_detail_screen.dart';
import 'package:seventh_project/widgets/meal_item.dart';

class MealScreen extends StatelessWidget {
  const MealScreen({
    super.key,
    required this.meals,
    this.title,
  });

  final String? title;
  final List<Meal> meals;

  void selectMeal(BuildContext context,Meal meal) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => MealDetailScreen(meal: meal),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget content = ListView.builder(
      itemCount: meals.length,
      itemBuilder: (ctx, index) {
        return MealItem(
          meal: meals[index],
          onSelectMeal: (BuildContext context, meal) {
            selectMeal(context, meal);
          },
        );
      },
    );

    if (meals.isEmpty) {
      content = Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Uh oh ... nothing herea!',
              style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
            ),
            const SizedBox(
              height: 16,
            ),
            Text(
              'Try selecting a different category!',
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
            ),
          ],
        ),
      );
    }

    if(title==null)
    {
      return content;
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(title!),
      ),
      body: content,
    );
  }
}
