import 'dart:io';

import 'package:firedart/auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';

import 'hive_store.dart';

class LoginControllerWindows extends GetxController{
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
    await FirebaseAuth.instance.signIn(email, password);
    if (FirebaseAuth.instance.isSignedIn){
      Get.toNamed("/dashboard");
    }
  }
}