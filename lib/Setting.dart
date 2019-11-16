import 'package:http/http.dart' as http;
import 'Global.dart';

class IntSetting {
  var name;
  int current;
  int max;
  int min;
  int standart;
  String endpoint;

  void setSetting() {
    var url = endpoint2 + "setSetting";
    var body2 = '{"Effect": "' +
        this.endpoint +
        '", "' +
        name +
        '": "' +
        this.current.toString() +
        '"';
    body2 += '}';

    print(body2);

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

  IntSetting(this.max, this.min, this.standart, this.name, this.endpoint)
      : current = standart;
}
