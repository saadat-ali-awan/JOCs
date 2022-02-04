import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jocs/Dashboard/Controllers/dashboard_controller.dart';
import 'package:jocs/Dashboard/Screens/tickets_screen.dart';
import 'package:jocs/FirebaseCustomControllers/DataModels/detailed_metadata.dart';
import 'package:jocs/FirebaseCustomControllers/FirebaseInterface/firebase_controller_interface.dart';

class ScreenAdapter {
  RxInt currentPage = 1.obs;
  int currentPaginatedPage = 1;
  //RxInt lastId = 0.obs;
  int articlesOnOnePage = 10;
  RxList adapterData = RxList();
  String screenName = "";

  late Rx<CustomDataTableSource> dataTableSource;



  ScreenAdapter(this.screenName) {
    dataTableSource = CustomDataTableSource(screenName, RxList()).obs;
  }

  getScreenData(FirebaseControllerInterface firebaseController, {String filter = "", Map<String, String> customFilter = const <String, String>{}, bool nextPage = false}) async {
    DashboardController _dashboardController = Get.find<DashboardController>();
    if (customFilter.isNotEmpty && !nextPage){
      currentPage.value = 1;
      currentPaginatedPage = 1;
      //lastId.value = 0;
      adapterData.clear();
    }
    print("Check Codition ${adapterData.length < (10 * currentPage.value)}");
    if (adapterData.length < (10 * currentPage.value)) {
      var data = await firebaseController.getData(
          screenName, currentPage.value, articlesOnOnePage,
          filter: filter, customFilter: customFilter);
      if (data.length == 0) {
        currentPage -= 1;
      } else {
        data.forEach((res) {
          //adapterData[currentPage.value-1].add(res);
          print(res.data());
          bool valueNotPresent = true;

          for (var d in adapterData){
            if (d["time"] == res["time"]){
              valueNotPresent = false;
            }
          }
          if (valueNotPresent) {
            adapterData.add(res);
          }
        });
      }
    }

    RxList<DataRow> tempRows = <DataRow>[].obs;

    String metadataKey = "";
    int metadataValue = 0;

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
        metadataKey = "inventoryCount";
        metadataValue = _dashboardController.metadata.value.inventoryCount;
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
          metadataKey = "purchaseCount";
          metadataValue = _dashboardController.metadata.value.purchaseCount;
        }else {
          print("Screen Name: ${screenName}");
          if (screenName == "articles") {
            tempData = [
              d['author'],
              d['category-name'],
              d['comment'],
              d['topic']
            ];
            metadataKey = "articlesCount";
            metadataValue = _dashboardController.metadata.value.articlesCount;
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
      int index = tempRows.length;
      tempRows.add(createRow(tempData, (){
        adapterData.removeAt(index);
        dataTableSource.value.data.removeAt(index);
        dataTableSource.value.data.refresh();
        dataTableSource.value.notifyListeners();
        firebaseController.removeDataFromTable(screenName, d["time"], {metadataKey: metadataValue - 1});
        if (screenName == "articles") {
          firebaseController.removeArticleFromCategory(d["category-name"], d.reference);
        }
      }, false
      )
      );
    }

    //print("DataTable Source Before: ${dataTableSource.value.data.value.first.cells.length}");
    dataTableSource.value = CustomDataTableSource(screenName, tempRows);
    //print("DataTable Source After: ${dataTableSource.value.data.value.first.cells.length}");
    //dataTableSource.refresh();
    //print("DataTable Source Refresh: ${dataTableSource.value.data.value.first.cells.length}");
    // if (filter == ""){
    //   getNextPage(firebaseController);
    // }
  }

  getNextPage(firebaseController, Map<String , String> customFilter) {
    currentPage.value += 1;
    getScreenData(firebaseController,
        filter: adapterData[adapterData.length-1]["time"], customFilter: customFilter, nextPage: true);
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
    //lastId.value = await firebaseController.getLastId(screenName);
    getScreenData(firebaseController);
  }

  static DataRow createRow(data, Function() remove, bool empty) {
    List<DataCell> cellList = <DataCell>[];
    for (var i=0; i<data.length; i++){
      cellList.add(
        DataCell(
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Text(data[i], style: Get.textTheme.bodyText2,),
            ),
          ),
        ),
      );
    }
    cellList.add(
      DataCell(
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: InkWell(
              child: empty ? Container() : Icon(
                Icons.clear,
                color: Get.theme.errorColor,
              ),
              onTap: remove,
            ),
          ),
        )
      )
    );
    return DataRow(cells: cellList);
  }



}
