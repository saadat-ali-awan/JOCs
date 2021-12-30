import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jocs/Dashboard/Controllers/dashboard_controller.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final DashboardController _dashboardController = Get.find<DashboardController>();
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    if (width > 500){
      _dashboardController.changeBody(false);
    }else {
      _dashboardController.changeBody(true);
    }
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'JOCs',
            style: Theme
                .of(context)
                .textTheme
                .headline4,
          ),
        ),
        body: SafeArea(
            child: _dashboardController.body.value
        )

    );
  }
}

