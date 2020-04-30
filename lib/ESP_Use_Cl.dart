import 'package:flutter/material.dart';
import 'package:super_duper_led_app/Classes/ESP.dart';
import 'package:super_duper_led_app/ESP_Use.dart';
import 'package:super_duper_led_app/Update.dart';

class ESP_Use_Cl extends StatefulWidget {
  final ESP esp;
  ESP_Use_Cl({this.esp});

  @override
  _ESP_use_Cl createState() => _ESP_use_Cl(esp: esp);
}

class _ESP_use_Cl extends State<ESP_Use_Cl> {
  final ESP esp;

  _ESP_use_Cl({@required this.esp});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          esp.name,
          style: TextStyle(
            fontFamily: 'serif-monospace',
            fontWeight: FontWeight.w800,
          ),
        ),
        actions: <Widget>[
          IconButton(
              icon: new Icon(Icons.system_update),
              onPressed: () => {checkifUpdate(esp.ip)})
        ],
      ),
      body: ListView(
        children:
            esp.effects.map((ef) => ESP_use(effect: ef, ip: esp.ip)).toList(),
      ),
    );
  }
}
