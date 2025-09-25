import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:video_player/video_player.dart';
import 'package:youtubeclone/const/string.dart';
import 'package:youtubeclone/services/playback_manager.dart';

class VideoDetails extends StatefulWidget {
  const VideoDetails({super.key, required this.vedio_ID});
  final String vedio_ID;

  @override
  State<VideoDetails> createState() => _VideoDetailsState();
}

class _VideoDetailsState extends State<VideoDetails> {
  VideoPlayerController? controller;
  bool isLoading = true;
  String? errorMsg;

  Future<void> getvideo() async {
    try {
      final id = widget.vedio_ID;
      final uri =
          '${ApiConfig.baseUrl}/v2/video/details?videoId=$id&urlAccess=normal&videos=auto&audios=auto';
      final url = Uri.parse(uri);

      final response = await http.get(url, headers: ApiConfig.headers);

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = jsonDecode(response.body);
        String? videoUrl;
        if (jsonData.containsKey('streamUrl')) {
          videoUrl = jsonData['streamUrl']?.toString();
        } else if (jsonData['audios'] is List && (jsonData['audios'] as List).isNotEmpty) {
          // Prefer audio-only stream for background playback if available
          final first = (jsonData['audios'] as List).first;
          videoUrl = (first is Map<String, dynamic> ? first['url'] : null)?.toString();
        } else if (jsonData['formats'] is List && (jsonData['formats'] as List).isNotEmpty) {
          final first = (jsonData['formats'] as List).first;
          videoUrl = (first is Map<String, dynamic> ? first['url'] : null)?.toString();
        } else if (jsonData['videos'] is Map<String, dynamic>) {
          final videos = jsonData['videos'] as Map<String, dynamic>;
          if (videos['items'] is List && (videos['items'] as List).isNotEmpty) {
            final first = (videos['items'] as List).first;
            videoUrl = (first is Map<String, dynamic> ? first['url'] : null)?.toString();
          }
        }

        if (videoUrl == null) {
          setState(() {
            errorMsg = "No video URL found in API response.";
            isLoading = false;
          });
          return;
        }

        // Use shared VideoPlayer controller so audio can continue when leaving the page
        await PlaybackManager.instance.playFromUrl(videoId: id, url: videoUrl);
        controller = PlaybackManager.instance.controller;
        if (!mounted) return;
        setState(() {
          isLoading = false;
        });
      } else {
        setState(() {
          errorMsg = "Failed to load video details: ${response.statusCode}";
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMsg = "Error: $e";
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getvideo();
  }

  @override
  void dispose() {
    // إيقاف الصوت والتخلص من الكونترولر عند الخروج
    PlaybackManager.instance.stopAndDispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
      ),
      body: isLoading
          ? const CircularProgressIndicator()
          : errorMsg != null
          ? Text(errorMsg!)
          : controller != null && controller!.value.isInitialized
          ? AspectRatio(
        aspectRatio: controller!.value.aspectRatio,
        child: VideoPlayer(controller!),
      )
          : const Text("Video not available"),
    );
  }
}
