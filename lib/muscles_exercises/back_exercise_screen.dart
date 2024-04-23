import 'package:flutter/material.dart';
import '.././screens/muscle_tile.dart';
import 'package:url_launcher/url_launcher.dart';

class BackExerciseScreen extends StatelessWidget {
  final String muscleName;
  final String imagePath;
  const BackExerciseScreen({
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
        title: const Text('Back Muscles Exercises'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            MuscleTile(
              muscleName: 'Barbell Row',
              imagePath: 'assets/exercises/Back/barbellrow.jpg',
              onTap: () {
                _launchYoutubeApp('6FZHJGzMFEc');
              },
            ),
            MuscleTile(
              muscleName: 'Deadlift',
              imagePath: 'assets/exercises/Back/Deadlift.jpg',
              onTap: () {
                _launchYoutubeApp('1ZXobu7JvvE');
              },
            ),
            MuscleTile(
              muscleName: 'LatPullDown',
              imagePath: 'assets/exercises/Back/Latpulldown.webp',
              onTap: () {
                _launchYoutubeApp('JGeRYIZdojU');
              },
            ),
            MuscleTile(
              muscleName: 'Pullup',
              imagePath: 'assets/exercises/Back/pullup.webp',
              onTap: () {
                _launchYoutubeApp('aAggnpPyR6E');
              },
            ),
            MuscleTile(
              muscleName: 'Seated Row',
              imagePath: 'assets/exercises/Back/seatedrow.webp',
              onTap: () {
                _launchYoutubeApp('UCXxvVItLoM');
              },
            ),
            MuscleTile(
              muscleName: 'T Bar Row',
              imagePath: 'assets/exercises/Back/Tbarrow.webp',
              onTap: () {
                _launchYoutubeApp('yPis7nlbqdY');
              },
            ),
          ],
        ),
      ),
    );
  }
}
