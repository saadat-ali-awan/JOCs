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
    return Container(
      child: Column(
        children: [
          Obx((){
            if (sub_category.value == 2){
              return Expanded(child: ArticleWriter());
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
                                  DataColumn(label: Text("Issued By")),
                                  DataColumn(label: Text("Topic")),
                                  DataColumn(label: Text("Status")),
                                  DataColumn(label: Text("Priority")),
                                  DataColumn(label: Text("Assigned To")),
                                  DataColumn(label: Text("Comments")),
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
          Align(
            alignment: Alignment.centerLeft,
            child: DecoratedBox(
              decoration: BoxDecoration(
                  color:Get.theme.canvasColor, //background color of  //border of dropdown button
                  borderRadius: const BorderRadius.all(Radius.circular(12)), //border raiuds of dropdown button
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                child: DropdownButton(
                  iconEnabledColor: Get.theme.appBarTheme.foregroundColor,
                  style: Get.textTheme.bodyText1,
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
                    }
                  },
                  isExpanded: false,
                  underline: Container(),

                ),
              ),
            ),
          )
        ],
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
    return Container( color: Colors.green,);
  }
}

