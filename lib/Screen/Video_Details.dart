import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:video_player/video_player.dart';
import 'package:youtubeclone/const/string.dart';
import 'package:youtubeclone/services/playback_manager.dart';

class VideoDetails extends StatefulWidget {
  const VideoDetails({super.key, required this.videoId});
  final String videoId;
  @override
  State<VideoDetails> createState() => _VideoDetailsState();
}

class _VideoDetailsState extends State<VideoDetails> {
  VideoPlayerController? controller;
  bool isLoading = true;
  String? errorMsg;
  String? videoTitle;
  String? videoDescription;
  String? viewCount;
  String? publishDate;
  String? channelName;
  String? channelLogo;
  bool showDescription = false;

  /// ******************** getvideo ****************
  Future<void> getvideo() async {
    try {
      final id = widget.videoId;
      final uri =
          '${ApiConfig.baseUrl}/v2/video/details?videoId=$id&urlAccess=normal&videos=auto&audios=auto';
      final url = Uri.parse(uri);

      final response = await http.get(url, headers: ApiConfig.headers);

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = jsonDecode(response.body);

        // استخراج البيانات من API response
        videoTitle = jsonData['title']?.toString();
        videoDescription = jsonData['description']?.toString();
        
        // البحث عن viewCount في أماكن مختلفة
        viewCount = jsonData['viewCount']?.toString() ?? 
                   jsonData['viewCountText']?.toString() ?? 
                   jsonData['views']?.toString();
        
        // البحث عن publishDate في أماكن مختلفة  
        publishDate = jsonData['publishDate']?.toString() ?? 
                     jsonData['publishedTimeText']?.toString() ?? 
                     jsonData['uploadDate']?.toString();
        
        // البحث عن channelName في أماكن مختلفة
        if (jsonData['channel'] is Map<String, dynamic>) {
          final channel = jsonData['channel'] as Map<String, dynamic>;
          channelName = channel['name']?.toString() ?? 
                       channel['title']?.toString();
          if (channel['avatar'] is List && (channel['avatar'] as List).isNotEmpty) {
            final avatar = (channel['avatar'] as List).first;
            if (avatar is Map<String, dynamic>) {
              channelLogo = avatar['url']?.toString();
            }
          }
        } else {
          channelName = jsonData['channelName']?.toString() ?? 
                       jsonData['channel']?.toString();
          channelLogo = jsonData['channelLogo']?.toString();
        }
        
        // يمكن إضافة debug prints هنا إذا لزم الأمر

        String? videoUrl;
        if (jsonData.containsKey('streamUrl')) {
          videoUrl = jsonData['streamUrl']?.toString();
        } else if (jsonData['audios'] is List &&
            (jsonData['audios'] as List).isNotEmpty) {
          final first = (jsonData['audios'] as List).first;
          videoUrl =
              (first is Map<String, dynamic> ? first['url'] : null)?.toString();
        } else if (jsonData['formats'] is List &&
            (jsonData['formats'] as List).isNotEmpty) {
          final first = (jsonData['formats'] as List).first;
          videoUrl =
              (first is Map<String, dynamic> ? first['url'] : null)?.toString();
        } else if (jsonData['videos'] is Map<String, dynamic>) {
          final videos = jsonData['videos'] as Map<String, dynamic>;
          if (videos['items'] is List && (videos['items'] as List).isNotEmpty) {
            final first = (videos['items'] as List).first;
            videoUrl = (first is Map<String, dynamic> ? first['url'] : null)
                ?.toString();
          }
        }

        if (videoUrl == null) {
          setState(() {
            errorMsg = "No video URL found in API response.";
            isLoading = false;
          });
          return;
        }

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
    PlaybackManager.instance.stopAndDispose();
    super.dispose();
  }

  void videoToggle() {
    setState(() {
      if (controller!.value.isPlaying) {
        controller!.pause();
      } else {
        controller!.play();
      }
    });
  }

  /// *************** Text Styling for description ***************
  List<TextSpan> _buildTextSpans(String text) {
    final RegExp regex = RegExp(r"(https?:\/\/\S+|#[\w\d_]+)");
    final List<TextSpan> spans = [];
    int start = 0;

    for (final match in regex.allMatches(text)) {
      if (match.start > start) {
        spans.add(TextSpan(
          text: text.substring(start, match.start),
          style: const TextStyle(color: Colors.white54, fontSize: 10),
        ));
      }

      final String matchText = match.group(0)!;
      if (matchText.startsWith('#')) {
        spans.add(TextSpan(
          text: matchText,
          style: const TextStyle(
            color: Colors.blue,
            fontSize: 10,
            fontWeight: FontWeight.bold,
          ),
        ));
      } else {
        spans.add(TextSpan(
          text: matchText,
          style: const TextStyle(
            color: Colors.lightBlueAccent,
            fontSize: 10,
            decoration: TextDecoration.underline,
          ),
        ));
      }

      start = match.end;
    }

    if (start < text.length) {
      spans.add(TextSpan(
        text: text.substring(start),
        style: const TextStyle(color: Colors.white54, fontSize: 10),
      ));
    }

    return spans;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : errorMsg != null
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error, size: 64, color: Colors.red),
            SizedBox(height: 16),
            Text(
              errorMsg!,
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  isLoading = true;
                  errorMsg = null;
                });
                getvideo();
              },
              child: Text('retry'),
            ),
          ],
        ),
      )
          : controller != null && controller!.value.isInitialized
          ? SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: controller!.value.aspectRatio,
              child: GestureDetector(
                onTap: videoToggle,
                child: VideoPlayer(controller!),
              ),
            ),
            if (videoTitle != null)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  videoTitle!,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            if (videoDescription != null)
              GestureDetector(
                onTap: () {
                  setState(() {
                    showDescription = !showDescription;
                  });
                },
                child: Padding(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 8.0),
                  child: RichText(
                    maxLines: showDescription ? 10 : 2,
                    overflow: TextOverflow.ellipsis,
                    text: TextSpan(
                      children:
                      _buildTextSpans(videoDescription!),
                    ),
                  ),
                ),
              ),
            // عرض معلومات الفيديو
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                "${viewCount ?? '0 views'} • ${publishDate ?? 'Unknown date'}",
                style: const TextStyle(
                    fontSize: 12, color: Colors.white70),
              ),
            ),
            // عرض معلومات القناة
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundImage: channelLogo != null
                        ? NetworkImage(channelLogo!)
                        : null,
                    child: channelLogo == null
                        ? Icon(Icons.person)
                        : null,
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      channelName ?? 'Unknown Channel',
                      style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      // TODO: handle subscribe action
                    },
                    child: Text("Subscribe"),
                  ),
                ],
              ),
            ),
          ],
        ),
      )
          : const Text("Video not available"),
    );
  }
}
