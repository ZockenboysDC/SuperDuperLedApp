import 'package:flutter/material.dart';
import 'package:super_duper_led_app/Global.dart';
import 'package:super_duper_led_app/Setting.dart';
import './AppBar.dart';
import './BuildWidget.dart';
import './Effect.dart';

void main() {
  runApp(MaterialApp(
    home: MyAppapp(),
    debugShowCheckedModeBanner: false,
  ));
}

class MyAppapp extends StatefulWidget {
  @override
  MyApp createState() {
    return MyApp();
  }
}

List<Effect> effects = [
  Visualizer(
      boolsettings: null,
      endpoint: 'Visualizer',
      intsettings: [
        IntSetting(250, 20, 168, 'Brightness', 'Visualizer'),
        IntSetting(8, 1, 4, 'High', 'Visualizer'),
        IntSetting(30, 1, 5, 'Decay', 'Visualizer'),
        IntSetting(10, 1, 3, 'Wheel_speed', 'Visualizer'),
      ],
      name: 'Visualizer'),
  Rainbow(
      boolsettings: null,
      endpoint: 'Rainbow',
      intsettings: [
        IntSetting(40, 1, 15, 'hue', 'Rainbow'),
        IntSetting(10, -10, 1, 'rate', 'Rainbow')
      ],
      name: 'Rainbow'),
  StaticPalet(
      boolsettings: null,
      endpoint: 'StaticPalet',
      intsettings: null,
      name: 'StaticPalet'),
  OFF(boolsettings: null, endpoint: 'OFF', intsettings: null, name: 'OFF'),
];

class MyApp extends State<MyAppapp> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[900],
      appBar: AppBarTemp().build(context),
      body: ListView(
        children: effects.map((ef) => EffectWidget(effect: ef)).toList(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return Choose();
          }));
        },
        child: Text('click'),
        backgroundColor: Colors.black,
      ),
    );
  }
}
