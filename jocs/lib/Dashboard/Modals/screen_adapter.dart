import 'dart:async';
import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jocs/Dashboard/Dialog/CategoryScreenDialogs/add_article_dialog.dart';
import 'package:jocs/Dashboard/Dialog/custom_dialog.dart';
import 'package:jocs/Dashboard/Screens/tickets_screen.dart';
import 'package:jocs/FirebaseCustomControllers/FirebaseInterface/firebase_controller_interface.dart';


/// **Screen Adapter is a Common Adapter for Tickets, Problems, Inventory,**
/// **Purchase and Articles Tables.**
class ScreenAdapter {
  /// Current Page of the table according to the Database
  /// It is different from [currentPaginatedPage] because it only deals with
  /// getting data from the database.
  RxInt currentPage = 1.obs;

  /// Current Paginated Page is the Page A [PaginatedDataTable] is currently showing.
  int currentPaginatedPage = 1;

  /// Number of Values to Get from Firebase Database at one time
  int articlesOnOnePage = 10;

  /// Screen Name of the Current Screen That is being Displayed
  /// This [screenName] is used to specify the Screen for which adapter has
  /// been deployed.
  String screenName = "";

  /// ## [mapList] is the list of Maps
  /// For Each Page of the table the Firebase Controller will have a Stream.
  /// The return Value of each Stream is a Map of all the values the Stream is
  /// listening to. All these values of the Maps will be stored in a single
  /// list [mapList] to deal with them as one complete Data.
  List<Map<String, dynamic>> mapList = <Map<String, dynamic>>[];

  //RxMap<String, dynamic> rowMap = <String, dynamic>{}.obs;
  SplayTreeMap rowMapSorted = SplayTreeMap((a, b) => b.compareTo(a));

  String latestTimeStamp = "";

  /// [dataTableSource] is the [CustomDataTableSource] of the Screen referred by
  /// the ScreenName. This would be used to populate the table with the values
  /// from the FirebaseDatabase
  late Rx<CustomDataTableSource> dataTableSource;

  /// [lastTime] is used to get the last Item that was returned from Firebase
  /// Database. This is used to get the old items from the database.
  String lastTime = '';

  /// All The Streams that were used to populate [mapList] are stored in
  /// [tableSourceStreams].
  ///
  /// For Each Page of the table the Firebase Controller will have a Stream.
  /// The return Value of each Stream is a Map of all the values the Stream is
  /// listening to. This Stream is stored in [tableSourceStream] which makes it
  /// easy to remove the streams when it is not required.
  List<StreamSubscription> tableSourceStreams = <StreamSubscription>[];

  ScreenAdapter(this.screenName) {
    dataTableSource = CustomDataTableSource(screenName).obs;
  }

  Future<void> getLatestTimeStamp( FirebaseControllerInterface firebaseController ) async {
    latestTimeStamp = await firebaseController.getLatestTimeStamp(screenName);
  }

  /// ## Get Data For the Screen and save it in a [mapList].
  ///
  /// This functions calls getData function on firebaseController to get the
  /// required page data from the database.
  /// The firebase.getData returns a Stream of the items whose time is less than
  /// the filter. This stream is stored in [tableSourceStream] and the data is
  /// saved in [mapList] on the index equal to the index of respective stream
  /// in the list.
  ///
  /// Finally the [dataTableSource] is notified about the changes in the mapList.
  ///
  /// 1. [firebaseController] is reference to the FirebaseController that is used
  /// to get data from Firebase Database.
  /// 2. [filter] is an optional parameter used to Provide the time(which is
  /// identifier of the elements) so that if there was some data already fetched
  /// we can fetched the older data. It helps in pagination.
  /// 3. [customFilter] is the filter that a user can customise. It is present
  /// in Tickets Screen and problems Screen Named as Status and Priority.
  /// 4. [nextPage] specifies if a user is demanding Next Page or Not.
  getDataForScreen(FirebaseControllerInterface firebaseController
      , {String filter = ""
        , Map<String
        , String> customFilter = const <String, String>{}
        , bool nextPage = false}
        ) {
    if (customFilter.isNotEmpty && !nextPage){
      currentPage.value = 1;
      currentPaginatedPage = 1;
      mapList.clear();
    }

    if (mapList.length < (10 * currentPage.value)) {
      var dataStream = firebaseController.getData(
          screenName, currentPage.value, articlesOnOnePage,
          filter: filter, customFilter: customFilter);

      int streamIndex = tableSourceStreams.length;

      tableSourceStreams.add(
        dataStream.map((snapshot) {
          List notCheckedKeys = [];
          bool reVisit = false;
          if (mapList.length > streamIndex) {
            notCheckedKeys = mapList[streamIndex].keys.toList();
            reVisit = true;
          }
          if (defaultTargetPlatform == TargetPlatform.windows && !kIsWeb){
            for (var document in snapshot) {
              if (!notCheckedKeys.contains(document["time"]) && reVisit) {
                continue;
              }
              if (mapList.length > streamIndex) {
                mapList[streamIndex][document["time"]] = document;
              } else {
                mapList.add({document["time"]: document});
              }

              rowMapSorted[int.parse(document["time"])] = document;

              notCheckedKeys.removeWhere((key) => key == document["time"]);
            }
          } else {
            for (var document in snapshot.docs) {
              if (!notCheckedKeys.contains(document["time"]) && reVisit) {
                continue;
              }
              if (mapList.length > streamIndex) {
                mapList[streamIndex][document["time"]] = document;
              } else {
                mapList.add({document["time"]: document});
              }

              rowMapSorted[int.parse(document["time"])] = document;

              notCheckedKeys.removeWhere((key) => key == document["time"]);
            }
          }

          for (String key in notCheckedKeys) {
            mapList[streamIndex].remove(key);
            rowMapSorted.remove(int.parse(key));
          }

          if (defaultTargetPlatform == TargetPlatform.windows && !kIsWeb) {
            if (snapshot.isNotEmpty) {
              lastTime = snapshot.last["time"];
            }
          } else {
            if (snapshot.docs.isNotEmpty) {
              lastTime = snapshot.docs.last["time"];
            }
          }

          dataTableSource.value.notifyListeners();
        }).listen((event) { })
      );
    }
  }

