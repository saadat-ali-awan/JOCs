import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jocs/Dashboard/Controllers/dashboard_controller.dart';
import 'package:jocs/Dashboard/Layout/screens_layout.dart';

import 'navigation_menu.dart';

/// [DashboardMobile] will have stack of Navigation Menu Above the Rest of the
/// Items. When The Navigation Menu is opened it covers the whole screen and
/// the rest of widgets are hidden.
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
                  child: ScreensLayout())
          )
        ],
      ),
      Obx(() => _dashboardController.showMenu.value
          ? Row(children: [
        Container(
            width: MediaQuery.of(context).size.width,
            color: _dashboardController.tileColor.value,
            child: NavItems()
        )
      ])
          : const SizedBox(
        width: 0,
        height: 0,
      )),
    ]);
  }
}