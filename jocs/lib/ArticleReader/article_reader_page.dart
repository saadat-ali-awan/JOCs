import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' hide Text;
import 'package:get/get.dart';
import 'package:jocs/ArticleReader/Controllers/article_reader_controller.dart';
import 'package:jocs/universal_ui/universal_ui.dart';

class ArticleReaderPage extends StatelessWidget {
  ArticleReaderPage({Key? key}) : super(key: key);

  ArticleReaderController _readerController = Get.find<ArticleReaderController>();
  final FocusNode _focusNode = FocusNode();
  @override
  Widget build(BuildContext context) {
    if (Get.arguments['time'] != null && Get.arguments['time'] != "") {
      _readerController.getArticleByTime(Get.arguments['time']);
    }
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

    if (Get.arguments['time'] != null && Get.arguments['time'] != "") {
      return Scaffold(
        appBar: AppBar(
          leading: InkWell(
            child: Icon(Icons.arrow_back_ios_rounded, color: context.theme.appBarTheme.foregroundColor,),
            onTap: () {
              Get.back();
            },
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(8.0),
                child: quillEditor,
              ),
            ),
          ],
        ),
      );
    }
    return  Column(
      children: [
        Tooltip(
          message: 'Click to Download',
          child: InkWell(
            child: Obx(()=> Text(_readerController.fileName.value)),
            onTap: () {
              if (_readerController.fileName.value.isNotEmpty) {
                _readerController.downloadFile(_readerController.fileName.value);
              }
            },
          ),
        ),
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(8.0),
            child: quillEditor,
          ),
        ),
      ],
    );
  }
}
