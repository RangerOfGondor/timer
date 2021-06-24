import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:timer/background_service.dart';
import 'package:timer/constants.dart';

class ActionWidgets extends StatelessWidget {
  const ActionWidgets({Key? key, this.hasStarted = false, this.isPaused = true})
      : super(key: key);

  final bool hasStarted;
  final bool isPaused;

  /// This is the common method that sends the actions to the respective streams
  void sendAction(actions action) {
    if (!kIsWeb && (Platform.isAndroid || Platform.isIOS)) {
      FlutterBackgroundService().sendData(
        {"action": actionToString[action]},
      );
    } else {
      uiToBusinessLogic.add(
        {"action": actionToString[action]},
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        if (hasStarted) ...[
          FloatingActionButton(
              child: Icon(Icons.stop),
              onPressed: () => sendAction(actions.stop)),
        ],
        FloatingActionButton(
            child: (!isPaused) ? Icon(Icons.pause) : Icon(Icons.play_arrow),
            onPressed: () {
              if (!isPaused) {
                sendAction(actions.pause);
              } else if (hasStarted) {
                sendAction(actions.play);
              } else {
                sendAction(actions.start);
              }
            }),
        if (hasStarted) ...[
          FloatingActionButton(
            child: Icon(Icons.replay),
            onPressed: () => sendAction(actions.reset),
          ),
        ],
      ],
    );
  }
}
