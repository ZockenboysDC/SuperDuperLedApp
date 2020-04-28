import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:url_launcher/url_launcher.dart';

checkifUpdate(ip) async {
  EasyLoading.showInfo("Checking for a newer Version \n Step 0/2 finished");

  var newestVersion = "0";
  var fileurl = "";

  http.get("http://" + ip + "/getversionURL").then((http.Response response) => {
        http.get(response.body).then((http.Response response) {
          EasyLoading.showInfo(
              "Checking for a newer Version \n Step 1/2 finished");
          Map decoded = jsonDecode(response.body);
          newestVersion = decoded["version"];
          fileurl = decoded["fileurl"];
          EasyLoading.showInfo(
              "Checking for a newer Version \n Step 2/2 finished");
          http
              .get("http://" + ip + "/getversion")
              .then((http.Response response) {
            if (newestVersion == response.body) {
              EasyLoading.showInfo("You are up to date");
              new Future.delayed(
                  const Duration(seconds: 2), () => EasyLoading.dismiss());
              return;
            } else {
              EasyLoading.showInfo("Starting update");
              if (true) {
                launch(Uri.encodeFull(fileurl));
                new Future.delayed(
                    const Duration(seconds: 2),
                    () => EasyLoading.showInfo(
                        "Bald wird eine Update Seite geöffnet, uploade dort die gerade heruntergeladene Datei"));
                new Future.delayed(const Duration(seconds: 30),
                    () => launch("http://" + ip + "/update"));
              } else {
                EasyLoading.showError("Failed");
              }
            }
          });
        }),
      });
}
