import 'package:get/get.dart';
import 'package:jocs/Dashboard/Controllers/dashboard_controller.dart';

/// [DashboardBindings] binds [DashboardController] with [Dashboard] Screen
class DashboardBindings extends Bindings {
  @override
  void dependencies() {
    Get.put<DashboardController>(DashboardController());
  }
}