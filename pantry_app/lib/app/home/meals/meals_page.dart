import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pantry_app/app/home/meals/edit_meal_page.dart';
import 'package:pantry_app/app/home/meals/empty_content.dart';
import 'package:pantry_app/app/home/meals/list_items_builder.dart';
import 'package:pantry_app/app/home/meals/meal_list_tile.dart';
import 'package:pantry_app/app/home/models/meal.dart';
import 'package:pantry_app/common_widgets/show_alert_dialog.dart';
import 'package:pantry_app/common_widgets/show_exception_alert_dialog.dart';
import 'package:pantry_app/services/auth.dart';
import 'package:pantry_app/services/database.dart';
import 'package:provider/provider.dart';

class MealsPage extends StatelessWidget {
  const MealsPage({Key? key}) : super(key: key);

  Future<void> _delete(BuildContext context, Meal meal) async {
    try {
      final database = Provider.of<Database>(context, listen: false);
      await database.deleteMeal(meal);
    } on FirebaseException catch (e) {
      showExceptionAlertDialog(context,
          title: 'Operation Failed', exception: e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meals'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add, color: Colors.white),
            onPressed: () => EditMealPage.show(
              context,
            ),
          ),
        ],
      ),
      body: _buildContents(context),
    );
  }

  Widget _buildContents(BuildContext context) {
    final database = Provider.of<Database>(context);
    return StreamBuilder<List<Meal>>(
        stream: database.mealsStream(),
        builder: (context, snapshot) {
          return ListItemsBuilder<Meal>(
            snapshot: snapshot,
            itemBuilder: (context, meal) => Dismissible(
              key: Key('meal-${meal.id}'),
              background: Container(color: Colors.red),
              direction: DismissDirection.endToStart,
              onDismissed: (direction) => _delete(context, meal),
              child: MealListTile(
                meal: meal,
                onTap: () => EditMealPage.show(context, meal: meal),
              ),
            ),
          );
        });
  }
}
