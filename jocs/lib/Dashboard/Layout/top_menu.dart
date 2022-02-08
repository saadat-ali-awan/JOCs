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
      color: context.theme.appBarTheme.backgroundColor,
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
            getAddButton(context),
            // _dashboardController.mobileDisplay.value ? PopupMenuButton(
            //     color: context.theme.appBarTheme.backgroundColor,
            //     itemBuilder: (context) {
            //       List<Widget> list = getMenuItems(context);
            //       return [
            //         PopupMenuItem(child: list[0]),
            //         PopupMenuItem(child: list[1]),
            //         PopupMenuItem(child: list[2]),
            //       ];
            //     }) : Row(
            //         mainAxisSize: MainAxisSize.min,
            //         children: getMenuItems(context)
            //     ),
          ],
        )),
      ]),
    );
  }

  Widget getAddButton(context) {
    return Obx((){
      switch (_dashboardController.selectedMenuItem.value) {
        case 0:
        case 4:
        case 6:
        case 7:
          return Container();
        default:
          return IconButton(
              onPressed: () {
                if (_dashboardController.selectedMenuItem>0) {
                  Get.dialog(
                      CustomDialog(previousData: const [], time: "")
                  );
                }else{
                  Get.defaultDialog(
                      titlePadding: const EdgeInsets.all(16.0),
                      title: "Can not add when in Dashboard Tab",
                      middleText: "Switch Tab and come back.",
                      titleStyle: TextStyle(color: context.theme.appBarTheme.backgroundColor),
                      onConfirm: (){
                        Get.back();
                      },
                      confirmTextColor:  context.theme.iconTheme.color,
                      buttonColor: context.theme.appBarTheme.backgroundColor
                  );
                }
              },
              icon: const Icon(Icons.add_box));
      }
    });
  }

  List<Widget> getMenuItems(context) {
    return [
      IconButton(
          onPressed: () {
            if (_dashboardController.selectedMenuItem>0) {
              Get.dialog(
                  CustomDialog(previousData: const [], time: "")
              );
            }else{
              Get.defaultDialog(
                  titlePadding: const EdgeInsets.all(16.0),
                  title: "Can not add when in Dashboard Tab",
                  middleText: "Switch Tab and come back.",
                  titleStyle: TextStyle(color: context.theme.appBarTheme.backgroundColor),
                  onConfirm: (){
                    Get.back();
                  },
                  confirmTextColor:  context.theme.iconTheme.color,
                  buttonColor: context.theme.appBarTheme.backgroundColor
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
    ];
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
