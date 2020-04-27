import 'dart:typed_data';
import 'dart:io';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:simple_permissions/simple_permissions.dart';

checkifUpdate(ip) {
  EasyLoading.showInfo("Checking for a newer Version \n Step 0/2 finished");

  var newestVersion = "0";
  var fileurl = "";

  http
      .get("https://7h3730b.github.io/SuperDuperLedAppESP/versions.json")
      .then((http.Response response) {
    EasyLoading.showInfo("Checking for a newer Version \n Step 1/2 finished");
    Map decoded = jsonDecode(response.body);
    newestVersion = decoded["version"];
    fileurl = decoded["fileurl"];
    EasyLoading.showInfo("Checking for a newer Version \n Step 2/2 finished");
    http.get("http://" + ip + "/getversion").then((http.Response response) {
      if (newestVersion == response.body) {
        EasyLoading.showInfo("You are up to date");
        new Future.delayed(
            const Duration(seconds: 2), () => EasyLoading.dismiss());
        return;
      } else {
        EasyLoading.showInfo("Starting update");
        downloadupdateFile(fileurl,
            filename: "SUPERDUPERLED_APP_" + newestVersion + ".bin");
      }
    });
  });
}

downloadupdateFile(String url, {String filename}) async {
  var httpClient = http.Client();
  var request = new http.Request('GET', Uri.parse(url));
  var response = httpClient.send(request);
  String dir = (await getApplicationDocumentsDirectory()).path;

  List<List<int>> chunks = new List();
  int downloaded = 0;

  if (!await SimplePermissions.checkPermission(
      Permission.WriteExternalStorage)) {
    await SimplePermissions.requestPermission(Permission.WriteExternalStorage);
    if (await SimplePermissions.checkPermission(
        Permission.WriteExternalStorage)) {
      EasyLoading.showError("No Permisson");
      new Future.delayed(
          const Duration(seconds: 2), () => EasyLoading.dismiss());
      return;
    }
  }

  response.asStream().listen((http.StreamedResponse r) {
    r.stream.listen((List<int> chunk) {
      EasyLoading.showProgress((downloaded / r.contentLength * 100) / 100);
      print('downloadPercentage: ${downloaded / r.contentLength * 100}');

      chunks.add(chunk);
      downloaded += chunk.length;
    }, onDone: () async {
      File file = new File('$dir/$filename');
      final Uint8List bytes = Uint8List(r.contentLength);
      int offset = 0;
      for (List<int> chunk in chunks) {
        bytes.setRange(offset, offset + chunk.length, chunk);
        offset += chunk.length;
      }
      await file.writeAsBytes(bytes);
      EasyLoading.showSuccess("Worked");
      new Future.delayed(
          const Duration(seconds: 2), () => {EasyLoading.dismiss()});
      return;
    });
  });
}
