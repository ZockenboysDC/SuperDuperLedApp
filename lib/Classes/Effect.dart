import 'IntSetting.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class Effect {
  String name;
  int id;

  List<IntSetting> intsettings = [];

  Effect({this.name, this.id});

  void init(ip) async  {
    var url = "http://" + ip + "/getsettingofFunction";
    var body2 = '{"i": "' + this.id.toString() + '"}';

    Map<String, String> headers = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
    };

    http
        .post(url, body: body2, headers: headers)
        .then((http.Response response) {
      Map decoded = jsonDecode(response.body);
      decoded["e"].forEach((ef) => {
            this.intsettings.add(new IntSetting(
                max: int.parse(ef["mx"]),
                min: int.parse(ef["mn"]),
                standart: int.parse(ef["s"]),
                name: ef["n"],
                endpoint: ef["e"],
                current: ef["v"])),
          });
      EasyLoading.dismiss();
    });
  }

  void turnOn(ip) async {
    var url = "http://" + ip + "/set";
    var body2 = '{"i": "' + this.id.toString() + '"}';

    Map<String, String> headers = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
    };

    print(body2);

    http
        .post(url, body: body2, headers: headers)
        .then((http.Response response) {});
  }

  void setSettings(ip, setting) async {
    print("Setting: " + setting.endpoint);
    var url = "http://" + ip + "/seteffectset";
    var body2 = '{"i": "' + this.id.toString() + '",';
    body2 += '"' + setting.endpoint + '": "' + setting.current.toString() + '"';
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
}
