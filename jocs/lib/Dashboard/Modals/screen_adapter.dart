import 'package:get/get.dart';

class ScreenAdapter {
  RxInt currentPage = 1.obs;
  RxInt lastId = 0.obs;
  int articlesOnOnePage = 10;
  RxList adapterData = RxList();
  String screenName = "";

  ScreenAdapter(this.screenName);

  getScreenData(firebaseController, {String filter="", previous=false}) async {
    if (previous){

    }
    if (adapterData.length < currentPage.value ) {
      var data = await firebaseController.getData(screenName, currentPage.value, articlesOnOnePage, filter: filter);
      if (data.docs.length == 0){
        currentPage -= 1;
      }else {
        adapterData.add([]);
        data.docs.forEach((res) {
          adapterData[currentPage.value-1].add(res);
        });
      }
    }
  }

  getNextPage(firebaseController){
    currentPage.value+=1;
    getScreenData(firebaseController, filter: adapterData[currentPage.value-2][articlesOnOnePage-1]["time"]);
  }
  getPreviousPage(firebaseController){
    currentPage.value-=1;
    if (currentPage.value < 1){
      currentPage.value = 1;
    }
  }

  refreshCurrentPage(firebaseController) async{
    adapterData = RxList();
    currentPage.value = 1;
    lastId.value = await firebaseController.getLastId(screenName);
    getScreenData(firebaseController);
  }
}