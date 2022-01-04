import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jocs/Dashboard/Layout/dashboard_general.dart';
import 'package:jocs/Dashboard/Layout/dashboard_mobile.dart';
import 'package:jocs/Dashboard/Modals/ticket_model.dart';
import 'package:jocs/FirebaseCustomControllers/firebase_controller.dart';
import 'package:jocs/FirebaseCustomControllers/firebase_controller_windows.dart';

class DashboardController extends GetxController {
  var menuItemStyle = Get.theme.textTheme.headline5;
  var submenuItemStyle = Get.theme.textTheme.headline6;
  var submenuItemStyle2 = Get.theme.textTheme.caption;
  var iconColor = Get.theme.iconTheme.color;
  var tileColor = Get.theme.appBarTheme.backgroundColor;
  late final List<Widget> menuItemWidgets;
  RxBool mobileDisplay = false.obs;

  late var firebaseController;

  DashboardController() {
    menuList = [
      [
        Text(
          "DASHBOARD",
          style: menuItemStyle,
        ),
        Icon(
          Icons.dashboard,
          color: iconColor,
          size: 32,
        )
      ],
      [
        Text(
          "TICKETS",
          style: menuItemStyle,
        ),
        Icon(
          Icons.all_inbox_sharp,
          color: iconColor,
          size: 32,
        )
      ],
      [
        Text(
          "PROBLEMS",
          style: menuItemStyle,
        ),
        Icon(
          Icons.clear,
          color: iconColor,
          size: 32,
        )
      ],
      [
        Text(
          "ASSETS",
          style: menuItemStyle,
        ),
        Icon(
          Icons.featured_play_list,
          color: iconColor,
          size: 32,
        ),
        Obx(
          () => Text(
            "INVENTORY",
            style: showPanel.value ? submenuItemStyle2 : submenuItemStyle,
            textAlign: TextAlign.left,
          ),
        ),
        Obx(
          () => Text(
            "PURCHASE ORDER",
            style: showPanel.value ? submenuItemStyle2 : submenuItemStyle,
            textAlign: TextAlign.left,
          ),
        )
      ],
      [
        Text(
          "CHAT",
          style: menuItemStyle,
        ),
        Icon(
          Icons.message,
          color: iconColor,
          size: 32,
        )
      ],
      [
        Text(
          "ETERNAL KBS",
          style: menuItemStyle,
        ),
        Icon(
          Icons.attach_file,
          color: iconColor,
          size: 32,
        )
      ],
      [
        Text(
          "SETTINGS",
          style: menuItemStyle,
        ),
        Icon(
          Icons.settings,
          color: iconColor,
          size: 32,
        )
      ]
    ];


    body.value = Stack(children: const [DashboardGeneral()]);

    if (defaultTargetPlatform != TargetPlatform.windows || kIsWeb) {
      firebaseController = Get.find<FirebaseController>();
      // firebaseController.getData("Tickets", 1);
    }else {
      if (defaultTargetPlatform == TargetPlatform.windows){
        firebaseController = Get.find<FirebaseControllerWindows>();
      }
    }

  }

  Rx<Widget> body = Stack(
    children: [],
  ).obs;

  RxBool showMenu = false.obs;
  RxBool showMenuForBigScreen = false.obs;
  RxBool showPanel = false.obs;
  Rx<Widget> menuIcon = const Icon(Icons.menu,).obs;

  var menuList = [];
  var selectedMenuItem = 0.obs;

  changeBody(bool mobile) {
    mobileDisplay.value = mobile;
    if (mobile) {
      body.value = Stack(children: const [DashboardMobile()]);
    } else {
      body.value = Stack(children: const [DashboardGeneral()]);
    }
  }

  void addDataToFirebase(Map<String, dynamic> data, String collectionName) {
    firebaseController.addDataToFirebase(data, collectionName);
  }


  /// Tickets Screen Getx Logic
  Rx<TicketModel> ticketModel = TicketModel().obs;
  getTicketsData() async {
    ticketModel.value.getTicketsData(firebaseController);
    ticketModel.value.lastId.value = await firebaseController.getLastId("tickets");
  }
  /**
  * Tickets Screen Getx Logic
  **/

}
