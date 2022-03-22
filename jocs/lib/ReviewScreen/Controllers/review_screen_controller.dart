import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:jocs/FirebaseCustomControllers/FirebaseInterface/firebase_controller_interface.dart';
import 'package:jocs/FirebaseCustomControllers/firebase_controller.dart';
import 'package:jocs/FirebaseCustomControllers/firebase_controller_windows.dart';

class ReviewScreenController extends GetxController {
  late List<String> data = <String>[];
  late List<String> dataTitle = <String>[];
  late String time = "";
  late String screenName = "";
  RxList<Map<String, dynamic>> reviews = RxList();

  late FirebaseControllerInterface firebaseController;

  ReviewScreenController() {
    try {
      data = Get.arguments['data'].cast<String>();
      time = Get.arguments['time'];
      screenName = Get.arguments['screenName'];
    } on NoSuchMethodError catch(e) {
      Get.toNamed('/dashboard');
    }


    if (defaultTargetPlatform != TargetPlatform.windows || kIsWeb || defaultTargetPlatform == TargetPlatform.android) {
      firebaseController = Get.find<FirebaseController>();
      // firebaseController.getData("Tickets", 1);
    }else {
      if (defaultTargetPlatform == TargetPlatform.windows){
        firebaseController = Get.find<FirebaseControllerWindows>();
      }
    }

    switch (screenName) {
      case 'tickets':
        dataTitle = [
          'Issued By',
          'Topic',
          'Status',
          'Priority',
          'Assigned To',
          'Comments',
        ];
        break;
      case 'inventory':
        dataTitle = [
          'Item Name',
          'Item Type',
          'Location',
          'Used By',
          'Processed By',
          'Comments',
        ];
        break;
      case 'problems':
        dataTitle = [
          'Issued By',
          'Topic',
          'Status',
          'Priority',
          'Assigned To',
          'Department',
        ];
        break;
      case 'purchase':
        dataTitle = [
          'ORDER NO.',
          'ORDER NAME',
          'DESCRIPTION',
          'EXPECTED DELIVERY',
          'STATUS',
          'COMMENTS',
        ];
        break;
      case 'articles':
        dataTitle = [
          'ARTICLE TOPIC',
          'AUTHOR',
          'CATEGORY',
          'COMMENTS',
        ];
        break;
      default:
        break;
    }

    getReviews();

  }

  /// Get Reviews of the [screenName] From The Database
  getReviews() async {
    var rev = await firebaseController.getReviews(time, screenName);
    reviews.bindStream(rev);
  }

  /// Send Review for [screenName] to the Database
  sendReview(String review) {
    firebaseController.sendReview(review, time, screenName);
  }

  @override
  void onClose() {
    reviews.close();
    super.onClose();
  }
}