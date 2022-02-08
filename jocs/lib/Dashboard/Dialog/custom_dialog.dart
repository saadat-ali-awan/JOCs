import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jocs/Dashboard/Controllers/dashboard_controller.dart';
import 'package:jocs/Dashboard/Dialog/problems_item.dart';
import 'package:jocs/Dashboard/Dialog/purchase_item.dart';
import 'package:jocs/Dashboard/Dialog/ticket_item.dart';
import 'package:jocs/Dashboard/Screens/eternal_kbs_screen.dart';

import 'inventory_item.dart';

class CustomDialog extends StatelessWidget {
  CustomDialog({Key? key, required this.previousData, required this.time}) : super(key: key);

  final DashboardController _dashboardController =
  Get.find<DashboardController>();

  final List<String> previousData;
  final String time;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(
                  Radius.circular(10)),
              color: Get.theme.iconTheme.color,
            ),
            width: 400,
            child: Wrap(
                children: [Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: getDialogOptions(),
                ),
                ]),
          ),
        ),
        Positioned(
          right: 0,
          child: ClipOval(
            child: Material(
              color: Get.theme.appBarTheme
                  .backgroundColor, // Button color
              child: InkWell( // Splash color
                onTap: () {
                  Get.back();
                },
                child: Icon(Icons.clear,
                  color: Get.theme.iconTheme.color,),
              ),
            ),
          ),

        ),
      ]),
    );
  }

  Widget getDialogOptions(){
    switch (_dashboardController.selectedMenuItem.value){
      case 1:
        return TicketItem(previousData: previousData, time: time);
      case 2:
        return ProblemsItem(previousData: previousData, time: time);
      case 32:
        return InventoryItem(previousData: previousData, time: time);
      case 33:
        return PurchaseItem(previousData: previousData, time: time);
      case 5:
        return CategoryFormWidget();
    }
    return Column();
  }
}
