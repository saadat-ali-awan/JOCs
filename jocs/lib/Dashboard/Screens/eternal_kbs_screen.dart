import 'dart:convert';
import 'dart:io';
import 'dart:async';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:file_picker/file_picker.dart';
import 'package:filesystem_picker/filesystem_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' hide Text;
import 'package:get/get.dart';
import 'package:jocs/ArticleReader/Controllers/article_reader_controller.dart';
import 'package:jocs/ArticleReader/article_reader.dart';
import 'package:jocs/ArticleReader/article_reader.dart';
import 'package:jocs/Dashboard/Controllers/dashboard_controller.dart';
import 'package:jocs/Dashboard/Dialog/CategoryScreenDialogs/add_article_dialog.dart';
import 'package:jocs/Dashboard/Screens/tickets_screen.dart';
import 'package:jocs/FirebaseCustomControllers/DataModels/article_category.dart';
import 'package:jocs/Theme/custom_theme.dart';
import 'package:jocs/universal_ui/universal_ui.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:tuple/tuple.dart';
import 'package:jocs/universal_ui/universal_ui.dart';

class EternalKbsScreen extends StatelessWidget {
  EternalKbsScreen({Key? key}) : super(key: key);

  final DashboardController _dashboardController =
  Get.find<DashboardController>();

  RxInt sub_category = 1.obs;


  @override
  Widget build(BuildContext context) {

    return Column(
      children: [
        Expanded(
            child: Container(child: Obx((){
              if (sub_category.value == 2){
                return ArticleWriter();
              }
              if (sub_category.value == 3){
                return CategoryCreationWidget();
              }
              return ArticlesTable();
            }
            ),)
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Align(
            alignment: Alignment.centerLeft,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              controller: ScrollController(),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextButton(onPressed: (){sub_category.value = 1;}, child: Text("Articles", style: context.textTheme.bodyText1,),),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextButton(onPressed: (){sub_category.value = 2;}, child: Text("Create Article", style: context.textTheme.bodyText1,),),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextButton(onPressed: (){sub_category.value = 3;}, child: Text("Categories", style: context.textTheme.bodyText1,),),
                  )
                ],
              ),
            ),
            // child: DecoratedBox(
            //   decoration: BoxDecoration(
            //     color: context.theme.appBarTheme.backgroundColor, //background color of  //border of dropdown button
            //     borderRadius: const BorderRadius.all(Radius.circular(12)), //border raiuds of dropdown button
            //   ),
            //   child: Row(
            //     children: [
            //       TextButton(onPressed: (){sub_category.value = 2;}, child: const Text("Create Article"),),
            //       TextButton(onPressed: (){sub_category.value = 3;}, child: const Text("Categories"),)
            //     ],
            //   ),
              // child: Padding(
              //   padding: const EdgeInsets.only(left: 8.0, right: 8.0),
              //   child: Theme(
              //     data: context.theme.copyWith(canvasColor: context.theme.appBarTheme.backgroundColor),
              //     child: DropdownButton(
              //       iconEnabledColor: context.theme.appBarTheme.foregroundColor,
              //       style: context.textTheme.bodyText1,
              //       value: "Create New",
              //       items: <String>["Create New", "Article", "Category"].map((value){
              //         return DropdownMenuItem(
              //           child: Text(value),
              //           value: value,
              //         );
              //       }).toList(),
              //       onChanged: (String? newValue){
              //         if (newValue == "Article"){
              //           sub_category.value = 2;
              //         }else {
              //           if (newValue == "Category"){
              //             sub_category.value = 3;
              //           }else {
              //             _dashboardController.getKBSData();
              //             sub_category.value = 1;
              //           }
              //         }
              //       },
              //       isExpanded: false,
              //       underline: Container(),
              //
              //     ),
              //   ),
              // ),
            // ),
          ),
        ),
      ],
    );
  }
}

class ArticleWriter extends StatefulWidget {
  ArticleWriter({Key? key}) : super(key: key);

  @override
  State<ArticleWriter> createState() => _ArticleWriterState();
}

class _ArticleWriterState extends State<ArticleWriter> {
  final QuillController _controller = QuillController.basic();