  getNewDataForScreen(FirebaseControllerInterface firebaseController
      , String time ) {
    if (time.isNotEmpty) {
      var streamForNewData = firebaseController.getNewData(time, screenName);
      int streamIndex = tableSourceStreams.length;

      tableSourceStreams.add(
          streamForNewData.map((snapshot) {
            List notCheckedKeys = [];
            bool reVisit = false;
            if (mapList.length > streamIndex) {
              notCheckedKeys = mapList[streamIndex].keys.toList();
              reVisit = true;
            }

            if (defaultTargetPlatform == TargetPlatform.windows && !kIsWeb){
              for (var document in snapshot) {
                if (!notCheckedKeys.contains(document["time"]) && reVisit) {
                  continue;
                }
                if (mapList.length > streamIndex) {
                  mapList[streamIndex][document["time"]] = document;
                } else {
                  mapList.add({document["time"]: document});
                }

                rowMapSorted[int.parse(document["time"])] = document;

                notCheckedKeys.removeWhere((key) => key == document["time"]);
              }
            } else {
              for (var document in snapshot.docs) {
                if (!notCheckedKeys.contains(document["time"]) && reVisit) {
                  continue;
                }
                if (mapList.length > streamIndex) {
                  mapList[streamIndex][document["time"]] = document;
                } else {
                  mapList.add({document["time"]: document});
                }

                rowMapSorted[int.parse(document["time"])] = document;

                notCheckedKeys.removeWhere((key) => key == document["time"]);
              }
            }

            for (String key in notCheckedKeys) {
              mapList[streamIndex].remove(key);
              rowMapSorted.remove(int.parse(key));
            }

            if (defaultTargetPlatform == TargetPlatform.windows && !kIsWeb) {
              if (snapshot.isNotEmpty) {
                lastTime = snapshot.last["time"];
              }
            } else {
              if (snapshot.docs.isNotEmpty) {
                lastTime = snapshot.docs.last["time"];
              }
            }

            dataTableSource.value.notifyListeners();
          }).listen((event) { })
      );
    }
  }

  /// Get The Next Paginated Page From The Database
  ///
  /// It increments [currentPage] value by one an calls [getDataForScreen]
  /// passing appropriate Parameters.
  ///
  /// 1. [firebaseController] is reference to the FirebaseController that is used
  /// to get data from Firebase Database.
  /// 2. [customFilter] is the filter that a user can customise. It is present
  /// in Tickets Screen and problems Screen Named as Status and Priority.
  getNextPage(firebaseController, Map<String , String> customFilter) {
    currentPage.value += 1;
    getDataForScreen(firebaseController,
        filter: lastTime, customFilter: customFilter, nextPage: true);
  }

  /// Get Previous Page Just decrements the value of current page by one which
  /// Notifies the PaginatedDataTable to go to the Previous Screen.
  getPreviousPage(firebaseController) {
    currentPage.value -= 1;
    if (currentPage.value < 1) {
      currentPage.value = 1;
    }
  }

  /// Using the Data Provided Create a Data Row That can be inserted in the
  /// [PaginatedDataTable]
  ///
  /// 1. [data] is the array of items that should be shown in a row.
  /// 2. [remove] is the function that would be called when remove button is
  /// pressed.
  /// 3. [empty] is used to notfy if empty row was required.
  /// 4. [screenName] tells the name of Screen for which DataRow is need to be
  /// developed.
  /// 5. [time] is the identifier for the data inside the DataRow that would be used
  /// to update and delete the data.
  static DataRow createRow(data, Function() remove, bool empty, String screenName, String time) {
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
          onTap: () {
            if (screenName == 'articles') {
              Get.toNamed('/articleReader', arguments: {'time': time});
            }
          }
        ),
      );
    }
    cellList.add(
      DataCell(
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              InkWell(
                child: Tooltip(
                  message: "Add Review",
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(Icons.rate_review, color: Get.theme.appBarTheme.backgroundColor,),
                  ),
                ),
                onTap: () {
                  Get.toNamed('/review', arguments: {'data': data, 'time': time, 'screenName': screenName});
                },
              ),
              InkWell(
                child: Tooltip(
                  message: "Edit",
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(Icons.edit, color: Get.theme.appBarTheme.backgroundColor,),
                  ),
                ),
                onTap: () {
                  Get.dialog(
                    updateDataDialog(data, screenName, time),
                  );
                },
              ),
              Center(
                child: InkWell(
                  child: empty ? Container() : Icon(
                    Icons.clear,
                    color: Get.theme.errorColor,
                  ),
                  onTap: remove,
                ),
              ),
            ],
          ),
        )
      )
    );
    return DataRow(cells: cellList);
  }

  /// Show The [CustomDialog] or [AddArticleDialog] to update the values
  /// when edit Button is pressed.
  static Widget updateDataDialog(data,String screenName, String time) {
    if (screenName == 'articles') {
      return AddArticleDialog(previousData: data.cast<String>(), time: time);
    }
    return CustomDialog(previousData: data.cast<String>(), time: time);
  }



}
