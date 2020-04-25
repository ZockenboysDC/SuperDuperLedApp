import 'dart:async';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:smartconfig/smartconfig.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart' as http;
import 'package:super_duper_led_app/ESP_Config.dart';
import 'package:super_duper_led_app/ESP_Search.dart';

class esp_touch_widget extends StatefulWidget {
  @override
  esp_touch_widgetstate createState() => esp_touch_widgetstate();
}

class esp_touch_widgetstate extends State<esp_touch_widget> {
  final Connectivity _connectivity = Connectivity();

  final _ssidcon = TextEditingController();
  final _bssidcon = TextEditingController();
  final _passwordcon = TextEditingController();

  String _ssid = "";
  String _bssid = "";
  String _password = "";
  String _msg = "";

  @override
  void initState() {
    super.initState();

    _ssidcon.addListener(_ssidListen);
    _bssidcon.addListener(_bssidListen);
    _passwordcon.addListener(_passwordListen);
  }

  @override
  void dispose() {
    _ssidcon.dispose();
    _bssidcon.dispose();
    _passwordcon.dispose();
    super.dispose();
  }

  void _ssidListen() {
    if (_ssidcon.text.isEmpty) {
      _ssid = "";
    } else {
      _ssid = _ssidcon.text;
    }
  }

  void _bssidListen() {
    if (_bssidcon.text.isEmpty) {
      _bssid = "";
    } else {
      _bssid = _bssidcon.text;
    }
  }

  void _passwordListen() {
    if (_passwordcon.text.isEmpty) {
      _password = "";
    } else {
      _password = _passwordcon.text;
    }
  }

  Future<void> _configureEsp() async {
    String output = "";

    try {
      if (_ssid == "") throw Exception("Bitte gebe eine SSID ein.");
      if (_bssid == "") throw Exception("Bitte gebe eine BSSID ein.");
      const Duration _kLongTimeout = const Duration(seconds: 70);

      EasyLoading.show(status: 'Laden...\nDies kann bis zu 1 Minute dauern');

      // Set Smartconfig
      var result = await Smartconfig.start(_ssid, _bssid, _password)
          .timeout(_kLongTimeout);

      String ip = result.toString().split(" ")[1].split("}")[0];

      var url = "http://" + ip + "/setWiFi";
      var body2 = '{"w": "' + _ssid + '","p": "' + _password + '"}';

      Map<String, String> headers = {
        'Content-type': 'application/json',
        'Accept': 'application/json',
      };
      print(body2);
      EasyLoading.dismiss();
      EasyLoading.showInfo("Bitte warte noch maximal 30 Minuten");

      await Future.delayed(const Duration(seconds: 4));

      http
          .post(url, body: body2, headers: headers)
          .timeout(const Duration(seconds: 80))
          .then((http.Response response) {
        print(response.body);
        if (response.body == "f") {
          EasyLoading.dismiss();
          EasyLoading.showSuccess("Funkt");
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => esp_search()),
            ModalRoute.withName('/'),
          );
        } else {
          throw Exception("Bitte nochmal versuchen");
        }
      });
    } on Exception catch (e) {
      output = "Konnte nicht einstellen: '${e}' Bitte versuche es erneut";
      EasyLoading.dismiss();
      EasyLoading.showError(output);
      new Future.delayed(
          const Duration(seconds: 5), () => EasyLoading.dismiss());
    }

    setState(() {
      _msg = output;
    });
  }

  Future<void> _getConnectedWiFiInfo() async {
    String ssid = "";
    String bssid = "";
    String msg = "";

    try {
      bssid = await (_connectivity.getWifiBSSID());
      ssid = await (_connectivity.getWifiName());

      msg = 'Verbunden mit $ssid. bssid ist $bssid';

      var connectivityResult = await (_connectivity.checkConnectivity());

      if (connectivityResult == ConnectivityResult.mobile) {
        msg += "Verbunden mit einem mobilen Netzwerk. Funktoniert damit nicht!";
      }
    } on Exception catch (e) {
      msg = "Konnte WiFi Daten nicht ermitteln: '${e}'.";
    }

    setState(() {
      _ssidcon.text = ssid;
      _bssidcon.text = bssid;

      _msg = msg;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ESP WIFI konfigurieren...'),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width - 16,
        height: MediaQuery.of(context).size.height - 16,
        margin: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: new BorderRadius.circular(15.0),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: <Widget>[
                TextField(
                  controller: _ssidcon,
                  decoration: new InputDecoration(labelText: 'ssid'),
                ),
                TextField(
                  controller: _bssidcon,
                  decoration: new InputDecoration(labelText: 'bssid'),
                ),
                RaisedButton(
                  child: Text('Bekomme verbundene WiFi Daten'),
                  onPressed: _getConnectedWiFiInfo,
                ),
                TextField(
                  controller: _passwordcon,
                  decoration: new InputDecoration(labelText: 'Passwort'),
                ),
                new RaisedButton(
                  child: new Text('Stelle ESP ein'),
                  onPressed: _configureEsp,
                ),
                Text(_msg),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
