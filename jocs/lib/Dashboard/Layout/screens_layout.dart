import 'package:flutter/material.dart';
import 'package:jocs/Dashboard/Layout/top_menu.dart';

class ScreensLayout extends StatelessWidget {
  const ScreensLayout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const TopMenu()
      ],
    );
  }
}
