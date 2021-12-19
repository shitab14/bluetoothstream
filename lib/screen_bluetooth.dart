/*
    Created by Shitab Mir on 19 December 2021
 */

import 'dart:async';
import 'dart:typed_data';
import 'package:btstream/common/constants/colors_app.dart';
import 'package:btstream/common/constants/image_app.dart';
import 'package:btstream/common/util/util_debug.dart';
import 'package:btstream/presenter_btscreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:permission_handler/permission_handler.dart';
import 'common/constants/constants_app.dart';
import 'common/util/util_common.dart';

class BluetoothPage extends StatefulWidget {
  const BluetoothPage({Key? key}) : super(key: key);

  @override
  _BluetoothPageState createState() => _BluetoothPageState();
}

class _BluetoothPageState extends State<BluetoothPage> {

  /// Presenter
  late BtScreenPresenter _presenter;

  // Static Data
  static const _pageTitle = 'Bluetooth Stream Reader';
  static const _SELECT_BLUETOOTH_DEVICE = 'Select Bluetooth Device';
  static final BluetoothDiscoveryResult _emptyBtDevice = BluetoothDiscoveryResult(
    device: BluetoothDevice(name: _SELECT_BLUETOOTH_DEVICE, address: ''),
  );

  /// Variables
  final ValueNotifier<BluetoothState> _bluetoothState = ValueNotifier(BluetoothState.UNKNOWN);
  final ValueNotifier<bool> _bluetoothEnabled = ValueNotifier(false);

  //Device Discovery
  final ValueNotifier<List<BluetoothDiscoveryResult>> _discoveryResults = ValueNotifier(
      [_emptyBtDevice]);
  StreamSubscription<BluetoothDiscoveryResult>? _streamSubscription;
  final ValueNotifier<bool> _isDiscovering = ValueNotifier(false);
  final ValueNotifier<String> _btDropdownValue = ValueNotifier(
      _SELECT_BLUETOOTH_DEVICE); // Shows the value of the selected dropdown option
  String _selectedDeviceMacAddress = "";

  // ValueNotifier<List<TankListItem>> _tankList = ValueNotifier(
  //     [
  //       // TankListItem(tankName: 'Tanki Tank', tankId: 007, tankCapacity: 69, tankLengthInch: 96, tankWidthInch: 90, tankDepthInch: 60, tankDescription: 'komu na'),
  //       // TankListItem(tankName: 'Tank Tanki', tankId: 008, tankCapacity: 69, tankLengthInch: 96, tankWidthInch: 90, tankDepthInch: 60, tankDescription: 'komu na'),
  //     ]
  // );
  final ValueNotifier<String> _tankDropdownValue = ValueNotifier(
      'Select Tank'); // Shows the value of the selected dropdown option

  //Connection
  BluetoothConnection? _connection;
  final ValueNotifier<String> _connectionStatusText = ValueNotifier(
      AppConstants.CONNECTION_STATUS_NOT_CONNECTED);
  final ValueNotifier<Color> _connectionStatusColor = ValueNotifier(Colors.red);

  final ValueNotifier<String?> _messageBuffer = ValueNotifier('');

  final TextEditingController _tankIdController = TextEditingController();

  /// Life Cycle Methods
  @override
  void initState() {
    super.initState();
    _presenter = BtScreenPresenter(context);
    _setCurrentBluetoothState();
    _startDiscovery();
  }

