import 'package:get/get.dart';
import 'package:firedart/auth/exceptions.dart';
import 'package:firedart/auth/firebase_auth.dart';

class RegisterControllerWindows extends GetxController{
  RxString registerErrorMessage = "".obs;
  register(String email, String password) async {
    try {
      await FirebaseAuth.instance.signUp(email, password);
    }on AuthException catch(e){
      registerErrorMessage.value = e.message;
    }

  }
}