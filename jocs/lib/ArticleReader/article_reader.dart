import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' hide Text;
import 'package:get/get.dart';
import 'package:jocs/ArticleReader/Controllers/article_reader_controller.dart';
import 'package:jocs/universal_ui/universal_ui.dart';

class ArticleReader extends StatelessWidget {
  ArticleReader({Key? key}) : super(key: key);

  ArticleReaderController _readerController = Get.find<ArticleReaderController>();
  final FocusNode _focusNode = FocusNode();
  @override
  Widget build(BuildContext context) {
    _readerController.getArticles(Get.arguments["id"]);
    var quillEditor = Obx( ()=> QuillEditor(
      controller: _readerController.controller.value,
      scrollController: ScrollController(),
      scrollable: true,
      focusNode: _focusNode,
      autoFocus: true,
      readOnly: true,
      expands: false,
      padding: EdgeInsets.zero,
    ));
    if (kIsWeb) {
      quillEditor = Obx( ()=> QuillEditor(
          controller: _readerController.controller.value,
          scrollController: ScrollController(),
          scrollable: true,
          focusNode: _focusNode,
          autoFocus: true,
          readOnly: true,
          expands: false,
          padding: EdgeInsets.zero,
          embedBuilder: defaultEmbedBuilderWeb));
    }
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("JOC Articles"),
          leading: InkWell(
            child: Icon(Icons.arrow_back_ios_rounded),
            onTap: () {
              Get.back();
            },
          ),
        ),
        body: Container(
          child: quillEditor,
        ),
      ),
    );
  }
}
