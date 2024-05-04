import 'package:flutter/material.dart';

class HighProteinDiet extends StatelessWidget {
  const HighProteinDiet({super.key});

  @override
  Widget build(BuildContext context) {
    // Define the calories for each meal component
    const breakfastCalories = 400;
    const morningSnackCalories = 200;
    const lunchCalories = 600;
    const eveningSnackCalories = 200;
    const dinnerCalories = 800;

    // Calculate the overall total calories
    const overallTotalCalories = breakfastCalories +
        morningSnackCalories +
        lunchCalories +
        eveningSnackCalories +
        dinnerCalories;

    return Scaffold(
      appBar: AppBar(
        title: const Text('High Protein Diet'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Overall Total Calories: $overallTotalCalories kcal',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            _buildMealSection('Breakfast', ['Egg whites', 'Turkey bacon'], breakfastCalories),
            _buildMealSection('Morning Snack', ['Greek yogurt', 'Mixed nuts'], morningSnackCalories),
            _buildMealSection('Lunch', ['Grilled chicken breast', 'Quinoa'], lunchCalories),
            _buildMealSection('Evening Snack', ['Cottage cheese', 'Protein shake'], eveningSnackCalories),
            _buildMealSection('Dinner', ['Salmon', 'Steamed vegetables'], dinnerCalories),
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
