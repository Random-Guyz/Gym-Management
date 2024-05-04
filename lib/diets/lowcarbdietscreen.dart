import 'package:flutter/material.dart';

class LowCarbDiet extends StatelessWidget {
  const LowCarbDiet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Define the calories for each meal component
    final breakfastCalories = 300;
    final morningSnackCalories = 150;
    final lunchCalories = 500;
    final eveningSnackCalories = 150;
    final dinnerCalories = 600;

    // Calculate the overall total calories
    final overallTotalCalories = breakfastCalories +
        morningSnackCalories +
        lunchCalories +
        eveningSnackCalories +
        dinnerCalories;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Low Carb Diet'),
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
            _buildMealSection('Breakfast', ['Scrambled eggs', 'Avocado'], breakfastCalories),
            _buildMealSection('Morning Snack', ['Cheese sticks', 'Cucumber slices'], morningSnackCalories),
            _buildMealSection('Lunch', ['Grilled chicken salad', 'Spinach'], lunchCalories),
            _buildMealSection('Evening Snack', ['Celery with peanut butter', 'Hard-boiled eggs'], eveningSnackCalories),
            _buildMealSection('Dinner', ['Salmon fillet', 'Asparagus'], dinnerCalories),
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
