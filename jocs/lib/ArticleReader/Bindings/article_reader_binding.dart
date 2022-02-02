import 'package:get/get.dart';
import 'package:jocs/ArticleReader/Controllers/article_reader_controller.dart';

class ArticleReaderBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<ArticleReaderController>(ArticleReaderController());
  }

}