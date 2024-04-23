import 'package:flutter/material.dart';
import '.././screens/muscle_tile.dart';
import 'package:url_launcher/url_launcher.dart';

class LegsExerciseScreen extends StatelessWidget {
  final String muscleName;
  final String imagePath;
  const LegsExerciseScreen({
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
        title: const Text('Legs Muscles Exercises'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            MuscleTile(
              muscleName: 'Squats',
              imagePath: 'assets/exercises/Legs/squats.webp',
              onTap: () {
                _launchYoutubeApp('IB_icWRzi4E');
              },
            ),
            MuscleTile(
              muscleName: 'Goblet Squat',
              imagePath: 'assets/exercises/Legs/gobletsquat.jpg',
              onTap: () {
                _launchYoutubeApp('wzx1t-0RA0k');
              },
            ),
            MuscleTile(
              muscleName: 'Leg Curls',
              imagePath: 'assets/exercises/Legs/legcurl.jpg',
              onTap: () {
                _launchYoutubeApp('Orxowest56U');
              },
            ),
            MuscleTile(
              muscleName: 'Leg Press',
              imagePath: 'assets/exercises/Legs/legpress.jpg',
              onTap: () {
                _launchYoutubeApp('yZmx_Ac3880');
              },
            ),
            MuscleTile(
              muscleName: 'Calf Raises',
              imagePath: 'assets/exercises/Legs/calfraises.jpg',
              onTap: () {
                _launchYoutubeApp('eMTy3qylqnE');
              },
            ),
            MuscleTile(
              muscleName: 'Lunges',
              imagePath: 'assets/exercises/Legs/lunges.webp',
              onTap: () {
                _launchYoutubeApp('3XDriUn0udo');
              },
            ),
          ],
        ),
      ),
    );
  }
}
