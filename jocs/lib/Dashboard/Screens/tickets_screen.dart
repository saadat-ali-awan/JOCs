import 'package:flutter/material.dart';
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
            IconButton(
                onPressed: (){
                  _dashboardController.ticketAdapter.value.refreshCurrentPage(_dashboardController.firebaseController);
                },
                icon: const Icon(Icons.refresh),
              color: Get.theme.appBarTheme.backgroundColor,
            ),
          ],
        ),
        Obx(
          () => Table(
            border:
                TableBorder.all(color: Colors.black, style: BorderStyle.solid),
            children: _dashboardController
                        .ticketAdapter.value.adapterData.isEmpty ||
                    _dashboardController.ticketAdapter.value.currentPage.value < 1
                ? [
                  createRow(["Issued By","Topic","Status","Priority","Assigned To","Comments"])
                  ]
                : getRows(),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Obx(() {
                return IconButton(
                    onPressed: _dashboardController.ticketAdapter.value.currentPage.value <= 1 ? null:() {
                      _dashboardController.ticketAdapter.value.getPreviousPage(
                          _dashboardController.firebaseController);
                    },
                    icon: const Icon(
                      Icons.arrow_back_ios_outlined,),
                    color: Get.theme.appBarTheme.backgroundColor
                );
              }),
              Obx(() {
                return Text("${_dashboardController.ticketAdapter.value.currentPage.value} / ${(_dashboardController.ticketAdapter.value.lastId.value/_dashboardController.ticketAdapter.value.articlesOnOnePage).ceil()}");
              }),
              Obx(() {
                return IconButton(
                    onPressed: _dashboardController.ticketAdapter.value
                        .currentPage.value >=
                        _dashboardController.ticketAdapter.value.lastId.value /
                            _dashboardController.ticketAdapter.value
                                .articlesOnOnePage ? null : () {
                      _dashboardController.ticketAdapter.value
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

  List<TableRow> getRows() {
    List<TableRow> onePageTableRows = [];
    onePageTableRows.add(createRow(["Issued By","Topic","Status","Priority","Assigned To","Comments"]));
    try {
      for (var res in _dashboardController.ticketAdapter.value.adapterData[
          _dashboardController.ticketAdapter.value.currentPage.value-1]) {
        onePageTableRows.add(
          createRow([
            res.data()["issued_by"],
            res.data()["topic"],
            res.data()["status"],
            res.data()["priority"],
            res.data()["assigned_to"],
            res.data()["comments"]
          ])
        );
      }
    } on RangeError catch (e) {
      return onePageTableRows;
    }
    return onePageTableRows;
  }

  TableRow createRow(data){
    return TableRow(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(child: Text(data[0]),),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(child: Text(data[1]),),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(child: Text(data[2]),),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(child: Text(data[3]),),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(child: Text(data[4]),),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(child: Text(data[5]),),
        ),
      ]
    );
  }
}
