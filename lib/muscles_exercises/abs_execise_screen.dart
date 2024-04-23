import 'package:flutter/material.dart';
import '.././screens/muscle_tile.dart';

import 'package:url_launcher/url_launcher.dart';

class AbsExerciseScreen extends StatelessWidget {
  final String muscleName;
  final String imagePath;
  const AbsExerciseScreen({
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
        title: const Text('Abs Exercises'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            MuscleTile(
              muscleName: 'Plank',
              imagePath: 'assets/exercises/Abs/plank.png',
              onTap: () {
                _launchYoutubeApp('pSHjTRCQxIw');
              },
            ),
            MuscleTile(
              muscleName: 'Crunches',
              imagePath: 'assets/exercises/Abs/crunches.jpeg',
              onTap: () {
                _launchYoutubeApp('5ER5Of4MOPI');
              },
            ),
            MuscleTile(
              muscleName: 'Hanging Knee Raise',
              imagePath: 'assets/exercises/Abs/hangingkneeraise.jpg',
              onTap: () {
                _launchYoutubeApp('RD_A-Z15ER4');
              },
            ),
            MuscleTile(
              muscleName: 'Mountain Climber',
              imagePath: 'assets/exercises/Abs/mountainclimber.webp',
              onTap: () {
                _launchYoutubeApp('ruQ4ZwncXBg');
              },
            ),
            MuscleTile(
              muscleName: 'Russian Twist',
              imagePath: 'assets/exercises/Abs/russiantwist.webp',
              onTap: () {
                _launchYoutubeApp('wkD8rjkodUI');
              },
            ),
            MuscleTile(
              muscleName: 'Leg Raises',
              imagePath: 'assets/exercises/Abs/legraises.jpg',
              onTap: () {
                _launchYoutubeApp('l4kQd9eWclE');
              },
            ),
          ],
        ),
      ),
    );
  }
}
