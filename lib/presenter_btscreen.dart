/*
    Created by Shitab Mir on 19 December 2021
 */

import 'dart:async';
import 'dart:typed_data';

import 'package:btstream/common/util/util_common.dart';
import 'package:btstream/common/util/util_debug.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:permission_handler/permission_handler.dart';

class BtScreenPresenter {

  BuildContext context;
  Function setStateCall;

  BtScreenPresenter(this.context, this.setStateCall);

  void clearReading(ValueNotifier<String?> buffer) {
    buffer.value = '';
  }

  void toggleBluetooth({
    required bool value,
    required ValueNotifier<bool> bluetoothEnabled,
    required ValueNotifier<BluetoothState> bluetoothState,
    required ValueNotifier<bool> isDiscovering,
    required ValueNotifier<List<BluetoothDiscoveryResult>> discoveryResults,
    required StreamSubscription<BluetoothDiscoveryResult>? streamSubscription,
    required BluetoothDiscoveryResult emptyBtDevice,
  }) {
    if (!CommonUtil.instance.isRedundantClick(DateTime.now())) {
      future() async {
        try {
          if (value) {
            bluetoothEnabled.value = (await FlutterBluetoothSerial.instance.requestEnable())!;
          } else {
            bluetoothEnabled.value = (await FlutterBluetoothSerial.instance.requestDisable())!;
          }
        } catch (e) {
          DebugUtil.instance.printLog(msg : e);
        }
        setStateCall();
      }
      future().then((_) {
        Future.delayed(const Duration(milliseconds: 650), () {
          currentBluetoothStateEnabled(bluetoothEnabled: bluetoothEnabled, bluetoothState: bluetoothState);
          DebugUtil.instance.printLog(msg : bluetoothEnabled.value);
          startDiscovery(
            bluetoothEnabled: bluetoothEnabled,
            isDiscovering: isDiscovering,
            streamSubscription: streamSubscription,
            discoveryResults: discoveryResults,
            emptyBtDevice: emptyBtDevice,
          );
        });
      });
    }
  }

  bool currentBluetoothStateEnabled({
    required ValueNotifier<BluetoothState> bluetoothState,
    required ValueNotifier<bool> bluetoothEnabled,
  }) {
    // Get current state
    FlutterBluetoothSerial.instance.state.then((state) {
      bluetoothState.value = state;
      bluetoothEnabled.value = bluetoothState.value.isEnabled;
    });
    return bluetoothEnabled.value;
  }

  void startDiscovery({
    required ValueNotifier<bool> bluetoothEnabled,
    required ValueNotifier<bool> isDiscovering,
    required ValueNotifier<List<BluetoothDiscoveryResult>> discoveryResults,
    required StreamSubscription<BluetoothDiscoveryResult>? streamSubscription,
    required BluetoothDiscoveryResult emptyBtDevice,
  }) async {
    Future.delayed(const Duration(milliseconds: 650), () async {
      if (bluetoothEnabled.value) {
        var status = await Permission.locationWhenInUse.request();
        if (status.isPermanentlyDenied || status.isDenied || status.isDenied) {
          CommonUtil.instance.showToast(
              context,
              'Provide Location Permission to Search for Bluetooth Devices');
        } else {
          discoveryResults.value.clear();
          discoveryResults.value.add(emptyBtDevice);
          isDiscovering.value = true;
          // setState(() {});
          setStateCall();
          streamSubscription =
              FlutterBluetoothSerial.instance.startDiscovery().listen((r) {
                discoveryResults.value.add(r);
                DebugUtil.instance.printLog(msg :
                "Name:${r.device.name.toString()} \nType:${r.device.type
                    .toString()} \nAddress:${r.device.address
                    .toString()} \nisBonded: ${r.device.isBonded
                    .toString()} \nisConnected: ${r.device.isConnected
                    .toString()} ");
              });
          streamSubscription?.onDone(() {
            isDiscovering.value = false;
            // setState(() {});
            setStateCall();
          });
        }
      } else {
        CommonUtil.instance.showToast(
            context, 'Enable Bluetooth to Search for Devices');
      }
    });
  }

  void onDataReceived({required Uint8List data, required ValueNotifier<String?> messageBuffer}) {
    messageBuffer.value = messageBuffer.value.toString() +  String.fromCharCodes(data);
  }

  // Data Parsing
  String? parseBluetoothDataForUse(String? value) {
    RegExp regExp = RegExp(
        r'T:.{1,5},EC:.{1,5},pH:.{1,5}.,TDS:.{1,5},Sal:.{1,5},');
    try {
      if (value != null) {
        return regExp
            .allMatches(value)
            .last
            .group(0) == null ? '' : regExp
            .allMatches(value)
            .last
            .group(0);
      } else {
        return '';
      }
    } catch (e) {
      return '';
    }
  }

  void selectDevice({
    required String value,
    required ValueNotifier<String> btDropdownValue,
    required ValueNotifier<String> selectedDeviceMacAddress,
  }) {
    DebugUtil.instance.printLog(msg : "Selected: " + value);
    btDropdownValue.value = value;
    selectedDeviceMacAddress.value =
        RegExp(r'\[(.*?)\]').stringMatch(value).toString().replaceAll('[', '')
            .replaceAll(']', '')
            .trim();
    DebugUtil.instance.printLog(
        msg : "Selected MacAddress: " + selectedDeviceMacAddress.value
    );
    // setState(() {});
    setStateCall();
  }

}