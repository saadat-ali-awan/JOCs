import 'package:get/get.dart';
import 'package:jocs/FirebaseCustomControllers/firebase_controller_windows.dart';
import 'package:jocs/Registration/Interfaces/register_controller_interface.dart';

class RegisterControllerWindows extends RegisterControllerInterface{
  /// Firebase Controller get the Instance of [FirebaseController] to use during
  /// registration process
  final FirebaseControllerWindows _firebaseController = Get.find<FirebaseControllerWindows>();

  @override
  initializeRegister(){
    _firebaseController.initializeRegisterController();
  }

  @override
  register(String username, String email, String password) {
    _firebaseController.register(username, email, password);
  }
}