import 'package:flutter/material.dart';
import 'package:jocs/Dashboard/Controllers/dashboard_controller.dart';
import 'package:jocs/Theme/custom_theme.dart';
import 'package:get/get.dart';
class SettingsScreen extends StatelessWidget {
  SettingsScreen({Key? key}) : super(key: key);

  RxBool switchValue = false.obs;
  final DashboardController _dashboardController =
  Get.find<DashboardController>();

  @override
  Widget build(BuildContext context) {
    getTheme();
    return Container(
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Dark Mode: "),
            Obx( () => Switch(
                  value: switchValue.value,
                  activeColor: context.theme.appBarTheme.backgroundColor,
                  onChanged: (bool val) async {
                    switchValue.value = val;
                    await ThemeColors.changeTheme(val);
                    _dashboardController.changeTheme();
                  }
              ),
            ),
          ],
        ),
      ),
    );
  }

  getTheme() async {
    switchValue.value = await ThemeColors.getThemeMode();
  }
}
