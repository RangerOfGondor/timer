import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:timer/constants.dart';

class ActionWidgets extends StatelessWidget {
  const ActionWidgets({Key? key, this.hasStarted = false, this.isPaused = true})
      : super(key: key);

  final bool hasStarted;
  final bool isPaused;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        if (hasStarted) ...[
          FloatingActionButton(
              child: Icon(Icons.stop),
              onPressed: () {
                FlutterBackgroundService().sendData(
                  {"action": actionToString[actions.stop]},
                );
              }),
        ],
        FloatingActionButton(
            child: (!isPaused) ? Icon(Icons.pause) : Icon(Icons.play_arrow),
            onPressed: () async {
              if (!isPaused) {
                FlutterBackgroundService().sendData({
                  "action": actionToString[actions.pause],
                });
              } else if (hasStarted) {
                FlutterBackgroundService().sendData({
                  "action": actionToString[actions.play],
                });
              } else {
                FlutterBackgroundService().sendData(
                  {"action": actionToString[actions.start]},
                );
              }
            }),
        if (hasStarted) ...[
          FloatingActionButton(
            child: Icon(Icons.replay),
            onPressed: () => FlutterBackgroundService().sendData({
              "action": actionToString[actions.reset],
            }),
          ),
        ],
      ],
    );
  }
}
