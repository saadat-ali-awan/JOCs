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
  RxString fileName = "".obs;

  ArticleReaderController(){
    if (defaultTargetPlatform != TargetPlatform.windows || kIsWeb) {
      firebaseController = Get.find<FirebaseController>();
    }else {
      if (defaultTargetPlatform == TargetPlatform.windows){
        firebaseController = Get.find<FirebaseControllerWindows>();
      }
    }

    // if (Get.arguments['time'] != null && Get.arguments['time'] != "") {
    //   print(Get.arguments['time']);
    // }
  }

  RxString articleString = "".obs;
  getArticles(String articleId) async {
    print('Get Articles Called ${articleId}');
    var article = await firebaseController.getArticle(articleId);
    articleString.value = article!['article'];
    fileName.value = article!['fileName'];
    print(articleString);
    var myJSON = jsonDecode(articleString.value);
    controller.value = QuillController(
        document: Document.fromJson(myJSON),
        selection: TextSelection.collapsed(offset: 0));
  }

  Future<void> getArticleByTime(String time) async {
    var article = await firebaseController.getArticleByTime(time);
    articleString.value = article!['article'];
    fileName.value = article!['fileName'];
    print(articleString);
    var myJSON = jsonDecode(articleString.value);
    controller.value = QuillController(
        document: Document.fromJson(myJSON),
        selection: TextSelection.collapsed(offset: 0));
  }

  void downloadFile(String fileName) {
    firebaseController.downloadFile(fileName);
  }

}