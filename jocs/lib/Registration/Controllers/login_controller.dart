import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  FirebaseAuth auth = FirebaseAuth.instance;

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
  }

  bool checkFirebaseLoggedIn(){
      if (auth.currentUser != null){
        return true;
      }
      return false;
  }
}