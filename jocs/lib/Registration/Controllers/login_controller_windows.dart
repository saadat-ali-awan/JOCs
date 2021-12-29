import 'dart:io';

import 'package:firedart/auth/exceptions.dart';
import 'package:firedart/auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';

import 'hive_store.dart';

class LoginControllerWindows extends GetxController{

  RxString loginErrorMessage = "".obs;

  initializeLogin() async {
    var path = Directory.current.path;
    Hive
        .init(path);
    var firebaseAuth = FirebaseAuth.initialize('AIzaSyBqcQEfEXhRUn2Bn4900aOP7BZfxphsKss', await HiveStore.create());

    firebaseAuth.signInState.listen((state){
      if (state){
        Get.toNamed("/dashboard");

      } else {
        print('User is currently signed out!');
      }
    });

  }

  login(String email, String password) async {
    try {
      await FirebaseAuth.instance.signIn(email, password);
    }on AuthException catch (e){
      print(e.message);
      if (e.message == 'EMAIL_NOT_FOUND') {
        print('No user found for that email.');
        loginErrorMessage.value = 'No user found for that email.';
      } else if (e.message == 'INVALID_PASSWORD') {
        print('Wrong password provided for that user.');
        loginErrorMessage.value = 'Wrong password provided for that user.';
      }
    }
    if (FirebaseAuth.instance.isSignedIn){
      Get.toNamed("/dashboard");
    }
  }
}