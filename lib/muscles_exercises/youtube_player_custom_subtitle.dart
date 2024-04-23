import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class YoutubePlayerCustomSubtitle extends StatefulWidget {
  final String videoId;
  final void Function(String videoId) onLaunchYoutubeApp;

  const YoutubePlayerCustomSubtitle({
    super.key,
    required this.videoId,
    required this.onLaunchYoutubeApp,
  });

  @override
  State<YoutubePlayerCustomSubtitle> createState() =>
      _YoutubePlayerCustomSubtitleState();
}

class _YoutubePlayerCustomSubtitleState
    extends State<YoutubePlayerCustomSubtitle> {
  late YoutubePlayerController _controller;

  // For Custom Subtitle and Subtitle displaying duration
  List<Subtitle> subtitle = [
    Subtitle(start: 2, end: 10, text: "Animated Container Widget in Flutter"),
    // subtitle starts at 2 seconds and ends at 10 seconds
    Subtitle(start: 10, end: 20, text: "You can add your custom subtitle"),
    Subtitle(start: 20, end: 100, text: ""),
    // add more subtitles as required
  ];
  String subtitleText = "";

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId: widget.videoId,
      flags: const YoutubePlayerFlags(autoPlay: true, mute: false),
    )..addListener(_onPlayerStateChange);
  }

  void _onPlayerStateChange() {
    if (_controller.value.playerState == PlayerState.playing) {
      final currentTime = _controller.value.position.inSeconds;
      final currentSubtitle = subtitle.firstWhere(
        (subtitle) =>
            currentTime >= subtitle.start && currentTime <= subtitle.end,
        orElse: () => Subtitle(start: 0, end: 0, text: ""),
      );

      // Update the UI with the current subtitle
      setState(() {
        subtitleText = currentSubtitle.text;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("YouTube Video of Exercise"),
        actions: [
          IconButton(
            icon: const Icon(Icons.open_in_new),
            onPressed: () => widget.onLaunchYoutubeApp(widget.videoId),
          ),
        ],
      ),
      body: Stack(
        children: [
          YoutubePlayer(controller: _controller),
          Padding(
            padding: const EdgeInsets.only(left: 8.0, top: 190),
            child: Text(
              subtitleText,
              style: const TextStyle(fontSize: 17, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class Subtitle {
  final int start;
  final int end;
  final String text;

  Subtitle({
    required this.start,
    required this.end,
    required this.text,
  });
}
