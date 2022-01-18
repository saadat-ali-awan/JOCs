import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jocs/Dashboard/Controllers/dashboard_controller.dart';
import 'package:jocs/Theme/custom_theme.dart';

class NavItems extends StatelessWidget {
  NavItems({Key? key}) : super(key: key);

  final DashboardController _dashboardController =
  Get.find<DashboardController>();

  @override
  Widget build(BuildContext context) {
    return ListView(children: [
      _dashboardController.mobileDisplay.value?
      Container(
          height: 50,
          color: _dashboardController.tileColor,
        child: Obx(
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
      )
          :
      Container(
          decoration: BoxDecoration(
              border: Border.symmetric(
                  horizontal:
                  BorderSide(color: _dashboardController.iconColor!))),
          child: Obx(
                () => Material(
              child: _dashboardController.showPanel.value
                  ? Container(
                  color: _dashboardController.tileColor,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_forward_ios_outlined),
                    color: _dashboardController.iconColor,
                    onPressed: () {
                      _dashboardController.showPanel.value = false;
                    },
                  ))
                  : ListTile(
                tileColor: _dashboardController.tileColor,
                hoverColor: ThemeColors.hoverColor,
                onTap: () {
                  _dashboardController.showPanel.value = true;
                },
                trailing: Icon(Icons.arrow_back_ios_outlined,
                    color: _dashboardController.iconColor),
                title: Text("HIDE PANEL",
                    style: _dashboardController.menuItemStyle),
              ),
            ),
          )),
      Tooltip(
        message: 'Dashboard',
        child: Container(
            decoration: BoxDecoration(
                border: Border.symmetric(
                    horizontal:
                    BorderSide(color: _dashboardController.iconColor!))),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Obx(
                    () => Material(
                    child: _dashboardController.showPanel.value
                        ? Container(
                        color: _dashboardController.tileColor,
                        child: IconButton(
                          icon: _dashboardController.menuList[0][1],
                          color: _dashboardController.iconColor,
                          onPressed: () {
                            _dashboardController.selectedMenuItem.value = 0;
                            _dashboardController.getDashboardData();
                          },
                        ))
                        : ListTile(
                      tileColor: _dashboardController.tileColor,
                      hoverColor: ThemeColors.hoverColor,
                      onTap: () { _dashboardController.selectedMenuItem.value = 0;},
                      leading: _dashboardController.menuList[0][1],
                      title: _dashboardController.menuList[0][0],
                    )),
              ),
            )),
      ),
      Tooltip(
        message: "Tickets",
        child: Container(
          decoration: BoxDecoration(
              border: Border(
                  bottom: BorderSide(color: _dashboardController.iconColor!))),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Obx(
                  () => Material(
                  child: _dashboardController.showPanel.value
                      ? Container(
                      color: _dashboardController.tileColor,
                      child: IconButton(
                        icon: _dashboardController.menuList[1][1],
                        color: _dashboardController.iconColor,
                        onPressed: () {
                          _dashboardController.selectedMenuItem.value = 1;
                          _dashboardController.getTicketsData();
                        },
                      ))
                      : ListTile(
                    tileColor: _dashboardController.tileColor,
                    hoverColor: ThemeColors.hoverColor,
                    onTap: () {
                      _dashboardController.selectedMenuItem.value = 1;
                      _dashboardController.getTicketsData();
                      },
                    leading: _dashboardController.menuList[1][1],
                    title: _dashboardController.menuList[1][0],
                  )),
            ),
          ),
        ),
      ),
      Tooltip(
        message: "Problems",
        child: Container(
          decoration: BoxDecoration(
              border: Border(
                  bottom: BorderSide(color: _dashboardController.iconColor!))),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Obx(
                  () => Material(
                  child: _dashboardController.showPanel.value
                      ? Container(
                      color: _dashboardController.tileColor,
                      child: IconButton(
                        icon: _dashboardController.menuList[2][1],
                        color: _dashboardController.iconColor,
                        onPressed: () {
                          _dashboardController.selectedMenuItem.value = 2;
                          _dashboardController.getProblemsData();
                        },
                      ))
                      : ListTile(
                    tileColor: _dashboardController.tileColor,
                    hoverColor: ThemeColors.hoverColor,
                    onTap: () {
                      _dashboardController.selectedMenuItem.value = 2;
                      _dashboardController.getProblemsData();
                      },
                    leading: _dashboardController.menuList[2][1],
                    title: _dashboardController.menuList[2][0],
                  )),
            ),
          ),
        ),
      ),
      Tooltip(
        message: "Assets",
        child: Container(
          decoration: BoxDecoration(
              border: Border(
                  bottom: BorderSide(color: _dashboardController.iconColor!))),
          child: ExpansionTile(
            tilePadding:
            const EdgeInsets.only(left: 0, right: 8, top: 0, bottom: 0),
            iconColor: _dashboardController.iconColor,
            collapsedIconColor: _dashboardController.iconColor,
            backgroundColor: _dashboardController.tileColor,
            title: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Obx(() => Material(
                  child: _dashboardController.showPanel.value
                      ? Container(
                      color: _dashboardController.tileColor,
                      child: _dashboardController.menuList[3][1],
                    // child: IconButton(
                      //   icon: _dashboardController.menuList[3][1],
                      //   color: _dashboardController.iconColor,
                      //   onPressed: () {
                      //     _dashboardController.selectedMenuItem.value = 32;
                      //   },
                      // )
                  )
                      : ListTile(
                    tileColor: _dashboardController.tileColor,
                    hoverColor: ThemeColors.hoverColor,
                    leading: _dashboardController.menuList[3][1],
                    title: _dashboardController.menuList[3][0],
                  ))),
            ),
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextButton(
                      onPressed: () {
                        _dashboardController.selectedMenuItem.value = 32;
                        _dashboardController.getInventoryData();
                      },
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: _dashboardController.menuList[3][2],
                      )),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextButton(
                      onPressed: () {
                        _dashboardController.selectedMenuItem.value = 33;
                        _dashboardController.getPurchaseData();
                      },
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: _dashboardController.menuList[3][3]
                      )),
                ],
              )
            ],
          ),
        ),
      ),
      Tooltip(
        message: "Chat",
        child: Container(
            decoration: BoxDecoration(
                border: Border(
                    bottom: BorderSide(color: _dashboardController.iconColor!))),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Obx(
                    () => Material(
                    child: _dashboardController.showPanel.value
                        ? Container(
                        color: _dashboardController.tileColor,
                        child: IconButton(
                          icon: _dashboardController.menuList[4][1],
                          color: _dashboardController.iconColor,
                          onPressed: () {
                            _dashboardController.initializeStream();
                            _dashboardController.selectedMenuItem.value = 4;
                          },
                        ))
                        : ListTile(
                      tileColor: _dashboardController.tileColor,
                      hoverColor: ThemeColors.hoverColor,
                      onTap: () {
                        _dashboardController.selectedMenuItem.value = 4;
                        },
                      leading: _dashboardController.menuList[4][1],
                      title: _dashboardController.menuList[4][0],
                    )),
              ),
            )),
      ),
      Tooltip(
        message: "Eternal KBS",
        child: Container(
            decoration: BoxDecoration(
                border: Border(
                    bottom: BorderSide(color: _dashboardController.iconColor!))),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Obx(
                    () => Material(
                    child: _dashboardController.showPanel.value
                        ? Container(
                        color: _dashboardController.tileColor,
                        child: IconButton(
                          icon: _dashboardController.menuList[5][1],
                          color: _dashboardController.iconColor,
                          onPressed: () {
                            _dashboardController.selectedMenuItem.value = 5;
                          },
                        ))
                        : ListTile(
                      tileColor: _dashboardController.tileColor,
                      hoverColor: ThemeColors.hoverColor,
                      onTap: () { _dashboardController.selectedMenuItem.value = 5;},
                      leading: _dashboardController.menuList[5][1],
                      title: _dashboardController.menuList[5][0],
                    )),
              ),
            )),
      ),
      Tooltip(
        message: 'Settings',
        child: Container(
          decoration: BoxDecoration(
              border: Border(
                  bottom: BorderSide(color: _dashboardController.iconColor!))),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Obx(
                  () => Material(
                child: _dashboardController.showPanel.value
                    ? Container(
                    color: _dashboardController.tileColor,
                    child: IconButton(
                      icon: _dashboardController.menuList[6][1],
                      color: _dashboardController.iconColor,
                      onPressed: () {
                        _dashboardController.selectedMenuItem.value = 6;
                      },
                    ))
                    : ListTile(
                  tileColor: _dashboardController.tileColor,
                  hoverColor: ThemeColors.hoverColor,
                  onTap: () { _dashboardController.selectedMenuItem.value = 6;},
                  leading: _dashboardController.menuList[6][1],
                  title: _dashboardController.menuList[6][0],
                ),
              ),
            ),
          ),
        ),
      ),
      const Padding(
        padding: EdgeInsets.only(top: 32.0),
        child: ListTile(
          title: Center(
            child: CircleAvatar(
              radius: 50,
              backgroundColor: Colors.white,
              child: ClipOval(
                child: Image(
                  image: AssetImage('images/avatar.png'),
                  width: 100,
                  height: 100,
                ),
              ),
            ),
          ),
        ),
      )
    ]);
  }
}
