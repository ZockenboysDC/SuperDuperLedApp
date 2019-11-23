import 'package:flutter/material.dart';
import 'package:super_duper_led_app/Global.dart';
import 'package:http/http.dart' as http;

class AppBarTemp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
      backgroundColor: Colors.black,
      title: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            'Super Duper Led App',
            style: TextStyle(
              fontSize: 28.0,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.5,
            ),
          ),
          IconButton(
            iconSize: 30,
            icon: Icon(Icons.file_upload),
            onPressed: () {
              try {
                http.get(endpoint2 + "update").then((http.Response response) {
                  print(response.body.toString());
                });
              } catch (e) {
                print(e.toString());
              }
            },
          ),
        ],
      ),
    );
  }
}

class AppbarChoose extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
      backgroundColor: Colors.black,
      title: Text(
        'Super Duper Led App',
        style: TextStyle(
          fontSize: 30.0,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.5,
        ),
      ),
    );
  }
}
