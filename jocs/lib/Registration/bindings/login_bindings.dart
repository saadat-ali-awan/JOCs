import 'package:get/get.dart';

import '../Controllers/LoginController.dart';

class LoginBindings implements Bindings{
  @override
  void dependencies() {
    Get.put(() => LoginController());
  }

}