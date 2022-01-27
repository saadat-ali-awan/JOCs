import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:jocs/Dashboard/Controllers/dashboard_controller.dart';
import 'package:jocs/Dashboard/Modals/screen_adapter.dart';

class TicketsScreen extends StatelessWidget {
  TicketsScreen({Key? key}) : super(key: key);

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
                child: Obx(
                      () => Theme(
                    data: Get.theme.copyWith(
                        textTheme: TextTheme(
                            caption: TextStyle(
                                color: Get.theme.appBarTheme
                                    .backgroundColor))),
                    child: PaginatedDataTable(
                      columns: [
                        const DataColumn(label: Text("Issued By")),
                        const DataColumn(label: Text("Topic")),
                        DataColumn(
                          label: DecoratedBox(
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
                                  value: "Status",
                                  items: <String>["Status", "OPEN", "PENDING", "RESOLVED", "CLOSED"].map((value){
                                    return DropdownMenuItem(
                                      child: Text(value, textAlign: TextAlign.right,),
                                      value: value,
                                    );
                                  }).toList(),
                                  onChanged: (String? newValue){
                                    if (newValue != null){
                                      customFilter["status"] = newValue;
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
                              borderRadius: const BorderRadius.all(Radius.circular(12)), //border raiuds of dropdown button
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                              child: Theme(
                                data: context.theme.copyWith(canvasColor: context.theme.appBarTheme.backgroundColor),
                                child: DropdownButton(
                                  iconEnabledColor: context.theme.appBarTheme.foregroundColor,
                                  style: context.textTheme.bodyText1,
                                  value: "Priority",
                                  items: <String>["Priority", "LOW", "MEDIUM", "HIGH", "URGENT"].map((value){
                                    return DropdownMenuItem(
                                      child: Text(value, textAlign: TextAlign.right,),
                                      value: value,
                                    );
                                  }).toList(),
                                  onChanged: (String? newValue){
                                    if (newValue != null){
                                      customFilter["priority"] = newValue;
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
                        const DataColumn(label: Text("Assigned To")),
                        const DataColumn(label: Text("Comments")),
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
                    ),
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
  List<DataRow>? data = <DataRow>[];
  String screenName;

  CustomDataTableSource(this.screenName,[this.data]){
    print(this.screenName);
  }

  @override
  DataRow? getRow(int index) {
    final DashboardController _dashboardController =
        Get.find<DashboardController>();
    try {
      return data == null ? null : data![index];
    } on RangeError catch (e) {
      return ScreenAdapter.createRow(["","","","","",""]);
    }
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount {
    final DashboardController _dashboardController =
        Get.find<DashboardController>();
    switch (screenName){
      case "tickets":
        return _dashboardController.ticketAdapter.value.lastId.value - 1;
      case "problems":
        return _dashboardController.problemAdapter.value.lastId.value - 1;
      case "inventory":
        return _dashboardController.inventoryAdapter.value.lastId.value - 1;
      case "purchase":
        return _dashboardController.purchaseAdapter.value.lastId.value;
      default:
        return 0;
    }

  }

  @override
  int get selectedRowCount => 0;
}

