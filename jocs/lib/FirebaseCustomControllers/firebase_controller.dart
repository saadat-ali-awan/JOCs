import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'package:jocs/Registration/Controllers/login_controller.dart';
import 'package:jocs/Registration/Controllers/register_controller.dart';

import '../firebase_options.dart';

class FirebaseController {

  late CollectionReference tickets;
  late LoginController _loginController;
  late RegisterController _registerController;

  FirebaseAuth auth = FirebaseAuth.instance;

  FirebaseController(){
    initializeFirebase();
  }

  initializeFirebase() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    tickets = FirebaseFirestore.instance.collection('tickets');
  }

  initializeLoginController(){
    _loginController = Get.find<LoginController>();
  }

  initializeRegisterController(){
    _registerController = Get.find<RegisterController>();
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
        _loginController.loginErrorMessage.value = 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
        _loginController.loginErrorMessage.value = 'Wrong password provided for that user.';
      }
    }
  }

  bool checkFirebaseLoggedIn(){
    if (auth.currentUser != null){
      return true;
    }
    return false;
  }

  Future<void> addDataToFirebase(data) async {
    tickets
        .add(data)
        .then((value) => print("Ticket Added"))
        .catchError((error) => print("Failed to add Ticket: $error"));
  }

  register(String email, String password) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email,
          password: password
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
        _registerController.registerErrorMessage.value = "The password provided is too weak.";

      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
        _registerController.registerErrorMessage.value = "The account already exists for that email.";
      }
    } catch (e) {
      print(e);
    }
  }
}