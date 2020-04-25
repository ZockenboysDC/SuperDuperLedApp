import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import './AppBar.dart';
import './Drawer.dart';

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

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarMain().build(context),
      drawer: AspectRatio(aspectRatio: 0.5, child: left(context)),
    );
  }
}
