import 'dart:convert';
import './Setting.dart';
import './BooleanSettin.dart';
import 'package:http/http.dart' as http;
import 'Global.dart';

class Effect {
  String name;
  String endpoint;

  List<IntSetting> intsettings = [];
  List<BoolSetting> boolsettings = [];

  Effect({this.name, this.endpoint, this.intsettings, this.boolsettings});

  void turnOn() {
    var url = endpoint2 + "set";
    var body2 = '{"Effect": "' + this.endpoint + '"}';

    Map<String, String> headers = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
    };

    print(body2);

    try {
    http
        .post(url, body: body2, headers: headers)
        .then((http.Response response) {});
    } catch (e) {
      print(e.toString());
    }
  }

  void setSettings() {
    var url = endpoint2 + "setSetting";
    var body2 = '{"Effect": "' + this.endpoint + '"';
    this.intsettings.forEach((int2) {
      body2 += ',"' + int2.name + '": "' + int2.current.toString() + '"';
      print(body2);
    });
    body2 += '}';

    Map<String, String> headers = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
    };

    try {
      http
          .post(url, body: body2, headers: headers)
          .then((http.Response response) {});
    } catch (e) {
      print(e.toString());
    }
  }

  String getSettings() {
    var url = endpoint2 + "getSetting";
    var body = json.encode({"Effect": this.endpoint});

    Map<String, String> headers = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
    };

    http.post(url, body: body, headers: headers).then((http.Response response) {
      return response.body.toString();
    });
  }
}

class Rainbow extends Effect {
  Rainbow(
      {String name,
      String endpoint,
      List<IntSetting> intsettings,
      List<BoolSetting> boolsettings})
      : super(
            name: name,
            endpoint: endpoint,
            intsettings: intsettings,
            boolsettings: boolsettings);
}

class StaticPalet extends Effect {
  StaticPalet(
      {String name,
      String endpoint,
      List<IntSetting> intsettings,
      List<BoolSetting> boolsettings})
      : super(
            name: name,
            endpoint: endpoint,
            intsettings: intsettings,
            boolsettings: boolsettings);
}

class OFF extends Effect {
  OFF(
      {String name,
      String endpoint,
      List<IntSetting> intsettings,
      List<BoolSetting> boolsettings})
      : super(
            name: name,
            endpoint: endpoint,
            intsettings: intsettings,
            boolsettings: boolsettings);
}

class Visualizer extends Effect {
  Visualizer(
      {String name,
      String endpoint,
      List<IntSetting> intsettings,
      List<BoolSetting> boolsettings})
      : super(
            name: name,
            endpoint: endpoint,
            intsettings: intsettings,
            boolsettings: boolsettings);
}

class Oldvisualizer extends Effect {
  Oldvisualizer(
      {String name,
      String endpoint,
      List<IntSetting> intsettings,
      List<BoolSetting> boolsettings})
      : super(
            name: name,
            endpoint: endpoint,
            intsettings: intsettings,
            boolsettings: boolsettings);
}
