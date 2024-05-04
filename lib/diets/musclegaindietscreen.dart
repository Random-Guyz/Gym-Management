import 'package:flutter/material.dart';

class MuscleGainDiet extends StatelessWidget {
  const MuscleGainDiet({super.key});

  @override
  Widget build(BuildContext context) {
    // Define the calories for each meal component
    const breakfastCalories = 600;
    const morningSnackCalories = 300;
    const lunchCalories = 800;
    const eveningSnackCalories = 300;
    const dinnerCalories = 1000;

    // Calculate the overall total calories
    const overallTotalCalories = breakfastCalories +
        morningSnackCalories +
        lunchCalories +
        eveningSnackCalories +
        dinnerCalories;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Muscle Gain Diet'),
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
            _buildMealSection('Breakfast', ['Eggs', 'Whole grain bread', 'Banana'], breakfastCalories),
            _buildMealSection('Morning Snack', ['Greek yogurt', 'Almonds'], morningSnackCalories),
            _buildMealSection('Lunch', ['Grilled chicken', 'Brown rice', 'Broccoli'], lunchCalories),
            _buildMealSection('Evening Snack', ['Protein shake', 'Peanut butter sandwich'], eveningSnackCalories),
            _buildMealSection('Dinner', ['Salmon', 'Sweet potato', 'Green beans'], dinnerCalories),
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
