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
            IconButton(
              onPressed: (){
                _dashboardController.problemAdapter.value.refreshCurrentPage(_dashboardController.firebaseController);
              },
              icon: const Icon(Icons.refresh),
              color: Get.theme.appBarTheme.backgroundColor,
            ),
          ],
        ),
        Obx(
              () => Expanded(
            child: Scrollbar(
                isAlwaysShown: true,
                child: SingleChildScrollView(
                  controller: ScrollController(),
                  scrollDirection: Axis.horizontal,
                  child: SingleChildScrollView(
                    controller: ScrollController(),
                    scrollDirection: Axis.vertical,
                    child: DataTable(
                      columns: const [
                        DataColumn(label: Text("Issued By")),
                        DataColumn(label: VerticalDivider(color: Colors.black,)),
                        DataColumn(label: Text("Topic")),
                        DataColumn(label: VerticalDivider(color: Colors.black,)),
                        DataColumn(label: Text("Status")),
                        DataColumn(label: VerticalDivider(color: Colors.black,)),
                        DataColumn(label: Text("Priority")),
                        DataColumn(label: VerticalDivider(color: Colors.black,)),
                        DataColumn(label: Text("Assigned To")),
                        DataColumn(label: VerticalDivider(color: Colors.black,)),
                        DataColumn(label: Text("Department")),
                      ],
                      rows: getRows(),
                    ),
                  ),
                )),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Obx(() {
                return IconButton(
                    onPressed: _dashboardController.problemAdapter.value.currentPage.value <= 1 ? null:() {
                      _dashboardController.problemAdapter.value.getPreviousPage(
                          _dashboardController.firebaseController);
                    },
                    icon: const Icon(
                      Icons.arrow_back_ios_outlined,),
                    color: Get.theme.appBarTheme.backgroundColor
                );
              }),
              Obx(() {
                return Text("${_dashboardController.problemAdapter.value.currentPage.value} / ${(_dashboardController.problemAdapter.value.lastId.value/_dashboardController.problemAdapter.value.articlesOnOnePage).ceil()}");
              }),
              Obx(() {
                return IconButton(
                    onPressed: _dashboardController.problemAdapter.value
                        .currentPage.value >=
                        _dashboardController.problemAdapter.value.lastId.value /
                            _dashboardController.problemAdapter.value
                                .articlesOnOnePage ? null : () {
                      _dashboardController.problemAdapter.value
                          .getNextPage(_dashboardController.firebaseController);
                    },
                    icon: const Icon(
                      Icons.arrow_forward_ios_outlined,),
                    color: Get.theme.appBarTheme.backgroundColor
                );
              })
            ],
          ),
        )
      ],
    );
  }

  List<DataRow> getRows() {
    List<DataRow> onePageTableRows = [];
    try {
      for (var res in _dashboardController.problemAdapter.value.adapterData[
      _dashboardController.problemAdapter.value.currentPage.value - 1]) {
        onePageTableRows.add(createRow([
          res.data()["issued_by"],
          res.data()["topic"],
          res.data()["status"],
          res.data()["priority"],
          res.data()["assigned_to"],
          res.data()["department"]
        ]));
      }
    } on RangeError catch (e) {
      return onePageTableRows;
    }
    return onePageTableRows;
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
      const DataCell(VerticalDivider(color: Colors.black,)),
      DataCell(
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: Text(data[1]),
          ),
        ),
      ),
      const DataCell(VerticalDivider(color: Colors.black,)),
      DataCell(
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: Text(data[2]),
          ),
        ),
      ),
      const DataCell(VerticalDivider(color: Colors.black,)),
      DataCell(
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: Text(data[3]),
          ),
        ),
      ),
      const DataCell(VerticalDivider(color: Colors.black,)),
      DataCell(
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: Text(data[4]),
          ),
        ),
      ),
      const DataCell(VerticalDivider(color: Colors.black,)),
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
