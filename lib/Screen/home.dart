import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:youtubeclone/widgets/video_list.dart';
import 'package:http/http.dart' as http;
import '../const/string.dart';
import '../widgets/app_bar.dart';
import 'Video_Details.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final TextEditingController searchController = TextEditingController();
  List<Map<String, dynamic>> items = <Map<String, dynamic>>[];
  String searchText = 'macbook';
  bool isLoading = false;

  /// ******************** search ****************
  /// Purpose     : Fetch videos from the API based on the search text.
  /// Description : Sends a GET request to the API, decodes the JSON response,
  ///               extracts video items, and updates the state with results.
  /// Usage       : Called automatically in initState() and manually
  ///               after entering a new search query.
  /// Author      : Islam Sayed
  ///*****************************************************
  Future<void> search() async {
    try {
      final url = Uri.parse(
        '${ApiConfig.baseUrl}/v2/search/videos?keyword=$searchText&uploadDate=all&duration=all&sortBy=relevance',
      );
      final response = await http.get(url, headers: ApiConfig.headers);
      if (response.statusCode != 200) {
        return;
      }
      final Map<String, dynamic> jsonBody = jsonDecode(response.body) as Map<String, dynamic>;
      final List<dynamic> resultsDynamic = (jsonBody['items'] as List?) ?? <dynamic>[];
      final List<Map<String, dynamic>> results = resultsDynamic
          .whereType<Map<String, dynamic>>()
          .toList(growable: false);
      if (!mounted) return;
      setState(() {
        items = results;
      });
    } catch (_) {
      // Silently ignore for now; could show a SnackBar in future
    }
  }

  /// ******************** initState ****************
  /// Purpose     : Initialize the state when the widget is first created.
  /// Description : Calls the search() function to load default search
  ///               results (e.g., "macbook") when the Home screen opens.
  /// Usage       : Automatically called by Flutter when the widget is mounted.
  /// Author      : Islam Sayed
  ///*****************************************************
  @override
  void initState() {
    super.initState();
    search();
  }

  /// ******************** dispose ****************
  /// Purpose     : Clean up resources when the widget is removed.
  /// Description : Disposes the searchController to prevent memory leaks.
  /// Usage       : Automatically called by Flutter when the widget is destroyed.
  /// Author      : Islam Sayed
  ///*****************************************************
  @override
  void dispose() {
    searchController.dispose();
    // Nothing else to dispose at the moment
    super.dispose();
  }

  /// ******************** build ****************
  /// Purpose     : Build the UI for the Home screen.
  /// Description : Creates a Scaffold with a custom AppBar for searching
  ///               and a ListView that displays video items using the VideoList widget.
  /// Usage       : Automatically called by Flutter whenever the UI needs to rebuild
  ///               (e.g., after setState).
  /// Author      : Islam Sayed
  ///*****************************************************
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
        body: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final Map<String, dynamic> item = items[index];

                  return GestureDetector(
                    onTap: () async {
                      setState(() {
                        isLoading = true;
                      });
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => VideoDetails(vedio_ID: (item['id'] ?? '').toString()),
                        ),
                      );
                      setState(() {
                        isLoading = false;
                      });
                    },
                    child: VideoList(
                      title: (item['title'] ?? 'No title').toString(),
                      Channel_name: (item['channel']?['name'] ?? 'Unknown Channel').toString(),
                      date: (item['publishedTimeText'] ?? 'Unknown date').toString(),
                      vedio_Img: (item['thumbnails'] is List && item['thumbnails'].isNotEmpty)
                          ? (item['thumbnails'][0]?['url'] ?? '').toString()
                          : 'https://via.placeholder.com/360x202.png?text=No+Thumbnail',
                      views: (item['viewCountText'] ?? '0 views').toString(),
                      Chanel_img: (item['channel']?['avatar'] is List && (item['channel']?['avatar'] as List).isNotEmpty)
                          ? (item['channel']?['avatar'][0]?['url'] ?? '').toString()
                          : 'https://via.placeholder.com/88.png?text=No+Image',
                      time: (item['lengthText'] ?? '0:00').toString(),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
