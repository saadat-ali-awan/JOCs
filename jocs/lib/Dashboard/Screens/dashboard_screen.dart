import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jocs/Dashboard/Controllers/dashboard_controller.dart';

class DashboardScreen extends StatelessWidget {
  DashboardScreen({Key? key}) : super(key: key);

  DashboardController _dashboardController = Get.find<DashboardController>();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Expanded(
              child: Row(
                children: [
                  Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          color: Get.theme.appBarTheme.backgroundColor,
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Container(
                                  color: Get.theme.appBarTheme.foregroundColor,
                                  child: const Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Center(
                                      child: Text("OPEN TICKETS"),
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(child: Center(
                                child: Obx(()=> Text("${_dashboardController.openTickets}", style: Get.textTheme.headline1,))
                              ))
                            ],
                          ),
                        ),
                      )
                  ),
                  Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          color: Get.theme.appBarTheme.backgroundColor,
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Container(
                                  color: Get.theme.appBarTheme.foregroundColor,
                                  child: const Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Center(
                                      child: Text("UNRESOLVED TICKETS"),
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(child: Center(
                                child: Obx(()=> Text("${_dashboardController.unresolvedTickets}", style: Get.textTheme.headline1,))
                              ))
                            ],
                          ),
                        ),
                      )
                  ),
                ],
              )
          ),
          Expanded(
              child: Row(
                children: [
                  Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          color: Get.theme.appBarTheme.backgroundColor,
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Container(
                                  color: Get.theme.appBarTheme.foregroundColor,
                                  child: const Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Center(
                                      child: Text("UNASSIGNED TICKETS"),
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(child: Center(
                                child: Obx(()=> Text("${_dashboardController.unassignedTickets}", style: Get.textTheme.headline1,))
                              ))
                            ],
                          ),
                        ),
                      )
                  ),
                  Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          color: Get.theme.appBarTheme.backgroundColor,
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Container(
                                  color: Get.theme.appBarTheme.foregroundColor,
                                  child: const Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Center(
                                      child: Text("TICKETS ASSIGNED TO ME"),
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(child: Center(
                                child: Obx(()=> Text("${_dashboardController.ticketsAssignedToMe}", style: Get.textTheme.headline1,))
                              ))
                            ],
                          ),
                        ),
                      )
                  ),
                ],
              )
          )
        ],
      ),
    );
  }
}
