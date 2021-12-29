import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  FirebaseAuth auth = FirebaseAuth.instance;

  RxString loginErrorMessage = "".obs;

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

  login(String email, String password) async {
    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
          email: email,
          password: password
      ).then((value) {
        print(value);
        return Future.value(value);
      });
      if (auth.currentUser != null){
        Get.toNamed("/dashboard");
      }
      print("success");
      print(auth.currentUser);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
        loginErrorMessage.value = 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
        loginErrorMessage.value = 'Wrong password provided for that user.';
      }
    }
  }

  bool checkFirebaseLoggedIn(){
      if (auth.currentUser != null){
        return true;
      }
      return false;
  }
}