/*
    Created by Shitab Mir on 19 December 2021
 */

import 'package:btstream/common/util/util_common.dart';
import 'package:flutter/material.dart';

class BtScreenPresenter {

  BuildContext context;

  BtScreenPresenter(this.context);

  String getDateStamp() {
    return '(${CommonUtil.instance.makeTimeParamTwoDigit(DateTime.now().hour)}'
        ':${CommonUtil.instance.makeTimeParamTwoDigit(DateTime.now().minute)}'
        ':${CommonUtil.instance.makeTimeParamTwoDigit(DateTime.now().second)}'
        ':${DateTime.now().millisecond + DateTime.now().microsecond}) ';
  }





}