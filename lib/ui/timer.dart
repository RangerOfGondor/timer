import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:timer/background_service.dart';
import 'package:timer/ui/actions.dart';
import 'package:timer/ui/background.dart';

class TimerView extends StatelessWidget {
  const TimerView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Flutter Timer')),
      body: Stack(
        children: [
          Background(),
          StreamBuilder<Map<String, dynamic>?>(
            /// Use the STREAM based on the Platform to recieve the data
            stream: (!kIsWeb && (Platform.isAndroid || Platform.isIOS))
                ? FlutterBackgroundService().onDataReceived
                : businessLogicToUI.stream,
            builder: (context, snapshot) {
              final int seconds = (snapshot.data?["seconds"] ?? 0) as int;
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 100.0),
                    child: Center(child: TimerText(duration: seconds)),
                  ),
                  ActionWidgets(
                    isPaused: snapshot.data?["isPaused"] ?? true,
                    hasStarted: snapshot.data?["hasStarted"] ?? false,
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class TimerText extends StatelessWidget {
  TimerText({Key? key, this.duration = 0}) : super(key: key);
  final int duration;
  @override
  Widget build(BuildContext context) {
    final minutesStr =
        ((duration / 60) % 60).floor().toString().padLeft(2, '0');
    final secondsStr = (duration % 60).floor().toString().padLeft(2, '0');
    return Text(
      '$minutesStr:$secondsStr',
      style: Theme.of(context).textTheme.headline1,
    );
  }
}
