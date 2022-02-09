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

class CustomDataTableSource extends DataTableSource {
  RxList<DataRow> data = RxList();
  String screenName = "";

  CustomDataTableSource(this.screenName, List<DataRow> list){
    data.value = list;
  }

  @override
  DataRow? getRow(int index) {
    final DashboardController _dashboardController =
        Get.find<DashboardController>();
    try {
      return data[index];
    } on RangeError catch (e) {
      if (screenName == "articles") {
        return ScreenAdapter.createRow(["","","",""], (){},  true, screenName, "");
      }
      return ScreenAdapter.createRow(["","","","","",""], (){}, true, screenName, "");
    }
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount {
    final DashboardController _dashboardController =
        Get.find<DashboardController>();
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