  @override
  void dispose() {
    _connection?.dispose();
    if (_streamSubscription != null)
      _streamSubscription?.cancel();
    if (EasyLoading.isShow)
      EasyLoading.dismiss();

    /// Value Notifiers
    _messageBuffer.dispose();
    _bluetoothState.dispose();
    _bluetoothEnabled.dispose();
    _discoveryResults.dispose();
    _isDiscovering.dispose();
    _btDropdownValue.dispose();
    _connectionStatusText.dispose();
    _connectionStatusColor.dispose();
    // _tankList.dispose();
    _tankDropdownValue.dispose();

    _tankIdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    CommonUtil.instance.setupStatusBarForPage();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _getAppBar(),
      body: Stack(
        children: [

          /// Background
          _backgroundWallpaper(),

          /// Bottom Wave
          _getBottomWave(),

          /// Body
          Align(
            alignment: Alignment.topCenter,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _getConnectedDeviceView(),
                _getBluetoothPairedDeviceConnectView(),
                _getDataView(),
              ],
            ),
          ),

          /// Discovering BT Devices
          _getDiscoveringBTAnimation(),

        ],
      ),
    );
  }

  /// UI
  // Discovery BT Lottie Animation
  Widget _getDiscoveringBTAnimation() {
    return Visibility(
      visible: _isDiscovering.value,
      child: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: Colors.white,
        child: Lottie.asset('assets/lottiefiles/bluetooth-search.zip'),
      ),
    );
  }

  // AppBar
  AppBar _getAppBar() {
    return AppBar(
      centerTitle: true,
      toolbarHeight: 60,
      backgroundColor: Colors.white,
      iconTheme: IconThemeData(
        color: Colors.black,
      ),
      title: FittedBox(
        fit: BoxFit.fitWidth,
        child: Text(
          _pageTitle,
          style: TextStyle(
            fontSize: 16,
            color: Colors.black,
          ),
        ),
      ),
      actions: _getBluetoothToggleSection(),
    );
  }

  // Background Wallpaper
  Widget _backgroundWallpaper() {
    return Align(
      alignment: Alignment.center,
      child: FittedBox(
        child: FaIcon(
          FontAwesomeIcons.fish,
          size: 300,
          color: AppColors.instance.waveBlue,
        ),
      ),
    );
  }

  // Bottom Wave
  Widget _getBottomWave() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        height: 90,
        child: SvgPicture.asset(
          AppImages.instance.waveBackground,
          fit: BoxFit.fill,
          width: MediaQuery
              .of(context)
              .size
              .width,
        ),
      ),
    );
  }

  // Bluetooth Toggle Section in AppBar
  List<Widget> _getBluetoothToggleSection() {
    List<Widget> widgets = [];
    widgets.add(
      ValueListenableBuilder(
          valueListenable: _bluetoothEnabled,
          builder: (BuildContext context, bool value, Widget? child) {
            return Row(
              children: [
                Icon(
                  Icons.bluetooth,
                  color: value ? Colors.lightBlueAccent : Colors.blueGrey,
                ),
                Switch(
                  value: value,
                  onChanged: (bool value) => _bluetoothToggle(value),
                  activeTrackColor: Colors.lightBlueAccent,
                  activeColor: Colors.lightBlueAccent,
                ),
              ],
            );
          }
      ),
    );

    return widgets;
  }

  // Top SnackBar showing Connection Status
  Widget _getConnectedDeviceView() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(6.0),
      color: _connectionStatusColor.value,
      child: Text(
        _connectionStatusText.value,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 12,
          color: Colors.white,
        ),
      ),
    );
  }


  // BT Device Dropdown, Refresh Button, Connect Button
  Widget _getBluetoothPairedDeviceConnectView() {
    return Container(
      margin: const EdgeInsets.all(10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Flexible(
            flex: 2,
            child: Center(
              child: Container(
                margin: const EdgeInsets.only(left: 6, right: 6,),
                child: PopupMenuButton<String>(
                  tooltip: 'Select Bluetooth Device',
                  initialValue: _btDropdownValue.value,
                  onSelected: (String value) => _selectDevice(value),
                  itemBuilder: (BuildContext context) {
                    return _discoveryResults.value.skip(0).map((
                        BluetoothDiscoveryResult choice) {
                      return PopupMenuItem<String>(
                        value: '${choice.device.name == null
                            ? "BT Device"
                            : choice.device.name.toString()} ${choice.device
                            .address.isEmpty || choice.device.address == null
                            ? ""
                            : "[" + choice.device.address.toString() + "]"}',
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Flexible(
                              child: Text(
                                '${choice.device.name == null
                                    ? "BT Device"
                                    : choice.device.name.toString()} ${choice
                                    .device.address.isEmpty ||
                                    choice.device.address == null ? "" : "[" +
                                    choice.device.address.toString() + "]"}',
                                overflow: TextOverflow.visible,
                                textAlign: TextAlign.left,
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList();
                  },
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(
                          color: AppColors.instance.blueBorderColor,
                        )
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Text(
                            _btDropdownValue.value,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14,
                              color: AppColors.instance.blueBorderColor,
                              fontStyle: FontStyle.normal,
                            ),
                          ),
                        ),
                        const Icon(
                          Icons.arrow_drop_down,
                          color: Colors.blue,
                          size: 20,
                        ),
                      ],
                    ),
                  ),

                ),

              ),
            ),
          ),
          Flexible(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.only(right: 6.0),
                child: ElevatedButton(
                  onPressed: _restartDiscovery,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(0.0),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6.0)),
                  ),
                  child: Ink(
                    decoration: const BoxDecoration(
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                      color: const Color(0xFF63B6EE),
                    ),
                    child: Container(
                      height: 23,
                      padding: const EdgeInsets.all(5),
                      margin: const EdgeInsets.all(10),
                      child: FittedBox(
                        child: Text(
                          '   Scan   ',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ),
              )
          ),
          ValueListenableBuilder(
              valueListenable: _connectionStatusText,
              builder: (BuildContext context, String value, Widget? child) {
                return Flexible(
                    flex: 1,
                    child: ElevatedButton(
                      onPressed: _connectDisconnectButtonPress,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(0.0),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6.0)),
                      ),
                      child: Ink(
                        decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.all(Radius.circular(5.0)),
                          color: (value ==
                              AppConstants.CONNECTION_STATUS_CONNECTED) ? Color(
                              0xFFD32F2F) : Color(0xFF61d800),
                        ),
                        child: Container(
                          height: 23,
                          padding: const EdgeInsets.all(5),
                          margin: const EdgeInsets.all(10),
                          child: FittedBox(
                            child: Text(
                              (value ==
                                  AppConstants.CONNECTION_STATUS_CONNECTED)
                                  ? "Disconnect"
                                  : " Connect ",
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                );
              }
          ),

        ],
      ),
    );
  }

  // Shows the Cards with Sensor Values
  Widget _getDataView() {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(15.0,),
        height: 300,
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          border: Border.all(color: AppColors.instance.blueBorderColor, width: 2),
          borderRadius: const BorderRadius.all(Radius.circular(4)),
          // color: AppColors.instance.translucentWhite,
          boxShadow: const [ BoxShadow(
            color:  Color(0x508EC7D7),
            blurRadius: 2,
            spreadRadius: 1,
            offset: Offset(0.0, 1.0), // shadow direction: bottom right
          ),
          ],
        ),
        child: ValueListenableBuilder(
            valueListenable: _messageBuffer,
            builder: (BuildContext context, String? value,
                Widget? child) {
              // DebugUtil.instance.printLog(value);
              String? parsedValue = (value != null) ? (value
                  .isNotEmpty
                  ? _parseBluetoothDataForUse(value)
                  : '') : '';
              return (value == null)
                  ? Container()
                  : Container(
                child: SingleChildScrollView(
                  child: Text(
                      _messageBuffer.value.toString(),
                  ),
                ),
              );
            }
        ),
      ),
    );
  }

  // Card for Sensor Data
  Widget _getDataCardView(String value, String valueOf, String unit) {
    return Container(
      height: 125,
      width: MediaQuery
          .of(context)
          .size
          .width / 3.7,
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.all(3.5),
      decoration: const BoxDecoration(
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.all(Radius.circular(5.0)),
        color: const Color(0xFF80D3FF),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          FittedBox(
            child: Row(
              children: [
                Text(
                  (value.isNotEmpty) ? value : '-',
                  style: TextStyle(fontSize: 40, color: Colors.white),
                ),
                Text(
                  (value.isNotEmpty) ? unit : ' --',
                  style: TextStyle(fontSize: 12, color: Colors.white),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: FittedBox(
              alignment: Alignment.bottomCenter,
              fit: BoxFit.contain,
              child: Text(
                valueOf,
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Functions
  void _restartDiscovery() {
    _setCurrentBluetoothState();
    _startDiscovery();
  }

  void _startDiscovery() async {
    Future.delayed(const Duration(milliseconds: 650), () async {
      if (_bluetoothEnabled.value) {
        var status = await Permission.locationWhenInUse.request();
        if (status.isPermanentlyDenied || status.isDenied || status.isDenied) {
          CommonUtil.instance.showToast(
              context,
              'Provide Location Permission to Search for Bluetooth Devices');
        } else {
          _discoveryResults.value.clear();
          _discoveryResults.value.add(_emptyBtDevice);
          _isDiscovering.value = true;
          setState(() {});
          // onStartLoadingBluetoothDevices();
          _streamSubscription =
              FlutterBluetoothSerial.instance.startDiscovery().listen((r) {
                _discoveryResults.value.add(r);
                DebugUtil.instance.printLog(msg :
                "Name:${r.device.name.toString()} \nType:${r.device.type
                    .toString()} \nAddress:${r.device.address
                    .toString()} \nisBonded: ${r.device.isBonded
                    .toString()} \nisConnected: ${r.device.isConnected
                    .toString()} ");
              });
          _streamSubscription?.onDone(() {
            // onStopLoading();
            _isDiscovering.value = false;
            setState(() {});
          });
        }
      } else {
        CommonUtil.instance.showToast(
            context, 'Enable Bluetooth to Search for Devices');
      }
    });
  }

  void _selectDevice(String value) {
    DebugUtil.instance.printLog(msg : "Selected: " + value);
    _btDropdownValue.value = value;
    _selectedDeviceMacAddress =
        RegExp(r'\[(.*?)\]').stringMatch(value).toString().replaceAll('[', '')
            .replaceAll(']', '')
            .trim();
    DebugUtil.instance.printLog(msg :
    "Selected MacAddress: " + _selectedDeviceMacAddress);

    setState(() {});
  }

  bool _setCurrentBluetoothState() {
    // Get current state
    FlutterBluetoothSerial.instance.state.then((state) {
      _bluetoothState.value = state;
      _bluetoothEnabled.value = _bluetoothState.value.isEnabled;
    });
    return _bluetoothEnabled.value;
  }

  void _connectDisconnectButtonPress() {
    (_connectionStatusText.value == AppConstants.CONNECTION_STATUS_CONNECTED &&
        _connection != null && _connection!.isConnected)
        ? _disconnectSelectedDevice()
        : _connectToSelectedDevice();
  }

  void _connectToSelectedDevice() {
    if (CommonUtil.instance.isRedundantClick(DateTime.now())) {}
    else {
      if (_selectedDeviceMacAddress == 'null' ||
          _selectedDeviceMacAddress.isEmpty) {
        CommonUtil.instance.showToast(context, 'Select a Bluetooth device');
      }
      else {
        DebugUtil.instance.printLog(msg : 'Connecting');
        // CommonUtil.instance.showToast(context, 'Connecting');
        _connectionStatusText.value = AppConstants.CONNECTION_STATUS_CONNECTING;
        _connectionStatusColor.value = Colors.orange;
        setState(() {});

        BluetoothConnection.toAddress(_selectedDeviceMacAddress).then((
            connection) {
          DebugUtil.instance.printLog(msg : 'Connected to the device');
          // CommonUtil.instance.showToast(context, CONNECTION_STATUS_CONNECTED);
          _connectionStatusText.value =
              AppConstants.CONNECTION_STATUS_CONNECTED;
          _connectionStatusColor.value = Colors.green;

          _connection = connection;
          setState(() {});

          _connection?.input?.listen(_onDataReceived).onDone(() {});

        }).catchError((error) {
          DebugUtil.instance.printLog(msg : 'Cannot connect, exception occurred');
          DebugUtil.instance.printLog(msg : 'Error: ' + error.toString());
          _connectionStatusText.value = AppConstants.CONNECTION_STATUS_FAILED;
          _connectionStatusColor.value = Colors.red;
          setState(() {});
        });
      }
    }
  }

  void _disconnectSelectedDevice() {
    _connection?.close();
    _connectionStatusText.value = AppConstants.CONNECTION_STATUS_DISCONNECTED;
    _connectionStatusColor.value = Colors.red;
  }

  void _onDataReceived(Uint8List data) {
    // Allocate buffer for parsed data
    int backspacesCounter = 0;
    data.forEach((byte) {
      if (byte == 8 || byte == 127) {
        backspacesCounter++;
      }
    });
    Uint8List buffer = Uint8List(data.length - backspacesCounter);
    int bufferIndex = buffer.length;

    // Apply backspace control character
    backspacesCounter = 0;
    for (int i = data.length - 1; i >= 0; i--) {
      if (data[i] == 8 || data[i] == 127) {
        backspacesCounter++;
      } else {
        if (backspacesCounter > 0) {
          backspacesCounter--;
        } else {
          buffer[--bufferIndex] = data[i];
        }
      }
    }

    // Create message if there is new line character
    String dataString = String.fromCharCodes(buffer);
    int index = buffer.indexOf(0);

    if (~index != 0) {
      _messageBuffer.value = dataString.substring(index).toString();
    } else {
      if (_messageBuffer.value != null) {
        _messageBuffer.value =
        (backspacesCounter > 0
            ? _messageBuffer.value!.substring(
            0, _messageBuffer.value!.length - backspacesCounter)
            : (_messageBuffer.value! + dataString)
        ).split('\r\n')[0];
      }
    }
    _messageBuffer.value = _messageBuffer.value.toString();
  }

  void _bluetoothToggle(bool value) {
    if (!CommonUtil.instance.isRedundantClick(DateTime.now())) {
      future() async {
        try {
          if (value) {
            _bluetoothEnabled.value =
            (await FlutterBluetoothSerial.instance.requestEnable())!;
          } else {
            _bluetoothEnabled.value =
            (await FlutterBluetoothSerial.instance.requestDisable())!;
          }
        } catch (e) {
          DebugUtil.instance.printLog(msg : e);
        }
      }
      future().then((_) {
        Future.delayed(const Duration(milliseconds: 650), () {
          _setCurrentBluetoothState();
          DebugUtil.instance.printLog(msg : _bluetoothEnabled.value);
          _startDiscovery();
        });
      });
    }
  }

  String? _parseBluetoothDataForUse(String? value) {
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

  String _getValueFromBTDataLine(String? value, int index) {
    if (value != null) {
      if (','
          .allMatches(value)
          .length > index && value != '') {
        return value.split(",")[index].replaceAll(RegExp('[a-zA-Z:]'), '');
      } else {
        return '';
      }
    } else
      return '';
  }

}
