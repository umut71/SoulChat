import 'package:flutter/material.dart';

class RecipeBookScreen extends StatelessWidget {
  const RecipeBookScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final recipes = [
      {'name': 'Spaghetti Carbonara', 'time': '30 min', 'difficulty': 'Easy', 'icon': '🍝'},
      {'name': 'Chicken Curry', 'time': '45 min', 'difficulty': 'Medium', 'icon': '🍛'},
      {'name': 'Caesar Salad', 'time': '15 min', 'difficulty': 'Easy', 'icon': '🥗'},
      {'name': 'Beef Steak', 'time': '25 min', 'difficulty': 'Medium', 'icon': '🥩'},
      {'name': 'Chocolate Cake', 'time': '60 min', 'difficulty': 'Hard', 'icon': '🍰'},
      {'name': 'Sushi Rolls', 'time': '40 min', 'difficulty': 'Hard', 'icon': '🍣'},
    ];
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recipe Book'),
        actions: [
          IconButton(icon: const Icon(Icons.search), onPressed: () {}),
          IconButton(icon: const Icon(Icons.filter_list), onPressed: () {}),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: recipes.length,
        itemBuilder: (context, index) {
          final recipe = recipes[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              leading: Text(recipe['icon']!, style: const TextStyle(fontSize: 50)),
              title: Text(recipe['name']!, style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text('${recipe['time']} • ${recipe['difficulty']}'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(icon: const Icon(Icons.favorite_border), onPressed: () {}),
                  const Icon(Icons.arrow_forward_ios),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
    );
  }
}
