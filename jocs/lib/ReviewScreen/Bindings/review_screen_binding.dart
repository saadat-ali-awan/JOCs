import 'package:get/get.dart';
import 'package:jocs/ReviewScreen/Controllers/review_screen_controller.dart';

class ReviewScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<ReviewScreenController>(ReviewScreenController());
  }

}