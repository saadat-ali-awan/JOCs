import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jocs/Dashboard/Controllers/dashboard_controller.dart';

class ProblemsScreen extends StatelessWidget {
  ProblemsScreen({Key? key}) : super(key: key);

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
                                DataColumn(label: Text("Department")),
                              ],
                              source: _dashboardController
                                  .problemAdapter.value.dataTableSource.value,
                              arrowHeadColor:
                              Get.theme.appBarTheme.backgroundColor,
                              onPageChanged: (int? index) {
                                if (index != null) {
                                  if (((index+1)/10).ceil() > _dashboardController.problemAdapter.value
                                      .currentPaginatedPage){
                                    _dashboardController.problemAdapter.value
                                        .getNextPage(_dashboardController
                                        .firebaseController);
                                  }
                                  _dashboardController.problemAdapter.value
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

// class CustomDataTableSource extends DataTableSource {
//   List<DataRow>? data = <DataRow>[];
//
//   CustomDataTableSource([this.data]);
//
//   @override
//   DataRow? getRow(int index) {
//     final DashboardController _dashboardController =
//     Get.find<DashboardController>();
//     try {
//       return data == null ? null : data![index];
//     } on RangeError catch (e) {
//       null;
//     }
//   }
//
//   @override
//   bool get isRowCountApproximate => false;
//
//   @override
//   int get rowCount {
//     final DashboardController _dashboardController =
//     Get.find<DashboardController>();
//     return _dashboardController.problemAdapter.value.lastId.value - 1;
//   }
//
//   @override
//   int get selectedRowCount => 0;
// }
//
