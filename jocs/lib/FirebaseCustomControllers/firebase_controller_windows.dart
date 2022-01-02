import 'dart:io';

import 'package:firedart/auth/exceptions.dart';
import 'package:firedart/auth/firebase_auth.dart';
import 'package:firedart/firestore/firestore.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:jocs/Registration/Controllers/hive_store.dart';
import 'package:jocs/Registration/Controllers/login_controller_windows.dart';
import 'package:jocs/Registration/Controllers/register_controller_windows.dart';

class FirebaseControllerWindows {
  late FirebaseAuth auth;
  late Firestore firestore;
  late LoginControllerWindows _loginController;
  late RegisterControllerWindows _registerControllerWindows;

  FirebaseControllerWindows(){
    initializeFirebase();
  }

  initializeLoginController(){
    _loginController = Get.find<LoginControllerWindows>();
  }

  initializeRegisterController(){
    _registerControllerWindows = Get.find<RegisterControllerWindows>();
  }

  initializeFirebase() async {
    var path = Directory.current.path;
    Hive
        .init(path);
    try {
      Hive.registerAdapter(TokenAdapter());
    }on HiveError catch(e){
      print(e.message);
    }

    try {
      auth = FirebaseAuth.initialize('AIzaSyBqcQEfEXhRUn2Bn4900aOP7BZfxphsKss', await HiveStore.create());
      firestore = Firestore("jocit-b0c8a", auth: auth);
    }on Exception catch (e){
      print("Already Initialized");
    }
  }

  login(String email, String password) async {
    try {
      await FirebaseAuth.instance.signIn(email, password);
    }on AuthException catch (e){
      print(e.message);
      if (e.message == 'EMAIL_NOT_FOUND') {
        print('No user found for that email.');
        _loginController.loginErrorMessage.value = 'No user found for that email.';
      } else if (e.message == 'INVALID_PASSWORD') {
        print('Wrong password provided for that user.');
        _loginController.loginErrorMessage.value = 'Wrong password provided for that user.';
      }
    }
    if (FirebaseAuth.instance.isSignedIn){
      Get.toNamed("/dashboard");
    }
  }

  register(String email, String password) async {
    try {
      await FirebaseAuth.instance.signUp(email, password);
    }on AuthException catch(e){
      _registerControllerWindows.registerErrorMessage.value = e.message;
    }

  }

  Future<void> addDataToFirebase(data) async {
    var reference = firestore.collection('tickets');
    var docReference = await reference.add(data);
  }
}