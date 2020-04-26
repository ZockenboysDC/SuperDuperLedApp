import 'Effect.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ESP {
  String name;
  String macAdress;
  String type;
  String ip;

  List<Effect> effects = [];

  ESP(this.name, this.macAdress, this.type, this.ip) : super();

  init() async {
    var url = "http://" + this.ip + "/getallFunctions";

    http.get(url).then((http.Response response) {
      Map decoded = jsonDecode(response.body);
      decoded["e"].forEach((ef) => {
            this.effects.add(new Effect(name: ef["n"], id: ef["id"])),
            this.effects[ef["id"]].init(this.ip),
          });
    });
  }

  oN() async {
    var url = "http://" + this.ip + "/on";

    http.get(url);
  }

  oFF() async {
    var url = "http://" + this.ip + "/off";

    http.get(url);
  }
}
