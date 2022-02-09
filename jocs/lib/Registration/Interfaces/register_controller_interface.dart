import 'package:get/get.dart';

/// Register Controller is GetX controller controlling Register Screen
///
/// [initializeRegister] initializes Register Controller after Contoller is
/// bound to Register Screen
///
/// [register] is used to register new User using Username Email and Password
/// to the Firebase Database
abstract class RegisterControllerInterface extends GetxController {

  RxString registerErrorMessage = "".obs;

  initializeRegister();

  register(String username, String email, String password);
}