import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firedart/firedart.dart';
import 'package:get/get.dart';
import 'package:jocs/Dashboard/Controllers/dashboard_controller.dart';

class DetailedMetadata {
  int ticketsCount = 0;
  int purchaseCount = 0;
  int problemsCount = 0;
  int inventoryCount = 0;
  int articlesCount = 0;

  DetailedMetadata();

  DetailedMetadata.fromDataSnapshot(DocumentSnapshot snapshot){
    ticketsCount = snapshot["ticketsCount"];
    purchaseCount = snapshot["purchaseCount"];
    problemsCount = snapshot["problemsCount"];
    inventoryCount = snapshot["inventoryCount"];
    articlesCount = snapshot["articlesCount"];

    Get.find<DashboardController>().updateDashboard();
  }

  DetailedMetadata.fromDataSnapshotWindows(Document snapshot){
    ticketsCount = snapshot["ticketsCount"];
    purchaseCount = snapshot["purchaseCount"];
    problemsCount = snapshot["problemsCount"];
    inventoryCount = snapshot["inventoryCount"];
    articlesCount = snapshot["articlesCount"];
    Get.find<DashboardController>().updateDashboard();
  }

}