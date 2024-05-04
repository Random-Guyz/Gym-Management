import 'package:flutter/material.dart';

class WeightLossDiet extends StatelessWidget {
  const WeightLossDiet({super.key});

  @override
  Widget build(BuildContext context) {
    // Define the calories for each meal component
    const breakfastCalories = 300;
    const morningSnackCalories = 150;
    const lunchCalories = 400;
    const eveningSnackCalories = 150;
    const dinnerCalories = 500;

    // Calculate the overall total calories
    const overallTotalCalories = breakfastCalories +
        morningSnackCalories +
        lunchCalories +
        eveningSnackCalories +
        dinnerCalories;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Weight Loss Diet'),
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
            _buildMealSection('Breakfast', ['Oatmeal', 'Fruit'], breakfastCalories),
            _buildMealSection('Morning Snack', ['Greek yogurt', 'Berries'], morningSnackCalories),
            _buildMealSection('Lunch', ['Grilled chicken salad', 'Mixed vegetables'], lunchCalories),
            _buildMealSection('Evening Snack', ['Almonds', 'Apple'], eveningSnackCalories),
            _buildMealSection('Dinner', ['Salmon', 'Steamed broccoli'], dinnerCalories),
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
