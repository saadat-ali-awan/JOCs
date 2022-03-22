import 'package:get/get.dart';
import 'package:jocs/Registration/Controllers/login_controller_windows.dart';
import 'package:flutter/foundation.dart';
import '../Controllers/login_controller.dart';


/// [LoginBindings] is GetX Binding For Login Screen
/// It would load required controller based on the Platform
class LoginBindings implements Bindings{

  /// [LoginBindings] Binds The Login Controllers to The Screen
  /// Based on the platform either [LoginControllerWindows] or [LoginController]
  /// would be bound
  @override
  void dependencies() {

    if (defaultTargetPlatform == TargetPlatform.windows && !kIsWeb) {
      Get.put<LoginControllerWindows>(LoginControllerWindows());
      Get.find<LoginControllerWindows>().initializeLogin();
    }
    else {
      Get.put<LoginController>(LoginController());
      Get.find<LoginController>().initializeLogin();
    }
  }

}