import 'package:flutter/material.dart';
import '../diets/highcarbdietscreen.dart';
import '../diets/highproteindietscreen.dart';
import '../diets/hypertrophydietscreen.dart';
import '../diets/lowcarbdietscreen.dart';
import '../diets/musclegaindietscreen.dart';
import '../diets/weightlossdietscreen.dart';
//import '../screens/diet_screen.dart'; // Import the diet screen file
import 'muscle_tile.dart';

class DietScreen extends StatelessWidget {
  const DietScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Diets'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            MuscleTile(
              muscleName: 'High Carb Diet',
              imagePath: 'assets/diets/highcarb.webp', // Add the path to the diet image
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const HighCarbDiet(), // Navigate to the diet screen
                  ),
                );
              },
            ),
            MuscleTile(
              muscleName: 'High Protein Diet',
              imagePath: 'assets/diets/highprotein.webp',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const HighProteinDiet(
                    ),
                  ),
                );
              },
            ),

            MuscleTile(
              muscleName: 'HyperTrophy Diet',
              imagePath: 'assets/diets/hypertrophy.jpeg',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const HyperTrophyDiet(
                    ),
                  ),
                );
              },
            ),
            MuscleTile(
              muscleName: 'Low Carb Diet',
              imagePath: 'assets/diets/lowcarb.jpg',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LowCarbDiet(

                    ),
                  ),
                );
              },
            ),
            MuscleTile(
              muscleName: 'Muscle Gain Diet',
              imagePath: 'assets/diets/musclegain.webp',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const MuscleGainDiet(
                    ),
                  ),
                );
              },
            ),
            MuscleTile(
              muscleName: 'Weight Loss Diet',
              imagePath: 'assets/diets/weightloss.avif',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const WeightLossDiet(
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
