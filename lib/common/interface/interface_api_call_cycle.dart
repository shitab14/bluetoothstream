/*
    Created by Shitab Mir on 18 August 2021
 */

class ApiCallCycleInterface {
  void onStartLoading() {}
  void onResponseReceived(String successMsg) {}
  void onStopLoading() {}
  // void onSuccess(){}
  void onFailed(String failedMsg){}
  void onNoInternet(){}
}