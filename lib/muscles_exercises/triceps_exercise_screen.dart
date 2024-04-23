import 'package:flutter/material.dart';
import '.././screens/muscle_tile.dart';

import 'package:url_launcher/url_launcher.dart';

class TricepsExerciseScreen extends StatelessWidget {
  final String muscleName;
  final String imagePath;
  const TricepsExerciseScreen({
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
        title: const Text('Triceps Muscles Exercises'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            MuscleTile(
              muscleName: 'Triceps Pushdowns',
              imagePath: 'assets/exercises/Triceps/tricepspushdowns.jpeg',
              onTap: () {
                _launchYoutubeApp('6Fzep104f0s');
              },
            ),
            MuscleTile(
              muscleName: 'Triceps Rope Pushdowns',
              imagePath: 'assets/exercises/Triceps/tricepsropepushdown.jpg',
              onTap: () {
                _launchYoutubeApp('-xa-6cQaZKY');
              },
            ),
            MuscleTile(
              muscleName: 'Triceps KickBacks',
              imagePath: 'assets/exercises/Triceps/tricepskickbacks.jpg',
              onTap: () {
                _launchYoutubeApp('JPmbMOu4IYw');
              },
            ),
            MuscleTile(
              muscleName: 'Triceps Extension',
              imagePath: 'assets/exercises/Triceps/tricepsextensions.webp',
              onTap: () {
                _launchYoutubeApp('kqidUIf1eJE');
              },
            ),
            MuscleTile(
              muscleName: 'Triceps Dips',
              imagePath: 'assets/exercises/Triceps/tricepsdips.jpg',
              onTap: () {
                _launchYoutubeApp('ynm9hhHJFEU');
              },
            ),
            MuscleTile(
              muscleName: 'Skull Crushers',
              imagePath: 'assets/exercises/Triceps/skullcrushers.webp',
              onTap: () {
                _launchYoutubeApp('l3rHYPtMUo8');
              },
            ),
          ],
        ),
      ),
    );
  }
}
