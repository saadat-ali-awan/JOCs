import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TopMenu extends StatelessWidget {
  const TopMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(height: 50, color: Get.theme.appBarTheme.backgroundColor,);
  }
}
