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

  /// To Initialize all the variables of Login Screen and Check if a User is
  /// Logged In [initializeLogin] is used which is called Just After Login
  /// Controller is up and Running.
  initializeLogin();

  /// When user Press Login In Button the Button calls [login] function
  /// passing it Email And Password of the User
  /// If Credentials are correct the User Would be Logged In
  login(String email, String password);
}