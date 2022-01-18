import 'package:get/get.dart';
import 'package:jocs/FirebaseCustomControllers/firebase_controller.dart';
import 'package:jocs/Registration/Interfaces/register_controller_interface.dart';

class RegisterController extends RegisterControllerInterface{

  /// Firebase Controller get the Instance of [FirebaseController] to use during
  /// registration process
  final FirebaseController _firebaseController = Get.find<FirebaseController>();

  @override
  initializeRegister(){
    _firebaseController.initializeRegisterController();
  }

  @override
  register(String username, String email, String password) {
    _firebaseController.register(username, email, password);
  }
}