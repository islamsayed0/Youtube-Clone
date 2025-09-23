import 'package:flutter/material.dart';

import '../widgets/app_bar.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TextEditingController searchController = TextEditingController();
  FocusNode focusNode = FocusNode();

  @override
  void initState() {
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
          title:App_Bar(
            controller: searchController,
            logo: 'assets/img/logo_app.png',
            prefixIcon: Icons.cancel,
            suffixIcon: Icons.search,
            onsubmit: (v){},
            ontap: (){},
          )
        ),
      ),
    );
  }
}
