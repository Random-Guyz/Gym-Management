import 'package:flutter/material.dart';

class HyperTrophyDiet extends StatelessWidget {
  const HyperTrophyDiet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Define the calories for each meal component
    final breakfastCalories = 500;
    final morningSnackCalories = 250;
    final lunchCalories = 700;
    final eveningSnackCalories = 300;
    final dinnerCalories = 800;

    // Calculate the overall total calories
    final overallTotalCalories = breakfastCalories +
        morningSnackCalories +
        lunchCalories +
        eveningSnackCalories +
        dinnerCalories;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Hypertrophy Diet'),
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
            _buildMealSection('Breakfast', ['Oatmeal', 'Fruit smoothie'], breakfastCalories),
            _buildMealSection('Morning Snack', ['Protein bar', 'Almonds'], morningSnackCalories),
            _buildMealSection('Lunch', ['Grilled chicken', 'Brown rice', 'Steamed vegetables'], lunchCalories),
            _buildMealSection('Evening Snack', ['Greek yogurt', 'Mixed berries'], eveningSnackCalories),
            _buildMealSection('Dinner', ['Salmon', 'Quinoa', 'Broccoli'], dinnerCalories),
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
