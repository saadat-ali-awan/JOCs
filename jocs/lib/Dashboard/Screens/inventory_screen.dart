import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jocs/Dashboard/Controllers/dashboard_controller.dart';

class InventoryScreen extends StatelessWidget {
  InventoryScreen({Key? key}) : super(key: key);

  final DashboardController _dashboardController =
  Get.find<DashboardController>();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      controller: ScrollController(),
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
                      columns: const [
                        //DataColumn(label: Expanded(child: Text("", textAlign: TextAlign.center,))),
                        DataColumn(label: Expanded(child: Text("Item Name", textAlign: TextAlign.center,))),
                        DataColumn(label: Expanded(child: Text("Item Type", textAlign: TextAlign.center,))),
                        DataColumn(label: Expanded(child: Text("Location", textAlign: TextAlign.center,))),
                        DataColumn(label: Expanded(child: Text("Used By", textAlign: TextAlign.center,))),
                        DataColumn(label: Expanded(child: Text("Processed By", textAlign: TextAlign.center,))),
                        DataColumn(label: Expanded(child: Text("Comments", textAlign: TextAlign.center,))),
                        DataColumn(label: Expanded(child: Text("", textAlign: TextAlign.center,))),
                      ],
                      source: _dashboardController
                          .inventoryAdapter.value.dataTableSource.value,
                      arrowHeadColor:
                      Get.theme.appBarTheme.backgroundColor,
                      onPageChanged: (int? index) {
                        if (index != null) {
                          if (((index+1)/10).ceil() > _dashboardController.inventoryAdapter.value
                              .currentPaginatedPage){
                            _dashboardController.inventoryAdapter.value
                                .getNextPage(_dashboardController
                                .firebaseController, <String, String>{});
                          }
                          _dashboardController.inventoryAdapter.value
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
