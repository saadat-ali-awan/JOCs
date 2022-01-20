import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jocs/Dashboard/Controllers/dashboard_controller.dart';

class EternalKbsScreen extends StatelessWidget {
  EternalKbsScreen({Key? key}) : super(key: key);

  final DashboardController _dashboardController =
  Get.find<DashboardController>();

  RxInt sub_category = 1.obs;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: SingleChildScrollView(
        controller: ScrollController(),
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Row(
                children: [
                  Obx((){
                    if (sub_category.value == 2){
                      return Expanded(child: ArticleWriter());
                    }
                    if (sub_category.value == 3){
                      return Expanded(child: Container(color: Colors.red, child: Center(child: Text("Article"),),));
                    }
                    return Expanded(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        controller: ScrollController(),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Obx(
                                        () => Theme(
                                      data: Get.theme.copyWith(
                                          textTheme: TextTheme(
                                              caption: TextStyle(
                                                  color: Get.theme.appBarTheme
                                                      .backgroundColor))),
                                      child: PaginatedDataTable(
                                        columns: const [
                                          DataColumn(label: Text("ARTICLE TOPIC")),
                                          DataColumn(label: Text("AUTHOR")),
                                          DataColumn(label: Text("CATEGORY")),
                                          DataColumn(label: Text("COMMENTS")),
                                          DataColumn(label: Text("ASSIGNED TO")),
                                          DataColumn(label: Text("COMMENTS")),
                                        ],
                                        source: _dashboardController
                                            .inventoryAdapter.value.dataTableSource.value,
                                        arrowHeadColor:
                                        Get.theme.appBarTheme.backgroundColor,
                                        onPageChanged: (int? index) {
                                          if (index != null) {
                                            if (((index+1)/10).ceil() > _dashboardController.inventoryAdapter.value
                                                .currentPaginatedPage){
                                              _dashboardController.inventoryAdapter.value
                                                  .getNextPage(_dashboardController
                                                  .firebaseController);
                                            }
                                            _dashboardController.inventoryAdapter.value
                                                .currentPaginatedPage = ((index+1)/10).ceil();

                                          }

                                        },
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    );}
                  ),
                ],
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
        ),
      ),
    );
  }
}

class ArticleWriter extends StatefulWidget {
  const ArticleWriter({Key? key}) : super(key: key);

  @override
  _ArticleWriterState createState() => _ArticleWriterState();
}

class _ArticleWriterState extends State<ArticleWriter> {
  @override
  Widget build(BuildContext context) {
    return Container(color: Colors.red, child: Center(child: Text("Category"),),);
  }
}

