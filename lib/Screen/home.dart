import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:youtubeclone/widgets/video_list.dart';
import 'package:http/http.dart' as http;
import '../const/string.dart';
import '../widgets/app_bar.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TextEditingController searchController = TextEditingController();
  FocusNode focusNode = FocusNode();
  List itemes =[];
  String searchText = 'macbook';
  Future<void> search() async {
    final url = Uri.parse('${string.base_url}/v2/search/videos?keyword=${searchText}&uploadDate=all&duration=all&sortBy=relevance');
    final response = await http.get(url, headers: string.headers);
    final jason = jsonDecode(response.body) as Map;
    final results = jason['items'] as List;
    setState(() {
      itemes = results;
    });
  }

  @override
  void initState() {
    search();
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: App_Bar(
            controller: searchController,
            logo: 'assets/img/logo_app.png',
            prefixIcon: Icons.search,
            suffixIcon: Icons.cancel,
            onsubmit: (v) {
              setState(() {
                searchText = v.toString();
              });
              search();
            },
            ontap: () {},
          ),
        ),
        body: ListView.builder(
          itemCount: itemes.length,
          itemBuilder: (context, index) {
            final item = itemes[index];

            return VideoList(

              title: item['title'] ?? "No title",
              Channel_name: item['channel']?['name'] ?? "Unknown Channel",
              date: item['publishedTimeText'] ?? "Unknown date",
              vedio_Img: item['thumbnails']?[0]?['url'] ??
                  "https://via.placeholder.com/360x202.png?text=No+Thumbnail",
              views: item['viewCountText'] ?? "0 views",
              Chanel_img: item['channel']?['avatar']?[0]?['url'] ??
                  "https://via.placeholder.com/88.png?text=No+Image",
              time: item['lengthText'] ?? "0:00",
            );
          },
        ),

      ),
    );
  }
}
