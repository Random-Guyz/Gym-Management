import 'package:flutter/material.dart';

class HighCarbDiet extends StatelessWidget {
  const HighCarbDiet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Define the calories for each meal component
    final breakfastCalories = 500;
    final morningSnackCalories = 250;
    final lunchCalories = 700;
    final eveningSnackCalories = 250;
    final dinnerCalories = 800;

    // Calculate the overall total calories
    final overallTotalCalories = breakfastCalories +
        morningSnackCalories +
        lunchCalories +
        eveningSnackCalories +
        dinnerCalories;

    return Scaffold(
      appBar: AppBar(
        title: const Text('High Carb Diet'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Overall Total Calories: $overallTotalCalories kcal',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            _buildMealSection('Breakfast', ['Whole grain cereal', 'Banana'], breakfastCalories),
            _buildMealSection('Morning Snack', ['Granola bar', 'Orange juice'], morningSnackCalories),
            _buildMealSection('Lunch', ['Pasta', 'Tomato sauce', 'Bread'], lunchCalories),
            _buildMealSection('Evening Snack', ['Bagel', 'Jam'], eveningSnackCalories),
            _buildMealSection('Dinner', ['Brown rice', 'Vegetable curry'], dinnerCalories),
            const SizedBox(height: 20),
            const Text(
              'NOTE: This diet is designed for all weekdays, allowing for a day off if needed. However, it\'s important to maintain the overall calorie intake consistently throughout the week.',
              style: TextStyle(
                fontSize: 16,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMealSection(String title, List<String> meals, int totalCalories) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        for (final meal in meals)
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Text('- $meal'),
          ),
        const SizedBox(height: 8),
        Text(
          'Total Calories: $totalCalories kcal',
          style: const TextStyle(
            fontSize: 16,
            fontStyle: FontStyle.italic,
          ),
        ),
        const Divider(),
      ],
    );
  }
}
