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

    if (firebaseAuth.isSignedIn){
      Get.toNamed("/dashboard");

    } else {
      print('User is currently signed out!');
    }
  }
}