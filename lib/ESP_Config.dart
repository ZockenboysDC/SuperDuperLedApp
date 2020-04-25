import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import './main.dart';

String numberValidator(String value, int max, int min) {
  if (value == null) return 'Bitte gebe etwas ein';
  final n = num.tryParse(value);
  if (n == null) return 'Bitte gebe etwas ein';
  if (n < min) return 'Zu kurz';
  if (n > max) return 'Zu lang';
  return null;
}

String stringValidator(String value, int max, int min) {
  if (value == null) return 'Bitte gebe etwas ein';
  if (value.length <= min) return 'Zu kurz';
  if (value.length > max) return 'Zu lang';
  return null;
}

// Classes for all the settings
// {
//     "e": [
//         {
//             "t": "i",
//             "mn": "1",
//             "mx": "999",
//             "n": "Led Anzahl",
//             "e":"l"
//         },
//         {
//             "t": "s",
//             "mn": "4",
//             "mx": "25",
//             "n": "Passwort",
//             "e":"p"
//         }
//     ]
// }
class String_Setting {
  final String min;
  final String max;
  final String name;
  final String endpoint;
  final TextFormField con;
  final TextEditingController controller = new TextEditingController();

  String_Setting({this.endpoint, this.name, this.max, this.min, this.con});

  String_Setting fromJson(Map<String, dynamic> responseJson) {
    return String_Setting(
      min: responseJson['mn'],
      max: responseJson['mx'],
      name: responseJson['n'],
      endpoint: responseJson['e'],
      con: new TextFormField(
        controller: controller,
        validator: (value) {
          return stringValidator(value, int.parse(responseJson['mx']),
              int.parse(responseJson['mn']));
        },
        maxLength: int.parse(responseJson['mx']),
        autovalidate: true,
        decoration: InputDecoration(labelText: responseJson['n']),
      ),
    );
  }
}

class Int_Setting {
  final String min;
  final String max;
  final String name;
  final String endpoint;
  final TextFormField con;
  final TextEditingController controller = new TextEditingController();

  Int_Setting({this.endpoint, this.name, this.max, this.min, this.con});

  Int_Setting fromJson(Map<String, dynamic> responseJson) {
    return Int_Setting(
      min: responseJson['mn'],
      max: responseJson['mx'],
      name: responseJson['n'],
      endpoint: responseJson['e'],
      con: new TextFormField(
          controller: controller,
          autovalidate: true,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(labelText: responseJson['n']),
          inputFormatters: <TextInputFormatter>[
            WhitelistingTextInputFormatter.digitsOnly
          ],
          validator: (value) {
            return numberValidator(value, int.parse(responseJson['mx']),
                int.parse(responseJson['mn']));
          }),
    );
  }
}

class esp_config extends StatefulWidget {
  final String ip;

  esp_config({@required this.ip});
  @override
  esp_configState createState() => esp_configState(ipString: ip);
}

class esp_configState extends State<esp_config> {
  final String ipString;
  InternetAddress ip;
  List<Int_Setting> int_Setting = [];
  List<String_Setting> string_Setting = [];

  esp_configState({Key key, @required this.ipString});

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance
        .addPostFrameCallback((_) => {jsontoWidget(ipString)});
  }

  void jsontoWidget(String ip) {
    var url = "http://" + ip + "/getSettings";

    Map<String, String> headers = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
    };

    try {
      http.get(url, headers: headers).then((http.Response response) {
        if (response.statusCode == 200) {
          final responseJson = json.decode(response.body);
          var list = responseJson['e'] as List;

          setState(() {
            for (int i = 0; i < list.length; i++) {
              if (list[i]["t"] == "i") {
                int_Setting.add(Int_Setting().fromJson(list[i]));
              } else if (list[i]["t"] == "s") {
                string_Setting.add(String_Setting().fromJson(list[i]));
              }
            }
          });
        } else {
          EasyLoading.showError("Konnte Einstellungen nicht bekommen");
          new Future.delayed(
              const Duration(seconds: 5), () => EasyLoading.dismiss());
        }
      });
    } catch (e) {
      EasyLoading.showError(e.toString());
      new Future.delayed(
          const Duration(seconds: 5), () => EasyLoading.dismiss());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("ESP Konfigurieren...")),
      body: Container(
        width: MediaQuery.of(context).size.width - 16,
        height: MediaQuery.of(context).size.height - 16,
        margin: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: new BorderRadius.circular(15.0),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              child: new ListView.builder(
                itemCount: string_Setting.length + int_Setting.length,
                itemBuilder: (context, index) {
                  String_Setting item;
                  Int_Setting item2;
                  if (index < string_Setting.length) {
                    item = string_Setting[index];
                    return Container(
                      padding: const EdgeInsets.all(8.0),
                      child: new Card(
                        color: Theme.of(context).secondaryHeaderColor,
                        child: Container(
                            padding: EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 8.0),
                            child: item.con),
                      ),
                    );
                  } else {
                    item2 = int_Setting[index - string_Setting.length];
                    return Container(
                      padding: const EdgeInsets.all(8.0),
                      child: new Card(
                        color: Theme.of(context).secondaryHeaderColor,
                        child: Container(
                            padding: EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 8.0),
                            child: item2.con),
                      ),
                    );
                  }
                },
              ),
            ),
            RaisedButton(
              onPressed: () {
                bool valid = false;
                var body = '{';

                Map<String, String> headers = {
                  'Content-type': 'application/json',
                  'Accept': 'application/json',
                };

                for (int i = 0;
                    i < string_Setting.length + int_Setting.length;
                    i++) {
                  if (i < string_Setting.length) {
                    // Go over Strings
                    String error = stringValidator(
                        string_Setting[i].con.controller.text,
                        int.parse(string_Setting[i].max),
                        int.parse(string_Setting[i].min));

                    if (error == null) {
                      valid = true;
                      body += '"' +
                          string_Setting[i].endpoint +
                          '": "' +
                          string_Setting[i].con.controller.text +
                          '",';
                    } else {
                      EasyLoading.showError(error);
                      Future.delayed(const Duration(seconds: 1),
                          () => EasyLoading.dismiss());
                      valid = false;
                      break;
                    }
                  } else {
                    // Go over ints
                    int minus = i - string_Setting.length;
                    String error = numberValidator(
                        int_Setting[minus].con.controller.text,
                        int.parse(int_Setting[minus].max),
                        int.parse(int_Setting[minus].min));

                    if (error == null) {
                      valid = true;
                      body += '"' +
                          int_Setting[minus].endpoint +
                          '": ' +
                          int_Setting[minus].con.controller.text +
                          ',';
                    } else {
                      EasyLoading.showError(error);
                      Future.delayed(const Duration(seconds: 1),
                          () => EasyLoading.dismiss());
                      valid = false;
                      break;
                    }
                  }
                }
                if (valid) {
                  EasyLoading.showSuccess("Bitte warte noch kurz");
                  try {
                    http
                        .post("http://" + ipString + '/setSettings',
                            body: body.substring(0, body.length - 1) + '}',
                            headers: headers)
                        .then((http.Response response) {
                      // TODO: ON SUCCESS ADD TO FILE
                      if (response.body == "f") {
                        EasyLoading.showSuccess("Hat Funktoniert");
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    HomePage()),
                            ModalRoute.withName('/'),
                          );
                      }
                    }).timeout((const Duration(seconds: 60)));
                  } catch (e) {
                    EasyLoading.showSuccess("Bitte warte noch kurz");
                    Future.delayed(const Duration(seconds: 5),
                        () => {EasyLoading.dismiss()});
                  }
                }
              },
              child: Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}
