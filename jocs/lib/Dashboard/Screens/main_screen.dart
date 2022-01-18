import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jocs/Dashboard/Controllers/dashboard_controller.dart';
import 'package:jocs/Dashboard/Screens/dashboard_screen.dart';
import 'package:jocs/Dashboard/Screens/eternal_kbs_screen.dart';
import 'package:jocs/Dashboard/Screens/problems_screen.dart';
import 'package:jocs/Dashboard/Screens/purchase_screen.dart';
import 'package:jocs/Dashboard/Screens/tickets_screen.dart';

import 'chat_screen.dart';
import 'inventory_screen.dart';

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
        case 2:
          return ProblemsScreen();
        case 32:
          return InventoryScreen();
        case 33:
          return PurchaseScreen();
        case 4:
          return ChatScreen();
        case 5:
          return EternalKbsScreen();
        default:
          return Container(color: Colors.amber);
      }
    });
  }
}
