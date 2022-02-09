import 'package:get/get.dart';

/// Register Controller is GetX controller controlling Register Screen
///
/// [initializeLogin] initializes Register Controller after Contoller is
/// bound to Login Screen
///
/// [login] is used to register new User using Username Email and Password
/// to the Firebase Database
abstract class LoginControllerInterface extends GetxController {
  RxString loginErrorMessage = "".obs;

  initializeLogin();
  login(String email, String password);
}