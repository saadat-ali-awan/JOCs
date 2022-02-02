import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:get/get.dart';
import 'package:jocs/FirebaseCustomControllers/FirebaseInterface/firebase_controller_interface.dart';
import 'package:jocs/FirebaseCustomControllers/firebase_controller.dart';
import 'package:jocs/FirebaseCustomControllers/firebase_controller_windows.dart';

class ArticleReaderController extends GetxController {
  late FirebaseControllerInterface firebaseController;
  late Rx<QuillController> controller = QuillController.basic().obs;

  ArticleReaderController(){
    if (defaultTargetPlatform != TargetPlatform.windows || kIsWeb) {
      firebaseController = Get.find<FirebaseController>();
      // firebaseController.getData("Tickets", 1);
    }else {
      if (defaultTargetPlatform == TargetPlatform.windows){
        firebaseController = Get.find<FirebaseControllerWindows>();
      }
    }
  }

  RxString articleString = "".obs;
  getArticles(String articleId) async {
    var article = await firebaseController.getArticle(articleId);
    articleString.value = article!['article'];
    print(articleString);
    var myJSON = jsonDecode(articleString.value);
    controller.value = QuillController(
        document: Document.fromJson(myJSON),
        selection: TextSelection.collapsed(offset: 0));
  }

}