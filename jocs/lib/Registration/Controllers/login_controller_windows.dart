import 'dart:io';

import 'package:firedart/auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:jocs/FirebaseCustomControllers/firebase_controller_windows.dart';
import 'package:jocs/Registration/Interfaces/login_controller_interface.dart';

import 'hive_store.dart';

class LoginControllerWindows extends LoginControllerInterface {

  /// Firebase Controller get the Instance of [FirebaseController] to use during
  /// registration process

  final FirebaseControllerWindows firebaseController = Get.find<FirebaseControllerWindows>();

  @override
  initializeLogin() async {
    var path = Directory.current.path;
    Hive
        .init(path);
    try {
      Hive.registerAdapter(TokenAdapter());
    }on HiveError catch(e){
      print(e.message);
    }
    try {
      FirebaseAuth.initialize('AIzaSyBqcQEfEXhRUn2Bn4900aOP7BZfxphsKss', await HiveStore.create());
    }on Exception catch (e){
      print("Already Initialized");
    }

    try {
      FirebaseAuth.instance.signInState.listen((state) {
        if (state) {
          Get.toNamed("/dashboard");
        } else {
          print('User is currently signed out!');
        }
      });
    }on StateError catch(e){
      print("Listen Stream Created Already");
    }
    firebaseController.initializeLoginController();

  }

  @override
  login(String email, String password){
    firebaseController.login(email, password);
  }


}