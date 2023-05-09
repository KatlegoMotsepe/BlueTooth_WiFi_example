import 'package:flutter_blue/flutter_blue.dart';
import 'package:wifi_scan/wifi_scan.dart';
import 'dart:async';

class EnvironmentConfig {
  final showBluetooth = const bool.fromEnvironment("showBluetooth");
  final showWifi = const bool.fromEnvironment("showWifi");
}

class Environment {
  Environment._();

  final environemnt = EnvironmentConfig();

  String conditon = "";

  static final Environment _instance = Environment._();
  static Environment get instance => _instance;

  factory Environment() {
    return _instance;
  }

  String Conditions() {
    if (environemnt.showBluetooth && environemnt.showWifi) {
      conditon = "Bluetooth = on & WiFi = on";
    } else if (!environemnt.showBluetooth && !environemnt.showWifi) {
      conditon = "Bluetooth = off & WiFi = off";
    } else if (environemnt.showBluetooth && !environemnt.showWifi) {
      conditon = "Bluetooth = on & WiFi = off";
    } else if (environemnt.showWifi && !environemnt.showBluetooth) {
      conditon = "Bluetooth = off & WiFi = on";
    }

    return conditon;
  }
}

class ScanWifi {
  static final ScanWifi _instance = ScanWifi._internal();

  factory ScanWifi() {
    return _instance;
  }

  ScanWifi._internal();
  Future<List<WiFiAccessPoint>> scanWifi() async {
    final can =
        await WiFiScan.instance.canGetScannedResults(askPermissions: true);
    switch (can) {
      case CanGetScannedResults.yes:
        return await WiFiScan.instance.getScannedResults();
      default:
        return <WiFiAccessPoint>[];
    }
  }
}

class ScanBlue {
  static final ScanBlue _instance = ScanBlue._internal();

  factory ScanBlue() {
    return _instance;
  }

  ScanBlue._internal();

  Future<List<ScanResult>> scanBluetooth() async {
    FlutterBlue flutterBlue = FlutterBlue.instance;
    return await flutterBlue.startScan(timeout: Duration(seconds: 4));
  }
}
