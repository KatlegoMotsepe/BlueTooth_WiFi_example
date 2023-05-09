import 'dart:convert' show jsonDecode;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:wifi_scan/wifi_scan.dart';
import 'Singleton.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<WiFiAccessPoint> wifiResults = [];
  List<ScanResult> bluetoothResults = [];

  @override
  void initState() {
    super.initState();
    final scanWifi = ScanWifi();
    final scanBlue = ScanBlue();
    final environemnt = EnvironmentConfig();

    if (environemnt.showWifi) {
      scanWifi.scanWifi().then((results) {
        setState(() {
          wifiResults = results;
        });
      });
    }

    if (environemnt.showBluetooth) {
      scanBlue.scanBluetooth().then((results) {
        setState(() {
          bluetoothResults = results;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final condition = Environment().Conditions();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Learning Flutter'),
      ),
      body: Column(
        children: <Widget>[
          const Text(
            "                           ",
            style: TextStyle(fontSize: 11),
          ),
          const Text(
            "Current conditions: ",
            style:
                TextStyle(fontSize: 22, decoration: TextDecoration.underline),
          ),
          const Text(
            "                           ",
            style: TextStyle(fontSize: 5),
          ),
          Text(
            condition,
            style: const TextStyle(fontSize: 25),
          ),
          const Divider(
            height: 20,
            thickness: 7,
            indent: 0,
            endIndent: 0,
            color: Color.fromARGB(95, 203, 116, 44),
          ),
          const Text(
            "                           ",
            style: TextStyle(fontSize: 7),
          ),
          const Text(
            "WiFi :",
            style:
                TextStyle(fontSize: 22, decoration: TextDecoration.underline),
          ),
          const Text(
            "                           ",
            style: TextStyle(fontSize: 7),
          ),
          Expanded(
            child: Container(
              color: const Color.fromARGB(54, 48, 201, 71),
              child: ListView.builder(
                itemCount: wifiResults.length,
                itemBuilder: (context, index) {
                  final wifiresults = wifiResults[index];
                  return Card(
                    child: ListTile(
                      title: Text(wifiresults.ssid),
                      subtitle: Text(wifiresults.bssid),
                      onLongPress: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => WiFiInfo(
                                index: wifiresults.ssid, device: wifiresults),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ),
          const Text(
            "                           ",
            style: TextStyle(fontSize: 7),
          ),
          const Text(
            "Bluetooth :",
            style:
                TextStyle(fontSize: 22, decoration: TextDecoration.underline),
          ),
          const Text(
            "                           ",
            style: TextStyle(fontSize: 7),
          ),
          Expanded(
            child: Container(
              color: const Color.fromARGB(54, 48, 107, 201),
              child: ListView.builder(
                itemCount: bluetoothResults.length,
                itemBuilder: (context, index) {
                  final bluetootresults = bluetoothResults[index];
                  return Card(
                    child: ListTile(
                      title: Text(bluetootresults.device.name),
                      subtitle: Text(bluetootresults.device.id.id),
                      onLongPress: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BluetoothInfo(
                              index: bluetootresults.device.name,
                              device: bluetootresults,
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ),
          const Text(
            "                           ",
            style: TextStyle(fontSize: 11),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ApiPage()),
              );
            },
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(
                    const Color.fromARGB(255, 255, 206, 165))),
            child: const Text("API Page"),
          ),
          const Text(
            "                           ",
            style: TextStyle(fontSize: 11),
          ),
        ],
      ),
    );
  }
}

class WiFiInfo extends StatelessWidget {
  final String index;
  final WiFiAccessPoint device;

  const WiFiInfo({Key? key, required this.index, required this.device})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Information about: $index"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              "                   ",
              style: TextStyle(fontSize: 22),
            ),
            Text(
              "WiFi name : $index",
              style: const TextStyle(fontSize: 20),
              textAlign: TextAlign.left,
            ),
            const Text(
              "                           ",
              style: TextStyle(fontSize: 11),
            ),
            Text(
              "Accessopoint address : ${device.bssid}",
              style: const TextStyle(fontSize: 20),
              textAlign: TextAlign.left,
            ),
            const Text(
              "                           ",
              style: TextStyle(fontSize: 11),
            ),
            Text(
              "BandWidth : ${device.channelWidth}",
              style: const TextStyle(fontSize: 20),
              textAlign: TextAlign.left,
            ),
            const Text(
              "                           ",
              style: TextStyle(fontSize: 11),
            ),
            Text(
              "Standard : ${device.standard}",
              style: const TextStyle(fontSize: 20),
              textAlign: TextAlign.left,
            ),
            const Text(
              "                           ",
              style: TextStyle(fontSize: 11),
            ),
            Text(
              "Capabiities : ${device.capabilities}",
              style: const TextStyle(fontSize: 20),
              textAlign: TextAlign.left,
            ),
            const Text(
              "                           ",
              style: TextStyle(fontSize: 11),
            ),
            Text(
              "Frequency : ${device.frequency}",
              style: const TextStyle(fontSize: 20),
              textAlign: TextAlign.left,
            ),
            const Text(
              "                           ",
              style: TextStyle(fontSize: 11),
            ),
          ],
        ),
      ),
    );
  }
}

class BluetoothInfo extends StatelessWidget {
  final String index;
  final ScanResult device;

  const BluetoothInfo({Key? key, required this.index, required this.device})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Information about: $index"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              "                   ",
              style: TextStyle(fontSize: 22),
            ),
            Text(
              "Device name : $index",
              style: const TextStyle(fontSize: 20),
              textAlign: TextAlign.left,
            ),
            const Text(
              "                           ",
              style: TextStyle(fontSize: 11),
            ),
            Text(
              "Device id : ${device.device.id}",
              style: const TextStyle(fontSize: 20),
              textAlign: TextAlign.left,
            ),
            const Text(
              "                           ",
              style: TextStyle(fontSize: 11),
            ),
            Text(
              "Device type : ${device.device.type.name}",
              style: const TextStyle(fontSize: 20),
              textAlign: TextAlign.left,
            ),
            const Text(
              "                           ",
              style: TextStyle(fontSize: 11),
            ),
          ],
        ),
      ),
    );
  }
}

class ApiPage extends StatefulWidget {
  const ApiPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ApiPageState createState() => _ApiPageState();
}

class _ApiPageState extends State<ApiPage> {
  List data = [];
  List<bool> isSelected = [];
  @override
  void initState() {
    super.initState();
    getData();
  }

  Future<void> getData() async {
    var url = Uri.parse(
        'https://www.belgiumcampus.ac.za/portalapi/api/Tablet/Marketers'
            .trim());

    var response = await http.get(url);

    if (response.statusCode == 200) {
      setState(() {
        data = jsonDecode(response.body);
        isSelected = List.generate(data.length, (_) => false);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 206, 165),
      appBar: AppBar(
        title: const Text("These are the marketers"),
      ),
      // ignore: unnecessary_null_comparison
      body: data != null
          ? ListView.builder(
              itemCount: data.length,
              itemBuilder: (BuildContext context, int index) {
                return Card(
                  child: CheckboxListTile(
                    title: Text(data[index]['Name']),
                    // ignore: prefer_interpolation_to_compose_strings
                    subtitle: Text("Id : " + data[index]["Id"]),
                    value: isSelected[index],
                    onChanged: (bool? value) {
                      setState(() {
                        isSelected[index] = value!;
                      });
                    },
                  ),
                );
              },
            )
          : const Center(child: CircularProgressIndicator()),
    );
  }
}
