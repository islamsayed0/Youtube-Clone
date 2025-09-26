import 'package:flutter/material.dart';
import 'package:youtubeclone/widgets/custom_text.dart';

/// ******************** VideoList (Class) ****************
/// Purpose     : A widget to display a YouTube-style video item.
/// Description : Shows a video thumbnail with its duration,
///               channel avatar, title, channel name, views, and publish date.
/// Usage       : Use inside a ListView to show multiple videos, e.g.:
///               VideoList(
///                 vedio_Img: "video_url",
///                 Chanel_img: "channel_avatar_url",
///                 title: "Video Title",
///                 views: "100K views",
///                 date: "2 days ago",
///                 Channel_name: "Channel Name",
///                 time: "10:30",
///               )
/// Author      : Islam Sayed
///*****************************************************
class VideoList extends StatelessWidget {
  const VideoList({
    super.key,
    required this.videoImg,
    required this.channelImg,
    required this.title,
    required this.views,
    required this.date,
    required this.channelName,
    required this.time,
  });

  final String videoImg, channelImg, title, views, date, channelName, time;

  /// ******************** build ****************
  /// Purpose     : Build the UI for a single video item.
  /// Description : Displays video thumbnail (with duration overlay),
  ///               channel avatar, video title, and metadata (views, channel name, date).
  /// Usage       : Automatically called by Flutter when rendering this widget.
  /// Author      : Islam Sayed
  ///*****************************************************
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Stack(
            children: [
              Image.network(videoImg),
              Positioned(
                bottom: 5,
                right: 10,
                child: Container(
                  color: Colors.black12,
                  padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                  child: CustomText(text: time),
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              CircleAvatar(backgroundImage: NetworkImage(channelImg)),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(text: title,fontSize: 10,),
              CustomText(text: channelName, color: Colors.white70),
              CustomText(text: views, color: Colors.white70),
              CustomText(text: date, color: Colors.white70),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
