import 'package:flutter/material.dart';
import 'package:super_duper_led_app/Setting.dart';
import './Effect.dart';

class EffectWidget extends StatefulWidget {
  final Effect effect;
  EffectWidget({this.effect});

  @override
  _EffectWidget createState() => _EffectWidget(effect: effect);
}

class _EffectWidget extends State<EffectWidget> {
  final Effect effect;

  _EffectWidget({@required this.effect});

  Widget getSet(Effect effect) {
    List<IntSetting> int3 = effect.intsettings;
    if (int3 == null)
      return Text(
        'Nothing to costumice here',
        style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
      );
    return Column(
        children: int3
            .map(
              (item) => Container(
                  child: Column(
                children: <Widget>[
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        child: Text(
                          item.name + ': ' + item.current.toString(),
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Container(
                        width: 60,
                        margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
                        child: FlatButton(
                          onPressed: () {
                            setState(() {
                              item.current = item.standart;
                            });
                            item.setSetting();
                          },
                          child: Icon(
                            Icons.settings_backup_restore,
                            size: 40,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Container(
                        //padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                        margin: EdgeInsets.fromLTRB(5, 0, 0, 0),
                        width: 50,
                        child: RaisedButton(
                          color: Colors.blueGrey[400],
                          child: Icon(Icons.keyboard_arrow_left, size: 35),
                          padding: EdgeInsets.fromLTRB(0.0, 0.0, 1.0, 0.0),
                          onPressed: () {
                            setState(() {
                              if (item.current > item.min) {
                                item.current--;
                                item.setSetting();
                              }
                            });
                          },
                        ),
                      ),
                      Expanded(
                        child: Slider(
                          max: item.max.toDouble() + 0.5,
                          min: item.min.toDouble(),
                          value: item.current.toDouble(),
                          onChangeEnd: (e) {
                            item.current = e.toInt();
                            item.setSetting();
                          },
                          label: item.current.toString(),
                          onChanged: (e) {
                            setState(() {
                             item.current = e.toInt(); 
                            });
                          },
                        ),
                      ),
                      Container(
                        //padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                        margin: EdgeInsets.fromLTRB(0, 0, 5, 0),
                        width: 50,
                        child: RaisedButton(
                          color: Colors.blueGrey[400],
                          child: Icon(Icons.keyboard_arrow_right, size: 35),
                          padding: EdgeInsets.fromLTRB(0.0, 0.0, 1.0, 0.0),
                          onPressed: () {
                            setState(() {
                              if (item.current < item.max) {
                                item.current++;
                                item.setSetting();
                              }
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              )),
            )
            .toList());
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
      child: Container(
        child: Container(
          child: ExpansionTile(
            trailing: Icon(
              Icons.keyboard_arrow_down,
              size: 55,
            ),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(
                  child: FlatButton(
                    padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                    child: Icon(
                      Icons.play_arrow,
                      size: 50,
                    ),
                    onPressed: () {
                      effect.turnOn();
                    },
                  ),
                ),
                Text(
                  effect.name,
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            children: <Widget>[
              getSet(effect),
            ],
          ),
        ),
        color: Colors.blueGrey,
      ),
    );
  }
}
