import 'package:get/get.dart';

class ProblemModel {
  RxInt currentPage = 1.obs;
  RxInt lastId = 0.obs;
  int articlesOnOnePage = 10;
  RxList problemsData = RxList();

  getProblemsData(firebaseController, {String filter="", previous=false}) async {
    if (previous){

    }
    if (problemsData.length < currentPage.value ) {
      var data = await firebaseController.getData("problems", currentPage.value, articlesOnOnePage, filter: filter);
      if (data.docs.length == 0){
        currentPage -= 1;
      }else {
        problemsData.add([]);
        data.docs.forEach((res) {
          problemsData[currentPage.value-1].add(res);
        });
      }
    }
  }

  getNextPage(firebaseController){
    currentPage.value+=1;
    getProblemsData(firebaseController, filter: problemsData[currentPage.value-2][articlesOnOnePage-1]["time"]);
  }
  getPreviousPage(firebaseController){
    currentPage.value-=1;
    if (currentPage.value < 1){
      currentPage.value = 1;
    }
  }

  refreshCurrentPage(firebaseController) async{
    problemsData = RxList();
    currentPage.value = 1;
    lastId.value = await firebaseController.getLastId("problems");
    getProblemsData(firebaseController);
  }
}