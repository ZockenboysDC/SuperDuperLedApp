import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/material.dart';
import 'package:super_duper_led_app/ESP_conf.dart';

Widget left(BuildContext context) {
  return Drawer(
    child: ListView(
      padding: EdgeInsets.zero,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 0),
          child: Card(
            child: ListTile(
              title: Text(
                "Füge einen ESP hinzu / ESP configurieren",
                style: TextStyle(
                  fontFamily: "MajorMonoDisplay-Regular.ttf",
                  fontSize: 16.0,
                ),
              ),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => esp_conf()));
              },
            ),
          ),
        ),
        Divider(),

        Padding(
          padding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 0),
          child: Card(child: elements(context, "Hello 2")),
        ),
        Divider(),

        // TODO: ADD SETTINGS FOR APP
        Padding(
          padding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 0),
          child: Card(
            child: ListTile(
              title: Text("Dark Theme"),
              trailing: Switch(
                value: Theme.of(context).brightness == Brightness.dark
                    ? true
                    : false,
                onChanged: (e) {
                  DynamicTheme.of(context).setBrightness(
                      Theme.of(context).brightness == Brightness.dark
                          ? Brightness.light
                          : Brightness.dark);
                },
              ),
            ),
          ),
        ),
      ],
    ),
  );
}

Widget elements(BuildContext context, String title) {
  return ListTile(
    title: Text(
      title,
      style: TextStyle(
        fontFamily: "MajorMonoDisplay-Regular.ttf",
        fontSize: 16.0,
      ),
    ),
    onTap: () {
      Navigator.pop(context);
    },
  );
}
