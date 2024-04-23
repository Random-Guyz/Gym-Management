import 'package:flutter/material.dart';

import '.././screens/muscle_tile.dart';

import 'package:url_launcher/url_launcher.dart';

class BicepsExerciseScreen extends StatelessWidget {
  final String muscleName;
  final String imagePath;
  const BicepsExerciseScreen({
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
        title: const Text('Biceps Muscles Exercises'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            MuscleTile(
              muscleName: 'Barbell Curl',
              imagePath: 'assets/exercises/Biceps/barbellcurl.jpeg',
              onTap: () {
                _launchYoutubeApp('kwG2ipFRgfo');
              },
            ),
            MuscleTile(
              muscleName: 'Dumbell Curl',
              imagePath: 'assets/exercises/Biceps/dumbellcurl.webp',
              onTap: () {
                _launchYoutubeApp('ykJmrZ5v0Oo');
              },
            ),
            MuscleTile(
              muscleName: 'Hammer Curls',
              imagePath: 'assets/exercises/Biceps/hammercurls.jpg',
              onTap: () {
                _launchYoutubeApp('TwD-YGVP4Bk');
              },
            ),
            MuscleTile(
              muscleName: 'Concentration Curls',
              imagePath: 'assets/exercises/Biceps/concentrationcurl.jpg',
              onTap: () {
                _launchYoutubeApp('0AUGkch3tzc');
              },
            ),
            MuscleTile(
              muscleName: 'Preacher Curls',
              imagePath: 'assets/exercises/Biceps/preachercurls.webp',
              onTap: () {
                _launchYoutubeApp('Ja6ZlIDONac');
              },
            ),
            MuscleTile(
              muscleName: 'Cable Curls',
              imagePath: 'assets/exercises/Biceps/cablecurl.jpeg',
              onTap: () {
                _launchYoutubeApp('opFVuRi_3b8');
              },
            ),
          ],
        ),
      ),
    );
  }
}
