import 'package:video_player/video_player.dart';

class PlaybackManager {
  PlaybackManager._internal();

  static final PlaybackManager instance = PlaybackManager._internal();

  VideoPlayerController? controller;
  String? currentVideoId;

  Future<void> playFromUrl({required String videoId, required String url}) async {
    // If the same video is already prepared, just resume
    if (controller != null && currentVideoId == videoId) {
      await controller!.play();
      return;
    }

    // Stop and dispose any previous controller
    if (controller != null) {
      try {
        await controller!.pause();
      } finally {
        await controller!.dispose();
        controller = null;
      }
    }

    currentVideoId = videoId;
    controller = VideoPlayerController.networkUrl(Uri.parse(url));
    await controller!.initialize();
    await controller!.play();
  }

  bool get isInitialized => controller?.value.isInitialized == true;

  Future<void> pause() async {
    if (controller != null && controller!.value.isPlaying) {
      await controller!.pause();
    }
  }

  Future<void> play() async {
    if (controller != null && !controller!.value.isPlaying) {
      await controller!.play();
    }
  }

  Future<void> stopAndDispose() async {
    if (controller != null) {
      try {
        await controller!.pause();
      } finally {
        await controller!.dispose();
        controller = null;
        currentVideoId = null;
      }
    }
  }
}


