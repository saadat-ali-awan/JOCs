import 'package:get/get.dart';

class TicketModel {
  RxInt currentPage = 1.obs;
  RxInt lastId = 0.obs;
  int articlesOnOnePage = 10;
  RxList ticketsData = RxList();

  getTicketsData(firebaseController, {String filter="", previous=false}) async {
    if (previous){

    }
    if (ticketsData.length < currentPage.value ) {
      var data = await firebaseController.getData("tickets", currentPage.value, articlesOnOnePage, filter: filter);
      if (data.docs.length == 0){
        currentPage -= 1;
      }else {
        ticketsData.add([]);
        data.docs.forEach((res) {
          ticketsData[currentPage.value-1].add(res);
        });
      }
    }
  }

  getNextPage(firebaseController){
    currentPage.value+=1;
    getTicketsData(firebaseController, filter: ticketsData[currentPage.value-2][articlesOnOnePage-1]["time"]);
  }
  getPreviousPage(firebaseController){
    currentPage.value-=1;
    if (currentPage.value < 1){
      currentPage.value = 1;
    }
  }

  refreshCurrentPage(firebaseController) async{
    ticketsData = RxList();
    currentPage.value = 1;
    lastId.value = await firebaseController.getLastId("tickets");
    getTicketsData(firebaseController);
  }
}