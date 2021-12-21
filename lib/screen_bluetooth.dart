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
  final ValueNotifier<String> _btDropdownValue = ValueNotifier(_SELECT_BLUETOOTH_DEVICE); // Shows the value of the selected dropdown option
  ValueNotifier<String> _selectedDeviceMacAddress = ValueNotifier("");

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
    _presenter = BtScreenPresenter(context, _setStateCall);
    _restartDiscovery();
  }

  @override
  void dispose() {
    _connection?.dispose();
    if (_streamSubscription != null) {
      _streamSubscription?.cancel();
    }
    if (EasyLoading.isShow) {
      EasyLoading.dismiss();
    }

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
    _selectedDeviceMacAddress.dispose();
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
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              _getConnectedDeviceView(),
              _getBluetoothPairedDeviceConnectView(),
              _getDataView(),
            ],
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
      iconTheme: const IconThemeData(
        color: Colors.black,
      ),
      title: const FittedBox(
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
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
          TextButton(
            onPressed: _clearReading,
            child: const Text(
              'Clear All'
            ),
          )
        ],
      ),
    );
  }

  // Shows the Cards with Sensor Values
  Widget _getDataView() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(left: 15.0, right: 15.0, bottom: 15.0,),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(15.0,),
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
                    : SingleChildScrollView(
                      child: Text(
                          _messageBuffer.value.toString(),
                      ),
                    );
              }
          ),
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
  void _selectDevice(String value) {
    _presenter.selectDevice(value: value, selectedDeviceMacAddress: _selectedDeviceMacAddress, btDropdownValue: _btDropdownValue,);
    // setState(() {});
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
    } else {
      return '';
    }
  }

  void _clearReading() {
    _presenter.clearReading(_messageBuffer);
  }

  void _bluetoothToggle(bool value) {
    _presenter.toggleBluetooth(
      value: value,
      bluetoothEnabled: _bluetoothEnabled,
      bluetoothState: _bluetoothState,
      emptyBtDevice: _emptyBtDevice,
      isDiscovering: _isDiscovering,
      discoveryResults: _discoveryResults,
      streamSubscription: _streamSubscription,
    );
    setState(() {});
  }

  bool _setCurrentBluetoothState() {
    // Get current state
    return _presenter.currentBluetoothStateEnabled(bluetoothEnabled: _bluetoothEnabled, bluetoothState: _bluetoothState);
  }

  void _restartDiscovery() {
    _setCurrentBluetoothState();
    _startDiscovery();
  }

  void _startDiscovery() async {
    _presenter.startDiscovery(
      bluetoothEnabled: _bluetoothEnabled,
      isDiscovering: _isDiscovering,
      streamSubscription: _streamSubscription,
      discoveryResults: _discoveryResults,
      emptyBtDevice: _emptyBtDevice,
    );
  }

  void _connectDisconnectButtonPress() {
    (_connectionStatusText.value == AppConstants.CONNECTION_STATUS_CONNECTED &&
        _connection != null && _connection!.isConnected)
        ? _disconnectSelectedDevice()
        : _connectToSelectedDevice();
  }

  void _connectToSelectedDevice() {
    if (!CommonUtil.instance.isRedundantClick(DateTime.now())) {
      if (_selectedDeviceMacAddress == 'null' ||
          _selectedDeviceMacAddress.value.isEmpty) {
        CommonUtil.instance.showToast(context, 'Select a Bluetooth device');
      }
      else {
        DebugUtil.instance.printLog(msg : 'Connecting');
        _connectionStatusText.value = AppConstants.CONNECTION_STATUS_CONNECTING;
        _connectionStatusColor.value = Colors.orange;
        setState(() {});

        BluetoothConnection.toAddress(_selectedDeviceMacAddress.value).then((
            connection) {
          DebugUtil.instance.printLog(msg : 'Connected to the device');
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
          CommonUtil.instance.showToast(context, 'Please make sure you have enabled Bluetooth');
          setState(() {});
        });
      }
    }
  }

  void _disconnectSelectedDevice() {
    _connection?.close();
    _connectionStatusText.value = AppConstants.CONNECTION_STATUS_DISCONNECTED;
    _connectionStatusColor.value = Colors.red;
    setState(() {});
  }

  void _onDataReceived(Uint8List data) {
    _presenter.onDataReceived(data: data, messageBuffer: _messageBuffer);
  }

  String? _parseBluetoothDataForUse(String? value) {
    _presenter.parseBluetoothDataForUse(value);
  }

  _setStateCall() {
    setState(() {});
  }

}
