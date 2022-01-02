import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:jocs/FirebaseCustomControllers/firebase_controller.dart';

class LoginController extends GetxController {


  RxString loginErrorMessage = "".obs;

  final FirebaseController _firebaseController = Get.find<FirebaseController>();

  initializeLogin(){
    FirebaseAuth.instance
        .authStateChanges()
        .listen((User? user) {
      if (user == null) {
        print('User is currently signed out!');
      } else {
        Get.toNamed("/dashboard");
      }
    });
    _firebaseController.initializeLoginController();
  }


 login(String email, String password){
   _firebaseController.login(email, password);
 }
}