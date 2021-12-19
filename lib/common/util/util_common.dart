/*
    Created by Shitab Mir on 16 August 2021
 */

import 'package:btstream/common/constants/colors_app.dart';
import 'package:btstream/common/constants/image_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class CommonUtil {
  static final instance = CommonUtil();

  /// For Status Bar Show
  void setupStatusBarForPage() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: SystemUiOverlay.values);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: AppColors.instance.statusBarColor,
    ));
  }

  /// Show Toast
  void showToast(BuildContext context, String msg) {
    dismissToast(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.red,
        duration: Duration(seconds: 2),
        content: Text(msg),
      ),
    );
  }

  void dismissToast(BuildContext context) {
    ScaffoldMessenger.of(context).clearSnackBars();
  }

  void showToastGrey(BuildContext context, String msg) {
    dismissToast(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.grey,
        duration: Duration(seconds: 3),
        content: Text(
          msg,
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Future showSuccessToast(BuildContext context, String? successMessage) async{
    dismissToast(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.greenAccent,
        duration: Duration(seconds: 6),
        content: Text(successMessage!),
      ),
    );
  }

  /// Handle Over-tapping
  DateTime? initialClickTime;
  bool isRedundantClick(DateTime currentTime){
    if(initialClickTime==null){
      initialClickTime = currentTime;
      return false;
    } else {
      if (currentTime
          .difference(initialClickTime!)
          .inSeconds < 3) { //set this difference time in seconds
        return true;
      }
    }
    initialClickTime = currentTime;
    return false;
  }

  /// String Operations
  String getCGSLength(num? value) {
    if (value == null) {
      return '-';
    } else {
      int feet = getFeetFromInches(inches: value);
      String inches = (value%12).toStringAsFixed(2) == '0.00' ? '' : (value%12).toStringAsFixed(2);
      return "$feet Ft $inches ${inches.isNotEmpty ? getSingularOrPlural("inch", double.parse(inches), true) : ''}";
    }
  }

  String getOnlyInchesFromTotalInches({num? inches}) {
    if (inches==null) return '0';
    else return (inches%12).toStringAsFixed(2);
  }

  int getFeetFromInches({num? inches}) {
    if (inches==null) return 0;
    else return (inches~/12);
  }

  num getInchesFromFeet({num? feet}) {
    if(feet == null) return 0 ;
    else return (feet*12);
  }

  String getSingularOrPlural(String unitName, num? number, bool es) {
    if(number == 1) {
      return '';
    }
    else if (es) return unitName+'es';
    else return unitName+'s';
  }

  bool anyFieldsEmpty(List<String?> arrayList) {
    if(arrayList.contains('') || arrayList.contains(null)) {
      return true;
    } else return false;
  }

  void hideKeyboard(BuildContext context) {
    FocusScope.of(context).unfocus();
  }

  /// Loader Behavior
  void showLoading() {
    EasyLoading.show(status: 'Loading',
        dismissOnTap: false,
        maskType: EasyLoadingMaskType.black);
  }

  void stopLoading() {
    EasyLoading.dismiss(animation: true);
  }

  void onNoInternet() {
    EasyLoading.show(status: "No Internet!",
        indicator: Icon(Icons.signal_cellular_connected_no_internet_4_bar,
          color: Colors.white70,),
        dismissOnTap: true,
        maskType: EasyLoadingMaskType.black,
    );
  }

  Future onSuccessfulEntry(String? successMessage) async{
    EasyLoading.show(status: successMessage!,
      indicator: Icon(Icons.check,
        color: Colors.white70,),
      dismissOnTap: true,
      maskType: EasyLoadingMaskType.black,
    );
  }

  void onFailed(String failedMsg) {
    EasyLoading.show(status: failedMsg,
        indicator: Icon(Icons.sms_failed_outlined, color: Colors.white70,),
        dismissOnTap: true,
        maskType: EasyLoadingMaskType.black);
  }

  void onEasyMsg(String failedMsg) {
    EasyLoading.show(status: failedMsg,
        indicator: Icon(Icons.add_to_home_screen, color: Colors.white70,),
        dismissOnTap: true,
        maskType: EasyLoadingMaskType.black);
  }

  void onFailedNoDismiss(String failedMsg) {
    EasyLoading.show(status: failedMsg, indicator: Image.asset(AppImages.instance.errorIcon), dismissOnTap: false, maskType: EasyLoadingMaskType.black);
  }

  // Custom Loading
  Widget getCircularProgressIndicator() {
    return Container(
      height: 60,
      width: 60,
      padding: const EdgeInsets.all(10),
      child: CircularProgressIndicator(
        color: AppColors.instance.lightBlueTextColor,
      ),
    );
  }

  /// horizontal space
  Widget createHorizontalSpace(var spaceQuantity){
    return SizedBox(width: spaceQuantity);
  }

  /// vertical space
  Widget createVerticalSpace(var spaceQuantity){
    return SizedBox(height: spaceQuantity);
  }

}