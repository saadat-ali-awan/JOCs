import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:jocs/FirebaseCustomControllers/firebase_controller.dart';
import 'package:jocs/Registration/Interfaces/login_controller_interface.dart';

class LoginController extends LoginControllerInterface{
  /// Firebase Controller get the Instance of [FirebaseController] to use during
  /// registration process
  final FirebaseController firebaseController = Get.find<FirebaseController>();

  @override
  initializeLogin(){
    var path = Directory.current.path;
    Hive
        .init(path);
    FirebaseAuth.instance
        .authStateChanges()
        .listen((User? user) {
      if (user == null) {
        print('User is currently signed out!');
      } else {
        Get.toNamed("/dashboard");
      }
    });
    firebaseController.initializeLoginController();
  }

 @override
  login(String email, String password){
   firebaseController.login(email, password);
 }

}