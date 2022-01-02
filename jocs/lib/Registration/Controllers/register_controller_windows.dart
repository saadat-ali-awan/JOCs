import 'package:get/get.dart';
import 'package:firedart/auth/exceptions.dart';
import 'package:firedart/auth/firebase_auth.dart';
import 'package:jocs/FirebaseCustomControllers/firebase_controller_windows.dart';

class RegisterControllerWindows extends GetxController{
  RxString registerErrorMessage = "".obs;
  final FirebaseControllerWindows _firebaseController = Get.find<FirebaseControllerWindows>();

  initializeRegister(){
    _firebaseController.initializeRegisterController();
  }


  register(String email, String password) {
    _firebaseController.register(email, password);
  }
}