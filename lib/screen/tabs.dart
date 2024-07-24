import 'package:flutter/material.dart';
import 'package:seventh_project/categories.dart';
import 'package:seventh_project/data/dummy_data.dart';
import 'package:seventh_project/models/meal.dart';
import 'package:seventh_project/screen/filter.dart';
import 'package:seventh_project/screen/meals.dart';
import 'package:seventh_project/widgets/main_drawer.dart';

const kInitialFilters = {
  Filter.glutenFree: false,
  Filter.lactoseFree: false,
  Filter.vegetarian: false,
  Filter.vegan: false
};

class TabScreen extends StatefulWidget {
  const TabScreen({
    super.key,
  });

  @override
  State<TabScreen> createState() => _TabScreenState();
}

class _TabScreenState extends State<TabScreen> {
  var _selectedPageIndex = 0;
  final List<Meal> _favouriteMeals = [];
  Map<Filter, bool> _selectedFiltres = kInitialFilters;

  void _showInfoMessage(String msgg) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msgg),
      ),
    );
  }

  void _toggleMealFavoriteStatus(Meal meal) {
    final isExisting = _favouriteMeals.contains(meal);

    if (isExisting) {
      setState(() {
        _favouriteMeals.remove(meal);
      });
      _showInfoMessage('Meal is no longer a favorite.');
    } else {
      setState(() {
        _favouriteMeals.add(meal);
      });
      _showInfoMessage('Marked as a fovorite!');
    }
  }

  void _selectPage(index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  void _setScreen(String identifier) async {
    Navigator.of(context).pop();
    if (identifier == 'filters') {
      final result = await Navigator.of(context).push<Map<Filter, bool>>(
        MaterialPageRoute(
          builder: (ctx) => FilterScreen(
            currentFilters: _selectedFiltres,
          ),
        ),
      );

      setState(() {
        _selectedFiltres = result ?? kInitialFilters;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final availableMeals = dummyMeals.where((meal) {
      if (_selectedFiltres[Filter.glutenFree]! && !meal.isGlutenFree) {
        return false;
      }
      if (_selectedFiltres[Filter.lactoseFree]! && !meal.isLactoseFree) {
        return false;
      }
      if (_selectedFiltres[Filter.vegetarian]! && !meal.isVegetarian) {
        return false;
      }
      if (_selectedFiltres[Filter.vegan]! && !meal.isVegan) {
        return false;
      }

      return true;
    }).toList();
    Widget activePage = CategoriesScreen(
      onToggleFavorite: _toggleMealFavoriteStatus,
      availableMeals: availableMeals,
    );
    var activePageTitle = 'Categories';
    if (_selectedPageIndex == 1) {
      activePage = MealScreen(
        meals: _favouriteMeals,
        onToggleFavorite: _toggleMealFavoriteStatus,
      );
      activePageTitle = 'Your Favourite';
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(activePageTitle),
      ),
      drawer: MainDrawer(
        onSelectScreen: _setScreen,
      ),
      body: activePage,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedPageIndex,
        onTap: _selectPage,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.set_meal), label: 'Categories'),
          BottomNavigationBarItem(icon: Icon(Icons.star), label: 'favourites'),
        ],
      ),
    );
  }
}
