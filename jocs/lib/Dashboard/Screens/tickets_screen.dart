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
                  _dashboardController.ticketModel.value.refreshCurrentPage(_dashboardController.firebaseController);
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
                        .ticketModel.value.ticketsData.isEmpty ||
                    _dashboardController.ticketModel.value.currentPage.value < 1
                ? [
              const TableRow(children: [
                Padding(
                  padding: EdgeInsets.all(4.0),
                  child: Center(child: Text("Issued By")),
                ),
                Padding(
                  padding: EdgeInsets.all(4.0),
                  child: Center(child: Text("Topic")),
                ),
                Padding(
                  padding: EdgeInsets.all(4.0),
                  child: Center(child: Text("Status")),
                ),
                Padding(
                  padding: EdgeInsets.all(4.0),
                  child: Center(child: Text("Priority")),
                ),
                Padding(
                  padding: EdgeInsets.all(4.0),
                  child: Center(child: Text("Assigned To")),
                ),
                Padding(
                  padding: EdgeInsets.all(4.0),
                  child: Center(child: Text("Comments")),
                )
              ])
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
                    onPressed: _dashboardController.ticketModel.value.currentPage.value <= 1 ? null:() {
                      _dashboardController.ticketModel.value.getPreviousPage(
                          _dashboardController.firebaseController);
                    },
                    icon: const Icon(
                      Icons.arrow_back_ios_outlined,),
                    color: Get.theme.appBarTheme.backgroundColor
                );
              }),
              Obx(() {
                return Text("${_dashboardController.ticketModel.value.currentPage.value} / ${(_dashboardController.ticketModel.value.lastId.value/_dashboardController.ticketModel.value.articlesOnOnePage).ceil()}");
              }),
              Obx(() {
                return IconButton(
                    onPressed: _dashboardController.ticketModel.value
                        .currentPage.value >=
                        _dashboardController.ticketModel.value.lastId.value /
                            _dashboardController.ticketModel.value
                                .articlesOnOnePage ? null : () {
                      _dashboardController.ticketModel.value
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
    onePageTableRows.add(const TableRow(children: [
      Padding(
        padding: EdgeInsets.all(4.0),
        child: Center(child: Text("Issued By")),
      ),
      Padding(
        padding: EdgeInsets.all(4.0),
        child: Center(child: Text("Topic")),
      ),
      Padding(
        padding: EdgeInsets.all(4.0),
        child: Center(child: Text("Status")),
      ),
      Padding(
        padding: EdgeInsets.all(4.0),
        child: Center(child: Text("Priority")),
      ),
      Padding(
        padding: EdgeInsets.all(4.0),
        child: Center(child: Text("Assigned To")),
      ),
      Padding(
        padding: EdgeInsets.all(4.0),
        child: Center(child: Text("Comments")),
      )
    ]));
    try {
      for (var res in _dashboardController.ticketModel.value.ticketsData[
          _dashboardController.ticketModel.value.currentPage.value-1]) {
        onePageTableRows.add(TableRow(children: [
          Center(child: Text(res.data()["issued_by"])),
          Center(child: Text(res.data()["topic"])),
          Center(child: Text(res.data()["status"])),
          Center(child: Text(res.data()["priority"])),
          Center(child: Text(res.data()["assigned_to"])),
          Center(child: Text(res.data()["comments"]))
        ]));
      }
    } on RangeError catch (e) {
      return onePageTableRows;
    }
    return onePageTableRows;
  }
}
