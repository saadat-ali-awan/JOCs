

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:get/get.dart';
import 'package:jocs/Dashboard/Controllers/dashboard_controller.dart';
import 'package:jocs/Dashboard/Dialog/CategoryScreenDialogs/add_article_dialog.dart';
import 'package:jocs/Dashboard/Screens/tickets_screen.dart';
import 'package:jocs/Theme/custom_theme.dart';
import 'package:jocs/Theme/custom_theme.dart';


class EternalKbsScreen extends StatelessWidget {
  EternalKbsScreen({Key? key}) : super(key: key);

  final DashboardController _dashboardController =
  Get.find<DashboardController>();

  RxInt sub_category = 2.obs;


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
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: context.theme.appBarTheme.backgroundColor, //background color of  //border of dropdown button
                borderRadius: const BorderRadius.all(Radius.circular(12)), //border raiuds of dropdown button
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                child: Theme(
                  data: context.theme.copyWith(canvasColor: context.theme.appBarTheme.backgroundColor),
                  child: DropdownButton(
                    iconEnabledColor: context.theme.appBarTheme.foregroundColor,
                    style: context.textTheme.bodyText1,
                    value: "Create New",
                    items: <String>["Create New", "Article", "Category"].map((value){
                      return DropdownMenuItem(
                        child: Text(value),
                        value: value,
                      );
                    }).toList(),
                    onChanged: (String? newValue){
                      if (newValue == "Article"){
                        sub_category.value = 2;
                      }else {
                        if (newValue == "Category"){
                          sub_category.value = 3;
                        }else {
                          sub_category.value = 1;
                        }
                      }
                    },
                    isExpanded: false,
                    underline: Container(),

                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
    return CustomScrollView(
      controller: ScrollController(),
      reverse: true,
      scrollDirection: Axis.vertical,
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: context.theme.appBarTheme.backgroundColor, //background color of  //border of dropdown button
                  borderRadius: const BorderRadius.all(Radius.circular(12)), //border raiuds of dropdown button
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                  child: Theme(
                    data: context.theme.copyWith(canvasColor: context.theme.appBarTheme.backgroundColor),
                    child: DropdownButton(
                      iconEnabledColor: context.theme.appBarTheme.foregroundColor,
                      style: context.textTheme.bodyText1,
                      value: "Create New",
                      items: <String>["Create New", "Article", "Category"].map((value){
                        return DropdownMenuItem(
                          child: Text(value),
                          value: value,
                        );
                      }).toList(),
                      onChanged: (String? newValue){
                        if (newValue == "Article"){
                          sub_category.value = 2;
                        }else {
                          if (newValue == "Category"){
                            sub_category.value = 3;
                          }else {
                            sub_category.value = 1;
                          }
                        }
                      },
                      isExpanded: false,
                      underline: Container(),

                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        SliverFillRemaining(
          child: Container(
            child: Obx((){
              if (sub_category.value == 2){
                return ArticleWriter();
              }
              if (sub_category.value == 3){
                return Container(color: Colors.green, width: 100,child: CategoryCreationWidget());
              }
              return ArticlesTable();
              }
            ),
          ),
          hasScrollBody: false,
        ),

      ],
    );
    return Column(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: Row(
              children: [
                Container(
                  color: Colors.green,
                  child: Text(""),
                ),
              ],
            ),
          ),
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: context.theme.appBarTheme.backgroundColor, //background color of  //border of dropdown button
              borderRadius: const BorderRadius.all(Radius.circular(12)), //border raiuds of dropdown button
            ),
            child: Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8.0),
              child: Theme(
                data: context.theme.copyWith(canvasColor: context.theme.appBarTheme.backgroundColor),
                child: DropdownButton(
                  iconEnabledColor: context.theme.appBarTheme.foregroundColor,
                  style: context.textTheme.bodyText1,
                  value: "Create New",
                  items: <String>["Create New", "Article", "Category"].map((value){
                    return DropdownMenuItem(
                      child: Text(value),
                      value: value,
                    );
                  }).toList(),
                  onChanged: (String? newValue){
                    if (newValue == "Article"){
                      sub_category.value = 2;
                    }else {
                      if (newValue == "Category"){
                        sub_category.value = 3;
                      }else {
                        sub_category.value = 1;
                      }
                    }
                  },
                  isExpanded: false,
                  underline: Container(),

                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}

// class EternalKbsScreen extends StatelessWidget {
//   EternalKbsScreen({Key? key}) : super(key: key);
//
//   final DashboardController _dashboardController =
//   Get.find<DashboardController>();
//
//   RxInt sub_category = 1.obs;
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Expanded(
//           child: Padding(
//             padding: const EdgeInsets.only(bottom: 16.0),
//             child: SingleChildScrollView(
//               controller: ScrollController(),
//               scrollDirection: Axis.vertical,
//               child: Container(
//                 color: Colors.pink,
//                 child: Expanded(
//                   child: Column(
//                     children: [
//                       Padding(
//                         padding: const EdgeInsets.all(4.0),
//                         child: Row(
//                           children: [
//                             Obx((){
//                               if (sub_category.value == 2){
//                                 return ArticleWriter();
//                               }
//                               if (sub_category.value == 3){
//                                 return Expanded(child: Container(color: Colors.purple, child: Center(child: Text("Article"),),));
//                               }
//                               return Expanded(
//                                 child: SingleChildScrollView(
//                                   scrollDirection: Axis.vertical,
//                                   controller: ScrollController(),
//                                   child: Column(
//                                     children: [
//                                       Row(
//                                         mainAxisAlignment: MainAxisAlignment.start,
//                                         children: [
//                                           Expanded(
//                                             child: Obx(
//                                                   () => Theme(
//                                                 data: Get.theme.copyWith(
//                                                     textTheme: TextTheme(
//                                                         caption: TextStyle(
//                                                             color: Get.theme.appBarTheme
//                                                                 .backgroundColor))),
//                                                 child: PaginatedDataTable(
//                                                   columns: const [
//                                                     DataColumn(label: Text("ARTICLE TOPIC")),
//                                                     DataColumn(label: Text("AUTHOR")),
//                                                     DataColumn(label: Text("CATEGORY")),
//                                                     DataColumn(label: Text("COMMENTS")),
//                                                     DataColumn(label: Text("ASSIGNED TO")),
//                                                     DataColumn(label: Text("COMMENTS")),
//                                                   ],
//                                                   source: _dashboardController
//                                                       .inventoryAdapter.value.dataTableSource.value,
//                                                   arrowHeadColor:
//                                                   Get.theme.appBarTheme.backgroundColor,
//                                                   onPageChanged: (int? index) {
//                                                     if (index != null) {
//                                                       if (((index+1)/10).ceil() > _dashboardController.inventoryAdapter.value
//                                                           .currentPaginatedPage){
//                                                         _dashboardController.inventoryAdapter.value
//                                                             .getNextPage(_dashboardController
//                                                             .firebaseController, <String, String>{});
//                                                       }
//                                                       _dashboardController.inventoryAdapter.value
//                                                           .currentPaginatedPage = ((index+1)/10).ceil();
//
//                                                     }
//
//                                                   },
//                                                 ),
//                                               ),
//                                             ),
//                                           )
//                                         ],
//                                       )
//                                     ],
//                                   ),
//                                 ),
//                               );}
//                             ),
//                           ],
//                         ),
//                       ),
//
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ),
//         Align(
//           alignment: Alignment.centerLeft,
//           child: DecoratedBox(
//             decoration: BoxDecoration(
//               color: context.theme.appBarTheme.backgroundColor, //background color of  //border of dropdown button
//               borderRadius: const BorderRadius.all(Radius.circular(12)), //border raiuds of dropdown button
//             ),
//             child: Padding(
//               padding: const EdgeInsets.only(left: 8.0, right: 8.0),
//               child: Theme(
//                 data: context.theme.copyWith(canvasColor: context.theme.appBarTheme.backgroundColor),
//                 child: DropdownButton(
//                   iconEnabledColor: context.theme.appBarTheme.foregroundColor,
//                   style: context.textTheme.bodyText1,
//                   value: "Create New",
//                   items: <String>["Create New", "Article", "Category"].map((value){
//                     return DropdownMenuItem(
//                       child: Text(value),
//                       value: value,
//                     );
//                   }).toList(),
//                   onChanged: (String? newValue){
//                     if (newValue == "Article"){
//                       sub_category.value = 2;
//                     }else {
//                       if (newValue == "Category"){
//                         sub_category.value = 3;
//                       }else {
//                         sub_category.value = 1;
//                       }
//                     }
//                   },
//                   isExpanded: false,
//                   underline: Container(),
//
//                 ),
//               ),
//             ),
//           ),
//         )
//       ],
//     );
//   }
// }

class ArticleWriter extends StatelessWidget {
  ArticleWriter({Key? key}) : super(key: key);

  quill.QuillController _controller = quill.QuillController.basic();

  @override
  Widget build(BuildContext context) {
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
                      child: quill.QuillToolbar.basic(
                          controller: _controller
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      // decoration: BoxDecoration(
                      //   border: Border.all(
                      //     color: ThemeColors.getHoverColor()
                      //   )
                      // ),
                      child: quill.QuillEditor.basic(
                        controller: _controller,
                        readOnly: false, // true for view only mode
                      ),
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
}

class ArticlesTable extends StatelessWidget {
  const ArticlesTable({Key? key}) : super(key: key);

  static const List<Widget> list = [
    Text("ABC"),
    Text("ABC"),
    Text("ABC"),
    Text("ABC"),
    Text("ABC"),
    Text("ABC"),
    Text("ABC"),
    Text("ABC"),
    Text("ABC"),
    Text("ABC"),
    Text("ABC"),
    Text("ABC"),
    Text("ABC"),
    Text("ABC"),
    Text("ABC"),
    Text("ABC"),
    Text("ABC"),
    Text("ABC"),
    Text("ABC"),
    Text("ABC"),
    Text("ABC"),
    Text("ABC"),
    Text("ABC"),
    Text("ABC"),
    Text("ABC"),
    Text("ABC"),
    Text("ABC"),
    Text("ABC"),
    Text("ABC"),
    Text("ABC"),
    Text("ABC"),
    Text("ABC"),
    Text("ABC"),
    Text("ABC"),
    Text("ABC"),
    Text("ABC"),
    Text("ABC"),
    Text("ABC"),
    Text("ABC"),
    Text("ABC"),
  ];
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: Column(
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.7,
                child: SingleChildScrollView(
                  controller: ScrollController(),
                  child: Center(
                    child: PaginatedDataTable(
                      columns: const [
                        DataColumn(label: Text("ARTICLE TOPIC")),
                        DataColumn(label: Text("AUTHOR")),
                        DataColumn(label: Text("CATEGORY")),
                        DataColumn(label: Text("COMMENTS")),
                      ],
                      source: CustomDataTableSource("eternal_kbs"),
                    ),
                  ),
                ),
              ),
            ],
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
    return Column(
      children: [Expanded(
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
              child: CategoryFormWidget(),
            )
          ],
        ),
      )],
    );
  }
}

