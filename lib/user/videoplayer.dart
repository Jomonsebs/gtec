import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class VideoPlayerScreen extends StatefulWidget {
  final String url;
  const VideoPlayerScreen({Key? key, required this.url}) : super(key: key);

  @override
  _VideoPlayerScreenState createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late YoutubePlayerController _controller;
  bool isFullScreen = false;

  @override
  void initState() {
    super.initState();
    final videoId = YoutubePlayerController.convertUrlToId(widget.url);

    _controller = YoutubePlayerController.fromVideoId(
      videoId: videoId ?? '',
      params: YoutubePlayerParams(
        showControls: false, // Hide all YouTube controls (like share, volume, etc.)
        showFullscreenButton: false, // Hide fullscreen button
        mute: false, // Unmute video
        loop: false, // Disable looping
        playsInline: true, // Play inline on mobile devices
      ),
    );
  }

  @override
  void dispose() {
    _controller.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Video Player'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            _controller.close();
            Navigator.pop(context);
          },
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0), // Add some padding
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center, // Center the content vertically
            crossAxisAlignment: CrossAxisAlignment.center, // Center horizontally
            children: [
              Container(
                width: double.infinity, // Ensure full width for the player
                height: 250, // Reduced height for the player
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12), // Rounded corners for the player
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      offset: Offset(0, 4),
                      blurRadius: 10,
                    ),
                  ],
                ),
                child: YoutubePlayer(
                  controller: _controller,
                  aspectRatio: 18 /11,
                ),
              ),
              SizedBox(height: 20), // Add some space between the video and buttons
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: Icon(
                        _controller.value.playerState == PlayerState.playing
                            ? Icons.pause
                            : Icons.play_arrow,
                      ),
                      onPressed: () {
                        if (_controller.value.playerState == PlayerState.playing) {
                          _controller.pauseVideo();  // Pause video
                        } else {
                          _controller.playVideo();  // Play video
                        }
                      },
                      color: Colors.white,
                      iconSize: 40,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
