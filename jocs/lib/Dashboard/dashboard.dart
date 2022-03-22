import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jocs/Dashboard/Controllers/dashboard_controller.dart';


/// [Dashboard] is the main Screen After Login
/// All the Logic of Displaying, Adding, Editing and Remove Data is inside
/// [Dashboard]
class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  _DashboardState createState() => _DashboardState();
}

/// The Application deals with 2 Layouts
/// 1. Screen Width > 600
/// 2. Screen Width <= 600
/// Depending on the Screen Width Dashboard Screen Would Be Displayed
class _DashboardState extends State<Dashboard> {
  final DashboardController _dashboardController = Get.find<DashboardController>();
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    if (width > 600){
      _dashboardController.changeBody(false);
    }else {
      _dashboardController.changeBody(true);
    }
    return Scaffold(
        body: SafeArea(
            child: _dashboardController.body.value
        )

    );
  }
}

