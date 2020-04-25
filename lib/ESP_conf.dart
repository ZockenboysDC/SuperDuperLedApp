import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:super_duper_led_app/ESP_Search.dart';
import 'package:super_duper_led_app/ESP_TOUCH_widget.dart';

class esp_conf extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("ESP hinzufügen..."),
      ),
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
            Container(
              margin: EdgeInsets.all(10),
              child: Text(
                "In den nächsten Schritten fügen sie einen ESP hinzu und/oder konfigurieren ihn.\n Als erstes müssen wir heraus finden ob der ESP mit deinem Netzwerk verbunden ist. Wenn die LEDs, die am ESP angeschlossen sind Blau blinken, ist er nicht mit dem Netzwerk verbunden. Wenn dies der Fall ist drücke bitte auf den Button \"Ja\", wenn nicht dann auf \"Nein.\"",
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.w500),
                textAlign: TextAlign.center,
              ),
            ),
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.fromLTRB(10, 0, 5, 10),
                      child: RaisedButton(
                        onPressed: () {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    esp_touch_widget()),
                            ModalRoute.withName('/'),
                          );
                        },
                        child: Text(
                          "Ja",
                          style: TextStyle(fontSize: 35),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.fromLTRB(5, 0, 10, 10),
                      child: RaisedButton(
                        onPressed: () {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    esp_search()),
                            ModalRoute.withName('/'),
                          );
                        },
                        child: Text(
                          "Nein",
                          style: TextStyle(fontSize: 35),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
