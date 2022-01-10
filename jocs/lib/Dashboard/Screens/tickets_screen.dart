import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:jocs/Dashboard/Controllers/dashboard_controller.dart';

class TicketsScreen extends StatelessWidget {
  TicketsScreen({Key? key}) : super(key: key);

  final DashboardController _dashboardController =
      Get.find<DashboardController>();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              child: LayoutBuilder(builder: (context, constraints) {
                return Column(
                  children: [
                    Container(
                      child: SingleChildScrollView(
                        controller: ScrollController(),
                        scrollDirection: Axis.vertical,
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
                                  .ticketAdapter.value.dataTableSource.value,
                              arrowHeadColor:
                                  Get.theme.appBarTheme.backgroundColor,
                              onPageChanged: (int? index) {
                                if (index != null) {
                                  if (((index+1)/10).ceil() > _dashboardController.ticketAdapter.value
                                      .currentPaginatedPage){
                                    _dashboardController.ticketAdapter.value
                                        .getNextPage(_dashboardController
                                        .firebaseController);
                                  }
                                  _dashboardController.ticketAdapter.value
                                      .currentPaginatedPage = ((index+1)/10).ceil();

                                }

                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              }),
            )
          ],
        )
      ],
    );
  }
}

class CustomDataTableSource extends DataTableSource {
  List<DataRow>? data = <DataRow>[];
  String screenName;

  CustomDataTableSource(this.screenName,[this.data]);

  @override
  DataRow? getRow(int index) {
    final DashboardController _dashboardController =
        Get.find<DashboardController>();
    try {
      // var data = [
      //   _dashboardController.ticketAdapter.value
      //       .adapterData[index]["issued_by"],
      //   _dashboardController.ticketAdapter.value.adapterData[index]["topic"],
      //   _dashboardController.ticketAdapter.value.adapterData[index]["status"],
      //   _dashboardController.ticketAdapter.value.adapterData[index]["priority"],
      //   _dashboardController.ticketAdapter.value
      //       .adapterData[index]["assigned_to"],
      //   _dashboardController.ticketAdapter.value.adapterData[index]["comments"],
      // ];
      return data == null ? null : data![index];
    } on RangeError catch (e) {
      null;
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
      default:
        return 0;
    }

  }

  @override
  int get selectedRowCount => 0;
}

// class TicketsScreen extends StatelessWidget {
//   TicketsScreen({Key? key}) : super(key: key);
//
//   final DashboardController _dashboardController =
//       Get.find<DashboardController>();
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Row(
//           mainAxisAlignment: MainAxisAlignment.start,
//           children: [
//             IconButton(
//               onPressed: () {
//                 _dashboardController.ticketAdapter.value.refreshCurrentPage(
//                     _dashboardController.firebaseController);
//               },
//               icon: const Icon(Icons.refresh),
//               color: Get.theme.appBarTheme.backgroundColor,
//             ),
//           ],
//         ),
//         Obx(
//           () => Expanded(
//             child: SingleChildScrollView(
//               controller: ScrollController(),
//               scrollDirection: Axis.horizontal,
//               child: SingleChildScrollView(
//                 controller: ScrollController(),
//             scrollDirection: Axis.vertical,
//             child: DataTable(
//               columns: const [
//                 DataColumn(label: Text("Issued By")),
//                 DataColumn(label: VerticalDivider(color: Colors.black, width: 1.0)),
//                 DataColumn(label: Text("Topic")),
//                 DataColumn(label: VerticalDivider(color: Colors.black, width: 1.0)),
//                 DataColumn(label: Text("Status")),
//                 DataColumn(label: VerticalDivider(color: Colors.black, width: 1.0)),
//                 DataColumn(label: Text("Priority")),
//                 DataColumn(label: VerticalDivider(color: Colors.black, width: 1.0)),
//                 DataColumn(label: Text("Assigned To")),
//                 DataColumn(label: VerticalDivider(color: Colors.black, width: 1.0)),
//                 DataColumn(label: Text("Comments")),
//               ],
//               rows: getRows(),
//             ),
//               ),
//             ),
//           ),
//         ),
//         Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: Row(
//             children: [
//               Obx(() {
//                 return IconButton(
//                     onPressed: _dashboardController
//                                 .ticketAdapter.value.currentPage.value <=
//                             1
//                         ? null
//                         : () {
//                             _dashboardController.ticketAdapter.value
//                                 .getPreviousPage(
//                                     _dashboardController.firebaseController);
//                           },
//                     icon: const Icon(
//                       Icons.arrow_back_ios_outlined,
//                     ),
//                     color: Get.theme.appBarTheme.backgroundColor);
//               }),
//               Obx(() {
//                 return Text(
//                     "${_dashboardController.ticketAdapter.value.currentPage.value} / ${(_dashboardController.ticketAdapter.value.lastId.value / _dashboardController.ticketAdapter.value.articlesOnOnePage).ceil()}");
//               }),
//               Obx(() {
//                 return IconButton(
//                     onPressed: _dashboardController
//                                 .ticketAdapter.value.currentPage.value >=
//                             _dashboardController
//                                     .ticketAdapter.value.lastId.value /
//                                 _dashboardController
//                                     .ticketAdapter.value.articlesOnOnePage
//                         ? null
//                         : () {
//                             _dashboardController.ticketAdapter.value
//                                 .getNextPage(
//                                     _dashboardController.firebaseController);
//                           },
//                     icon: const Icon(
//                       Icons.arrow_forward_ios_outlined,
//                     ),
//                     color: Get.theme.appBarTheme.backgroundColor);
//               })
//             ],
//           ),
//         )
//       ],
//     );
//   }
//
//   List<DataRow> getRows() {
//     List<DataRow> onePageTableRows = [];
//     try {
//       for (var res in _dashboardController.ticketAdapter.value.adapterData[
//           _dashboardController.ticketAdapter.value.currentPage.value - 1]) {
//         onePageTableRows.add(createRow([
//           res.data()["issued_by"],
//           res.data()["topic"],
//           res.data()["status"],
//           res.data()["priority"],
//           res.data()["assigned_to"],
//           res.data()["comments"]
//         ]));
//       }
//     } on RangeError catch (e) {
//       return onePageTableRows;
//     }
//     return onePageTableRows;
//   }
//
//   DataRow createRow(data) {
//     return DataRow(cells: [
//       DataCell(
//         Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: Center(
//             child: Text(data[0]),
//           ),
//         ),
//       ),
//       const DataCell(VerticalDivider(color: Colors.black, width: 1.0)),
//       DataCell(
//         Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: Center(
//             child: Text(data[1]),
//           ),
//         ),
//       ),
//       const DataCell(VerticalDivider(color: Colors.black, width: 1.0)),
//       DataCell(
//         Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: Center(
//             child: Text(data[2]),
//           ),
//         ),
//       ),
//       const DataCell(VerticalDivider(color: Colors.black, width: 1.0)),
//       DataCell(
//         Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: Center(
//             child: Text(data[3]),
//           ),
//         ),
//       ),
//       const DataCell(VerticalDivider(color: Colors.black, width: 1.0)),
//       DataCell(
//         Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: Center(
//             child: Text(data[4]),
//           ),
//         ),
//       ),
//       const DataCell(VerticalDivider(color: Colors.black, width: 1.0)),
//       DataCell(
//         Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: Center(
//             child: Text(data[5]),
//           ),
//         ),
//       ),
//     ]);
//   }
// }
