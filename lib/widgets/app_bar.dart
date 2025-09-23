import 'package:flutter/material.dart';

class App_Bar extends StatelessWidget {
  App_Bar({
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
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(width: 150, height: 150, child: Image.asset(logo)),
        SizedBox(width: 40),
        Expanded(
          child: TextFormField(
            controller: controller,

            decoration: InputDecoration(
              suffixIcon: Icon(suffixIcon),
              prefixIcon: Icon(prefixIcon),
              hintText: "Enter your name",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                borderSide: BorderSide(color: Colors.white),
              ),
            ),
            onTap: ontap,
            onFieldSubmitted: onsubmit,
          ),
        ),
      ],
    );
  }
}
