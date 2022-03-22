import 'package:get/get.dart';
import 'package:flutter/foundation.dart';
import 'package:jocs/Registration/Controllers/register_controller.dart';
import 'package:jocs/Registration/Controllers/register_controller_windows.dart';

/// [RegisterBindings] is GetX Binding For [Register] Screen
/// It would load required controller based on the Platform
class RegisterBindings extends Bindings {
  @override
  void dependencies() {

    if (defaultTargetPlatform == TargetPlatform.windows && !kIsWeb) {
      Get.put<RegisterControllerWindows>(RegisterControllerWindows());
    }
    else {
      Get.put<RegisterController>(RegisterController());
    }
  }
}