import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jocs/Dashboard/Screens/tickets_screen.dart';

class ScreenAdapter {
  RxInt currentPage = 1.obs;
  int currentPaginatedPage = 1;
  RxInt lastId = 0.obs;
  int articlesOnOnePage = 10;
  RxList adapterData = RxList();
  String screenName = "";

  late Rx<CustomDataTableSource> dataTableSource;

  ScreenAdapter(this.screenName) {
    dataTableSource = CustomDataTableSource(screenName).obs;
  }

  getScreenData(firebaseController, {String filter = ""}) async {
    if (adapterData.length < (10 * currentPage.value)) {
      var data = await firebaseController.getData(
          screenName, currentPage.value, articlesOnOnePage,
          filter: filter);
      if (data.length == 0) {
        currentPage -= 1;
      } else {
        data.forEach((res) {
          //adapterData[currentPage.value-1].add(res);
          bool valueNotPresent = true;

          for (var d in adapterData){
            if (d["id"] == res["id"]){
              valueNotPresent = false;
            }
          }
          if (valueNotPresent) {
            adapterData.add(res);
          }
        });
      }
    }

    List<DataRow> tempRows = <DataRow>[];


    for (var d in adapterData) {
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
      }else {
        if (screenName == "purchase"){
          tempData = [
            d["order_no"],
            d["order_name"],
            d["description"],
            d["expected_delivery"],
            d["status"],
            d["comments"]
          ];
        }else {
          tempData = [
            d["issued_by"],
            d["topic"],
            d["status"],
            d["priority"],
            d["assigned_to"],
          ];
          if (screenName == "tickets") {
            tempData.add(d["comments"]);
          } else {
            if (screenName == "problems") {
              tempData.add(d["department"]);
            }
          }
        }
      }
      tempRows.add(createRow(tempData));
    }

    dataTableSource.value = CustomDataTableSource(screenName, tempRows);
    // if (filter == ""){
    //   getNextPage(firebaseController);
    // }
  }

  getNextPage(firebaseController) {
    currentPage.value += 1;
    getScreenData(firebaseController,
        filter: adapterData[adapterData.length-1]["time"]);
  }

  getPreviousPage(firebaseController) {
    currentPage.value -= 1;
    if (currentPage.value < 1) {
      currentPage.value = 1;
    }
  }

  refreshCurrentPage(firebaseController) async {
    adapterData = RxList();
    currentPage.value = 1;
    lastId.value = await firebaseController.getLastId(screenName);
    getScreenData(firebaseController);
  }

  DataRow createRow(data) {
    return DataRow(cells: [
      DataCell(
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: Text(data[0]),
          ),
        ),
      ),
      DataCell(
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: Text(data[1]),
          ),
        ),
      ),
      DataCell(
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: Text(data[2]),
          ),
        ),
      ),
      DataCell(
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: Text(data[3]),
          ),
        ),
      ),
      DataCell(
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: Text(data[4]),
          ),
        ),
      ),
      DataCell(
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: Text(data[5]),
          ),
        ),
      ),
    ]);
  }
}
