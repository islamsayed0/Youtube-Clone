import 'package:flutter/material.dart';
import 'package:youtubeclone/widgets/custom_text.dart';

class VideoList extends StatelessWidget {
  const VideoList({
    super.key,
    required this.vedio_Img,
    required this.Chanel_img,
    required this.title,
    required this.views,
    required this.date,
    required this.Channel_name,
    required this.time,
  });
  final String vedio_Img, Chanel_img, title, views, date, Channel_name, time;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Stack(
            children: [
              Image.network(vedio_Img),
              Positioned(
                bottom: 5,
                right: 10,
                child: Container(
                  color: Colors.black12,
                  padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                  child: CustomText(text: "$time"),
                ),
              ),
            ],
          ),
          SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              CircleAvatar(backgroundImage: NetworkImage(Chanel_img)),
              SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(text: title),
                  CustomText(
                    text: "$Channel_name        $views        $date",
                    color: Colors.white70,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