  final FocusNode _focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    var quillEditor = QuillEditor(
        controller: _controller,
        scrollController: ScrollController(),
        scrollable: true,
        focusNode: _focusNode,
        autoFocus: false,
        readOnly: false,
        placeholder: 'Add content',
        expands: false,
        padding: EdgeInsets.zero,
        customStyles: DefaultStyles(
          h1: DefaultTextBlockStyle(
              const TextStyle(
                fontSize: 32,
                color: Colors.black,
                height: 1.15,
                fontWeight: FontWeight.w300,
              ),
              const Tuple2(16, 0),
              const Tuple2(0, 0),
              null),
          sizeSmall: const TextStyle(fontSize: 9),
        ));
    if (kIsWeb) {
      quillEditor = QuillEditor(
          controller: _controller,
          scrollController: ScrollController(),
          scrollable: true,
          focusNode: _focusNode,
          autoFocus: false,
          readOnly: false,
          placeholder: 'Add content',
          expands: false,
          padding: EdgeInsets.zero,
          customStyles: DefaultStyles(
            h1: DefaultTextBlockStyle(
                const TextStyle(
                  fontSize: 32,
                  color: Colors.black,
                  height: 1.15,
                  fontWeight: FontWeight.w300,
                ),
                const Tuple2(16, 0),
                const Tuple2(0, 0),
                null),
            sizeSmall: const TextStyle(fontSize: 9),
          ),
          embedBuilder: defaultEmbedBuilderWeb);
    }
    var toolbar = QuillToolbar.basic(
      controller: _controller,
      // provide a callback to enable picking images from device.
      // if omit, "image" button only allows adding images from url.
      // same goes for videos.
      onImagePickCallback: _onImagePickCallback,
      onVideoPickCallback: _onVideoPickCallback,
      // uncomment to provide a custom "pick from" dialog.
      // mediaPickSettingSelector: _selectMediaPickSetting,
      showAlignmentButtons: true,
    );
    if (kIsWeb) {
      toolbar = QuillToolbar.basic(
        controller: _controller,
        onImagePickCallback: _onImagePickCallback,
        webImagePickImpl: _webImagePickImpl,
        showAlignmentButtons: true,
      );
    }
    if (_isDesktop()) {
      toolbar = QuillToolbar.basic(
        controller: _controller,
        onImagePickCallback: _onImagePickCallback,
        filePickImpl: openFileSystemPickerForDesktop,
        showAlignmentButtons: true,
      );
    }
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(8.0),
          alignment: Alignment.centerRight,
          child: TextButton(
            child: Text("NEXT", style: context.textTheme.bodyText1),
            onPressed: () {
              Get.dialog(AddArticleDialog(), arguments: {'article': jsonEncode(_controller.document.toDelta().toJson())});
            },
          ),
        ),
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(
                  color: ThemeColors.getHoverColor()
              ),
              color: context.theme.appBarTheme.backgroundColor,
            ),
            child: Material(
              child: Column(
                children: [
                  Theme(
                    data: ThemeData(
                      iconTheme: const IconThemeData(
                        color: Colors.black,
                      ),
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: ThemeColors.getHoverColor(),
                          ),
                        ),
                        // color: context.theme.appBarTheme.backgroundColor,
                      ),
                      width: double.infinity,
                      padding: const EdgeInsets.all(8.0),
                      child: toolbar,
                    ),
                  ),
                  Expanded(
                    child: Container(
                      child: quillEditor,
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  bool _isDesktop() => !kIsWeb && !Platform.isAndroid && !Platform.isIOS;

  Future<String?> openFileSystemPickerForDesktop(BuildContext context) async {
    return await FilesystemPicker.open(
      context: context,
      rootDirectory: await getApplicationDocumentsDirectory(),
      fsType: FilesystemType.file,
      fileTileSelectMode: FileTileSelectMode.wholeTile,
    );
  }

  Future<String> _onImagePickCallback(File file) async {
    // Copies the picked file from temporary cache to applications directory
    final appDocDir = await FilePicker.platform.getDirectoryPath();
    final copiedFile =
    await file.copy('$appDocDir/${basename(file.path)}');
    return copiedFile.path.toString();
  }

  Future<String?> _webImagePickImpl(
      OnImagePickCallback onImagePickCallback) async {
    final result = await FilePicker.platform.pickFiles();
    if (result == null) {
      return null;
    }

    // Take first, because we don't allow picking multiple files.
    final fileName = result.files.first.name;
    final file = File(fileName);

    return onImagePickCallback(file);
  }

  Future<String> _onVideoPickCallback(File file) async {
    // Copies the picked file from temporary cache to applications directory
    final appDocDir = await FilePicker.platform.getDirectoryPath();
    final copiedFile =
    await file.copy('$appDocDir/${basename(file.path)}');
    return copiedFile.path.toString();
  }
}

class ArticlesTable extends StatelessWidget {
  ArticlesTable({Key? key}) : super(key: key);

  DashboardController _dashboardController = Get.find<DashboardController>();
  Map<String,  String> customFilter = <String, String>{};

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: SingleChildScrollView(
            controller: ScrollController(),
            scrollDirection: Axis.vertical,
            child: Column(
              children: [
                Center(
                  child: Theme(
                    data: context.theme.copyWith(
                        textTheme: TextTheme(
                            caption: TextStyle(
                                color: context.theme.appBarTheme
                                    .backgroundColor))),
                    child: SingleChildScrollView(
                      controller: ScrollController(),
                      scrollDirection: Axis.vertical,
                      child: Obx(() {
                        print("DATA TABLE SOURCE: ${_dashboardController.kbsAdapter.value.dataTableSource.value}");
                        return PaginatedDataTable(
                          columns: const [
                            DataColumn(label: Expanded(child: Text("ARTICLE TOPIC", textAlign: TextAlign.center))),
                            DataColumn(label: Expanded(child: Text("AUTHOR", textAlign: TextAlign.center))),
                            DataColumn(label: Expanded(child: Text("CATEGORY", textAlign: TextAlign.center))),
                            DataColumn(label: Expanded(child: Text("COMMENTS", textAlign: TextAlign.center))),
                            DataColumn(label: Expanded(child: Text("", textAlign: TextAlign.center,))),
                          ],
                          source: _dashboardController.kbsAdapter.value.dataTableSource.value,
                          arrowHeadColor:
                          Get.theme.appBarTheme.backgroundColor,
                          onPageChanged: (int? index) {
                            if (index != null) {
                              if (((index+1)/10).ceil() > _dashboardController.kbsAdapter.value
                                  .currentPaginatedPage){
                                _dashboardController.kbsAdapter.value
                                    .getNextPage(_dashboardController
                                    .firebaseController, customFilter);
                              }
                              _dashboardController.kbsAdapter.value
                                  .currentPaginatedPage = ((index+1)/10).ceil();

                            }

                          },
                        );
                      }),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class CategoryCreationWidget extends StatelessWidget {
  const CategoryCreationWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (context.width > 600) {
      return Column(
        children: [
          Expanded(
            child: Row(
              children: [
                Flexible(
                  flex: 3,
                  child: Container(
                    color: context.theme.appBarTheme.backgroundColor,
                    child: CategorySideWidget(),
                  ),
                ),
                Flexible(
                  flex: 7,
                  child: ArticleReader(),
                )
              ],
            ),
          )
        ],
      );
    }else {
      return Column(
        children: [
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    controller: ScrollController(),
                    child: Column(
                      children: [
                        Expanded(child: ArticleReader())
                      ],
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      );
    }
  }
}

class CategoryFormWidget extends StatelessWidget {
  CategoryFormWidget({Key? key}) : super(key: key);
  final _formKey = GlobalKey<FormState>();

  final _categoryController = TextEditingController();
  final _descriptionController = TextEditingController();

  final DashboardController _dashboardController =
  Get.find<DashboardController>();

  RxString error = "".obs;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        color: Colors.white,
        width: context.width > 600 ? context.width * 0.5 : context.width * 0.9,
        child: Form(
          key: _formKey,
          child: Material(
            child: SingleChildScrollView(
              controller: ScrollController(),
              scrollDirection: Axis.vertical,
              child: Container(
                decoration: BoxDecoration(
                  color: context.theme.appBarTheme.backgroundColor!.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                padding: const EdgeInsets.all(8.0),
                margin: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Align(alignment: Alignment.centerLeft,child: Text("NEW CATEGORY", style: context.textTheme.headline4!.copyWith(color: context.theme.appBarTheme.backgroundColor), textAlign: TextAlign.left,)),
                    Padding(
                      padding: const EdgeInsets.only(top: 16.0),
                      child: Align( alignment: Alignment.centerLeft,child: Text("CATEGORY NAME", style: context.textTheme.bodyText2, textAlign: TextAlign.left,)),
                    ),
                    TextFormField(
                      controller: _categoryController,
                      decoration: const InputDecoration(
                        hintText: 'ENTER CATEGORY NAME',
                        border: OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(),
                        enabledBorder: OutlineInputBorder(),
                        disabledBorder: OutlineInputBorder()
                      ),
                      validator: (value) {
                        print(value);
                        if (value == null || value.isEmpty) {
                          return 'Category Name?';
                        }
                        return null;
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 16.0),
                      child: Align( alignment: Alignment.centerLeft,child: Text("DESCRIPTION", style: context.textTheme.bodyText2, textAlign: TextAlign.left,)),
                    ),
                    TextField(
                      controller: _descriptionController,
                      decoration: const InputDecoration(
                        hintText: 'ENTER DESCRIPTION',
                        floatingLabelBehavior: FloatingLabelBehavior.never,
                        border: OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(),
                        enabledBorder: OutlineInputBorder(),
                        disabledBorder: OutlineInputBorder()
                      ),
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      minLines: 10,
                    ),
                    SingleChildScrollView(
                      controller: ScrollController(),
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextButton(
                              child: Text("Cancel", style: context.textTheme.bodyText2,),
                              onPressed: (){},
                              style: context.theme.textButtonTheme.style!.copyWith(backgroundColor: MaterialStateColor.resolveWith((states) => context.theme.appBarTheme.foregroundColor!)),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextButton(
                              child: Text("Save", style: context.textTheme.bodyText1,),
                              onPressed: (){
                                if (_formKey.currentState!.validate()){
                                  if (_dashboardController.categoryList.where((category) => _categoryController.text == category.name).isEmpty){
                                    _dashboardController
                                        .addArticleCategory({ 'category-name': _categoryController.text, 'description': _descriptionController.text, 'articles': []
                                    });
                                  }else {
                                    error.value = "Category Already Exists";
                                  }
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    Obx(() => Text(error.value, style: context.textTheme.subtitle2,),),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class CategorySideWidget extends StatelessWidget {
  CategorySideWidget({Key? key}) : super(key: key);
  final DashboardController _dashboardController =
  Get.find<DashboardController>();

  final ArticleReaderController  _readerController =
  Get.find<ArticleReaderController>();

  ArticleCategory categorySelected = ArticleCategory("");

  @override
  Widget build(BuildContext context) {
    if (context.width > 600){
      return Column(
        children: getChildrenList(context.textTheme.bodyText1, context.width),
      );
    }
    return Row(
      children: getChildrenList(context.textTheme.bodyText1, context.width),
    );

  }

  List<Widget> getChildrenList(style, width){
    return [
      Text("CATEGORIES", style: style,),
      Expanded(
        child: Obx( ()=> ListView.builder(
          controller: ScrollController(),
          scrollDirection: width > 600 ? Axis.vertical : Axis.horizontal,
          itemCount: _dashboardController.categoryList.length,
          itemBuilder: (context, index){
            return ListTile(
              title: DropdownSearch<dynamic>(
                items: _dashboardController.categoryList[index].articles,
                dropdownSearchDecoration: InputDecoration(
                    labelText: _dashboardController.categoryList[index].name,
                    labelStyle: context.textTheme.bodyText2,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12)
                    ),
                    fillColor: Colors.white,
                    filled: true
                ),
                onChanged: (dynamic data) {
                  print(data["topic"]);
                  //Get.toNamed('/articleReader', arguments: {'id': data["id"]});
                  _readerController.getArticles(data["id"]);
                },
                showSearchBox: true,
                itemAsString: (dynamic data) => data["topic"],
              ),
              tileColor: Colors.red,
            );
          },
        ),
        ),
      ),
    ];
  }
}