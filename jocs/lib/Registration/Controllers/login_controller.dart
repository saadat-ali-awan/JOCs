import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:jocs/FirebaseCustomControllers/firebase_controller.dart';
import 'package:jocs/Registration/Interfaces/login_controller_interface.dart';

class LoginController extends LoginControllerInterface{
  /// Firebase Controller get the Instance of [FirebaseController] to use during
  /// registration process
  final FirebaseController firebaseController = Get.find<FirebaseController>();

  LoginController();

  @override
  initializeLogin() async {
    await firebaseController.initializeFirebase();
    if (!kIsWeb){
      var path = Directory.current.path;
      Hive.init(path);
    }

    FirebaseAuth.instance
        .authStateChanges()
        .listen((User? user) {
      if (user == null) {
        print('User is currently signed out!');
      } else {
        print('User is currently signed in!');
        Get.toNamed("/dashboard");
      }
    });
    firebaseController.initializeLoginController();

    // if (firebaseController.checkFirebaseLoggedIn()) {
    //   Get.toNamed('/dashboard');
    // }
  }

 @override
  login(String email, String password){
   firebaseController.login(email, password);
 }

}