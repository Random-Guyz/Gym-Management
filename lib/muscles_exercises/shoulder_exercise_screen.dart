import 'package:flutter/material.dart';
import '.././screens/muscle_tile.dart';

import 'package:url_launcher/url_launcher.dart';

class ShoulderExerciseScreen extends StatelessWidget {
  final String muscleName;
  final String imagePath;
  const ShoulderExerciseScreen({
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
        title: const Text('Shoulder Muscles Exercises'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            MuscleTile(
              muscleName: 'Shoulder Press',
              imagePath: 'assets/exercises/Shoulders/shoulderpress.webp',
              onTap: () {
                _launchYoutubeApp('0JfYxMRsUCQ');
              },
            ),
            MuscleTile(
              muscleName: 'Arnold Press',
              imagePath: 'assets/exercises/Shoulders/arnoldpress.jpg',
              onTap: () {
                _launchYoutubeApp('6Z15_WdXmVw');
              },
            ),
            MuscleTile(
              muscleName: 'Front Raise',
              imagePath: 'assets/exercises/Shoulders/frontraise.png',
              onTap: () {
                _launchYoutubeApp('hRJ6tR5-if0');
              },
            ),
            MuscleTile(
              muscleName: 'Reverse Peck Deck',
              imagePath: 'assets/exercises/Shoulders/reversepeckdeck.webp',
              onTap: () {
                _launchYoutubeApp('5YK4bgzXDp0');
              },
            ),
            MuscleTile(
              muscleName: 'Lateral Raise',
              imagePath: 'assets/exercises/Shoulders/lateralraise.jpg',
              onTap: () {
                _launchYoutubeApp('OuG1smZTsQQ');
              },
            ),
            MuscleTile(
              muscleName: 'Upright Row',
              imagePath: 'assets/exercises/Shoulders/uprightrow.webp',
              onTap: () {
                _launchYoutubeApp('um3VVzqunPU');
              },
            ),
          ],
        ),
      ),
    );
  }
}
