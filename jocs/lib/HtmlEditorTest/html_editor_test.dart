import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../firebase_options.dart';

class HtmlEditorTest extends GetView<TestController> {
  HtmlEditorTest({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    controller.initializeFirebase();
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            TextButton(
              onPressed: () {
                controller.getPaginatedDataFromFirebase();
              },
              child: const Text('Next'),
            ),
            Expanded(
              child: PaginatedDataTable(
                columns: const [
                  DataColumn(label: Expanded(child: Text("Issued By", textAlign: TextAlign.center,))),
                  DataColumn(label: Expanded(child: Text("Status", textAlign: TextAlign.center,))),
                  DataColumn(label: Expanded(child: Text("Priority", textAlign: TextAlign.center,))),
                  DataColumn(label: Expanded(child: Text("Topic", textAlign: TextAlign.center,))),
                  DataColumn(label: Expanded(child: Text("Assigned To", textAlign: TextAlign.center,))),
                  DataColumn(label: Expanded(child: Text("Comments", textAlign: TextAlign.center,))),
                  DataColumn(label: Expanded(child: Text("", textAlign: TextAlign.center,))),
                ],
                source: controller.dataSource,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomDataTableSource extends DataTableSource {
  RxList<DataRow> data = RxList();
  String screenName = "";

  CustomDataTableSource(this.screenName);

  @override
  DataRow? getRow(int index) {
    TestController _testController =
    Get.find<TestController>();

    int currentIndex = 0;
    DataRow row = const DataRow(
      cells: [
        DataCell(
            Text("")
        ),
        DataCell(
            Text("")
        ),
        DataCell(
            Text("")
        ),
        DataCell(
            Text("")
        ),
        DataCell(
            Text("")
        ),
        DataCell(
            Text("")
        ),
        DataCell(
            Text("")
        ),
      ],
    );
    for (var list in _testController.mapList) {
      list.forEach((key, ticket) {
        if (currentIndex == index) {
          row = DataRow(
              cells: [
                DataCell(
                  Text(ticket.topic),
                ),
                DataCell(
                  Text(ticket.assignedTo),
                ),
                DataCell(
                  Text(ticket.comments),
                ),
                DataCell(
                  Text(ticket.issuedBy),
                ),
                DataCell(
                  Text(ticket.priority),
                ),
                DataCell(
                  Text(ticket.status),
                ),
                const DataCell(
                  Text(""),
                ),
              ]
          );
        }
        currentIndex += 1;
      });
    }
    return row;
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount {
    TestController _testController =
    Get.find<TestController>();

    int totalElem = _testController.mapList.length;
    for (var list in _testController.mapList) {
      totalElem += list.length;
    }
    return totalElem;
  }
  

  @override
  int get selectedRowCount => 0;
}



class Ticket {
  final String assignedTo;
  final String comments;
  final String issuedBy;
  final String priority;
  final String status;
  final String time;
  final String topic;

  Ticket({
    required this.assignedTo,
    required this.comments,
    required this.issuedBy,
    required this.priority,
    required this.status,
    required this.time,
    required this.topic,
  });

  factory Ticket.fromMap(Map<String, dynamic> ticket) {
    return Ticket(
      status: ticket['assigned_to'],
      issuedBy: ticket['issued_by'],
      time: ticket['time'],
      assignedTo: ticket['assigned_to'],
      comments: ticket['comments'],
      topic: ticket['topic'],
      priority: ticket['priority'],
    );
  }

  factory Ticket.fromDocumentSnapshot(QueryDocumentSnapshot ticket) {
    return Ticket(
      status: ticket['assigned_to'],
      issuedBy: ticket['issued_by'],
      time: ticket['time'],
      assignedTo: ticket['assigned_to'],
      comments: ticket['comments'],
      topic: ticket['topic'],
      priority: ticket['priority'],
    );
  }
}

class TestBinding extends Bindings {
  @override
  void dependencies() {
    print('Dependency');
    Get.put(TestController());
  }

}

class TestController extends GetxController {
  late CollectionReference collectionReference;

  List<Map<String, Ticket>> mapList = <Map<String, Ticket>>[];
  String lastTime = '';

  CustomDataTableSource dataSource = CustomDataTableSource("");

  List<StreamSubscription> streams = <StreamSubscription>[];

  initializeFirebase() async {
    collectionReference = FirebaseFirestore.instance.collection('tickets');
  }

  void getPaginatedDataFromFirebase() {
    var query = collectionReference
        .orderBy('time', descending: true)
        .limit(3);

    if (lastTime.isNotEmpty) {
      query = query
          .where('time', isLessThan: lastTime);
    }

    int streamIndex = streams.length;

    streams.add(
      query
          .snapshots()
          .map((QuerySnapshot snapshot) {
            List notCheckedKeys = [];
            bool reVisit = false;
            if (mapList.length > streamIndex) {
              notCheckedKeys = mapList[streamIndex].keys.toList();
              reVisit = true;
            }

            for (var document in snapshot.docs) {
              if (!notCheckedKeys.contains(document["time"]) && reVisit) {
                continue;
              }
              if (mapList.length > streamIndex) {
                mapList[streamIndex][document["time"]] = Ticket.fromDocumentSnapshot(document);
              } else {
                mapList.add({document["time"]: Ticket.fromDocumentSnapshot(document)});
              }

              notCheckedKeys.removeWhere((key) => key == document["time"]);
            }

            for (String key in notCheckedKeys) {
              mapList[streamIndex].remove(key);
            }

            print('Map List: $mapList');

            if (snapshot.docs.isNotEmpty) {
              lastTime = snapshot.docs.last["time"];
            }
            dataSource.notifyListeners();
      }).listen((event) { })
    );
  }

  @override
  void onClose() {
    for (var stream in streams) {
      stream.cancel();
    }
    super.onClose();
  }
}