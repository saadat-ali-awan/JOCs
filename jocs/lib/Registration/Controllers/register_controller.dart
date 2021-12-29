import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class RegisterController extends GetxController{
  RxString registerErrorMessage = "".obs;
  register(String email, String password) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email,
          password: password
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
        registerErrorMessage.value = "The password provided is too weak.";

      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
        registerErrorMessage.value = "The account already exists for that email.";
      }
    } catch (e) {
      print(e);
    }
  }
}