import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter/foundation.dart';
import 'homescreen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late VideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;
  bool _navigated = false;

  @override
  void initState() {
    super.initState();

    if (kIsWeb) {
      _controller = VideoPlayerController.networkUrl(
        Uri.parse('assets/mc.mp4'),
      );
    } else {
      _controller = VideoPlayerController.asset('assets/mc.mp4');
    }

    _initializeVideoPlayerFuture = _controller.initialize().then((_) {
      _controller.setVolume(0.0);
      _controller.play();
      _controller.addListener(_videoListener);
    });
  }

  void _videoListener() {
    if (!mounted || _navigated) return;

    if (_controller.value.isInitialized &&
        _controller.value.position >= _controller.value.duration) {
      _navigated = true;
      _controller.removeListener(_videoListener);

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const HomeScreen()),
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
    final screenWidth = MediaQuery.of(context).size.width;
    final videoSize = screenWidth * 0.6;

    return Scaffold(
      backgroundColor: Colors.white,
      body: FutureBuilder(
        future: _initializeVideoPlayerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Center(
              child: SizedBox(
                width: videoSize,
                height: videoSize,
                child: AspectRatio(
                  aspectRatio: _controller.value.aspectRatio,
                  child: VideoPlayer(_controller),
                ),
              ),
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
