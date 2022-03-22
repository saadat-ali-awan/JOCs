import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jocs/Dashboard/Controllers/dashboard_controller.dart';
import 'package:jocs/Dashboard/Layout/screens_layout.dart';

import 'navigation_menu.dart';

/// In [DashboardGeneral] Navigation Items are on the left side of the Screen
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
                color: _dashboardController.tileColor.value,
                child: NavItems()),
          ),
          //Obx(() =>
          Obx( () => Expanded(
                child: Container(
                    color: _dashboardController.iconColor.value,
                    child: ScreensLayout()),
            ),
          )
        ],
      )
    ]);
  }

  @override
  void dispose() {
    super.dispose();
  }
}