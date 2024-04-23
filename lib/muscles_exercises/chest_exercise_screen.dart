import 'package:flutter/material.dart';
import '.././screens/muscle_tile.dart';

import 'package:url_launcher/url_launcher.dart';

class ChestExerciseScreen extends StatelessWidget {
  final String muscleName;
  final String imagePath;
  const ChestExerciseScreen({
    super.key,
    required this.muscleName,
    required this.imagePath,
  });

  void _launchYoutubeApp(String videoId) async {
    final String url = 'https://www.youtube.com/watch?v=$videoId';
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chest Muscles Exercises'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            MuscleTile(
              muscleName: 'Flat bench Workout',
              imagePath: 'assets/exercises/Chest/flatbench.jpg',
              onTap: () {
                _launchYoutubeApp('zubTrcIIl74');
              },
            ),
            MuscleTile(
              muscleName: 'Incline Bench Workout',
              imagePath: 'assets/exercises/Chest/inclinebench.jpg',
              onTap: () {
                _launchYoutubeApp('SrqOu55lrYU');
              },
            ),
            MuscleTile(
              muscleName: 'Pushups',
              imagePath: 'assets/exercises/Chest/pushups.jpg',
              onTap: () {
                _launchYoutubeApp('5aRHy5ZPjwk');
              },
            ),
            MuscleTile(
              muscleName: 'ChestFly',
              imagePath: 'assets/exercises/Chest/chestfly.jpg',
              onTap: () {
                _launchYoutubeApp('4mfLHnFL0Uw');
              },
            ),
            MuscleTile(
              muscleName: 'Close Grip Bench Press',
              imagePath: 'assets/exercises/Chest/closegripbench.webp',
              onTap: () {
                _launchYoutubeApp('qf_FTh3QyYs');
              },
            ),
            MuscleTile(
              muscleName: 'Chest Dumbell Flyover',
              imagePath: 'assets/exercises/Chest/dumbellfly.webp',
              onTap: () {
                _launchYoutubeApp('Nhvz9EzdJ4U');
              },
            ),
          ],
        ),
      ),
    );
  }
}
