import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jocs/Dashboard/Controllers/dashboard_controller.dart';
import 'package:jocs/Dashboard/Dialog/custom_dialog.dart';

class TopMenu extends StatelessWidget {
  TopMenu({Key? key}) : super(key: key);

  final DashboardController _dashboardController =
      Get.find<DashboardController>();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      color: Get.theme.appBarTheme.backgroundColor,
      child: Row(children: [
        Expanded(
            child: Wrap(
          alignment: WrapAlignment.spaceBetween,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Obx(() => Row(
                    mainAxisSize: MainAxisSize.min,
                    children: getTitle(),
                  )),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                    onPressed: () {
                      if (_dashboardController.selectedMenuItem>0) {
                        Get.dialog(
                          CustomDialog()
                        );
                      }else{
                        Get.defaultDialog(
                          titlePadding: const EdgeInsets.all(16.0),
                            title: "Can not add when in Dashboard Tab",
                          middleText: "Switch Tab and come back.",
                          titleStyle: TextStyle(color: Get.theme.appBarTheme.backgroundColor),
                          onConfirm: (){
                              Get.back();
                          },
                          confirmTextColor:  Get.theme.iconTheme.color,
                          buttonColor: Get.theme.appBarTheme.backgroundColor
                        );
                      }
                    },
                    icon: const Icon(Icons.add_box)),
                IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.perm_contact_calendar_rounded)),
                IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.notifications_active))
              ],
            )
          ],
        )),
      ]),
    );
  }

  List<Widget> getTitle() {
    List<Widget> temp = [];
    if (_dashboardController.mobileDisplay.value) {
      temp.add(
        Obx(
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
      );
    }
    if (_dashboardController.selectedMenuItem.value == 32 || _dashboardController.selectedMenuItem.value == 33) {
      temp.add(Container(
        margin: const EdgeInsets.all(8.0),
        child: _dashboardController
            .menuList[3][1],
      ));
      temp.add(_dashboardController
          .menuList[3][0]);
    } else {
      temp.add(Container(
        margin: const EdgeInsets.all(8.0),
        child: _dashboardController
            .menuList[_dashboardController.selectedMenuItem.value][1],
      ));
      temp.add(_dashboardController
          .menuList[_dashboardController.selectedMenuItem.value][0]);
    }
    return temp;
  }


}