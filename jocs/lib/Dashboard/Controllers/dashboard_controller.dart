import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jocs/Dashboard/Layout/dashboard_general.dart';
import 'package:jocs/Dashboard/Layout/dashboard_mobile.dart';

class DashboardController extends GetxController {
  var menuItemStyle = Get.theme.textTheme.headline5;
  var submenuItemStyle = Get.theme.textTheme.headline6;
  var submenuItemStyle2 = Get.theme.textTheme.caption;
  var iconColor = Get.theme.iconTheme.color;
  var tileColor = Get.theme.appBarTheme.backgroundColor;
  late final List<Widget> menuItemWidgets;
  RxBool mobileDisplay = false.obs;

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
}
