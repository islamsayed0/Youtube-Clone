import 'package:flutter/material.dart';

/// ******************** App_Bar (Class) ****************
/// Purpose     : A custom app bar widget with a logo and search field.
/// Description : Displays a logo on the left and a TextFormField
///               with prefix and suffix icons for searching.
/// Usage       :
///   App_Bar(
///     logo: "assets/img/logo_app.png",
///     prefixIcon: Icons.search,
///     suffixIcon: Icons.cancel,
///     controller: searchController,
///     onsubmit: (value) => print(value),
///     ontap: () => print("Search field tapped"),
///   )
/// Author      : Islam Sayed
///*****************************************************
class CustomAppBar extends StatelessWidget {
  const CustomAppBar({
    super.key,
    required this.logo,
    required this.suffixIcon,
    required this.prefixIcon,
    required this.controller,
    this.ontap,
    this.onsubmit,
  });

  final TextEditingController controller;
  final Function()? ontap;
  final Function(dynamic v)? onsubmit;
  final String logo;
  final IconData suffixIcon, prefixIcon;

  /// ******************** build ****************
  /// Purpose     : Build the UI for the custom app bar.
  /// Description : Creates a row with an image logo and a
  ///               styled TextFormField that includes prefix
  ///               and suffix icons, as well as callbacks for
  ///               tap and submit events.
  /// Usage       : Automatically called by Flutter when rendering this widget.
  /// Author      : Islam Sayed
  ///*****************************************************
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 120,
          height: 56,
          child: Image.asset(logo, fit: BoxFit.contain),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: SizedBox(
            height: 44,
            child: TextFormField(
              controller: controller,
              decoration: InputDecoration(
                suffixIcon: Icon(suffixIcon),
                prefixIcon: Icon(prefixIcon),
                hintText: "Search",
                border: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  borderSide: BorderSide(color: Colors.white),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 12),
              ),
              onTap: ontap,
              onFieldSubmitted: onsubmit,
            ),
          ),
        ),
      ],
    );
  }
}
