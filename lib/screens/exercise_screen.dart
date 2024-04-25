import 'package:flutter/material.dart';
import '../muscles_exercises/abs_execise_screen.dart';
import '../muscles_exercises/back_exercise_screen.dart';
import '../muscles_exercises/biceps_exercise_screen.dart';
import '../muscles_exercises/chest_exercise_screen.dart';
import '../muscles_exercises/legs_exercise_screen.dart';
import '../muscles_exercises/shoulder_exercise_screen.dart';
import '../muscles_exercises/triceps_exercise_screen.dart';
import 'muscle_tile.dart';

class ExerciseScreen extends StatelessWidget {
  const ExerciseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Muscles'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            MuscleTile(
              muscleName: 'Chest',
              imagePath: 'assets/muscles/chest.jpg',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ChestExerciseScreen(
                      muscleName: 'Chest',
                      imagePath: 'assets/muscles/chest.jpg',
                    ),
                  ),
                );
              },
            ),
            MuscleTile(
              muscleName: 'Biceps',
              imagePath: 'assets/muscles/biceps.jpg',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const BicepsExerciseScreen(
                      muscleName: 'Biceps',
                      imagePath: 'assets/muscles/biceps.jpg',
                    ),
                  ),
                );
              },
            ),
            MuscleTile(
              muscleName: 'Triceps',
              imagePath: 'assets/muscles/triceps.jpg',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const TricepsExerciseScreen(
                      muscleName: 'Triceps',
                      imagePath: 'assets/muscles/triceps.jpg',
                    ),
                  ),
                );
              },
            ),
            MuscleTile(
              muscleName: 'Abs',
              imagePath: 'assets/muscles/abs.jpg',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AbsExerciseScreen(
                      muscleName: 'Abs',
                      imagePath: 'assets/muscles/abs.jpg',
                    ),
                  ),
                );
              },
            ),
            MuscleTile(
              muscleName: 'Shoulders',
              imagePath: 'assets/muscles/shoulders.jpg',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ShoulderExerciseScreen(
                      muscleName: 'Shoulders',
                      imagePath: 'assets/muscles/Shoulders.jpg',
                    ),
                  ),
                );
              },
            ),
            MuscleTile(
              muscleName: 'Legs',
              imagePath: 'assets/muscles/legs.jpg',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LegsExerciseScreen(
                      muscleName: 'Legs',
                      imagePath: 'assets/muscles/legs.jpg',
                    ),
                  ),
                );
              },
            ),
            MuscleTile(
              muscleName: 'Back',
              imagePath: 'assets/muscles/back.jpg',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const BackExerciseScreen(
                      muscleName: 'Back',
                      imagePath: 'assets/muscles/back.jpg',
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
