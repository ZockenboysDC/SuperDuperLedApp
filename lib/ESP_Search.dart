import 'dart:convert';
import 'package:flutter/material.dart';
import 'dart:io' show RawDatagramSocket, InternetAddress, Datagram;
import 'package:super_duper_led_app/ESP_Config.dart';

class ESP {
  String name;
  String macAdress;
  String type;
  String ip;

  ESP(this.name, this.macAdress, this.type, this.ip) : super();
}

class esp_search extends StatefulWidget {
  @override
  esp_searchState createState() => esp_searchState();
}

class esp_searchState extends State<esp_search> {
  bool _isButtonDisabled;
  List<ESP> esp = [];
  var PORT = 8000;
  var data;

  @override
  void initState() {
    _isButtonDisabled = false;
    data = [];
  }

  void sendMessage() {
    setState(() {
      esp.clear();
    });
    RawDatagramSocket.bind(InternetAddress.anyIPv4, PORT)
        .then((RawDatagramSocket datagramSocket) {
      datagramSocket.broadcastEnabled = true;
      final textData = "Discovery";
      Datagram dg;
      var da2;
      var e;
      _isButtonDisabled = true;
      datagramSocket.listen((event) => {
            if (event.toString() == "RawSocketEvent.read")
              {
                dg = datagramSocket.receive(),
                if (dg != null)
                  {
                    da2 = utf8.decode(dg.data),
                    data = da2.split(
                        "|"), // [Super_Duper_Led, 68:C6:3A:D6:B8:D1, Super_Duper_Led]

                    // TODO: Dont add when already in list / Why is here a Error?
                    e = new ESP(data[0], data[1], data[2], dg.address.address),

                    setState(() {
                      esp.add(e);
                    }),
                  },
              },
          });
      datagramSocket.send(
          textData.codeUnits, InternetAddress('255.255.255.255'), PORT);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("ESP Suchen...")),
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
              child: Container(
                padding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 8.0),
                child: Text(
                  "Such dir einen ESP aus:",
                  style: TextStyle(
                    fontSize: 30,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ),
            // ADD ALL FOUND ESPs
            Expanded(
              child: new ListView.builder(
                  itemCount: esp.length,
                  itemBuilder: (context, index) {
                    final item = esp[index];

                    return new GestureDetector(
                      onTap: () => {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  esp_config(ip: item.ip)),
                          ModalRoute.withName('/'),
                        )
                      },
                      child: Container(
                        padding: const EdgeInsets.all(8.0),
                        child: new Card(
                          color: Theme.of(context).secondaryHeaderColor,
                          child: Column(
                            children: <Widget>[
                              Container(
                                padding: const EdgeInsets.fromLTRB(
                                    0.0, 8.0, 0.0, 0.0),
                                child: Text(
                                  item.name,
                                  style: new TextStyle(fontSize: 20.0),
                                ),
                              ),
                              Divider(),
                              Column(
                                children: <Widget>[
                                  Text("Type: " + item.type),
                                  Text("mac: " + item.macAdress),
                                  Container(
                                      padding: const EdgeInsets.fromLTRB(
                                          0.0, 0.0, 0.0, 8.0),
                                      child: Text("IP: " + item.ip)),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(5, 0, 10, 10),
              child: RaisedButton(
                onPressed: () {
                  sendMessage(); // _isButtonDisabled ? print("h") : sendMessage();
                },
                child: Text(
                  "Suchen",
                  style: TextStyle(fontSize: 35),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
