import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:super_duper_led_app/ESP_Use.dart';
import 'package:super_duper_led_app/ESP_Use_Cl.dart';
import './AppBar.dart';
import './Drawer.dart';
import 'dart:convert';
import 'dart:io' show RawDatagramSocket, InternetAddress, Datagram;
import './Classes/ESP.dart';

void main() {
  runApp(MyApp());
}

ThemeData _buildTheme(Brightness brightness) {
  return brightness == Brightness.dark
      ? ThemeData.dark().copyWith(
          textTheme: ThemeData.dark().textTheme.apply(
                bodyColor: Colors.white,
                displayColor: Colors.white,
                fontFamily: 'Basier',
              ),
          buttonTheme: ThemeData.dark().buttonTheme.copyWith(
                buttonColor: Colors.blueGrey,
                shape: RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(15.0),
                ),
              ),
          backgroundColor: Colors.blueGrey,
          primaryColor: Colors.black,
          cardColor: Colors.blueGrey[810],
          accentColor: Colors.green,
          secondaryHeaderColor: Colors.blueGrey[900],
          scaffoldBackgroundColor: Colors.blueGrey[900])
      : ThemeData.light().copyWith(
          textTheme: ThemeData.light().textTheme.apply(
                bodyColor: Colors.black,
                displayColor: Colors.black,
                fontFamily: 'Basier',
              ),
          buttonTheme: ThemeData.light().buttonTheme.copyWith(
                buttonColor: Colors.grey[500],
                shape: RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(15.0),
                ),
              ),
          backgroundColor: Colors.white,
          primaryColor: Colors.grey[700],
          cardColor: Colors.grey[300],
          accentColor: Colors.green,
          secondaryHeaderColor: Colors.grey[500],
          scaffoldBackgroundColor: Colors.white);
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([]);
    return FlutterEasyLoading(
      child: new DynamicTheme(
        defaultBrightness: Brightness.dark,
        data: (brightness) => _buildTheme(brightness),
        themedWidgetBuilder: (context, theme) => MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: theme,
          home: HomePage(),
        ),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  bool _isButtonDisabled;
  List<ESP> esp = [];
  var PORT = 8000;
  var data;

  @override
  void initState() {
    _isButtonDisabled = false;
    data = [];
  }

  void findEsps() {
    setState(() {
      esp.clear();
    });
    EasyLoading.show(status: 'Laden...\nDies kann bis zu 1 Minute dauern');
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
                    e.init(),

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
      appBar: AppBarMain().build(context),
      drawer: AspectRatio(aspectRatio: 0.5, child: left(context)),
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
                  "ESPs:",
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
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (BuildContext context) =>
                                ESP_Use_Cl(esp: item),
                          ),
                        )
                      },
                      child: Container(
                        padding: const EdgeInsets.all(8.0),
                        child: new Card(
                          color: Theme.of(context).secondaryHeaderColor,
                          child: Column(
                            children: <Widget>[
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Container(
                                    padding: const EdgeInsets.fromLTRB(
                                        8.0, 8.0, 0.0, 8.0),
                                    child: Text(
                                      item.name,
                                      style: new TextStyle(fontSize: 20.0),
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.fromLTRB(
                                        0.0, 8.0, 8.0, 8.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: <Widget>[
                                        SizedBox(
                                          width: 60,
                                          height: 20,
                                          child: RaisedButton(
                                            onPressed: () => {item.oN()},
                                            child: Text("On"),
                                          ),
                                        ),
                                        Container(
                                          padding: EdgeInsets.fromLTRB(
                                              2.0, 0.0, 0.0, 0.0),
                                          child: SizedBox(
                                            width: 60,
                                            height: 20,
                                            child: RaisedButton(
                                              onPressed: () => {item.oFF()},
                                              child: Text("Off"),
                                            ),
                                          ),
                                        ),
                                        Container(
                                          padding: EdgeInsets.fromLTRB(
                                              8.0, 0.0, 0.0, 0.0),
                                          child: Icon(Icons.arrow_forward,
                                              color: Theme.of(context)
                                                  .accentColor),
                                        ),
                                      ],
                                    ),
                                  ),
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
                child: RaisedButton(
              onPressed: () => findEsps(),
              child: Text("Load"),
            ))
          ],
        ),
      ),
    );
  }
}
