import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jocs/Dashboard/Controllers/dashboard_controller.dart';

class PurchaseScreen extends StatelessWidget {
  PurchaseScreen({Key? key}) : super(key: key);

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
                        DataColumn(label: Expanded(child: Text("ORDER NO.", textAlign: TextAlign.center,))),
                        DataColumn(label: Expanded(child: Text("ORDER NAME", textAlign: TextAlign.center,))),
                        DataColumn(label: Expanded(child: Text("DESCRIPTION", textAlign: TextAlign.center,))),
                        DataColumn(label: Expanded(child: Text("EXPECTED DELIVERY", textAlign: TextAlign.center,))),
                        DataColumn(label: Expanded(child: Text("STATUS", textAlign: TextAlign.center,))),
                        DataColumn(label: Expanded(child: Text("COMMENTS", textAlign: TextAlign.center,))),
                        DataColumn(label: Expanded(child: Text("", textAlign: TextAlign.center,))),
                      ],
                      source: _dashboardController
                          .purchaseAdapter.value.dataTableSource.value,
                      arrowHeadColor:
                      Get.theme.appBarTheme.backgroundColor,
                      onPageChanged: (int? index) {
                        if (index != null) {
                          if (((index+1)/10).ceil() > _dashboardController.purchaseAdapter.value
                              .currentPaginatedPage){
                            _dashboardController.purchaseAdapter.value
                                .getNextPage(_dashboardController
                                .firebaseController, <String, String>{});
                          }
                          _dashboardController.purchaseAdapter.value
                              .currentPaginatedPage = ((index+1)/10).ceil();

                        }

                      },
                    ),
                  ),
                )
              )
            ],
          )
        ],
      ),
    );
  }
}
