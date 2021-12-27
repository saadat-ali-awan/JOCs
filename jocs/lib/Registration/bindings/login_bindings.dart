import 'package:get/get.dart';
import 'package:jocs/Registration/Controllers/login_controller_windows.dart';
import 'package:flutter/foundation.dart';
import '../Controllers/login_controller.dart';

class LoginBindings implements Bindings{
  @override
  void dependencies() {

    if (defaultTargetPlatform == TargetPlatform.windows && !kIsWeb) {
      Get.put<LoginControllerWindows>(LoginControllerWindows());
    }
    else {
      Get.put<LoginController>(LoginController());
    }
  }

}