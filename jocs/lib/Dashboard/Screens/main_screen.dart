import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jocs/Dashboard/Controllers/dashboard_controller.dart';
import 'package:jocs/Dashboard/Screens/dashboard_screen.dart';
import 'package:jocs/Dashboard/Screens/tickets_screen.dart';

class MainScreen extends StatelessWidget {
  MainScreen({Key? key}) : super(key: key);

  final DashboardController _dashboardController =
  Get.find<DashboardController>();

  @override
  Widget build(BuildContext context) {
    return Obx((){
      switch (_dashboardController.selectedMenuItem.value){
        case 0:
          return DashboardScreen();
        case 1:
          return TicketsScreen();
        default:
          return Container(color: Colors.amber);
      }
    });
  }
}
