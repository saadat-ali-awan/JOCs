import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:jocs/Dashboard/Controllers/dashboard_controller.dart';
import 'package:jocs/Dashboard/Modals/screen_adapter.dart';

class TicketsScreen extends StatefulWidget {
  TicketsScreen({Key? key}) : super(key: key);

  @override
  State<TicketsScreen> createState() => _TicketsScreenState();
}

class _TicketsScreenState extends State<TicketsScreen> {
  final DashboardController _dashboardController =
      Get.find<DashboardController>();

  Map<String,  String> customFilter = <String, String>{};

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: ScrollController(),
      scrollDirection: Axis.vertical,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                child: Theme(
                    data: Get.theme.copyWith(
                        textTheme: TextTheme(
                            caption: TextStyle(
                                color: Get.theme.appBarTheme
                                    .backgroundColor))),
                    child: Obx(() {
                      return PaginatedDataTable(
                        columns: [
                          //const DataColumn(label: Expanded(child: Text("", textAlign: TextAlign.center,))),
                          const DataColumn(label: Expanded(child: Text("Issued By", textAlign: TextAlign.center,))),
                          const DataColumn(label: Expanded(child: Text("Topic", textAlign: TextAlign.center,))),
                          DataColumn(
                            label: DecoratedBox(
                              decoration: BoxDecoration(
                                color: context.theme.appBarTheme.backgroundColor, //background color of  //border of dropdown button
                                borderRadius: const BorderRadius.all(Radius.circular(12)), //border radius of dropdown button
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                                child: Theme(
                                  data: context.theme.copyWith(canvasColor: context.theme.appBarTheme.backgroundColor),
                                  child: DropdownButton(
                                    iconEnabledColor: context.theme.appBarTheme.foregroundColor,
                                    style: context.textTheme.bodyText1,
                                    value: customFilter["status"] == null || customFilter["status"] == "" ? "Status" : customFilter["status"],
                                    items: <String>["Status", "OPEN", "PENDING", "RESOLVED", "CLOSED"].map((value){
                                      return DropdownMenuItem(
                                        child: Row(
                                          children: [
                                            if (customFilter["status"] != null && customFilter["status"] == value) InkWell(
                                              child: const Icon(
                                                  Icons.remove_circle
                                              ),
                                              onTap: (){
                                                setState(() {
                                                  customFilter.remove("status");
                                                });
                                                customFilter["P"] = "R";
                                                _dashboardController.getTicketsData(customFilter: customFilter);
                                                customFilter.remove("P");
                                              },
                                            ) else Container(),
                                            Text(value, textAlign: TextAlign.right,),
                                          ],
                                        ),
                                        value: value,
                                      );
                                    }).toList(),
                                    onChanged: (String? newValue){
                                      print("CHANGED ${newValue}");
                                      if (newValue != null){
                                        if (newValue == "Status"){
                                          return;
                                        }
                                        setState(() {
                                          customFilter["status"] = newValue;
                                        });
                                        _dashboardController.getTicketsData(customFilter:customFilter);
                                      }
                                    },
                                    isExpanded: false,
                                    underline: Container(),

                                  ),
                                ),
                              ),
                            ),
                          ),
                          DataColumn(
                            label: DecoratedBox(
                              decoration: BoxDecoration(
                                color: context.theme.appBarTheme.backgroundColor, //background color of  //border of dropdown button
                                borderRadius: const BorderRadius.all(Radius.circular(12)), //border radius of dropdown button
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                                child: Theme(
                                  data: context.theme.copyWith(canvasColor: context.theme.appBarTheme.backgroundColor),
                                  child: DropdownButton(
                                    iconEnabledColor: context.theme.appBarTheme.foregroundColor,
                                    style: context.textTheme.bodyText1,
                                    value: customFilter["priority"] == null || customFilter["priority"] == "" ? "Priority" : customFilter["priority"],
                                    items: <String>["Priority", "LOW", "MEDIUM", "HIGH", "URGENT"].map((value){
                                      return DropdownMenuItem(
                                        child: Row(
                                          children: [
                                            if (customFilter["priority"] != null && customFilter["priority"] == value) InkWell(
                                              child: const Icon(
                                                  Icons.remove_circle
                                              ),
                                              onTap: (){
                                                setState(() {
                                                  customFilter.remove("priority");
                                                });
                                                customFilter["P"] = "R";
                                                _dashboardController.getTicketsData(customFilter: customFilter);
                                                customFilter.remove("P");
                                              },
                                            ) else Container(),
                                            Text(value, textAlign: TextAlign.right,),
                                          ],
                                        ),
                                        value: value,
                                      );
                                    }).toList(),
                                    onChanged: (String? newValue){
                                      if (newValue != null){
                                        if (newValue == "Priority"){
                                          return;
                                        }
                                        setState(() {
                                          customFilter["priority"] = newValue;
                                        });
                                        _dashboardController.getTicketsData(customFilter:customFilter);
                                      }
                                    },
                                    isExpanded: false,
                                    underline: Container(),

                                  ),
                                ),
                              ),
                            ),
                          ),
                          const DataColumn(label: Expanded(child: Text("Assigned To", textAlign: TextAlign.center,))),
                          const DataColumn(label: Expanded(child: Text("Comments", textAlign: TextAlign.center,))),
                          const DataColumn(label: Expanded(child: Text("", textAlign: TextAlign.center,))),
                        ],
                        source: _dashboardController
                            .ticketAdapter.value.dataTableSource.value,
                        arrowHeadColor:
                        Get.theme.appBarTheme.backgroundColor,
                        onPageChanged: (int? index) {
                          if (index != null) {
                            if (((index+1)/10).ceil() > _dashboardController.ticketAdapter.value
                                .currentPaginatedPage){
                              _dashboardController.ticketAdapter.value
                                  .getNextPage(_dashboardController
                                  .firebaseController, customFilter);
                            }
                            _dashboardController.ticketAdapter.value
                                .currentPaginatedPage = ((index+1)/10).ceil();

                          }

                        },
                      );
                    }
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}

/// The [DataTableSource] for all the Tables in the Application is implemented
/// using [CustomDataTableSource].
class CustomDataTableSource extends DataTableSource {
  /// Screen Name of the Screen that requires data for the table
  String screenName = "";

  CustomDataTableSource(this.screenName);

  final DashboardController _dashboardController =
  Get.find<DashboardController>();

  @override
  DataRow? getRow(int index) {
    print('getRow($index)');
    int currentIndex = 0;

    DataRow row = DataRow(
      cells: [
        DataCell(Container()),
        DataCell(Container()),
        DataCell(Container()),
        DataCell(Container()),
        DataCell(Container()),
        DataCell(Container()),
        DataCell(Container()),
      ]
    );

    if (screenName == "articles") {
      row = DataRow(
          cells: [
            DataCell(Container()),
            DataCell(Container()),
            DataCell(Container()),
            DataCell(Container()),
            DataCell(Container()),
          ]
      );
    }

    switch (screenName) {
      case 'tickets':
        _dashboardController.ticketAdapter.value.rowMapSorted.forEach((key, data) {
          if (currentIndex == index) {
            row = getRowFromData(data);
          }
          currentIndex += 1;
        });
        break;
      case 'inventory':
        _dashboardController.inventoryAdapter.value.rowMapSorted.forEach((key, data) {
          if (currentIndex == index) {
            row = getRowFromData(data);
          }
          currentIndex += 1;
        });
        break;
      case 'purchase':
        _dashboardController.purchaseAdapter.value.rowMapSorted.forEach((key, data) {
          if (currentIndex == index) {
            row = getRowFromData(data);
          }
          currentIndex += 1;
        });
        break;
      case 'problems':
        _dashboardController.problemAdapter.value.rowMapSorted.forEach((key, data) {
          if (currentIndex == index) {
            row = getRowFromData(data);
          }
          currentIndex += 1;
        });
        break;
      case 'articles':
        _dashboardController.kbsAdapter.value.rowMapSorted.forEach((key, data) {
          if (currentIndex == index) {
            row = getRowFromData(data);
          }
          currentIndex += 1;
        });
        break;
    }



    return row;
  }

  /// [getRowFromData] creates the row from the Data provided as the array
  DataRow getRowFromData(d) {
    final DashboardController _dashboardController =
    Get.find<DashboardController>();

    /// [metadataKey] is the key used to update the total number of records of
    /// [screenName] in the firebase database.
    String metadataKey = "";

    /// [metadataValue] is the key used to update the total number of records of
    /// [screenName] in the firebase database.
    int metadataValue = 0;
    var tempData;
    if (screenName == "inventory"){
      tempData = [
        d["item_name"],
        d["item_type"],
        d["location"],
        d["used_by"],
        d["processed_by"],
        d["comments"]
      ];
      metadataKey = "inventoryCount";
      metadataValue = _dashboardController.metadata.value.inventoryCount;
    }else {
      if (screenName == "purchase") {
        tempData = [
          d["order_no"],
          d["order_name"],
          d["description"],
          d["expected_delivery"],
          d["status"],
          d["comments"]
        ];
        metadataKey = "purchaseCount";
        metadataValue = _dashboardController.metadata.value.purchaseCount;
      } else {
        print("Screen Name: ${screenName}");
        if (screenName == "articles") {
          tempData = [
            d['topic'],
            d['author'],
            d['category-name'],
            d['comment'],
          ];
          metadataKey = "articlesCount";
          metadataValue = _dashboardController.metadata.value.articlesCount;
        } else {
          tempData = [
            d["issued_by"],
            d["topic"],
            d["status"],
            d["priority"],
            d["assigned_to"],
          ];
          if (screenName == "tickets") {
            tempData.add(d["comments"]);
            metadataKey = "ticketsCount";
            metadataValue = _dashboardController.metadata.value.ticketsCount;
          } else {
            if (screenName == "problems") {
              tempData.add(d["department"]);
              metadataKey = "problemsCount";
              metadataValue = _dashboardController.metadata.value.problemsCount;
            }
          }
        }
      }
    }

    return ScreenAdapter.createRow(tempData, (){
      Get.defaultDialog(
          title: "Caution",
          titleStyle: TextStyle(color: Get.theme.errorColor),
          middleText: "Want to delete the row from Database?",
          confirm: TextButton(
            onPressed: () {
              _dashboardController.firebaseController.removeDataFromTable(screenName, d["time"], {metadataKey: metadataValue - 1});
              if (screenName == "articles") {
                _dashboardController.firebaseController.removeArticleFromCategory(d["category-name"], d.reference);
              }
              Get.back();
            },
            child: Text("DELETE", style: Get.textTheme.bodyText1,),
            style: Get.theme.textButtonTheme.style!.copyWith(backgroundColor: MaterialStateProperty.all(Get.theme.errorColor)),
          ),

          cancel: TextButton(
            onPressed: () {
              Get.back();
            },
            child: Text("Cancel", style: Get.textTheme.bodyText1,),
          ),

          onCancel: () {
            Get.back();
          }
      );
    }, false, screenName, d["time"]
    );
  }

  @override
  bool get isRowCountApproximate => true;

  @override
  int get rowCount {

    print("SCREEN NAME rowCount() => ${screenName} , Row => ${_dashboardController.metadata.value.articlesCount}");
    switch (screenName){
      case "tickets":
        //print("rowCount => ${_dashboardController.ticketAdapter.value.lastId.value - 1} AdapterLength ${data!.value.length}");
        return _dashboardController.metadata.value.ticketsCount;
      case "problems":
        return _dashboardController.metadata.value.problemsCount;
      case "inventory":
        return _dashboardController.metadata.value.inventoryCount;
      case "purchase":
        return _dashboardController.metadata.value.purchaseCount;
      case "articles":
        return _dashboardController.metadata.value.articlesCount;
      default:
        return 0;
    }

  }

  @override
  int get selectedRowCount => 0;
}

