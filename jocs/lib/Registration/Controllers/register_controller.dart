import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:jocs/FirebaseCustomControllers/firebase_controller.dart';

class RegisterController extends GetxController{
  RxString registerErrorMessage = "".obs;

  final FirebaseController _firebaseController = Get.find<FirebaseController>();

  initializeRegister(){
    _firebaseController.initializeRegisterController();
  }

  register(String email, String password) {
    _firebaseController.register(email, password);
  }
}