class CategoryFormWidget extends StatelessWidget {
  CategoryFormWidget({Key? key}) : super(key: key);
  final _formKey = GlobalKey<FormState>();

  final _categoryController = TextEditingController();
  final _descriptionController = TextEditingController();

  final DashboardController _dashboardController =
  Get.find<DashboardController>();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        color: Colors.white,
        width: context.width > 600 ? context.width * 0.5 : context.width * 0.7,
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
                    Row(
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
                                _dashboardController
                                    .addArticleCategory({ 'category-name': _categoryController.text, 'description': _descriptionController.text,
                                });
                              }
                            },
                          ),
                        ),
                      ],
                    )
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

  RxString selectedValue = 'A'.obs;
  final DashboardController _dashboardController =
  Get.find<DashboardController>();

  @override
  Widget build(BuildContext context) {
    // List<Widget> list = [
    //   DropdownButton(
    //     value: selectedValue.value,
    //     items: ['A', 'B'].map((String item){
    //       return DropdownMenuItem(
    //         value: item,
    //         child: Text(item, style: context.textTheme.bodyText1),
    //       );
    //     }).toList(),
    //     onChanged: (String? newValue){
    //       selectedValue.value = newValue!;
    //     },
    //     isExpanded: true,
    //   )
    // ];
    if (context.width > 600){

    }
    return Column(
      children: [
        Text("CATEGORIES", style: context.textTheme.bodyText1,),
        Expanded(
          child: Obx( ()=> ListView.builder(
              controller: ScrollController(),
              itemCount: _dashboardController.categoryList.length,
              itemBuilder: (context, index){
                return ListTile(
                  title: Text(_dashboardController.categoryList[index].name, style: context.textTheme.bodyText1,),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}