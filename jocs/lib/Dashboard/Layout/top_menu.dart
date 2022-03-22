import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jocs/Dashboard/Controllers/dashboard_controller.dart';
import 'package:jocs/Dashboard/Dialog/custom_dialog.dart';

/// Top Menu is the menu that resides vertically at the top of [MainScreen]
/// * On the left it contains the name of the Screen that is opened inside
/// [MainScreen]
/// * On the Right Most side it contains buttons for the creation of the item
/// and for Logging Out of the Application
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
            _dashboardController.mobileDisplay.value ? PopupMenuButton(
                color: context.theme.appBarTheme.backgroundColor,
                itemBuilder: (context) {
                  List<Widget> list = getMenuItems(context);
                  return getPopUpAddButtons();
                },
              onSelected: (value) {
                  if (value == 1) {
                    addButtonListener(context);
                  }
                  if (value == 2) {
                    logoutButtonListener();
                  }
              },
            ) : Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      InkWell(
                        child: getAddButton(context),
                        onTap: () {
                          addButtonListener(context);
                        },
                      ),
                      InkWell(
                        child: const Icon(Icons.logout),
                        onTap: logoutButtonListener,
                      ),
                    ]
                ),
          ],
        )),
      ]),
    );
  }

  List<PopupMenuEntry<dynamic>> getPopUpAddButtons() {
    List<PopupMenuEntry<dynamic>> menuItems = <PopupMenuEntry<dynamic>>[];
    switch (_dashboardController.selectedMenuItem.value) {
      case 0:
      case 4:
      case 6:
      case 7:
        break;
      default:
        menuItems.add(
          const PopupMenuItem(
            child: const Icon(Icons.add_box),
            value: 1,
          ),
        );
    }
    menuItems.add(const PopupMenuItem(
      child: Icon(Icons.logout),
      value: 2,
    ));
    return menuItems;
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
          return const Icon(Icons.add_box);
      }
    });
  }

  void addButtonListener(context) {
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
  }
  // <base href="/JOCs/">

  void logoutButtonListener() {
    _dashboardController.logOut();
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
