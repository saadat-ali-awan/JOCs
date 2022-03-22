import 'package:get/get.dart';
import 'package:jocs/FirebaseCustomControllers/firebase_controller_windows.dart';
import 'package:jocs/Registration/Interfaces/register_controller_interface.dart';

class RegisterControllerWindows extends RegisterControllerInterface{
  /// Firebase Controller get the Instance of [FirebaseController] to use during
  /// registration process
  final FirebaseControllerWindows _firebaseController = Get.find<FirebaseControllerWindows>();

  /// To Initialize all the variables of [Register] Screen
  /// [initializeRegister] is used which is called Just After Register
  /// Controller is up and Running.
  @override
  initializeRegister(){
    _firebaseController.initializeRegisterController();
  }

  /// When user Press Login In Button the Button calls [register] function
  /// passing it Username, Email And Password of the User
  /// Based on Credentials an Account is created for the User
  @override
  register(String username, String email, String password) {
    _firebaseController.register(username, email, password);
  }
}