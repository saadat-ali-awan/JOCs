import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jocs/Dashboard/Controllers/dashboard_controller.dart';
import 'package:jocs/Dashboard/Layout/screens_layout.dart';

import 'navigation_menu.dart';

class DashboardGeneral extends StatefulWidget {
  const DashboardGeneral({Key? key}) : super(key: key);

  @override
  _DashboardGeneralState createState() => _DashboardGeneralState();
}

class _DashboardGeneralState extends State<DashboardGeneral> {
  final DashboardController _dashboardController =
  Get.find<DashboardController>();

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Row(
        children: [
          Obx(
                () => Container(
                width: _dashboardController.showPanel.value ? 100 : 300,
                color: _dashboardController.tileColor,
                child: NavItems()),
          ),
          //Obx(() =>
          Expanded(
              child: Container(
                  color: _dashboardController.iconColor,
                  child: ScreensLayout()),
          )
        ],
      )
    ]);
  }
}