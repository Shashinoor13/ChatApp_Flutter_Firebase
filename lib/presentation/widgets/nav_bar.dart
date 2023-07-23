import 'package:flutter/material.dart';

Row NavigationBarCustom(BuildContext context) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceAround,
    children: [
      IconButton(
        onPressed: () {
          if (context.widget.toString() != "HomePage") {
            Navigator.pushNamed(context, "/");
          }
        },
        icon: const Icon(Icons.home),
      ),
      IconButton(
        onPressed: () {
          // print(context.widget);
          if (context.widget.toString() != "SearchPage") {
            Navigator.pushNamed(context, "/search");
          }
        },
        icon: const Icon(Icons.search),
      ),
      IconButton(
        onPressed: () {
          if (context.widget.toString() != "ProfilePage") {
            Navigator.pushNamed(context, "/profile");
          }
        },
        icon: const Icon(Icons.person),
      ),
    ],
  );
}
