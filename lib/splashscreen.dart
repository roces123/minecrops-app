import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'homescreen.dart';
import 'package:flutter/foundation.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late VideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;

  // Flag to ensure navigation only happens once
  bool _navigated = false;

  @override
  void initState() {
    super.initState();

    // --- 1. Platform-Aware Video Loading ---
    if (kIsWeb) {
      // Use networkUrl for web assets (requires video copy in web/assets/)
      _controller = VideoPlayerController.networkUrl(
        Uri.parse('assets/mc.mp4'),
      );
    } else {
      // Use asset for mobile (Android/iOS)
      _controller = VideoPlayerController.asset('assets/mc.mp4');
    }
    // ----------------------------------------

    _initializeVideoPlayerFuture = _controller.initialize().then((_) {
      // Mute the video to help ensure smooth autoplay on web browsers
      _controller.setVolume(0.0);
      _controller.play();

      // Attach a listener to detect when the video finishes
      _controller.addListener(_videoListener);
    });
  }

  void _videoListener() {
    // Check if the widget is mounted and navigation hasn't occurred
    if (!mounted || _navigated) return;

    // Check if the video has reached its end
    if (_controller.value.isInitialized &&
        _controller.value.position >= _controller.value.duration)
    {
      _navigated = true;
      _controller.removeListener(_videoListener);

      // Navigate to the main screen
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_videoListener);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Determine the size: 60% of the screen width for a centered video
    final screenWidth = MediaQuery.of(context).size.width;
    final videoSize = screenWidth * 1.0; // Adjust 0.6 (60%) if needed

    return Scaffold(
      backgroundColor: Colors.white,
      body: FutureBuilder(
        future: _initializeVideoPlayerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            // --- 2. Sizing and Centering the Video ---
            return Center(
              child: SizedBox(
                // Enforce the smaller, controlled size
                width: videoSize,
                height: videoSize,
                child: AspectRatio(
                  // Maintain the video's original proportions
                  aspectRatio: _controller.value.aspectRatio,
                  child: VideoPlayer(_controller),
                ),
              ),
            );
            // -----------------------------------------
          } else {
            // Show a loading indicator while the video is loading
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}