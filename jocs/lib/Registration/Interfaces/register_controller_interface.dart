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

  /// To Initialize all the variables of [Register] Screen
  /// [initializeRegister] is used which is called Just After Register
  /// Controller is up and Running.
  initializeRegister();

  /// When user Press Login In Button the Button calls [register] function
  /// passing it Username, Email And Password of the User
  /// Based on Credentials an Account is created for the User
  register(String username, String email, String password);
}