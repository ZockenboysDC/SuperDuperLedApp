import 'package:flutter/material.dart';
import 'package:super_duper_led_app/AppBar.dart';
import 'package:http/http.dart' as http;

var endpoint2 = 'http://192.168.178.51/'; // 192.168.178.51 // 192.168.100.203

class Choose extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white54,
      appBar: AppbarChoose().build(context),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            child: Text('Work in Progress'),
            /*padding: EdgeInsets.fromLTRB(0, 40, 0, 10),
            child: TextField(
              decoration: new InputDecoration(
                hintText: 'Type here the IP of the ESP z.B: 192.168.178.51',
                contentPadding: EdgeInsets.fromLTRB(10, 0, 10, 0),
              ),
              onSubmitted: (sub) {
                if (sub != null) {
                  var c = "http://" + sub + "/";
                  var url = c + "test";

                  Map<String, String> headers = {
                    'Content-type': 'application/json',
                    'Accept': 'application/json',
                  };
                  try {
                    http
                        .get(url, headers: headers)
                        .then((http.Response response) {
                      if (response.body == 'Worked') {
                        endpoint2 = c;
                        Navigator.of(context).pop();
                      }
                    });
                  } catch (e) {
                    print('Mäh');
                  }
                }
              },
            ),*/
          ),
        ],
      ),
    );
  }
}
