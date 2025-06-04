import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class YoutubePlayerWidget extends StatefulWidget {
  final String youtubeUrl;

  const YoutubePlayerWidget({
    Key? key,
    required this.youtubeUrl,
  }) : super(key: key);

  @override
  State<YoutubePlayerWidget> createState() => _YoutubePlayerWidgetState();
}

class _YoutubePlayerWidgetState extends State<YoutubePlayerWidget> {
  late YoutubePlayerController _controller;
  late String _videoId;

  @override
  void initState() {
    super.initState();
    _videoId = YoutubePlayer.convertUrlToId(widget.youtubeUrl) ?? '';
    _controller = YoutubePlayerController(
      initialVideoId: _videoId,
      flags: const YoutubePlayerFlags(
        autoPlay: false,
        mute: false,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _videoId.isNotEmpty
        ? YoutubePlayer(
            controller: _controller,
            showVideoProgressIndicator: true,
            progressIndicatorColor: Color.fromARGB(255, 217, 112, 8),
            progressColors: ProgressBarColors(
              playedColor: Color.fromARGB(255, 217, 112, 8),
              handleColor: Color.fromARGB(255, 217, 112, 8),
            ),
          )
        : Container(
            height: 200,
            color: Colors.grey[300],
            child: Center(
              child: Text(
                'Invalid YouTube URL',
                style: TextStyle(fontSize: 16),
              ),
            ),
          );
  }
} 