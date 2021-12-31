import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jocs/Dashboard/Controllers/dashboard_controller.dart';
import 'package:jocs/Dashboard/Layout/screens_layout.dart';

import 'navigation_menu.dart';

class DashboardMobile extends StatefulWidget {
  const DashboardMobile({Key? key}) : super(key: key);

  @override
  _DashboardMobileState createState() => _DashboardMobileState();
}

class _DashboardMobileState extends State<DashboardMobile> {
  final DashboardController _dashboardController =
  Get.find<DashboardController>();

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Row(
        children: [
          Expanded(
              flex: 10,
              child: Container(
                  color: Colors.blueAccent,
                  child: const ScreensLayout())
          )
        ],
      ),
      Obx(() => _dashboardController.showMenu.value
          ? Row(children: [
        Container(
            width: MediaQuery.of(context).size.width,
            color: _dashboardController.tileColor,
            child: NavItems()
        )
      ])
          : const SizedBox(
        width: 0,
        height: 0,
      )),
      Obx(
            () => IconButton(
            onPressed: () {
              _dashboardController.showMenu.value =
              !_dashboardController.showMenu.value;
              _dashboardController.menuIcon.value =
              _dashboardController.showMenu.value
                  ? const Icon(Icons.clear)
                  : const Icon(Icons.menu);
            },
            icon: _dashboardController.menuIcon.value),
      ),
    ]);
  }
}